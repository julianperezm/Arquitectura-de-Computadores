	.data
read:	.asciiz "Introduzca un número: "
readelete: .asciiz " ¿Qué número desea eliminar?"
readdeleted: .asciiz "El número eliminado es: "

	.text
main:
	#inicializamos el puntero(nodo)
	li $v0, 0 # nodo en la cima

loop:
	# "Introduzca un número: "
	la $a0, read
	li $v0, 4
	syscall
	
	# pedimos los numeros
	li $v0, 5
	syscall
	
	# si el numero es 0 dejamos de pedir numeros
	beqz $v0, EndRead
	
	# si no, los vamos metiendo en la pila con push
	move $a0, $s0
	move $a1, $v0
	jal Push
	
	# vamos actualizando el nodo de la cima
	move $s0, $v0
	
	b loop
	
EndRead:
	# " ¿Qué número desea eliminar?"
	la $a0, readelete
	li $v0, 4
	syscall
	
	# pedimos el numero que queremos eliminar
	li $v0, 5
	syscall
	
	# buscamos el numero en la pila y lo borramos con la funcion remove
	move $a0 $s0
	move $a1, $v0
	jal Remove
	
	# movemos el valor a t0 ya que vamos a utlizar v0 para hacer los syscalls
	move $t0, $v0
	
	# "El número eliminado es: "
	la $a0, readdeleted
	li $v0, 4
	syscall
	
	# sacamos el numero del nodo t0 y lo imprimimos
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	# tras esto imprimimos la pila resultante
	move $a0, $s0
	jal Print
	
	j Exit

Push:
	# creamos marco de pila ya que vamos a tener que guardar a0 y a1 para llamar a create
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	# guardamos a0 y a1
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	# vamos creando los nodos llamando a la funcion create, asignando a0 y a1
	move $a0, $a1 # valor del nodo
	lw $t0, 0($fp) # direccion al nodo siguiente
	move $a1, $t0
	jal Create
	
	# liberamos marco de pila
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra

Create:
	# muevo a0 ya que lo voy a utilizar para hacer los syscalls
	move $t0, $a0
	
	#creamos el nodo
	li $a0, 8
	li $v0, 9
	syscall
	
	# le asignamos el valor y la direccion al nodo
	sw $t0, 0($v0)
	sw $a1, 4($v0)
	
	jr $ra
	
Remove:
	# sacamos el valor del nodo
	move $t0, $a0
	
RemoveLoop:
	# sacamos el valor del nodo en la cima 
	lw $t1, 0($t0)
	
	# lo comparamos con el que hemos metido , si es asi lo eliminamos
	beq $t1, $a1, Delete
	
	# si no lo es pasamos al siguiente nodo y si es 0 es que hemos llegado al final y no lo hemos encontrado
	# antes movemos el nodo a t2 para poder poder paat al siguiente
	move $t2, $t0
	lw $t0, 4($t0)
	
	beqz $t0, NotFound
	
	b RemoveLoop
	
Delete:
	# creamos un nuevo nodo y lo conectamos a t2
	lw $t3, 4($t0)
	
	# y hacemos que el nodo al que esta apuntando t0 apunte a t3
	sw $t3, 4($t2)
	

NotFound:
	# movemos el nodo a v0 para devolverlo
	move $v0, $t0
	jr $ra
	
Print:
	# Creo marco de pila
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	# guardamos el nodo a0 en el marco ya que lo vamos a modificar
	sw $a0, 0($fp)
	
	# pasamos al siguiente nodo para recorrer toda la lista
	lw $a0, 4($a0)
	
	# si a0 es 0 significa que ya se ha recorrido toda la lista y empezamos imprimir
	beqz $a0, PrintF
	
	# si no es 0 volvemos a hacer lo mismo hasta llegar al final
	jal Print

PrintF:
	# sacamos el valor de a0 y lo improimimos
	lw $t0, 0($fp)
	
	# imprimimos el numero
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	# cerramos marco de pila

	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
	
Exit:
	li $v0, 10
	syscall
	
