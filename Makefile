all: run
os_image.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os_image.bin

boot.bin: asm.asm
	nasm -f bin asm.asm -o boot.bin

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pie -c kernel.c -o kernel.o

kernel.bin: kernel.o
	ld -m elf_i386 -Ttext 0x1000 --oformat binary kernel.bin

run: os_image.bin
	qemu-system-i386 -drive -format=raw,file=os_image.bin

clean:
	rm -f *.bin *.o
