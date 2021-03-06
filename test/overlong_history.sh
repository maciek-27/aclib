#!/bin/bash
# Test script aclib - auto completion library
# This is part of automated (unit) test suite for library
#
# Purpose of this is to test behavior when amount of history entries exceeds max
# size of history buffer
#
# Copyright (c) 2015, Maciej Kaminski.
# Published under 2-clause BSD-style license
# 1. Redistributions of source code must retain the above copyright notice
# 2. Redistributions in binary form must reproduce the above copyright notice

#assume that there is limit to 200 history entries.
#therefore in process of entering 250 commands, first 50 will be dropped
# next 51st will be dropped when entering command 'history';
# therefore 'history' shall contain entries 52-200 and word 'history'
echo "Possible completions test" >> test_log
(
    for i in `seq 250`
    do
	echo code $i;
    done
    echo history
) | ../example | grep \# | (
	for i in `seq 52 250`
	do
	    read str
	    echo -n "$i compare $str "
	    if [[ "# code $i" = $str ]] 
	    then
		echo OK
	    else
		echo FAIL!
		exit 1;
	    fi
	done
	read str
	echo -n "history compare $str "
	if [[ "# history" = $str ]] 
	then
	    echo OK
	else
	    echo FAIL!
	    exit 1;
	fi
    )
exit 0
