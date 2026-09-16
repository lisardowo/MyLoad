all: run

os_image.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os_image.bin
	dd if=/dev/zero bs=512 count=15 >> os_image.bin

boot.bin: bootloader.asm
	nasm -f bin bootloader.asm -o boot.bin

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -mno-sse -mno-mmx -mno-sse2 -c kernel.c -o kernel.o

kernel.bin: kernel.o
	ld -m elf_i386 -T linker.ld kernel.o -o kernel.bin
run: os_image.bin
	qemu-system-i386 -drive format=raw,file=os_image.bin

clean:
	rm -f *.bin *.o
