	.data
array:	.word 1, 2, 3, 4
read:	.asciiz "Introduce el numero que quieres intercambiar"
notfound:	.asciiz "Valor no encontrado"
	
	.text
main:
	la $a0, read
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	la $a0, array
	move $a1, $v0
	li $a2, 0
	li $a3, 4
	jal buscarDesde
	
	beq $v0, -1, NotFound
	
	move $a0, $v0
	addi $a1, $a0, 1
	la $a2, array
	jal intercambiar
	
	la $a0, array
	jal imprimir

exit:
	li $v0, 10
	syscall
NotFound:
	la $a0, notfound
	li $v0, 4
	syscall
	j exit
buscarDesde:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	sw $a2, 0($fp)
	
	bgt $a2,$a3, menosuno
	
	mul $t0, $a2, 4
	add $t1, $t0, $a0
	
	lw $t2, ($t1)

	beq $t2, $a1, pos
	
	addi $a2, $a2, 1
	jal buscarDesde
	
	j EndbuscarDesde
		
menosuno:
	li $v0, -1
	j EndbuscarDesde
	
pos:
	lw $a0, 0($fp)
	move $v0, $a0		
	
EndbuscarDesde:
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
intercambiar:
	
	mul $t0, $a0, 4
	add $t1, $a2, $t0
	
	mul $t2, $a1, 4
	add $t3, $a2, $t2
	
	lw $t4, ($t1)
	lw $t5,($t3)
	
	sw $t5, ($t1)
	sw $t4, ($t3)
	
	jr $ra
	
	move $t0, $a1
	sw $a0, ($a1)
	sw $t0, ($a0)
	
	jr $ra

imprimir:
	li $t1, 0
printloop:
	move $t0, $a0
	
	lw $a0, ($a0)
	li $v0, 1
	syscall
	
	add, $a0, $t0, 4
	
	add $t1, $t1, 1
	
	beq $t1,4,  exit
	
	b printloop
