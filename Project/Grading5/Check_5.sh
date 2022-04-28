#!/bin/bash

TIMEOUT=10
SCRIPT=$0
MODE=5
MYCC=""
OPTIONS=""
DASHO=""
DASHF=""


debug()
{
#  printf "%s\n" "$1"
  return
}

usage()
{
  echo "Usage: $SCRIPT \"executable\" (switches) infile infile ..."
  echo
  echo "Supported switches: "
  echo "    -f         : compiler uses fixed output file"
  echo "    -o         : use -o instead of stdout to collect output"
  echo "    -S options : invoke compiler with given option string"
  echo
  exit $1
}

GREEN="[1;32m"
CYAN="[1;36m"
YELLOW="[1;33m"
RED="[1;31m"
NORMAL="[0;39m"

green()
{
  printf "$GREEN%s$NORMAL$2" "$1"
}

cyan()
{
  printf "$CYAN%s$NORMAL$2" "$1"
}

yellow()
{
  printf "$YELLOW%s$NORMAL$2" "$1"
}

red()
{
  printf "$RED%s$NORMAL$2" "$1"
}

bailout()
{
  echo
  echo "Caught CTRL-C, terminating script"
  echo
  exit 1
}

# Arg1: PID to wait for
# Arg2: timeout message
timeout()
{
  PID=$1
  if [ $TIMEOUT -lt 1 ]; then
    wait
    return 0
  fi
  disown -r
# ^ avoid messages if we kill the process
  killsignal=""
  SECONDS=0
  while true; do
    sleep 1
    if ps $PID > /dev/null; then
      # still running
      if [ $SECONDS -gt $TIMEOUT ]; then
        if [ "$2" ]; then
          red "$2" "\n"
        fi
        if [ $killsignal ]; then
          kill $killsignal $PID
        else
          kill $PID
          killsignal="-9"
        fi
      fi
    else
      # completed
      return 0
    fi
  done
}

# Arg1: input file
# Arg2: output file
# Arg3: error file
timeoutCompile()
{
  infile=$1
  outfile=$2
  errfile=$3
  if [ $DASHF ]; then
    nice $MYCC -$MODE $OPTIONS  $infile 2> $errfile &
    timeout $! "Timeout exceeded"
  elif [ $DASHO ]; then
    nice $MYCC -$MODE $OPTIONS -o $outfile $infile 2> $errfile &
    timeout $! "Timeout exceeded"
  else
    nice $MYCC -$MODE $OPTIONS $infile 1> $outfile 2> $errfile &
    timeout $! "Timeout exceeded"
  fi
}

#
# Arg1: file to display
# Arg2: header or empty
#
displayError()
{
    if [ "$2" ]; then
      printf "\t\t  $2\n"
    fi
    printf "\t\t  --------------------------------------------------------\n"
    awk '(NR<11) {print "\t\t  |  " $0}' $1
    printf "\t\t  --------------------------------------------------------\n"
}


#
# Arg1: header or empty
#
showMethod()
{
  if [ "$1" ]; then
    printf "\t\t  $1\n"
  fi
  printf "\t\t  ----------------------------------------------------\n"
  indent=""
  while read -r line; do
    fw=`awk '{print $1}' <<< $line`
    if [ ".end" == "$fw" ]; then
      indent="${indent:2:200}"
      printf "\t\t  | $indent$line\n"
      continue
    fi
    if [ "." == "${fw:0:1}" ]; then
      printf "\t\t  | $indent$line\n"
      indent="$indent  "
      continue
    fi
    printf "\t\t  | $indent$YELLOW%s$NORMAL\n" "$line"
  done
  printf "\t\t  ----------------------------------------------------\n"
}

# Arg1: string to compare
# Remaining args: what to compare against
unique()
{
  key=$1
  shift
  for args; do
    if [ "$key" == "$args" ]; then
      return 1
    fi
  done
  return 0
}

