#!/bin/awk -f

@include "common.awk"

# usage:  awk -f makebooks.awk journal.txt
#
# Reads journal.txt and creates two files:
#       book.events.ini                     The events 
#       localization.book.english.txt       

BEGIN       {
				debug = 1

                IGNORECASE=1
                FS="|"

                NAME = 1
                CONDITIONS = 1
                TEXT = 2

				SKILLCHECK =3
				PASS = 4
				FAIL = 5

                TESTS = 6
                OPERATIONS = 7
                VISIBLE = 8
				VISIBLEOPERATION=9
                ISVISIBLE = 10
                TOCTEXT = 11
                INILINES = 12
                ISEXIT = 13
                FREEACTION = 14
				
                stderr = "/dev/stderr"
                
                eventsFile="book.events.ini"
                localizationFile="localization.book.english.txt"
                
                deleteFile(eventsFile)
                deleteFile(localizationFile)
                
                localizationHeader = ".,English"
                
                globalEventCounter = 0
                isBook = 0
				
				textContinue = "Continue"
				textCancel = "Cancel"
				
				abort = 0
            }

# remove leading and trailing blanks
            {
                $0 = trim($0)
            }
            
/^\s*$/     {
                # skip blank lines
                next
            }
            
/^\s*#/     {   # skip comments
                next
            }

			{ if (debug) print $0 >> stderr
			}

# book:  starts a book. Options are:
#        book|random|keep        Pages are all available as {action}s; after first use, {action} goes away
#        book|random|nokeep      Pages are all available, but each is removed after first use
#        book|ordered|keep       Only the first page is available as an {action}. On first use, {action} is removed from Page and the second Page is made available as an {action}. Repeat.
#        book|ordered|nokeep     First Page is shown as {action}; after first use, only the second page shows as {action}. Repeat.
#
# books can be followed by:  line (only before page)
$1 == "book" {
                if (isBook) {
					localizationFile = gensub(/[{]language[}]/, language, 1, localizationFile)
					if (debug) print "localization file=" localizationFile >> stderr
                    OutputBook(eventsFile, localizationFile, bookName, isRandom, isKeep, pages, startLines, endLines, isEndDirective)
                }
                
                isBook = 1
                
                type = ( $1 == "inspect" ? "Event" : "Token" )
                bookName = $2
                isRandom = $3 == "random"
                isKeep = $4 == "keep"
                
                bookCount++
                books[bookCount] = bookName
                if (debug) print "bookName=" bookName ", isRandom=" isRandom ", isKeep=" isKeep >> stderr
                
				isEndDirective = 0
                delete pages
                pageCount = 0
                endTocText = ""
                delete startLines
                delete endLines
                next
            }


# page|<button text>|<text>:  Adds a new page with <button text> to access it
$1 == "page" || $1 == "end" {
				if (isEndDirective) {
					printf "'page' is not allowed after 'end'\n" >> stderr
				} else if ($1 == "end") {
					isEndDirective = 1
				}

                # add this page; a page is an array of values that describe the page
                pageCount++
                if (debug) printf "Adding pages[%i] %s\n", pageCount, $2 >> stderr
                pages[pageCount][NAME] = $2
                pages[pageCount][TEXT] = $3
                testCount = 0
                next
            }

# toc|<text>: This is the <text> shown in the popup offering a page to you. The text actually shown is taken from the first page that has no {action} pending; if none, uses the text from the end directive
#             If there is no 'toc', the next page will be shown immediately with only a [Continue] button. This only makes sense for ordered|nokeep; for others, the result is undefined
#             All pages should have a 'toc' or none of them should (again, results undefined otherwise)
$1 == "toc" {
                pages[pageCount][TOCTEXT] = $2
                next
            }


# test|<expr>|<text>:  Uses this <text> instead of the page line if <expr> returns true
$1 == "test" {
                testCount++
                if (debug) printf "test: pages[pageCount][TESTS][testCount] = pages[%i][%i][%i]\n", pageCount, TESTS, testCount >> stderr
                pages[pageCount][TESTS][testCount][CONDITIONS] = $2
                pages[pageCount][TESTS][testCount][TEXT] = $3
                next
            }

# operations|...:  Adds an 'operations' line directly to the page
$1 == "operations" {
                pages[pageCount][OPERATIONS] = $2
                if (debug) printf "operations: pages[pageCount][OPERATIONS] => pages[%i][%i] = %s\n", pageCount, OPERATIONS, pages[pageCount][OPERATIONS] >> stderr
                next
            }

