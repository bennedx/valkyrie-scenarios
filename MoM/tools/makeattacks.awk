#!/bin/awk -f

@include "common.awk"
BEGIN   {   header = "EventWandererAttack"
            IGNORECASE = 1
            
            
            events = ""     # this is the space-delimited list of events that have been created
            separator = ""  # this is the separate used with events; it is set after the first one is added
            
            stories = ""    # this is the space-delimited list of events that are part of the story line
            storiesSeparator = "" # for the story list
            
            eventsFile = "attack.events.ini"
            localizationFile = "localization.attack.english.txt"
            system("del " eventsFile)
            system("del " localizationFile)

            print ".,English" >> localizationFile
            
            # add the main attack start
#print "Add attack Start event" >> stderr
            printf "\n[%sStart]\n", header >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%sStoryStart\n", header >> eventsFile
            printf "operations=wandererAttacked,=,0\n" >> eventsFile
            
            printf "%sStart.button1,Start Attack\n", header >> localizationFile
            printf "%sStoryStart.button1,Look for Story\n", header >> localizationFile
#print "Done initializing" > stderr   
        }

# a single word means a new event 
$0 ~ /^[^ ]+$/ {
            eventName = $0
            eventCount = 0
#print ">> New event: " eventName > stderr
            next
        }

# skip blank lines 
$0 ~ /^$/ {
#print ">> Skipping blank line" > stderr
            next    # skip this line
        }
        
# lines of the form *|condition|text are story lines
# these lines will be grouped together with the others in their set      
# each one maintains a variable so that it is used only once per game
# all of them coalesce at a single event which is NOT included in the generated code;
#   it is expected that a loop will try multiple times to match a story before giving up and trying a generic one

$0 ~ /^[*][|][^|]*[|].*$/ {
            eventCount++
#print ">> Story line found: " eventCount > stderr            
            split($0, parts, "|")
            
            printf "\n[%sStory%s%i]\n", header, eventName, eventCount >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%sStoryEnd\n", header >> eventsFile
            printf "conditions=%s %sStory%s%i,==,0\n", parts[2], header, eventName, eventCount  >> eventsFile
            printf "operations=%sStory%s%i,=,1 wandererAttacked,=,1\n", header, eventName, eventCount >> eventsFile

            printf "%sStory%s%i.button1,Continue\n", header, eventName, eventCount >> localizationFile
            printf "%sStory%s%i.text,%s\n", header, eventName, eventCount, FixQuotes(parts[3]) >> localizationFile
            
            stories = stories storiesSeparator sprintf("%sStory%s%i", header, eventName, eventCount)
            storiesSeparator = " "

#print ">> story line done: " eventCount > stderr
            next
        }
       

# all others
        {   eventCount++
#print ">> non-story line found: " eventCount > stderr
        
            printf "\n[%sGeneral%s%i]\n", header, eventName, eventCount >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%sGeneralEnd\n", header >> eventsFile
            printf "operations=wandererAttacked,=,1\n" >> eventsFile

            printf "%sGeneral%s%i.button1,Continue\n", header, eventName, eventCount >> localizationFile
            printf "%sGeneral%s%i.text,%s\n", header, eventName, eventCount, FixQuotes($0) >> localizationFile
            
            events = events separator sprintf("%sGeneral%s%i", header, eventName, eventCount)
            separator = " "
#print ">> non-story line done: " eventCount > stderr
            }
        
END     {
#print ">> END" > stderr
            # start the list of non-story attacks
            printf "\n[%sGeneralStart]\n", header >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%s\n", events >> eventsFile
            printf "randomevents=true\n" >> eventsFile
            printf "%sGeneralStart.text,\n", header >> localizationFile
            printf "%sGeneralStart.button1,Choose General Attack\n", header >> localizationFile
            
            printf "\n[%sGeneralEnd]\n", header >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%sEnd\n", header >> eventsFile
            printf "%sGeneralEnd.text,\n", header >> localizationFile
            printf "%sGeneralEnd.button1,End Attack\n", header >> localizationFile
            
            # add support for stories here
            printf "\n[%sStoryStart]\n", header >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%s %sGeneralStart\n", stories, header >> eventsFile
            printf "%sStoryStart.text,\n", header >> localizationFile
            printf "%sStoryStart.button1,Story Start\n", header >> localizationFile
            
            # the end of the story block
            printf "\n[%sStoryEnd]\n", header >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=%sEnd\n", header >> eventsFile
            printf "%sStoryEnd.text,\n", header >> localizationFile
            printf "%sStoryEnd.button1,Story Start\n", header >> localizationFile
            
            # add the end of it all
            printf "\n[%sEnd]\n", header >> eventsFile
            printf "buttons=1\n" >> eventsFile
            printf "event1=\n" >> eventsFile
            printf "%sEnd.text,\n", header >> localizationFile
            printf "%sEnd.button1,Attack End\n", header >> localizationFile
#print ">> END done" > stderr
        }
