# this is an include file
BEGIN   {
            stderr = "/dev/stderr"
            IGNORECASE = 1
			
			true = !false
			false = !true
        }
        
# FixQuotes() takes a string and returns a properly quoted string
# This function does not work on properly-formatted .ini text; instead, it assumes no surrounding quotes and single quotes, not double
function FixQuotes(s) {
    # if the string starts with Quotes, remove them
    if (s ~ /^".*"$/) {
        result = substr(s, 2, length(s) - 2)
    } else {
        result = s
    }
    
    # remove leading \n
    while (result ~ /^\\n/) {
        result = substr(result, 3, length(result) - 2)
    }
    
    # remove trailing \n
    while (result ~ /\\n$/) {
        result = substr(result, 1, length(result) - 2)
    }
    
    # double-up the quotes
    gsub(/"/, "\"\"", result)
    
    # add \n to front and back
    result = sprintf("\\n%s\\n", result)
    
    # if there are quotes, enclose string in another set
    if (result ~ /"/) {
        result = "\"" result "\""
    }
    
    return result
}


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }

function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }

function trim(s) { return rtrim(ltrim(s)); }

function copyFile(sourceFilename, targetFilename) {
    system("cp " sourceFilename " " targetFilename)
}

function deleteFile(filename) {
    system("rm -f " filename " >/dev/null &2>/dev/null")
}

function combineLocalization(header, sourceFile, targetFile,      output, tosser, line, first) {
    output = "combineLocalization.temp.txt"
    if (getline < output >= 0) deleteFile(output)
    
    # strip out lines that will be replaced
    tosserRegex = sprintf("^%s[^,]*,.*$", header)

	# copy all lines from the localization file that will not be in the new one
	while ( ( getline line < targetFile ) > 0 ) {
		if ( line ~ tosserRegex ) {
			# do nothing--this line will be replaced by content from sourceFile

		} else {
			# this line will be kept, so send it to the output file
			# print "output: " line
			print line >> output
		}
	}

	close(output)
    system("ls " output)
	
    # append the sourceFile to the output file when the header matches
    while ( ( getline line < sourceFile ) > 0 ) {
        if (line ~ tosserRegex) {
            # print "found line: " line
            print line >> output
        }
    }

    close(targetFile)
    close(sourceFile)
    close(output)
   
	system("mv " output " " targetFile)
}

function ConvertToVarTests(conditions,                      addEntry, condition, conditionIndex, conditionList, conditionResult, conditionSeparator, flipConditionFlag) {
	#printf "CTVT/Entry=%s\n", conditions >>stderr
	
	# divide it up on spaces
	split(conditions, conditionList, " ")
	
	isCondition = 1  # this alternates; 0=operator
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