# visible|variable:  Page only. If variable returns <> 0, the page is made avaiable.
$1 == "visible" {
                pages[pageCount][VISIBLE] = $2
				pages[pageCount][VISIBLEOPERATION] = ""
				if (debug) printf "%s:  pages[%i][VISIBLE]=%s\n", bookName, pageCount, pages[pageCount][VISIBLE] >> stderr
                next
            }

$1 == "notvisible" {
                pages[pageCount][VISIBLE] = $2
				pages[pageCount][VISIBLEOPERATION] = "!"
				if (debug) printf "%s:  pages[%i][VISIBLE]=%s\n", bookName, pageCount, pages[pageCount][VISIBLE] >> stderr
                next
            }

# 
$1 == "freeaction" {
				pages[pageCount][FREEACTION] = 1
			}
			

# line|...:  adds a line directly to the event file. These lines are usually assignments, but can be anything. 
#   If there are no pages, these lines go into the Start event
#   If we have seen the 'end' directive, these lines go into the End event
#   Otherwise, they go into the current page
$1 == "line" {
                
                if (pageCount == 0) {
                    # this is before the first page, put in the Start event
                    startLines[length(startLines) + 1] = $2
                } else if (endTocText != "") {
                    # for the end event, put these lines in an array
                    endLines[length(endLines) + 1] = $2
                } else {
                    # the others go against the current page
                    pages[pageCount][INILINES][length(pages[pageCount][INILINES]) + 1] = $2
                }
                
                next
            }

# exit:  Aborts the book immediately by transferring to Event<book>End
$1 == "exit" {
                pages[pageCount][ISEXIT] = 1
                next
            }
            
$1 == "skillcheck" {
				pages[pageCount][SKILLCHECK] = $2
			}

$1 = "pass" {
				pages[pageCount][PASS] = $2
			}

$1 = "fail" {
				pages[pageCount][FAIL] = $2
				next
			}

# the name of the file where the generated events go
$1 == "eventfile" {
				if (isBook) {
					printf "'eventfile' directive must be before the first book" >> stderr
					abort = 1
					exit
				}
				
				eventsFile=$2
				system("if exist " $2 " del /f " $2)
				next
			}

# the name of the file where localizable text goes
$1 == "localizationfile" {
				if (isBook) {
					printf "'localizationfile' directive must be before the first book" >> stderr
					abort = 1
					exit
				}
				
				localizationFile=$2 
				if (debug) printf "localizationFile changed to %s\n", localizationFile >> stderr
				system("if exist " $2 " del /f " $2)
				next
			}
			
# language:  specifies the language used in the locationization filename and the file's header
$1 == "language" {
				if (isBook) {
					printf "'language' directive must be first command in file" >> stderr
					abort = 1
					exit
				}
				
				language = $2
				localizationHeader = ".," + $2
				next
			}
			
# cancel|<text>: The text for the [Cancel] button; the default is "Cancel."	Use only once.
$1 == "cancel" {
				textCancel = $2
				next
			}
			
# continue|<text>: The text for the [Continue] button; the default is "Continue." Use only once.
$1 == "continue" {
				textContinue = $2
				next
            }

END         {
				if (abort) {
					exit
				}
				
                if (isBook) {
					localizationFile = gensub(/[{]language[}]/, language, 1, localizationFile)
					if (debug) print "localization file=" localizationFile >> stderr
                    OutputBook(eventsFile, localizationFile, bookName, isRandom, isKeep, pages, startLines, endLines, isEndDirective)
                }
            }
            
            {
                printf "Unknown command: %s\n", $0
            }


