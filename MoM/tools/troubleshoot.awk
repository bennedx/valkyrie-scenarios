#!/bin/awk -f

# usage:  awk -f troubleshoot.awk journal.txt events.ini  localization.book.english.txt 
#
# Reads various .ini and .txt files and validates the contents
#
#       included automatically:
#           attack.events.ini
#           book.events.ini
#           events.ini
#           items.ini
#           localization.en.txt
#
# Things checked
#       x Events that are used exist
#       x Events that are defined are used
#       x Events have localization keys
#       # localization keys are used

BEGIN	{   true = !false
            false = !true

            debug = true

            NAME = 1    # The name of the event, qitem, etc: the item
            FILE = 2    # File name where this item was defined
            LINE = 3    # Line in file where this item was defined
            USED = 4    # Set true when a reference to this item is found
            REFS = 5    # An array of boolean indexed by name; true only if the named item exists
            KEYS = 6    # Array of localization keys referenced by this item
            
            split("attack.events.ini book.events.ini events.ini items.ini tokens.ini monsters.ini puzzles.ini spawns.ini localization.english.txt", ARGV, " ")
            #   tiles.ini ui.ini
            ARGC = length(ARGV) + 1

			lookingForAdd = true
			lookingForButton = true
			lookingForEvent = true
			lookingForRemove = true
		}

BEGINFILE { isIni = FILENAME ~ /.*[.]ini$/
            if (isIni) {
                FS = "="
            } else {
                FS = ","
            }
            $0 = $0
        }

#### .ini files

/^[[]/  {   section = substr($0, 2, length($0) - 2)
            if (section in sections) error("Duplicate", section, FILENAME, FNR, "")

            sections[section][NAME] = name
            sections[section][FILE] = FILENAME
            sections[section][LINE] = FNR
            sections[section][KEYS][section ".text"] = false
			sections[section][USED] = false
			
            # "declare" a more-or-less empty array
            sections[section][REFS]["*"] = "*"
            next
        }

$1 == "buttons" {
			for(i = 1; i <= $2; i++) {
				sections[section][KEYS][section ".button" i] = false
			}
		}

/^add=.*QItemJournal/ {
			print
		}

$1 ~ /^(add|event[0-9]+|remove|monster)$/ {
            split($2, events, /[ \t]+/)
			
            for(i = 1; i <= length(events); i++) {
if (events[i]=="QItemJournal") print "QItemJournal stored"
				#if (event == "EventDVMRitualReadPage14End") {
				#	print "EventPlaceAltar found in " section " =================================================================="
				#}

				sections[section][REFS][events[i]] = false
			}
        }

isIni   {   next
        }
        
#### Localization files

$1 ~ /[.](button|text)/ {
            if ($1 in localization) {
                error("Duplicate", $1, FILENAME, FNR, section)
                next;
            }
            
            localization[$1][FILE] = FILENAME
            localization[$1][LINE] = FNR
            localization[$1][USED] = false
            
            next
        }

# wrap up

END     {   
            # referenced sections exist
			print "========================================================== referenced sections exist"
            for(section in sections) {
                for(event in sections[section][REFS]) {
					if (event == "*") continue;
				
                    found = event in sections
					sections[section][REFS][event] = found

					if (found) {
						sections[event][USED] = true
					} else {
                        error("Missing", event, sections[section][FILE], sections[section][LINE], section)
                    }
                }
            }
            
            # sections are used
			print "========================================================== sections are used"
            for(section in sections) {
                if (!sections[section][USED]) error("Unused", section, sections[section][FILE], sections[section][LINE], section)
            }
            
            print "========================================================== localization keys exist"
            # localization keys exist
            for(section in sections) {
                for (key in sections[section][KEYS]) {
                    found = key in localization
                    sections[section][KEYS][key] = found
                    if (found) {
                        localization[key][USED] = true
                    } else {
                        error("Missing", key, sections[section][FILE], sections[section][LINE], section)
                    }
                }
            }
            
            print "========================================================== localizations are used"
            # localizations are used
            for(key in localization) {
                if (!localization[key][USED]) {
                    error("Unused", key, localization[key][FILE], localization[key][LINE], "")
                }
            }
		}
		
function error(type, name, filename, line, section,          workingSection) {
    workingSection = section == "" ? "" : "(" section ")"
	printf "%-24s %-10s %s %s\n", filename "@" line, type, name, workingSection
}

