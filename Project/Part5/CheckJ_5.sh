#!/bin/bash


JPATH="../../Jexpr"


SCRIPT=$0
ERRLINES=10
DASHJ="-x"
TIMEOUT=10
MODE=5

usage()
{
  echo "Usage: $SCRIPT executable [options] infile infile ..."
	echo "Run compiler executable, in mode $MODE, on specified input files"
	echo "and compare with expected output files."
  echo "Any infile without corresponding output files will be skipped"
  echo "Options: "
  echo "  -gb:  generate basic stack management output files"
  echo "  -gs:  generate smart stack management output files"
  echo "  -o:   use -o instead of stdout to collect output"
  echo "  -j:   use Java assembly for comparison"
  echo "  -x:   use analyzed expression for comparison"
  echo "  -t N: set timeout to N seconds (default is $TIMEOUT)"
  echo "        0 seconds uses no timeout"
  exit $1
}

bailout()
{
  echo
  echo "Caught CTRL-C, terminating script"
  echo
  exit 1
}


green()
{
  printf "[1;32m$1[0;39m$2"
}

cyan()
{
  printf "[1;36m$1[0;39m$2"
}

yellow()
{
  printf "[1;33m$1[0;39m$2"
}

red()
{
  printf "[1;31m$1[0;39m$2"
}

codestr()
{
  if [ "$DASHJ" ]; then
    echo "assembly code"
  else
    echo "code computes"
  fi
}

# Arg1: main file
# Arg2: extra file
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
# Arg1: file to display
# Arg2: header or empty
#
displayError()
{
    if [ "$2" ]; then
      printf "\t\t$2\n"
    fi
    printf "\t\t--------------------------------------------------------\n"
    awk '(NR<11) {print "\t\t|  " $0}' $1
    printf "\t\t--------------------------------------------------------\n"
}

# Arg1: base name
timeoutCompile()
{
  base=$1
  infile="$base.c"
  outfile="$base.student.j"
  errfile="student.error"
  if [ $DASHO ]; then
    nice $EXE -$MODE -o $outfile $infile 2> $errfile &
    PID=$!
  else
    nice $EXE -$MODE $infile 1> $outfile 2> $errfile &
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
        if [ $killsignal ]; then
          kill $killsignal $PID
        else
          kill $PID
          killsignal="-9"
        fi
        echo "Timeout exceeded ($TIMEOUT secconds)" > $errfile
      fi
    else
      # completed
      return 0
    fi
  done
}

#
# Arg1: student output
# Arg2: basic output
# Arg3: smart output or empty
#
different()
{
  yellow "DIFFERENT" "\n"
  yellow "\t\tStudent `codestr`" "\n"
  printf "\t\t--------------------------------------------------------\n"
  awk '{print "\t\t|  " $0}' <<< "$1"
  printf "\t\t--------------------------------------------------------\n"

  cyan "\t\tBasic stack `codestr`" "\n"
  printf "\t\t--------------------------------------------------------\n"
  awk '{print "\t\t|  " $0}' <<< "$2"
  printf "\t\t--------------------------------------------------------\n"

  if [ "$3" ]; then
    green "\t\tSmart stack `codestr`" "\n"
    printf "\t\t--------------------------------------------------------\n"
    awk '{print "\t\t|  " $0}' <<< "$3"
    printf "\t\t--------------------------------------------------------\n"
  fi
}