function OutputBook(eventsFile, localizationFile, bookName, isRandom, isKeep, pages, startLines, endLines, isEndDirective,       pageCount, separator, events, pageIndex, testIndex, operations, testEventName, lineIndex) {
    # bookName will only be empty on the first run
    if (bookName == "") return

    # start with ReadPage entries (all versions use this)
    printf "OutputBook(%s)\n", bookName >> stderr
    pageCount = length(pages)
    for(pageIndex = 1; pageIndex <= pageCount; pageIndex++) {
        separator = ""
        events = ""

        operations = pages[pageIndex][OPERATIONS]

        #printf "test: length(pages[pageIndex][TESTS]) = length(pages[%i][%i]) = %i\n", pageIndex, TESTS, length(pages[pageIndex][TESTS]) >> stderr
        for (testIndex = 1; testIndex <= length(pages[pageIndex][TESTS]); testIndex++) {
            testEventName = sprintf("Event%sReadPage%iTest%i", bookName, pageIndex, testIndex)
            events = events separator testEventName
            separator = " "
            
            printf "\n[%s]\n", testEventName >> eventsFile
			printf "buttons=1\n" >> eventsFile
			printf "%s.button1,%s\n", testEventName, textContinue >> localizationFile

			if (pages[pageIndex][TOCTEXT] == "") {
				# we don't want to go back to the TOC after this
				printf "display=false\n" >> eventsFile
				pages[pageIndex][ISEXIT] = 1
			} else {
				# we have TOC text, so show it
				printf "display=true\n" >> eventsFile
				printf "%s.text,%s\n", testEventName, FixQuotes(pages[pageIndex][TESTS][testIndex][TEXT]) >> localizationFile
			}

			printf "event1=Event%sReadPage%iEnd\n", bookName, pageIndex >> eventsFile
			printf "Event%sReadPage%iEnd.text,\n", bookName, pageIndex >> localizationFile
			
			printf "vartests=%s\n", ConvertToVarTests(pages[pageIndex][TESTS][testIndex][CONDITIONS]) >> eventsFile
        }
        
        # create the base message to show if none of the conditional ones fire
        events = events separator sprintf("Event%sReadPage%iBase", bookName, pageIndex)
        separator = " "
        
        printf "\n[Event%sReadPage%iBase]\n", bookName, pageIndex >> eventsFile
		printf "display=true\n" >> eventsFile
        printf "buttons=1\n" >> eventsFile
        printf "event1=Event%sReadPage%iEnd\n", bookName, pageIndex >> eventsFile

        printf "Event%sReadPage%iBase.text,%s\n", bookName, pageIndex, FixQuotes(pages[pageIndex][TEXT]) >> localizationFile
        printf "Event%sReadPage%iBase.button1,%s\n", bookName, pageIndex, textContinue >> localizationFile

        printf "\n[Event%sReadPage%iEnd]\n", bookName, pageIndex >> eventsFile
        printf "display=false\n" >> eventsFile
        printf "buttons=1\n" >> eventsFile
        if (pages[pageIndex][ISEXIT] == 1) {
            printf "event1=Event%sEnd\n", bookName >> eventsFile
        } else {
            printf "event1=Event%sStart\n", bookName >> eventsFile
        }

        operations=UnionOperations(pages[pageIndex][OPERATIONS], endLines)
        printf "operations=read%sPage%i,=,1 %s\n", bookName, pageIndex, operations >> eventsFile

		for(lineIndex = 1; lineIndex <= length(pages[pageIndex][INILINES]); lineIndex++) {
			print pages[pageIndex][INILINES][lineIndex] >> eventsFile
		}

        printf "Event%sReadPage%iEnd.button1,%s\n", bookName, pageIndex, textContinue >> localizationFile
        
        # now create the event to choose the right version of the page to show
        printf "\n[Event%sReadPage%i]\n", bookName, pageIndex >> eventsFile
        printf "buttons=1\n"  >> eventsFile
        printf "event1=%s\n", events >> eventsFile 
        printf "Event%sReadPage%i.button1,%s\n", bookName, pageIndex, textContinue >> localizationFile
        printf "display=false\n" >> eventsFile
    }
    
    globalEventCounter = 0
    if (isRandom) {
        # random / keep
        # generate a TOC that shows all options, all the time; user can act on any one of them; after that, that option no longer costs an action
        # requires a TOC for every permutation of { action/no-action, visibles }

        # random / nokeep
        # generate a TOC that shows all options to start; user can act on any one of them; after that, that option is not longer visible
        # requires a TOC for each permutation of { show/not-show, visibles }
        #printf "random book\n" >> stderr
        OutputRandomTOC(eventsFile, localizationFile, bookName, pages, startLines, endLines, isKeep, isEndDirective)

	} else if (isKeep) {
		# ordered / keep
        OutputOrderedKeepTOC(eventsFile, localizationFile, bookName, pages, startLines, endLines, isEndDirective)

    } else {
        #printf "ordered book\n" >> stderr
        OutputOrderedNoKeepTOC(eventsFile, localizationFile, bookName, pages, startLines, endLines, isEndDirective)
    }

}

