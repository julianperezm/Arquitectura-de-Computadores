## BORRAMOS LA CIMA
	.data
read:	.asciiz "¿Qué número desea introducir en la lista? "
readdelete:	.asciiz "¿Que numero desea eliminar? "
readdeleted:	.asciiz "El nuevo nodo eliminado es "
stack:	.asciiz "La pila resultante es: "

	.text
main:
	li $s0, 0

loop:
	# "¿Qué número desea introducir en la lista? "
	la $a0, read
	li $v0, 4
	syscall
	
	# Pedimos los numeros
	li $v0, 5
	syscall
	
	# si es 0, dejamos de pedir
	beqz $v0, EndRead
	
	# si no, llamamos a push con sus argumentos
	move $a0, $s0
	move $a1, $v0
	jal Push
	
	# Actualizamos el nodo de la cima
	move $s0, $v0
	
	b loop
	
Exit:
	li $v0, 10
	syscall
	

EndRead:
	
	# "¿Que numero desea eliminar? "
	la $a0, readdelete
	li $v0, 4
	syscall 
	
	# Pedimos el numero que quremos eliminar
	li $v0, 5
	syscall
	
	# lo borramos con la funcion remove
	move $a0, $s0
	move $a1, $v0
	jal Remove 
	
	# si te da 0 (no se ha encontrado), imprimimos la pila
	beqz $v0, Print
	
	move $s0, $v0
	
	# si no, lo mostramos, pero antes movemos v0 ya que lo vamos a utilizar para la syscall
	move $t0, $v0
	
	 # "El nuevo nodo eliminado es "
	la $a0, readdeleted
	li $v0, 4
	syscall
	# sacamos el valor del nodo, y lo mostramos
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
Print:
	# "La pila resultante es: "
	la $a0, stack
	li $v0, 4
	syscall
	
	move $a0, $s0
	jal PrintList
	
	j Exit

Push:
	# movemos a0(el primer nodo) ya que lo vamos a utilizar para el syscall
	move $t0, $a0
	
	# creamos el nodo
	li $a0, 8
	li $v0, 9
	syscall
	
	# si la direccion del primer nodo esta vacia, creamos el primer nodo
	beqz $t0, First
	
	#si no, metemos el valor y la direccion(cima) al nodo qu acabamos de crear
	sw $a1, 0($v0)
	sw $t0, 4($v0)
	
	jr $ra
First:
	# metemos el valor y la direccion al primer nodo
	sw $a1, 0($v0)
	sw $zero, 4($v0)
	
	jr $ra

Remove:
	# movemos a0, ¡¡¡¡NO SE SI ESTO ESTA BIEN!!!!
	move $t0, $a0
RemoveLoop:
	# Si la direccion de la cima esta vacia nos salimos
	beqz $t0, Salir
	
	# si no, sacamos el valor del nodo, si son iguales , eliminamod la cima
	lw $t9, 0($t0)
	beq $t9, $a1, DeleteTop
	
	# pasamos al siguien nodo, comprobamos si esta vacio y sacamos su valor
	lw $t1,4($t0)
	
	beqz $t1, NotFound
	
	
	lw $t2, 0($t1)
	
	# si es igual al valor que hemos metido lo borramos
	beq $t2, $a1, Delete
	
	# mueves el nodo para poder borrarlo 
	#move $t3, $t1
	
	# pasas al siguiente para volver a hacer la lista
	lw $t0, 4($t0)
	
	b RemoveLoop

DeleteTop:
	
	# la cima ahora es el siguiente numero a la cima de antes
	lw $v0, 4($s0)
	
	jr $ra
Delete:
	# conectas el anterior con el siguiente
	lw $t4, 4($t1)
	sw $t4, 4($t0)
	
	move $v0, $t1
	jr $ra

NotFound:
	li $v0, 0
	jr $ra

Salir:
	jr $ra
	
PrintList:  
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16 ($sp)
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
	

	
	
