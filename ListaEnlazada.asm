	.data
read: .asciiz "Introduzca un numero "
readdelete: .asciiz "¿Qué numero quiere eliminar? "
readdeleted: .asciiz "El numero eliminado es: "

	.text 
main:
	li $s0, 0 # primer nodo
	li $s1, 0 # ultimo nodo

loop:
	la $a0, read
	li $v0, 4
	syscall
	
	la $v0, 5
	syscall
	
	beqz $v0, EndRead
	
	move $a0, $s1
	move $a1, $v0
	jal Insert
	
	move $s1, $v0
	
	beqz $s0, FirstNode
	
	b loop

FirstNode:
	move $s0, $v0
	
	b loop

EndRead:
	la $a0, readdelete
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0
	move $a1, $v0
	jal Remove
	
	beqz $v0, PrintList
	
	move $t0, $v0
	
	la $a0, readdeleted
	li $v0, 4
	syscall
	
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
PrintList:
	move $a0, $s0
	jal Print
	j Exit
Insert:
	
	move $t0, $a0
	
	li $a0, 8
	li $v0, 9
	syscall
	
	
	sw $a1, 0($v0)
	sw $zero, 4($v0)
	
	# si la lista esta vacia no lo enlazamos con ninguno
	beqz $t0,EndInsert
	
	# si no, lo enlazas
	sw $v0, 4($t0)
	
EndInsert:
	jr $ra
	
Remove:
	move $t0, $a0
RemoveLoop:
	beqz $t0, salir
	
	lw $t1, 0($t0)
	beq $t1, $a1, Delete
	
	move $t2, $t0
	
	lw $t0, 4($t0)
	
	b RemoveLoop

Delete:
	lw $t3, 4($t0)
	sw $t3, 4($t2)
	
	move $v0, $t0
	jr $ra
salir:
	li $v0, 0
	jr $ra

Print:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	
	lw $a0, 4($a0)
	beqz $a0, PrintF
	
	jal Print

PrintF:
	lw $a0, 0($fp)
	
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Exit:
	li $v0, 10
	syscall
	  