function OutputRandomTOC(eventsFile, localizationFile, bookName, pages, startLines, endLines, isKeep, isEndDirective,      pageCounter, visiblePages, events, separator, visible, visibleIndex, conditions, conditionsSeparator, pageIndex, newEvents, lineIndex) {
    events = ""
    separator = ""
    
    pageCounter = 0
    for(pageIndex = 1; pageIndex <= length(pages) - isEndDirective; pageIndex++) {
        #printf "pages[pageIndex][VISIBLE]:  pages[%i][VISIBLE] == |%s\n", pageIndex, pages[pageIndex][VISIBLE] >> stderr
        if (pages[pageIndex][VISIBLE] != "") {
            pageCounter++
            visiblePages[pageCounter] = pageIndex
        }
        pages[pageIndex][SHOW] = 1
    }
    #printf "%i pages found with visibility conditions\n", pageCounter >> stderr
    
    # this is a special case where no pages have visiblility conditions
    if (length(visiblePages) == 0) {
        #printf "special case:  no visibility conditions\n" >> stderr
        newEvents = OutputRandomTOCInternal(eventsFile, localizationFile, bookName, pages, isKeep, "", isEndDirective)
        events = events separator newEvents
        separator = " "
    }
    
    # loop for visibility (if no pages have visibility conditions, nothing happens)
    for (visibleIndex = 0; visibleIndex <= 2 ** length(visiblePages) - 1; visibleIndex++) {
        conditions = ""
        conditionSeparator = ""

        for (pageIndex = 1; pageIndex <= length(visiblePages); pageIndex++) {
            visible = and(visibleIndex, 2 ** (pageIndex - 1)) != 0
            pages[visiblePages[pageIndex]][SHOW] = visible

			if (pages[visiblePages[pageIndex]][VISIBLEOPERATION] == "!") {
				condition = sprintf("%s,%s,0", pages[visiblePages[pageIndex]][VISIBLE], (visible ? "==" : ">" ) )
			} else {
				condition = sprintf("%s,%s,0", pages[visiblePages[pageIndex]][VISIBLE], (visible ? ">" : "==" ) )
			}
            conditions = sprintf("%s%s%s", conditions, conditionSeparator, condition)
            conditionSeparator = " AND "
        }
        
        newEvents = OutputRandomTOCInternal(eventsFile, localizationFile, bookName, pages, isKeep, conditions, isEndDirective)
        events = events separator newEvents
        separator = " "
    }
    
    # create event to choose the toc show this time
    printf "\n[Event%sStart]\n", bookName >> eventsFile
    printf "buttons=1\n" >> eventsFile
    printf "event1=%s\n", events >> eventsFile
    printf "display=false\n" >> eventsFile
    
    for(lineIndex = 1; lineIndex <= length(startLines); lineIndex++) {
        printf "%s\n", startLines[lineIndex] >> eventsFile
    }
    
    printf "Event%sStart.button1,%s\n", bookName, textContinue >> localizationFile
    
    # and the End
    printf "\n[Event%sEnd]\n", bookName >> eventsFile
    printf "buttons=0\n" >> eventsFile
    printf "display=false\n" >> eventsFile
    
    for(lineIndex = 1; lineIndex <= length(endLines); lineIndex++) {
        printf "%s\n", endLines[lineIndex] >> eventsFile
    }
}

