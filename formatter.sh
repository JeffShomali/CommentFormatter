#!/bin/bash
#===============================================================================
#          FILE: formatter.sh
#         USAGE: ./formatter.sh filename
#   DESCRIPTION: Formating Assembli source comment
#        AUTHOR: Jeff, Shomali
#  ORGANIZATION: Jeffshomali.com
#       CREATED: Wednesday Jun 03 2015 21:20
#      REVISION:  ---
#===============================================================================
typeset -a Code=() 				# empty array to hold portian of input lines
typeset -a Comment=() 				# empty array to hold comment portion of input lines
typeset -i Max=0				# initialize maximum code length
Spaces='					                 '   # string of spaces


# Pass 1 : Separate lines into code and comment and calculate maximum code length
Index=0  						# initialize array Index
while IFS='' read Line ; do     			# preserve leading  and trailing spaces
	Semi=$(expr index "$Line" ';')
case $Semi  in
	0)  						 # ; absent
	    Code[Index]="$Line"		 		 # entire line in code
	    Comment[Index]=''        			 # null
	;;
	1) 						 # ; at beginning
		Code[Index]="$Line"      		 # entire lines is comment
		Comment[Index]='' 			 # null
	;;
	*) 						 # ; not first next lines removes ;  spaces =before everything after
		Code[Index]=$(echo "$Line" | sed -e 's/[ ]*;.*$//')
		Comment[Index]="${Line:$Semi -1}"
	;;
esac

if (( ${#Code[Index]} > Max )) ; then  			# longer than previous maximum
	Max=${Code[Index]}                  		#  new maximum code length
fi
  ((++Index))
done

LineCount=$Index                        		# number of lines in array


# pass: output code, spacaes, comment
Index=0                         			# reinitialize array index
while (( $Index < $LineCount )) ; do    		# loop though arrays
    SpaceCount=$(( $Max - ${#Code[Index]} )) 		# number of spaces to insert
    echo "${Code[Index]}  ${Spaces:0:$SpaceCount}  ${Comment[Index]}"
    (( ++Index ))
done
