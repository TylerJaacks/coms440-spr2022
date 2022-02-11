#!/bin/bash

TIMEOUT=10
SCRIPT=$0
DASHO=""
SUMMARY=""

usage()
{
  echo "Usage: $SCRIPT executable [options] infile infile ..."
	echo "Run compiler executable, in mode 2, on specified input files"
	echo "and compare with expected output files."
  echo "Any infile without corresponding output files will be skipped"
  echo "Options: "
  echo "  -d:   detailed output (default)"
  echo "  -gb:  generate non-extra credit output files"
  echo "  -ge:  generate extra credit output files"
  echo "  -o:   use -o instead of stdout to collect output"
  echo "  -s:   summary output (opposite of -d)"
  echo "  -t N: set timeout to N seconds (default is $TIMEOUT)"
  echo "        0 seconds uses no timeout"
  exit $1
}

green()
{
  printf "[1;32m$1[0;39m$2"
}

yellow()
{
  printf "[1;33m$1[0;39m$2"
}

red()
{
  printf "[1;31m$1[0;39m$2"
}

striplines()
{
  sed -n 's/^.* error in .*line *\([0-9]*\).*/Error \1/p'
}

# Arg1: error file
firstError()
{
  awk '/^.* error in .*line *[0-9]*/ { errors++; if (errors>1) exit }\
       /^.* warning in .*line *[0-9]*/ { errors++; if (errors>1) exit }\
                              { if (errors) print }' $1
}

# Arg1: input file
# Arg2: output stub
timeoutCompile()
{
  infile=$1
  outfile=$2
  if [ $DASHO ]; then
    nice $EXE -2 -o $outfile.output2 $infile 2> $outfile.error2 &
    PID=$!
  else
    nice $EXE -2 $infile 1> $outfile.output2 2> $outfile.error2 &
    PID=$!
  fi
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
        red "    Timeout exceeded ($TIMEOUT seconds), terminating"
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

#
# Clean up temp files
#
cleanup()
{
  touch $STUB.output2 $STUB.error2 $STUB
  rm $STUB.output2 $STUB.error2 $STUB
}

bailout()
{
  echo
  echo "Caught CTRL-C, terminating script"
  echo
  cleanup
  exit 1
}

checkDuplicate()
{
  mainfile=$1
  extrafile=$2
  if [ -e $mainfile -a -e $extrafile ]; then
      if diff -b $mainfile $extrafile > /dev/null; then
        echo "  collapsing equal $extrafile"
        rm $extrafile
      fi
  fi
}

#
# Arg1: output stream
# Arg2: error stream
#
removeRedundant()
{
  if [ ! -f $1 ]; then
    return 0
  fi
  if [ ! -f $2 ]; then
    return 0
  fi
  if [ -s $2 ]; then
    rm $1
  else
    rm $2
  fi
}

# Arg1: oracle output file
# Arg2: student output file
# Arg3: student error file
#
# Writes:
#   : missing oracle
#   G output matches and empty error (Green)
#   Y output matches but nonempty error (Yellow)
#   R output different (Red)
#
compareValid()
{
  if [ ! -f $1 ]; then
    echo "."
    return 0
  fi
  if diff -w -q $1 $2 > /dev/null; then
    if [ -s $3 ]; then
      echo "Y"
    else
      echo "G"
    fi
  else
    echo "R"
  fi
}

# Arg1: oracle error file
# Arg2: student error file
#
# Writes:
#   . missing oracle
#   g first error matches perfectly (green)
#   y first error line numbers match  (yellow)
#   r first errors different  (red)
compareInvalid()
{
  if [ ! -f $1 ]; then
    echo ":"
    return 0
  fi
  firstoracle=`firstError $1`
  firststudent=`firstError $2`
  if [ "$firstoracle" == "$firststudent" ]; then
    echo "g"
    return 0
  fi

  lineoracle=`striplines <<< "$firstoracle"`
  linestudent=`striplines <<< "$firststudent"`
  if [ "$lineoracle" == "$linestudent" ]; then
    echo "y"
  else
    echo "r"
  fi
}




# Arg1: state
# Arg2: after text
showStatus()
{
  if [ "$1" == "G" ]; then
    green  "Output OK;  no errors" "$2"
  elif [ "$1" == "Y" ]; then
    yellow "Output OK; has errors" "$2"
  elif [ "$1" == "R" ]; then
    red    "Output  is  different" "$2"
  elif [ "$1" == "g" ]; then
    green  "First  error  matches" "$2"
  elif [ "$1" == "y" ]; then
    yellow "First error same line" "$2"
  elif [ "$1" == "r" ]; then
    red    "First error different" "$2"
  else
    printf "                     " "$2"
  fi
}

#
# $1: infile
# $2: basic status
# $3: extra status
#
# All empty? Prints header line.
#
# stati:
#    M = matches perfectly
#    F = first error matches perfectly
#    L = line numbers match for first error
#    D = first errors are different
#
summaryLine()
{
  infile=$1
  basic=$2
  extra=$3

  if [ $infile ]; then
    printf "%-25s   " $infile
    showStatus $basic "    "
    showStatus $extra
		printf "\n"
  else
    printf "%-25s   ---------------------    ---------------------\n" "-------------------------"
    printf "%-25s   Basic Implementation     Extra Implementation \n" "Test file"
    printf "%-25s   ---------------------    ---------------------\n" "-------------------------"
  fi
}

# Arg1: status
# Arg2: type (basic or extra)
# Arg3: oracle output
# Arg4: oracle error
# Arg5: student output
# Arg6: student error
detailLine()
{
  st=$1
  if [ "$st" == "." ]; then
    return 0
  fi
  if [ "$st" == ":" ]; then
    return 0
  fi
  printf "    $2 Implementation Comparison: "
  showStatus $st "\n"
  if [ "$st" == "G" ]; then
    return 0
  fi
  if [ "$st" == "g" ]; then
    return 0
  fi
  if [ "$st" == "R" ]; then
    diff -w $3 $5 | awk '{print "        | " $0}'
    st="Y"
  fi
  if [ "$st" == "Y" ]; then
    echo "        Complete error stream given (should be empty):"
    echo "        ---------------------------------------------------------"
    awk '{print "        | " $0}' $6
    echo "        ---------------------------------------------------------"
    return 0
  fi
  echo "        Expected first error:"
  echo "        ---------------------------------------------------------"
  firstError $4 | awk '{print "        | " $0}'
  echo "        ---------------------------------------------------------"
  echo
  echo "        Given first error:"
  echo "        ---------------------------------------------------------"
  firstError $6 | awk '{print "        | " $0}'
  echo "        ---------------------------------------------------------"
  echo "        Complete error stream given:"
  echo "        ---------------------------------------------------------"
  awk '{print "        | " $0}' $6
  echo "        ---------------------------------------------------------"
}


#############################################################

trap bailout INT

if [ $# -eq 0 ]; then
  usage 0
fi

STUB=`mktemp XXXXXX`

EXE="$1"
shift

# if [ ! -x "$EXE" ]; then
  # echo "Can't execute $EXE"
  # usage 1
# fi

GENBASIC=""
GENEXTRA=""


echo Running tests using compiler:
$EXE -0 | awk '{print "  | " $0}'

echo " "

TOnext=""
for arg; do

# check for options/switches

  if [ $TOnext ]; then
    TIMEOUT=$arg
    TOnext=""
    continue
  fi

  case "$arg" in
    -d)
        SUMMARY=""
        echo "----------------------------------------------------------------------"
        continue
        ;;

    -gb)
        GENBASIC="y"
        continue
        ;;

    -ge)
        GENEXTRA="y"
        continue
        ;;

    -o)
        DASHO="y"
        continue
        ;;

    -s)
        SUMMARY="y"
        summaryLine
        continue
        ;;

    -t)
        TOnext="y"
        continue
        ;;

  esac


  EXOUT="$arg.extra.output2"
  EXERR="$arg.extra.error2"
  BAOUT="$arg.output2"
  BAERR="$arg.error2"