function OutputRandomTOCInternal(eventsFile, localizationFile, bookName, pages, isKeep, baseConditions, isEndDirective,     events, separators, baseSeparator, pageCount, pageIndex, pagesToShow, eventName, conditions, textFound, scanIndex, actionable, pageCondition, tocText, outputIndex, lineIndex) {
    events = ""
    separator = ""
 
    baseSeparator = (baseConditions != "" ? " AND " : "")
    
    # create an array of pointers to pages
    pageCount = 0
    for (pageIndex = 1; pageIndex <= length(pages) - isEndDirective; pageIndex++) {
        if (pages[pageIndex][SHOW] > 0) {
            pagesToShow[++pageCount] = pageIndex
        }
    }

    # go through every permutation of the displayable entries
    for (tocIndex = 0; tocIndex <= 2 ** (pageCount - isEndDirective) - 1; tocIndex++) {
        globalEventCounter++
        eventName = sprintf("Event%sTOC%i", bookName, globalEventCounter)
        events = events separator eventName
        separator = " "
        
        printf "\n[%s]\n", eventName >> eventsFile

        conditions = baseConditions
        conditionsSeparator = baseSeparator
        
        # for this permutation, show all available buttons
        textFound = 0
        outputIndex = 0
        for (scanIndex = 1; scanIndex <= pageCount; scanIndex++) {
            actionable = and(tocIndex, 2 ** (scanIndex - 1), pages[pagesToShow[scanIndex]][FREEACTION] != 1) 
        
            if (actionable || isKeep) {
                # we always output if the user will burn an action (actionable=true)
                # we also create the event if all of them will show all the time (isKeep=true)

                outputIndex++
                printf "event%i=Event%sReadPage%i\n", outputIndex, bookName, pagesToShow[scanIndex] >> eventsFile
                printf "%s.button%i,%s%s\n", eventName, outputIndex, (actionable ? "{action} " : ""), pages[pagesToShow[scanIndex]][NAME] >> localizationFile
            }

            # this toc only shows when certain pages have been read or not; add that requirement here
            pageCondition = sprintf("read%sPage%i,%s,0", bookName, scanIndex, (actionable ? "==" : ">") )
            conditions = conditions conditionsSeparator pageCondition
            conditionsSeparator = " AND "
            
            # now look for the TOC text
            if (textFound == 0) {
                if (pages[pagesToShow[scanIndex]][TOCTEXT] != "") {
                    tocText = pages[pagesToShow[scanIndex]][TOCTEXT]
                    textFound = actionable
                }
            }
        }

        # because nokeep can stop buttons from showing, we output this after setting the button events
        printf "buttons=%i\n", outputIndex + 1 >> eventsFile
        
        # put out the text to show in the window
        #print "textFound=" textFound ", tocText=" tocText >> stderr
        if (!textFound) tocText = endTocText
        printf "%s.text,%s\n", eventName, FixQuotes(tocText) >> localizationFile
        
        # cancel button
        printf "event%i=Event%sEnd\n", (outputIndex + 1), bookName >> eventsFile
        printf "%s.button%i,%s\n", eventName, (outputIndex + 1), textCancel >> localizationFile
        
        # conditions for coming to this toc
        printf "vartests=%s\n", ConvertToVarTests(conditions) >> eventsFile
    }
    
    return events
}

function OutputOrderedNoKeepTOC(eventsFile, localizationFile, bookName, pages, startLines, endLines, isEndDirective,      pageIndex, pageEventName, eventName, events, eventSeparator, wasReadCondition, tocText, line) {
	# for no keep, the rules are simple:  one event that references a bunch of pass-thru proxy events for ReadPage events (to handle visibility)
	event = ""
	eventSeparator = ""

	# go through each page, one-by-one
	for (pageIndex = 1; pageIndex <= length(pages); pageIndex++) {
		# generate a proxy event
		globalEventCounter++
		pageEventName = sprintf("Event%sReadPage%i", bookName, pageIndex)
		eventName = sprintf("%sProxy", pageEventName)
		events = events eventSeparator eventName
		eventSeparator = " "
		
		printf "\n[%s]\n", eventName >> eventsFile
		printf "buttons=1\n" >> eventsFile

		# add a condition to it:  for nokeep, we only show pages that haven't been read yet
		wasReadCondition = sprintf("read%sPage%i,==,0", bookName, pageIndex)

		# printf "pages[%i][VISIBLE]=%s\n", pageIndex, pages[pageIndex][VISIBLE] >> stderr
		if (isEndDirective && pageIndex == length(pages)) {
			# this is the 'end' directive
			# there is no condition here
		
		} else if (pages[pageIndex][VISIBLE] == "") {
			# just do the page-read condition
			printf "vartests=%s\n", wasReadCondition >>eventsFile

		} else if (pages[pageIndex][VISIBLEOPERATION] == "!") {
			print "vartests=" ConvertToVarTests(sprintf("%s AND %s,==,0\n", wasReadCondition, pages[pageIndex][VISIBLE])) "\n" >> eventsFile

		} else {
			print "vartests=" ConvertToVarTests(sprintf("%s AND %s,>,0\n", wasReadCondition, pages[pageIndex][VISIBLE])) "\n" >> eventsFile
		}

		# branch to real read page
		printf "event1=%s\n", pageEventName >> eventsFile
		
		tocText = pages[pageIndex][TOCTEXT]
		
		if (tocText) {
			# generate continue/cancel buttons
			printf "display=true\n" >> eventsFile
			printf "buttons=2\n" >> eventsFile
			printf "%s.text,%s\n", eventName, tocText >> localizationFile

			#continue button
			printf "%s.button1,%s%s\n", eventName, (isActionable ? "{action} " : ""), textContinue
			
			#cancel button
			printf "event2=%sEnd\n", bookName >> eventsFile
			printf "event2.button2=" textCancel >> localizationFile
			
		} else {
			# there is no toc text, so just go read the page (this allows for seeing a popup without taking an {action} to get there)
			printf "display=false\n" >> eventsFile
		}
	}

    # generate the main event to start this book
	globalEventCounter++
	eventName = sprintf("Event%sStart", bookName)
	
	printf "\n[Event%sStart]\n", bookName >> eventsFile
	printf "buttons=1\n" >> eventsFile
    printf "display=false\n" >> eventsFile
    printf "event1=%s\n", events >> eventsFile

	for (line = 1; line <= length(startLines); line++) {
		printf "%s\n", startLines[line] >> eventsFile
	}

    # generate the End event
	printf "\n[Event%sEnd]\n", bookName >> eventsFile
	printf "display=false\n" >> eventsFile
	printf "buttons=0\n" >> eventsFile
    
	for (line = 1; line <= length(endLines); line++) {
		printf "%s\n", endLines[line] >> eventsFile
	}

	return events
}

