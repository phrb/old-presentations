CC=gcc
LDFLAGS=
ASM=nasm
CFLAGS = -O2 -Wall -Wextra

ifeq ($(shell getconf LONG_BIT),32)
$(info Your operating system do not support 64-bits binaries)
all: sieve32
else
all: sieve64 sieve32
endif


sieve64: sieve.64.o is_prime.64.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

is_prime.64.o: is_prime.64.s
	$(ASM) -felf64 $< -o $@

sieve.64.o: sieve.c
	$(CC) $(CFLAGS) -c $< -o $@

sieve32: sieve.32.o is_prime.32.o
	$(CC) $(CFLAGS) -m32 -o $@ $^ $(LDFLAGS)

sieve.32.o: sieve.c
	$(CC) $(CFLAGS) -m32 -c sieve.c -o $@

is_prime.32.o: is_prime.32.s
	$(ASM) -felf32 $< -o $@

clean:
	rm -f sieve32 sieve64 *.o
