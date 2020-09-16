#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>
#include <stdlib.h>

/* Função disponível fora dessa unidade de compilação.  No caso, ela foi
   codificada em is_prime.32/64.s.  */
extern int is_prime (int number);


/* Funções static não são expostas para os demais arquivos.  Use-as sempre que
   não quiser que ela seja visível externamente.  */
static void
print_usage_message (void)
{
  fputs (
  "sieve: Check if number is prime.\n\n"
  "Usage: sieve <NUM_TO_SIEVE>\n",
  stdout
  );
}

/* Checa se string disponível em str é um número.  */
static bool
is_number (const char *str)
{
  while (*str != '\0')
    if (!isdigit (*str++))
      return false;

  return true;
}

int main (int argc, char *argv[])
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
      fprintf (stdout, "Error: %s is not a number!\n", argv[1]);
      return 1;
    }

  /* Converte string para inteiro.  */
  number = atoi (argv[1]);

  if (is_prime (number))
    fprintf (stdout, "%d is a prime number!\n", number);
  else
    fprintf (stdout, "%d is NOT a prime number!\n", number);

  return 0;
}