function OutputOrderedKeepTOC(eventsFile, localizationFile, bookName, pages, startLines, endLines, isEndDirective,    events, eventSeparator, visible, visibleIndex, conditions, conditionSeparator, pageIndex, condition, newEvents, lineIndex) {
    events = ""
    eventSeparator = ""
    
    # loop for visibility
    for (visible = 0; visible <= 1; visible++) {
        #printf "visble=%i\n", visible >> stderr
        for (visibleIndex = 0; visibleIndex <= 2 ** (length(pages) - isEndDirective) - 1; visibleIndex++) {
            #printf "visibleIndex=%i\n", visibleIndex >> stderr
            conditions = ""
            conditionSeparator = ""
            for (pageIndex = 1; pageIndex <= length(pages); pageIndex++) {
                #printf "pageIndex=%i of %i\n", pageIndex, length(pages) >> stderr
                if (and(visibleIndex, 2 ** (pageIndex - 1)) && pages[pageIndex][VISIBLE] != "") {
					if (pages[pageIndex][VISIBLEOPERATION] == "!") {
						condition = sprintf("%s,%s,0", pages[pageIndex][VISIBLE], (visible ? "==" : ">" ) )
					} else {
						condition = sprintf("%s,%s,0", pages[pageIndex][VISIBLE], (visible ? ">" : "==" ) )
					}
                    conditions = conditions conditionSeparator condition
                    conditionSeparator = " AND "
                    pages[pageIndex][SHOW] = visible
                } else {
                    pages[pageIndex][SHOW] = 1
                }
            }
            
            #printf "vartests=%s\n", ConvertToVarTests(conditions) >> stderr
            if (conditions != "") {
                #printf "about to OutputOrderedTOCInternal\n" >> stderr
                newEvents = OutputOrderedKeepTOCInternal(eventsFile, localizationFile, bookName, pages, conditions, isEndDirective)
                events = events eventSeparator newEvents
                eventSeparator = " "
            }
        }
    }

    for (pageIndex = 1; pageIndex <= (length(pages) - isEndDirective); pageIndex++) {
        pages[pageIndex][SHOW] = 1
    }
    newEvents = OutputOrderedKeepTOCInternal(eventsFile, localizationFile, bookName, pages, "", isEndDirective)
    events = events eventSeparator newEvents
    eventSeparator = " "
    
    # create event to choose the toc show this time
    printf "\n[Event%sStart]\n", bookName >> eventsFile
    printf "buttons=1\n" >> eventsFile
    printf "event1=%s\n", events >> eventsFile
    printf "display=false\n" >> eventsFile
    
    for(lineIndex = 1; lineIndex <= length(startLines); lineIndex++) {
        printf "%s\n", startLines[lineIndex] >> eventsFile
    }
    
    printf "Event%sStart.button1,%s\n", bookName, textContinue >> localizationFile
    
    # and the End
    printf "\n[Event%sEnd]\n", bookName >> eventsFile
    printf "buttons=0\n" >> eventsFile
    printf "display=false\n" >> eventsFile
    
    for(lineIndex = 1; lineIndex <= length(endLines); lineIndex++) {
        printf "%s\n", endLines[lineIndex] >> eventsFile
    }
}

