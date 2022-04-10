
struct bigint {
  char digits[1000];
  int size;
};

struct rational {
  struct bigint numerator, denominator;
};

struct node {
  char type;
  struct rational value;
  int left, right;
  char op;
};

struct formula {
  struct node instr[256];
  int size;
};

struct location {
  char filename[128];
  int line;
};

struct stmt {
  struct location where;
  struct formula how;
};

struct function {
  char name[50];
  struct stmt exec[256];
  int size;
};

struct module {
  struct function funcs[256];
  int size;
};

struct program {
  struct module mods[256];
  int size;
};

void test()
{
  struct program P;

  P;
  P.size;
  P.mods;
  P.mods[42];
  P.mods[42].funcs;
  P.mods[42].funcs[0];
  P.mods[42].funcs[0].name;
  P.mods[42].funcs[0].exec;
  P.mods[42].funcs[0].exec[1];
  P.mods[42].funcs[0].exec[1].where;
  P.mods[42].funcs[0].exec[1].where.filename;
  P.mods[42].funcs[0].exec[1].where.filename[0];

  P.mods[42].funcs[0].exec[2].how;
  P.mods[42].funcs[0].exec[2].how.size;
  P.mods[42].funcs[0].exec[2].how.instr;
  P.mods[42].funcs[0].exec[2].how.instr[5];
  P.mods[42].funcs[0].exec[2].how.instr[5].type;
  P.mods[42].funcs[0].exec[2].how.instr[5].value;
  P.mods[42].funcs[0].exec[2].how.instr[5].value.denominator;
  P.mods[42].funcs[0].exec[2].how.instr[5].value.denominator.size;
  P.mods[42].funcs[0].exec[2].how.instr[5].value.denominator.digits;
  P.mods[42].funcs[0].exec[2].how.instr[5].value.denominator.digits[1];
}
