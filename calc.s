.equ read,0x03
.equ write,0x04
.equ exit,0x01
.equ stdin, 0x00
.equ stdout, 0x01
.equ kernel, 0x80

.data

counter: .byte 0x00
txt_A:
    .ascii "Wprowadz a:\n"
txt_B:
    .ascii "Wprowadz b:\n"
txt_C:
    .ascii "Podaj dzialanie:\n"
io_buffer:
	.ascii "                                                                "

.text
.global _start

.macro disp_str address, length
	mov $write, %eax
	mov $stdout, %ebx
	mov \address, %ecx
	mov \length, %edx
	int $kernel
	.endm

.macro exit_prog exit_code
	mov $exit, %eax
	mov \exit_code, %ebx
	int $kernel
.endm

_start:
	mov $0x10, %eax # read 16 bytes
	call read_stdin

	cmp $0, %eax
	jz _exit

    disp_str $txt_A, $11
	disp_str $io_buffer, $64

_exit:
    exit_prog $0

#----------------------------------------
#
#	@func: read_stdin
# 	@args: %eax - bytes to read
# 	@retu: %eax - read bytes
# 	@note: Does not save the eax!
#
.type read_stdin, @function
read_stdin:
	push %rbx
	push %rcx
	push %rdx
	
	mov %eax, %edx # how much to read
	mov $read, %eax # sys func index
	mov $stdin, %ebx # from stdin
	mov $io_buffer, %ecx # into this buffer
	int $kernel

	pop %rdx
	pop %rcx
	pop %rbx
	
	ret