# Arg1: string of comma-separated regexes to look for
# standard input: file to read from
# return 0 if found, 1 otherwise
findSeq()
{
  found=0
  notfound=1
  if [ ! "$1" ]; then
    return $notfound
  fi
  STEP=1
  LA=""
  LB=""
  LC=""
  LD=""
  OPTIONAL=""
  while read -r line; do
    if [ ! "$line" ]; then
      continue
    fi
    debug "Read line $line"

    while true; do

      SEQ=`awk -F, -v N=$STEP '{print $N}' <<< "$1"`
      if [ ! "$SEQ" ]; then
        return $found
      fi
      debug "    checking '$SEQ'"

      # special case: placeholder labels
      if grep "LA" <<< "$SEQ" > /dev/null; then
        if [ ! "$LA" ]; then
          sub=`sed 's|.*\(L[0-9]*\).*|\1|' <<< "$line"`
          if unique $sub $LB $LC $LD; then
            LA="$sub"
          else
            LA="LA"
          fi
        fi
        SEQ=`sed "s|LA|$LA|" <<< $SEQ`
      fi

      if grep "LB" <<< "$SEQ" > /dev/null; then
        if [ ! "$LB" ]; then
          sub=`sed 's|.*\(L[0-9]*\).*|\1|' <<< "$line"`
          if unique $sub $LA $LC $LD; then
            LB="$sub"
          else
            LB="LB"
          fi
        fi
        SEQ=`sed "s|LB|$LB|" <<< $SEQ`
      fi

      if grep "LC" <<< "$SEQ" > /dev/null; then
        if [ ! "$LC" ]; then
          sub=`sed 's|.*\(L[0-9]*\).*|\1|' <<< "$line"`
          if unique $sub $LA $LB $LD; then
            LC="$sub"
          else
            LC="LC"
          fi
        fi
        SEQ=`sed "s|LC|$LC|" <<< $SEQ`
      fi

      if grep "LD" <<< "$SEQ" > /dev/null; then
        if [ ! "$LD" ]; then
          sub=`sed 's|.*\(L[0-9]*\).*|\1|' <<< "$line"`
          if unique $sub $LA $LB $LC; then
            LD="$sub"
          else
            LD="LD"
          fi
        fi
        SEQ=`sed "s|LD|$LD|" <<< $SEQ`
      fi


      # Is this optional?
      if [ ${SEQ::1} == "?" ]; then
        OPTIONAL="y"
        SEQ="${SEQ:1:100}"
      else
        OPTIONAL=""
      fi

      # Check for match
      if egrep "$SEQ" <<< "$line" > /dev/null; then
        debug "    matched $SEQ"
        STEP=$[STEP + 1]
        break
      fi

      # Ignore any extra labels
      if egrep "L.*:" <<< "$line" > /dev/null; then
        if unique "$line" "$LA:" "$LB:" "$LC:" "$LD:"; then
          debug "    ignored label $line"
          break
        fi
      fi

      # Skip optional matches
      if [ $OPTIONAL ]; then
        debug "    failed optional $SEQ"
        STEP=$[STEP + 1]
        continue
      fi

      debug "    failed $SEQ"
      STEP=1
      LA=""
      LB=""
      LC=""
      LD=""
      break
    done
  done
  return $notfound
}


#======================================================================

# Arg1: error file
firstError()
{
  awk '/^.* error in / { e++; if (e>1) exit; }  {if (e) print; }' $1
}

striplines()
{
  sed -n 's/^.* error in .*line *\([0-9]*\).*/Error \1/p'
}

# Arg1: oracle error file
# Arg2: student error file
compareInvalid()
{
  firstoracle=`firstError $1`
  firststudent=`firstError $2`
  if [ "$firstoracle" == "$firststudent" ]; then
    green "First error messages match" "\n"
    return 0
  fi

  lineoracle=`striplines <<< "$firstoracle"`
  linestudent=`striplines <<< "$firststudent"`
  if [ "$lineoracle" == "$linestudent" ]; then
    cyan "First error messages match lines" "\n"
  elif [ "$linestudent" ]; then
    yellow "First error message lines different" "\n"
  else
    red "Missing error message" "\n"
  fi
  displayError $1 "Expected error stream"
  displayError $2 "Student's error stream"
}

#======================================================================

