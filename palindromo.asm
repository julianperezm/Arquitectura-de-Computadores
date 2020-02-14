	.data
cad:	.space 1024
palindromo:	.asciiz "Es palíndromo"
nopalindromo:	.asciiz "No es palíndromo"

	.text
main:
	# vamos a pedir la cadena 
	la $a0, cad
	li $a1, 1024
	li $v0, 8
	syscall
	
	# movemos los punteros al primer valor de la cadena
	move $s0, $a0
	move $s1, $a0
	
	# sacas el primer valor
	lb $t0, ($s1)
	

loop:
	#apuntamos un nodo al final de la lista
	
	#si el valor que hemos sacado de t0 es un salot de linea te colocas en la posicion anterior que es una letra
	beq, $t0, 10, SaltoLinea
	addi $s1, $s1, 1
	
	lb $t0, ($s1)
	
	b loop
Exit:
	li $v0,10
	syscall
	
SaltoLinea:
	subi $s1, $s1, 1


Comparacion:
	# Emepazemos a comparar el valor del nodo s0 con el nodo s1
	# sacamos el valor de los nodos del principio y el final
	lb $t0, 0($s0)
	lb $t1, 0($s1)
	
	bne $t0, $t1, NoPalindromo
	bge $s0, $s1, Palindromo
	
	addi $s0, $s0, 1
	subi $s1, $s1, 1
	
	b Comparacion
	
NoPalindromo:
	la $a0, nopalindromo
	li $v0, 4
	syscall
	
	j Exit
Palindromo:
	
	la $a0, palindromo
	li $v0, 4
	syscall
	
	j Exit
	