# are we generating outputs?

  if [ $GENBASIC ]; then
    echo generating regular outputs for $arg in mode 2
    $EXE -2 -o $BAOUT $arg 2> $BAERR
    removeRedundant $BAOUT $BAERR
    checkDuplicate $BAOUT $EXOUT
    checkDuplicate $BAERR $EXERR
    continue
  fi

  if [ $GENEXTRA ]; then
    echo generating extra credit outputs for $arg in mode 2
    $EXE -2 -o $EXOUT $arg 2> $EXERR
    removeRedundant $EXOUT $EXERR
    checkDuplicate $BAOUT $EXOUT
    checkDuplicate $BAERR $EXERR
    continue
  fi

# Skip this input file if there's no output file.

  if [ ! -f $BAOUT -a ! -f $BAERR ]; then
    continue
  fi

# Run the compiler, with a timeout (in case it hangs)

  if [ ! $SUMMARY ]; then
    echo "$arg in mode 2"
  fi
  timeoutCompile $arg $STUB

#
# Get error/output stati
#
  if [ -f $BAERR ]; then
    STAT_BA=`compareInvalid $BAERR $STUB.error2`
  else
    STAT_BA=`compareValid $BAOUT $STUB.output2 $STUB.error2`
  fi

  if [ -f $EXERR ]; then
    STAT_EX=`compareInvalid $EXERR $STUB.error2`
  else
    STAT_EX=`compareValid $EXOUT $STUB.output2 $STUB.error2`
  fi

  if [ $SUMMARY ]; then
    summaryLine $arg $STAT_BA $STAT_EX
  else
    detailLine $STAT_BA "Basic" $BAOUT $BAERR $STUB.output2 $STUB.error2
    detailLine $STAT_EX "Extra Credit" $EXOUT $EXERR $STUB.output2 $STUB.error2
  fi

  rm $STUB.output2 $STUB.error2
done
cleanup