#
# Arg1: base
#
# Read and process the key file
processKey()
{
    testfunc=""
    ttype=""
    preferred=""
    sequence=""
    seqno="1"
    passed=""
    testnum="0"
    while read -r first rest; do
        #
        # Skip blank lines and comment lines
        #
        if [ ! "$first" ]; then
            continue
        fi
        if [ "$first" == "#" ]; then
            continue
        fi
        #
        # Start of a test
        #
        if [ "$first" == "FIND" -o "$first" == "OMIT" ]; then
            testnum=$[ testnum + 1 ]
            testfunc="$rest"
            ttype="$first"

            #
            # Extract and clean up method
            #
            sed -n "/.method.* $testfunc/,/.end.*method/p" $1.j | sed 's/;.*//' | sed 's/L.*:/&\n/' | grep -v "^ *$" | tr '\t' ' ' | sed 's/ * / /g' > $1.m

            preferred=""
            sequence=""
            seqno="1"
            passed=""
            printf "%12s %2d:  " "Test" "$testnum"
            continue
        fi

        #
        # Already determined test outcome, skip to the next one
        #
        if [ "$passed" ]; then
            continue
        fi

        #
        # Sequence delimeter
        #

        if [ "$first" == "====" -o "$first" == "END" ]; then
            if [ "$ttype" != "OMIT" ]; then
                if findSeq "$sequence" < $1.m; then
                    green "#$seqno" "  "
                    passed="y"
                else
                    yellow "#$seqno" "  "
                    # if [ ! "$preferred" ]; then
                        preferred="$sequence"
                    # fi
                    if [ "$first" == "END" ]; then
                      passed="n"
                    fi
                fi
            else
                if findSeq "$sequence" < $1.m; then
                    yellow "#$seqno" "  "
                    passed="n"
                    preferred="$sequence"
                else
                    green "#$seqno" "  "
                    if [ "$first" == "END" ]; then
                      passed="y"
                    fi
                fi
            fi

            sequence=""
            seqno=$[ seqno + 1 ]

            #
            # Did a test just pass?
            #
            if [ "xy" == "x$passed" ]; then
                green "PASSED" "\n"
            fi

            #
            # Did a test just fail?
            #
            if [ "xn" == "x$passed" ]; then
                red   "FAILED" "\n"
                echo
                showMethod "Student's method" < $1.m
                echo
                if [ "$ttype" == "FIND" ]; then
                    tr ',' '\n' <<< "$preferred" | showMethod "One possible expected sequence"
                else
                    tr ',' '\n' <<< "$preferred" | showMethod "Sequence to avoid"
                fi
            fi

            continue
        fi


        #
        # More of a sequence
        #
        if [ "$rest" ]; then
            line="$first $rest"
        else
            line="$first"
        fi
        if [ "$sequence" ]; then
            sequence="$sequence,$line"
        else
            sequence="$line"
        fi
    done < $1.key
    touch $1.m
    rm $1.m
}

#======================================================================

if [ $# -lt 1 ]; then
  usage 0
fi

MYCC="$1"
shift

echo Running tests using compiler:
$MYCC -0 | awk '{print "  | " $0}'
echo " "


dashs=""
for args; do
  if [ "$dashs" ]; then
    OPTIONS="$args"
    dashs=""
    continue
  fi
  if [ "$args" == "-f" ]; then
    DASHF="y"
    continue
  fi
  if [ "$args" == "-S" ]; then
    dashs="y"
    continue
  fi
  if [ "$args" == "-o" ]; then
    DASHO="y"
    continue
  fi
  #
  # This is a source file
  #
  BASE=`basename -s .c $args`
  if [ ! -f "$BASE.c" ]; then
    continue
  fi

  #
  # Files that generate errors
  #
  if [ -f $BASE.error ]; then
    printf "%-15s:  " "$BASE.c"
    timeoutCompile $BASE.c $BASE.j student.error
    compareInvalid $BASE.error student.error
    touch $BASE.j student.error
    rm $BASE.j student.error
    continue
  fi

  #
  # Files that have a key
  #
  if [ -f "$BASE.key" ]; then
    printf "%-15s:  " "$BASE.c"
    timeoutCompile $BASE.c $BASE.j student.error
    if [ -s student.error ]; then
      red "Compilation generated errors (first 10 lines):" "\n"
      displayError student.error
    else
      green "No compile errors" "\n"
      processKey $BASE
    fi
    touch $BASE.j student.error
    rm $BASE.j student.error
    continue
  fi
done
