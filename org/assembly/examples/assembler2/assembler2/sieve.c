/* Função disponível fora dessa unidade de compilação.  No caso, ela foi
   codificada em is_prime.32/64.s.  */

extern int is_prime (int number);
extern void print_it (int n, const char *str);

static void
print (const char * str)
{
  int n = 0;
  const char *ptr = str;

  while (*ptr++ != '\0')
    n++;

  print_it (n, str);
}

/* Funções static não são expostas para os demais arquivos.  Use-as sempre que
   não quiser que ela seja visível externamente.  */
static void
print_usage_message (void)
{
  print (
  "sieve: Check if number is prime.\n\n"
  "Usage: sieve <NUM_TO_SIEVE>\n"
  );
}

/* Checa se string disponível em str é um número.  */
static int
is_number (const char *str)
{
  while (*str != '\0')
    {
      char c = *str++;
      if ('0' <= c && c <= '9')
	return 1;
    }
  return 0;
}

static int atoi (const char *str)
{
  int value = 0;

  const char *ptr;
  for (ptr = str; *ptr != '\0'; ptr++)
    value = value*10 + (*ptr - '0');

  return value;
}

int
main (int argc, char* argv[])
{
  int number;

  if (argc != 2)
    {
      /* Poucos parâmetros (ou demais?).  */
      print_usage_message ();
      return 1;
    }

  if (!is_number (argv[1]))
    {
      print ("Error: ");
      print (argv[0]);
      print (" is not a number!\n");
      return 1;
    }

  /* Converte string para inteiro.  */
  number = atoi (argv[1]);

  if (is_prime (number))
    {
      print (argv[1]);
      print (" is a prime number!\n");
    }
  else
    {
      print (argv[1]);
      print (" is NOT a prime number!\n");
    }

  return 0;
}
