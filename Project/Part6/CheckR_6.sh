#!/bin/bash

KPATH="$HOME/Krakatau"

ASSEMBLE=""

TIMEOUT=10
SCRIPT=$0
MODE=6
DASHO=""
FLAGS=""
DETAIL="y"

usage()
{
  echo "Usage: $SCRIPT [-G | executable [options]] infile infile ..."
  echo "Any infile without corresponding output files will be skipped"
  echo "Options: "
  echo "  -c S: Use additional compiler switches in string S"
  echo "  -G:   generate test outputs with gcc"
  echo "  -o:   use -o instead of stdout to collect output"
  echo "  -s:   short comparison; doesn't show diff"
  echo "  -t N: set timeout to N seconds (default is $TIMEOUT)"
  echo "        0 seconds uses no timeout"
  exit $1
}

checkEnviron()
{
  #
  # Find java assembler
  #
  if assemble.py -h > /dev/null 2>/dev/null; then
    ASSEMBLE="assemble.py"
  elif $KPATH/assemble.py -h > /dev/null 2>/dev/null; then
    ASSEMBLE="$KPATH/assemble.py"
  else
    echo
    echo "    Didn't find assembler; either add it to your path or"
    echo "    set KPATH at the beginning of the script."
    echo
    exit 1
  fi

  #
  # Make sure java is installed
  #
  if ! java -version > /dev/null 2> /dev/null; then
    echo
    echo "    Missing java runtime environment?"
    echo
    exit 1
  fi
  if ! javac -version > /dev/null 2> /dev/null; then
    echo
    echo "    Missing java compiler?"
    echo
    exit 1
  fi

  #
  # Build libc.class if needed
  #
  if [ ! -f libc.class ]; then
    javac libc.java
    if [ ! -f libc.class ]; then
      echo
      echo "    Couldn't build libc.class, needed for supporting functions"
      echo
      exit 1
    fi
  fi

  #
  # Check executable
  #
  $EXE -0 | awk '{print "  | " $0}' > .exeout
  if [ -s .exeout ]; then
    echo Running tests using compiler:
    cat .exeout
    rm .exeout
  else
    rm .exeout
    echo
    echo "Error running compiler executable: $EXE"
    echo "But this might be an error in mode 0."
    echo "Run script with no arguments to see usage instructions."
    echo
    printf "Continuing in aa seconds..."
    for w in 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1; do
      printf "\b\b\b\b\b\b\b\b\b\b\b\b\b%02d seconds..." "$w"
      sleep 1
    done
    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b.                \n"
  fi
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


augment_source()
{
  echo "#include <stdio.h>"
  cat $1
}

# Arg1: base source file
generateGCCOuts()
{
  if ! grep -q "int main()" $1.c; then
    return 0
  fi
  echo "Generating files for $1.c"
  augment_source $1.c > __$1.c
  if gcc __$1.c; then
    green "    gcc compiled no problems" "\n"
    rm __$1.c
  else
    red   "    gcc had compile errors" "\n"
    rm __$1.c
    return 0
  fi

  errs=0
  lastin=""
  for infile in $1.input*; do
    if [ -f $infile ]; then
      outfile=`sed "s/$1.input/$1.output/" <<< $infile`
      ./a.out < $infile > $outfile
    else
      outfile=$1.output
      ./a.out > $outfile
    fi
    green "    $outfile" "\n"
  done
  rm a.out
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
          red "$2"
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
  if [ $DASHO ]; then
    nice $EXE -$MODE $FLAGS -o $outfile $infile 2> $errfile &
    timeout $! "Timeout exceeded"
  else
    nice $EXE -$MODE $FLAGS $infile 1> $outfile 2> $errfile &
    timeout $! "Timeout exceeded"
  fi
}

# Arg1: java class
# Arg2: output file
# Arg3: input file or empty
timeoutJava()
{
  if [ "$3" ]; then
    nice java $1 > $2 < $3 &
  else
    nice java $1 > $2 &
  fi
  timeout $! "Timeout exceeded\n        "
}


# Arg1: base
# Arg2: outfile
# Arg3: infile or missing
#
compareOut()
{
  if [ ! -f $2 ]; then
    return 0
  fi
  printf "    "
  echo "" > student.out.txt
  if [ -f $3 ]; then
    showinput=" on input $3"
    timeoutJava $1 student.out.txt $3
  else
    showinput=""
    timeoutJava $1 student.out.txt
  fi
  if diff -q student.out.txt $2 > /dev/null; then
    green "output matches" "$showinput\n"
  else
    red "output differs" "$showinput\n"
    if [ "$DETAIL" ]; then
      echo "         Expected output (first 20 lines):"
      echo "         ---------------------------------------------------------"
      awk '(NR<21) {print "         | " $0}' $2
      echo "         ---------------------------------------------------------"
      echo
      echo "         Given output (first 20 lines):"
      echo "         ---------------------------------------------------------"
      awk '(NR<21) {print "         | " $0}' student.out.txt
      echo "         ---------------------------------------------------------"
    fi
  fi
  rm student.out.txt
}

# Arg1: base
testOuts()
{
  cp -p $1.c $1.c.backup
  echo "" > student.error
  echo "" > $1.j
  printf "$1.c"
  timeoutCompile $1.c $1.j student.error
  printf "\n"
  if diff -q $1.c $1.c.backup > /dev/null; then
    rm $1.c.backup
  else
    red "    Input file mangled, restoring" "\n"
    mv -f $1.c.backup $1.c
  fi
  if [ -s student.error ]; then
    red  "    Unexpected compile error" "\n"
    echo "         First 20 lines of error stream:"
    echo "         ---------------------------------------------------------"
    awk '(NR<21) {print "         | " $0}' student.error
    echo "         ---------------------------------------------------------"
    rm student.error $1.j
    return 0
  fi
  rm student.error
  green "    No compile errors" ", running assembler\n"
  if $ASSEMBLE $1.j > /dev/null 2> student.log ; then
    green "    Target code assembles" ", running tests\n"
    rm student.log
    rm $1.j
  else
    red "    Target code assembly failed:" "\n"
    awk '{print "        | " $0}' student.log
    rm student.log
    rm $1.j
    return 0
  fi

  notests="y"
  for outfile in $1.output*; do
    if [ ! -f $outfile ]; then
      continue
    fi
    notests=""
    infile=`sed "s/$1.output/$1.input/" <<< $outfile`
    compareOut $1 $outfile $infile
  done

  if [ "$notests" ]; then
    red "    No test outputs; check with another script" "\n"
  fi

  rm $1.class
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

  if [ ! "$firststudent" ]; then
    red "    Missing error message" "\n"
    return 0
  fi

  if [ "$firstoracle" == "$firststudent" ]; then
    green "    First error messages match" "\n"
    return 0
  fi

  lineoracle=`striplines <<< "$firstoracle"`
  linestudent=`striplines <<< "$firststudent"`
  if [ "$lineoracle" == "$linestudent" ]; then
    cyan "    First error messages match lines" "\n"
  else
    yellow "    First error message lines different" "\n"
  fi
  displayError $1 "Expected error stream"
  displayError $2 "Student's error stream"
}

bailout()
{
  echo
  echo "Caught CTRL-C, terminating script"
  echo
  exit 1
}


#############################################################

trap bailout INT

if [ $# -eq 0 ]; then
  usage 0
fi

EXE="$1"
shift

if [ "x-G" == "x$EXE" ]; then
  for arg; do
    BASE=`basename -s .c $arg`
    if [ ! -f $BASE.c ]; then
      continue
    fi

    generateGCCOuts $BASE
  done
  exit 0
fi

checkEnviron

echo

Fnext=""
TOnext=""
for arg; do

# check for options/switches

  if [ $TOnext ]; then
    TIMEOUT=$arg
    TOnext=""
    continue
  fi

  if [ $Fnext ]; then
    FLAGS=$arg
    Fnext=""
    continue
  fi

  case "$arg" in
    -c)
        Fnext="y"
        continue
        ;;

    -s)
        DETAIL=""
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

  if [ ! -f $arg ]; then
    continue
  fi

  BASE=`basename -s .c $arg`
  if [ ! -f $BASE.c ]; then
    continue
  fi

  if [ -f $BASE.error ]; then
    printf "$BASE.c"
    timeoutCompile $BASE.c $BASE.j student.error
    printf "\n"
    compareInvalid $BASE.error student.error
    touch student.error $BASE.j
    rm student.error $BASE.j
    continue
  fi
  testOuts $BASE
done
