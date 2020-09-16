CC=/usr/lib/gcc/x86_64-linux-gnu/10/cc1
CFLAGS=-quiet -I/usr/include/
ASM=as
ASMFLAGS=--64
LD=ld
LDFLAGS= -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie \
/usr/lib/gcc/x86_64-linux-gnu/10/../../../x86_64-linux-gnu/Scrt1.o \
/usr/lib/gcc/x86_64-linux-gnu/10/../../../x86_64-linux-gnu/crti.o \
/usr/lib/gcc/x86_64-linux-gnu/10/crtbeginS.o \
-L/usr/lib/gcc/x86_64-linux-gnu/10 \
-lc -lgcc \
/usr/lib/gcc/x86_64-linux-gnu/10/crtendS.o \
/usr/lib/gcc/x86_64-linux-gnu/10/../../../x86_64-linux-gnu/crtn.o

bin: a.o b.o
	$(LD) $(LDFLAGS) $^ -o $@

a.s: a.c
	$(CC) $(CFLAGS) $< -o $@

b.s: b.c
	$(CC) $(CFLAGS) $< -o $@

%.o: %.s
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f *.s *.o bin