function OutputOrderedKeepTOCInternal(eventsFile, localizationFile, bookName, pages, baseConditions, isEndDirective,     events, eventSeparator, baseConditionSeparator, pageCount, pageIndex, pagesToShow, eventName, tocText, outputButtonIndex, buttonIndex, condition, conditions) {
    events = ""
    eventSeparator = ""

    baseConditionSeparator = (baseConditions != "" ? " AND " : "")
    
	if (isEndDirective) {
		pages[length(pages)][SHOW] = 1
	}

    # create an array of pointers to pages
    pageCount = 0
    for (pageIndex = 1; pageIndex <= length(pages); pageIndex++) {
        if (pages[pageIndex][SHOW] > 0) {
            pagesToShow[++pageCount] = pageIndex
        }
    }
	if (debug) printf "pageCount = %i\n", pageCount;
	
    # go through the pages; for each one, generate a TOC; count past the end for the special case when all pages are read
    for (pageIndex = 1; pageIndex <= length(pagesToShow); pageIndex++) {
        globalEventCounter++
        eventName = sprintf("Event%sTOC%i", bookName, globalEventCounter)
        events = events eventSeparator eventName
        eventSeparator = " "
        
        printf "\n[%s]\n", eventName >> eventsFile
        tocText = pages[pagesToShow[pageIndex]][TOCTEXT]
        
        outputButtonIndex = 0
		# output all the pages that have already been read
		for (buttonIndex = 1; buttonIndex < pageIndex; buttonIndex++) {
			outputButtonIndex++
			printf "event%i=Event%sReadPage%i\n", outputButtonIndex, bookName, pagesToShow[buttonIndex] >> eventsFile
			printf "Event%sTOC%i.button%i,%s\n", bookName, pageIndex, outputButtonIndex, pages[pagesToShow[buttonIndex]][NAME] >> localizationFile
		}
        
		# printf "%s:  pages[pagesToShow[%i]][TOCTEXT]=%s, isEndDirective=%i\n", bookName, pageIndex, pages[pagesToShow[pageIndex]][TOCTEXT], isEndDirective >> stderr
        if (pageIndex <= length(pagesToShow) - isEndDirective) {
            # add the only actionable button for this TOC
            outputButtonIndex++
            printf "event%i=Event%sReadPage%i\n", outputButtonIndex, bookName, pagesToShow[pageIndex] >> eventsFile
            printf "%s.button%i,{action} %s\n", eventName, outputButtonIndex, pages[pagesToShow[pageIndex]][NAME] >> localizationFile
            conditions = baseConditions baseConditionSeparator sprintf("read%sPage%i,==,0", bookName, pagesToShow[pageIndex])

			# the condition is only that the actionable page has not been read yet
			printf "vartests=%s\n", ConvertToVarTests(conditions) >> eventsFile
        
			# add cancel
			outputButtonIndex++
			printf "event%i=Event%sEnd\n", outputButtonIndex, bookName >> eventsFile
			printf "%s.button%i,%s\n", eventName, outputButtonIndex, textCancel >> localizationFile

        } else {
			outputButtonIndex++
			printf "event%i=Event%sEnd\n", outputButtonIndex, bookName >> eventsFile
			printf "%s.text,%s\n", eventName, textContinue >> localizationFile
        }
        
        printf "buttons=%i\n", outputButtonIndex >> eventsFile
        
        # output the text for the TOC
        printf "%s.text,%s\n", eventName, FixQuotes( tocText != "" ? tocText : endTocText ) >> localizationFile
    }
    
    return events
}

 
function UnionOperations(operationLine, iniLines,    lineIndex) {
    # operationLine is of the form "operations=a,op,b[ c,op,d[...]]
    # iniLines contains an array of lines that might contain an operations directive
    
    operationLine = trim(operationLine)
    
    for(lineIndex = 1; lineIndex <= length(iniLines); lineIndex++) {
        if (iniLines[lineIndex] ~ /^\s*operations=/) {
            operationLine = CombineOperations(operationLine, iniLines[lineIndex])
        }
    }

    return operationLine
}

function CombineOperations(line1, line2) {

    # remove operations=
    line2 = trim(substr(line2, length("operations=") + 1))
    
    if (line2 != "") {
        line1 = sprintf("%s %s", line1, line2)
    }

    return line1
}
