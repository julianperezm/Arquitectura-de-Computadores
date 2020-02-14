	.data
read:	.asciiz "Introduce un numero "
readdelete: .asciiz "Introduzca el numero que desea eliminar "
stack:	.asciiz "Pila restante: "

	.text
main:
	li $s0, 0
loop:
	la $a0, read
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, EndRead
	
	move $a0, $s0
	move $a1, $v0
	jal Push
	
	beqz $v0, loop
	
	move $s0, $v0

	b loop

Exit:
	li $v0, 10
	syscall

EndRead:
	la $a0, readdelete
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0
	move $a1, $v0
	jal RemoveAll
	
	beqz $v0,Print
	
	move $s0, $v0
	
	jal Print

	
Push:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	
	move $t0, $a0
	
	move $a0, $a1
	move $a1, $t0
	jal Create
	
	lw $ra, 20($sp)
	addiu $sp, $sp, 32
	jr $ra

Create:
	move $t0, $a0
	
	li $a0, 8
	li $v0, 9
	syscall
	
	sw $t0, 0($v0)
	sw $a1, 4($v0)
	
	jr $ra

RemoveAll:
	
	# beqz $a0, Salir
	
	lw $t1, 0($a0)
	
	beq $t1, $a1, DeleteTop
	
	lw $t2, 4($a0)
	
	beqz $t2, Salir
	
	lw $t3, 0($t2)
	
	beq $t3, $a1, Delete
	
	lw $a0, 4($a0)
	
	b RemoveAll

DeleteTop:
	lw $v0, 4($a0)
	lw $a0, 4($a0)
	b RemoveAll

Delete:
	lw $t4, 4($t2)
	sw $t4, 4($a0)
	
	li $v0, 0
	
	b RemoveAll
Salir:
	jr $ra
	

Print:
	move $a0, $s0
	jal PrintList
	
	j Exit
	
PrintList:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	
	lw $a0, 4($a0)
	beqz $a0, PrintF
	
	jal PrintList

PrintF:
	lw $a0, 0($fp)
	
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
	
	