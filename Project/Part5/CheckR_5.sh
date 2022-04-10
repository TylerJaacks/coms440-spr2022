#!/bin/bash

KPATH="$HOME/Krakatau"

ASSEMBLE=""

TIMEOUT=30
SCRIPT=$0
MODE=5
DASHO=""
FLAGS=""
DETAIL=""

usage()
{
  echo "Usage: $SCRIPT [-G | executable [options]] infile infile ..."
  echo "Any infile without corresponding output files will be skipped"
  echo "Options: "
  echo "  -c S: Use additional compiler switches in string S"
  echo "  -d:   more detailed comparison"
  echo "  -G:   generate test outputs with gcc"
  echo "  -o:   use -o instead of stdout to collect output"
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


  # Make sure executable works
  if [ ! -x $1 ]; then
    echo "Can't execute $1"
    usage 1
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

  sed 's/int main/int __main/' $1
cat <<EOF

  int main()
  {
    printf("Return code: %d\n", __main());
    return 0;
  }
EOF
}

# Arg1: base source file
generateGCCOuts()
{
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
    nice ./$EXE -$MODE $FLAGS -o $outfile $infile 2> $errfile &
    timeout $! "Timeout exceeded"
  else
    nice ./$EXE -$MODE $FLAGS $infile 1> $outfile 2> $errfile &
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
  showinput=""
  if [ "$3" ]; then
    showinput=" on input $3"
  fi
  printf "    "
  echo "" > student.out.txt
  timeoutJava $1 student.out.txt $3
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
  echo "" > student.error.txt
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
    rm student.error.txt $1.j
    return 0
  fi
  rm student.error.txt
  green "    No compile errors" ", running assembler\n"
  if $ASSEMBLE $1.j > /dev/null 2> student.log ; then
    green "    Target code assembles" ", running tests\n"
    rm $1.j
  else
    red "    Target code assembly failed:" "\n"
    awk '{print "        | " $0}' student.log
    rm student.log
    rm $1.j
    return 0
  fi

  lastin=""
  for infile in $1.input*; do
    if [ ! -f $infile ]; then
      continue
    fi
    lastin="$infile"
    outfile=`sed "s/$1.input/$1.output/" <<< $infile`
    compareOut $1 $outfile $infile
  done
  if [ ! "$lastin" ]; then
# No input files; that means the program does not take input.
    compareOut $1 $1.output
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

EXE=$1
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

checkEnviron $EXE

echo Running tests using compiler:
./$EXE -0 | awk '{print "  | " $0}'

echo " "

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

    -d)
        DETAIL="y"
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
    touch student.error
    rm student.error
    continue
  fi
  testOuts $BASE
done