# this is an include file
BEGIN   {
            stderr = "/dev/stderr"
            IGNORECASE = 1
			
			true = !false
			false = !true
        }
        
# FixQuotes() takes a string and returns a properly quoted string
function FixQuotes(s,
	result) {
	
	result = s

	gsub(/^"+/s, "", result)		# remove leading "
	gsub(/"+$/, "", result)			# remove trailing "
	gsub(/^[|]{3}/, "", result)		# remove leading |||
	gsub(/[|]{3}$/, "", result)		# remove trailing |||
	gsub(/^(\\n)+/, "", result)		# remove leading newlines
	gsub(/(\\n)+$/, "", result)		# remove trailing newlines
	gsub(/""/, "\"", result)		# replace doubled quotes
    
	if (result == "") return result

    # add \n to front and back
    result = sprintf("\\n%s\\n", result)
    
    # enclose in ||| quotes
	result = "|||" result "|||"
        
    return result
}


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }

function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }

function trim(s) { return rtrim(ltrim(s)); }

function copyFile(sourceFilename, targetFilename) {
    system("cp " sourceFilename " " targetFilename)
}

function deleteFile(filename,
	command, result) {
	
	command = "rm -f " filename #" >/dev/null &2>/dev/null"
	command | getline result
}

function combineLocalization(header, sourceFile, targetFile,
	output, evictThese, line, first) {
    
	if (targetFile == "") return;
	
	output = "combineLocalization.temp.txt"
	printf "" > output    

    # strip out lines that will be replaced
    headerRegex = sprintf("^%s[^,]*,.*$", header)

	# copy localization.english.txt to temp file
	# remove lines that will be replaced
	if (debug) print "targetFile: " targetFile
	while ( ( getline line < targetFile ) > 0 ) {
		if ( line ~ headerRegex ) {
			# do nothing--this line will be replaced by content from sourceFile
		} else {
			# this line will be kept, so send it to the output file
			print line >> output
		}
	}
	
    # append the sourceFile to the output file when the header matches
    if (debug) print "sourceFile: " sourceFile
	while ( ( getline line < sourceFile ) > 0 ) {
        if (line ~ headerRegex) {
            print line >> output
        }
    }

    close(targetFile)
    close(sourceFile)
    close(output)
   
	system("mv -f " output " " targetFile)
}

function ConvertToVarTests(conditions,                      addEntry, condition, conditionIndex, conditionList, conditionResult, conditionSeparator, flipConditionFlag) {
	# divide it up on spaces
	split(conditions, conditionList, " ")
	
	isCondition = 1  # this alternates; 0=logical operator
	conditionSeparator = ""
	conditionResult = ""
	for(conditionIndex in conditionList) {
		entry = conditionList[conditionIndex]
		addEntry = 0
		flipConditionFlag = 1
		
		if (entry ~ /^VarOperation:/) {
			#printf "found VarOperation: %s\n", entry >> stderr
			addEntry = 1
			if (!isCondition && conditionResult != "") {
				# we need to add an operator
				conditionResult = conditionResult " VarTestsLogicalOperation:AND"
			}
			
		} else if (entry ~ /^VarTestsLogicalOperation:/ ) {
			#printf "found bool-op: %s\n", entry >> stderr
			if (isCondition) {
				# skip this:  we don't need multiple operators in a row
			} else {
				addEntry = 1
			}

		} else if (entry ~ /^(AND|OR)$/) {
			#printf "found raw op: %s\n", entry >> stderr
			if (isCondition) {
				# skip this one:  we don't need two operators in a row
			} else {
				entry = sprintf("VarTestsLogicalOperation:%s", entry)
				addEntry = 1
			}
		
		} else if (entry ~ /^VarParenthesis:/) {
			#print "found Var()\n" >> stderr
			# it an original condition
			addEntry = 1
			flipConditionFlag = 0
		
		} else if (entry == "(" || entry == ")") {
			#print "found ()\n" >> stderr
			entry = "VarParenthesis:" entry
			addEntry = 1
			
		} else if (entry ~ /^[^,]*,[^,]*,.*$/) {
			entry = "VarOperation:" entry
			#printf "found op:%s\n", entry >> stderr
			addEntry = 1
			
		} else {
			printf "Could not figure out '%s'\n", entry >> stderr
			addEntry = 0
		}
		
		if (addEntry) {
			conditionResult = conditionResult conditionSeparator entry
			conditionSeparator = " "
		}
		
		if (flipConditionFlag) isCondition = isCondition ? 0 : 1
	}

	#printf "CTVT/Result=%s\n", conditionResult >>stderr

	return conditionResult;
}
