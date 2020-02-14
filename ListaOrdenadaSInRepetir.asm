	.data
read:	.asciiz "Introduce un numero"

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
	jal InsertInOrder
	
	beqz $v0, loop
	
	move $s0, $v0
	
	b loop
	
EndRead:
	move $a0, $s0
	jal Print

Exit:
	li $v0, 10
	syscall
	
InsertInOrder:
	move $t0, $a0
recorrer:
	
	
	beqz $t0, Insert
	
	lw $t1, 0($t0)
	
	beq $t1, $a1, NoInsert
	
	lw $t0, 4($t0)
	
	b recorrer
	
Insert:	
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	
	move $a0, $a1
	li $a1,0
	jal Create
	
	lw $t0, 0($fp)
	
	lw $t1, 0($v0)

	beqz $t0, First
	
	lw $t2, 0($t0)
	
	ble $t1, $t2, AddFirst

Insertloop:
	lw $t3, 4($t0)
	beqz $t3, AddLast
	lw $t4, 0($t3)
	
	ble $t1, $t4, AddMiddle
	
	lw $t0, 4($t0)
	b Insertloop
	
	
First:
	sw $t1, 0($v0)
	sw $zero, 4($v0)
	
	j EndInsertInOrder

AddFirst:
	sw $t0, 4($v0)
	
	j EndInsertInOrder	

AddMiddle:
	sw $v0, 4($t0)
	sw $t3, 4($v0)
	li $v0, 0
	
	j EndInsertInOrder
AddLast:	
	sw $v0, 4($t0)
	li $v0, 0
	j EndInsertInOrder
NoInsert:
	li $v0, 0
	jr $ra
EndInsertInOrder:
	lw $ra, 20($sp)
	lw $fp, 16($sp)
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
	
	