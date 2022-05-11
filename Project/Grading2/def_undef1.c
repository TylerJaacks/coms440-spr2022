
#define MAX 400

int MAX;    // would be a parse error

#undef MAX

int MAX, MIN;

#undef MIN  // does nothing

int MIN;
