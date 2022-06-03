%define SYS_EXIT 60
%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDOUT 1


%define BUFFER_SIZE 2048


section .text
global _start

_start:
	; get first args for the name of the file
	add rsp, byte 10h
	pop rdi

	call _open_file
	.read_file:
		call _fill_buffer
		cmp rax, 0
		je .exit
		call _print_buffer
		jp .read_file

	.exit:
		mov [file_buffer], dword 10
		call _fill_buffer
		call _close_file
		call _exit

_open_file:
	; open file
	mov rax, SYS_OPEN
	mov rsi, 0
	syscall
	mov [fd], rax
	ret

_close_file:
	; close file
	mov rax, SYS_CLOSE
	mov rdi, fd
	syscall
	ret

_fill_buffer:
	; fill buffer with file content
	mov rax, SYS_READ
	mov rdi, [fd]
	mov rsi, file_buffer
	mov rdx, BUFFER_SIZE
	syscall
	ret

_print_buffer:
	; print the content of the buffer
	mov rdx, rax
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, file_buffer
	syscall
	ret

_exit:
	; exit asm program
	mov rax, SYS_EXIT
	mov rdi, 0
	syscall
	ret

section .data
	fd dw 0

section .bss
	file_buffer resb BUFFER_SIZE