#
# Arg1: base name
analyze()
{
  base="$1"
  student="$base.student.j"
  basic="$base.basic.j"
  smart="$base.smart.j"
  if [ ! -f "$smart" ]; then
    smart=""
  fi
  if [ ! -f "$basic" ]; then
    return 1
  fi

  if [ "x-j" == "x$DASHJ" ]; then
    green "    Compilation successful, comparing Java assembly" "\n"
  else
    green "    Compilation successful, comparing analyzed expressions" "\n"
  fi

  jexpr="$JPATH/jexpr -T -V $DASHJ"

  if ! $jexpr $student > /dev/null 2> student.log; then
    red "    Failed to parse generated .j file" "\n"
    displayError student.log
    rm student.log
    return 1
  fi
  rm student.log

  list=`awk '/;;/{print $NF}' $basic | uniq | xargs`

  for line in $list; do
    outstu=`$jexpr -L $line $student | grep -v "^ *;"`
    outbas=`$jexpr -L $line $basic | grep -v "^ *;"`
    if [ "$smart" ]; then
      outsma=`$jexpr -L $line $smart | grep -v "^ *;"`
      if [ "$outsma" == "$outbas" ]; then
        outsma=""
      fi
    else
      outsma=""
    fi

    if [ ! "$outbas" ]; then
      continue
    fi

    printf "    Line %3d: " "$line"

    if [ ! "$outstu" ]; then
      red "MISSING" "\n"
      continue
    fi

    if [ ! "$outsma" ]; then
      if [ "$outstu" == "$outbas" ]; then
        green  "MATCHES both" "\n"
      else
        different "$outstu" "$outbas"
      fi
      continue
    fi
    if [ "$outstu" == "$outsma" ]; then
      green  "MATCHES smart stack" "\n"
      continue
    fi
    if [ "$outstu" == "$outbas" ]; then
      cyan   "MATCHES basic stack" "\n"
    else
      different "$outstu" "$outbas" "$outsma"
    fi

  done
}

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
    green "    First error messages match" "\n"
    return 0
  fi

  lineoracle=`striplines <<< "$firstoracle"`
  linestudent=`striplines <<< "$firststudent"`
  if [ "$lineoracle" == "$linestudent" ]; then
    cyan "    First error messages match lines" "\n"
  elif [ "$linestudent" ]; then
    yellow "    First error message lines different" "\n"
  else
    red "    Missing error message" "\n"
  fi
  displayError $1 "Expected error stream"
  displayError $2 "Student's error stream"
}



#############################################################

trap bailout INT

if [ $# -eq 0 ]; then
  usage 0
fi

# Check jexpr executable
if ! $JPATH/jexpr -h 2> /dev/null; then
  echo
  echo "Couldn't run jexpr utility; checked $JPATH/jexpr "
  echo "To fix this, either copy (or link) the jexpr executable"
  echo "into the search directory, or set variable JPATH at the start"
  echo "of the script to change where the script looks for the executable."
  echo
  exit 1
fi

EXE="$1"
shift

GENERATE=""
GFLAGS=""

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
    -j)
        DASHJ="-j"
        continue
        ;;

    -x)
        DASHJ="-x"
        continue
        ;;

    -gb)
        GENERATE="basic"
        GFLAGS=""
        continue
        ;;

    -gs)
        GENERATE="smart"
        GFLAGS="-r -s"
        continue
        ;;

    -o)
        DASHO="y"
        continue
        ;;

    -t)
        TOnext="y"
        continue
        ;;

  esac

  # Generate base name
  BASE=`basename -s .c $arg`
  if [ ! -f "$BASE.c" ]; then
    continue
  fi

  #
  # Special cases: generating outputs
  #

  if [ $GENERATE ]; then
    echo generating $GENERATE outputs for $arg in mode $MODE
    $EXE -$MODE $GFLAGS -o $BASE.$GENERATE.j $arg 2> $BASE.error
    if [ -s $BASE.error ]; then
      touch $BASE.basic.j $BASE.smart.j $BASE.output
      rm $BASE.basic.j $BASE.smart.j $BASE.output*
    else
      rm $BASE.error
      checkDuplicate $BASE.basic.j $BASE.smart.j
    fi
    continue
  fi

  #
  # Files that generate errors
  #
  if [ -f $BASE.error ]; then
    echo "Checking $arg"
    timeoutCompile $BASE
    compareInvalid $BASE.error student.error
    touch student.error
    rm student.error
    continue
  fi

  #
  # Files that generate outputs
  #
  if [ -f $BASE.basic.j ]; then
    echo "Checking $arg"
    timeoutCompile $BASE
    if [ -s student.error ]; then
      red "    Compilation generated errors (first 10 lines):" "\n"
      displayError student.error
    else
      analyze $BASE
    fi
    touch $BASE.student.j
    rm $BASE.student.j
  fi
  touch student.error
  rm student.error

done

