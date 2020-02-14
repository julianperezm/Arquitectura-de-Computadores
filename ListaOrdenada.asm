	.data
read: .asciiz "Que números desea introducir"
Stack: .asciiz "la lista es: "
	
	.text
main:
	li $a0, 0
	li $a1, 0
	jal Create
	
	move $s0, $v0

loop:
	la $a0, read
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, Print
	
	move $a0,$s0 
	move $a1, $v0
	jal insert_in_order
	
	beqz $v0 , loop
	
	move $s0, $v0
	
	b loop
	
Print:
	move $a0, $s0
	jal PrintList
	
	j Exit

insert_in_order:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $ra, 16($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	
	move $a0, $a1
	li $a1, 0
	jal Create
	
	lw $t0, 0($fp)
	
	lw $t1, 0($t0)
	lw $t2, 0($v0)
	
	bgt $t2, $t1, AddFirst

InsertLoop:
	move $t1, $t0
	lw $t0, 4($t0)
	
	beqz $t0, EndInsert
	
	lw $t3, 0($t0)
	
	bgt $t2, $t3, AddMiddle
	
	b InsertLoop
	
AddFirst:
	sw $t2, 0($v0)
	sw $t0, 4($v0)
	j EndInsert

AddMiddle:
	sw $v0, 4($t1)
	sw $t0, 4($v0)
	
	li $v0, 0
	
EndInsert:
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
PrintList:
	#Creamos marco de pila
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	#guardamos el valor de a0 ya que lo vamos a modificar
	sw $a0, 0($fp)
	
	lw $a0, 4($a0)
	
	beqz $a0, PrintF
	
	jal PrintList

PrintF:
	#sacamos el nodo del marco de pila y sacamos su valor y lo imprimimos
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	
	# lo imprimimos 
	li $v0, 1
	syscall 
	
	#libreramos marco y terminamos
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra

Exit:
	li $v0, 10
	syscall
	