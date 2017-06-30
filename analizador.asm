; ---------------------------------------<Directivas>---------------------------------------
; Procesador
.386
; Segmento de Pila
Stack Segment Para Stack Use16 'STACK'
    db 256 dup(0)
Stack Ends

texto segment
    padd db "$"
    padd2 db "nop nop$"
    padd3 db "nop nop$"
    padd4 db "nop nop$"
    padd5 db "nop nop$"
    padd6 db "nop nop nop$"
    padd7 db "nop nop nop$"
    ttle db "Analizador$"
    txt_continue db "continuar$"
    txt_regresar db "regresar$"
    txt_tips db "tips$"
    txt_exit db "salir$"
    txt_iter db "cantidad de iteraciones $"
    txt_password db "Ingrese password$"
    txt_unsafe0 db "Muy insegura$"
    txt_unsafe1 db "Insegura$"
    txt_unsafe2 db "Poco insegura$"
    txt_safe0 db "Poco Segura$"
    txt_safe1 db "Segura$"
    txt_safe2 db "Muy Segura$"
    tip1 db "1. Utilizar muchos caracteres$"
    tip2 db "2. Utilizar mas de 8 caracteres$"
    tip3 db "3. No usar nombres$"
    tip4 db "4. No usar palabras de diccionario$"
    tip5 db "5. Mezcla numeros y letras$"
    tip6 db "6. Mezcla minusculas y mayusculas$"
texto ends
; Segmento de Código
Code Segment Para Use16 'Code' 
      Assume CS:Code
      Assume DS:Code
; Dirección de Inicio:
Org 0100H
    db 256 dup(0)
Start:		;Comienzo de Programa
; ------------------------------------------------------------------------------------------------


pantalla_menu: 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;llamando el segmento de datos;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    pusha
    mov ax, texto
    mov ds, ax
    mov ax, 0000h
    mov bx, 0000h
    mov dx, 0000h
    mov cx, 0000h
    mov ax, 0013h 
    int 10h   
    mov al, 42
    call dibujar_pantalla_base
    ;title box
    call dibujar_caja_titulo
    ;exit/back button
    mov cx, 253
    mov dx, 17
    mov ax, 302
    mov bx, 35
    call dibujar_btn
    mov dx, offset txt_exit
    mov al, 32
    mov ah, 3
    call print_str
    mov cx, 253
    mov dx, 17
    mov ax, 302
    mov bx, 35
    call dibujar_btn
    mov dx, offset txt_exit
    mov al, 32
    mov ah, 3
    call print_str
    ;tip button
    mov cx, 78
    mov dx, 148
    mov ax, 140
    mov bx, 172
    call dibujar_btn
    mov dx, offset txt_tips
    mov al, 11
    mov ah, 20
    call print_str
    ;continue button
    mov cx, 168
    mov dx, 148
    mov ax, 260
    mov bx, 172
    call dibujar_btn
    mov dx, offset txt_continue
    mov al, 22
    mov ah, 20
    call print_str
    ;iniciar y mostrar mouse
    call iniciar_mouse
    jmp check_menu_buttons
    
pantalla_ayuda:
    call esconder_mouse
    mov al, 126
    call dibujar_pantalla_base
    mov al, 0
    mov ds:[0200h], al
    mov cx, 15
    mov dx, 65
    mov ax, 300
    mov bx, 165
    call cuadrado
    mov al, 0
    mov ds:[0200h], al
    mov cx, 135
    mov dx, 45
    mov ax, 170
    mov bx, 60
    call cuadrado
    ;exit/back button
    mov cx, 223
    mov dx, 17
    mov ax, 302
    mov bx, 35
    call dibujar_btn
    mov dx, offset txt_regresar
    mov al, 29
    mov ah, 3
    call print_str
    mov dx, offset txt_tips
    mov al, 17
    mov ah, 6
    call print_str
    mov dx, offset tip1
    mov al, 3
    mov ah, 9
    call print_str
    mov dx, offset tip2
    mov al, 3
    mov ah, 11
    call print_str
    mov dx, offset tip3
    mov al, 3
    mov ah, 13
    call print_str
    mov dx, offset tip4
    mov al, 3
    mov ah, 15
    call print_str
    mov dx, offset tip5
    mov al, 3
    mov ah, 17
    call print_str
    mov dx, offset tip6
    mov al, 3
    mov ah, 19
    call print_str
    call mostrar_mouse
    call check_ayuda_buttons

pantalla_password:
    call esconder_mouse
    mov al, 121
    call dibujar_pantalla_base
    mov cx, 223
    mov dx, 17
    mov ax, 302
    mov bx, 35
    call dibujar_btn
    mov dx, offset txt_regresar
    mov al, 29
    mov ah, 3
    call print_str
    mov al, 0
    mov ds:[0200h], al
    mov cx, 60
    mov dx, 55
    mov ax, 250
    mov bx, 90
    call cuadrado
    mov dx, offset txt_password
    mov al, 131
    mov ah, 7
    call print_str
    call mostrar_mouse
    ;;;;;EMPIEZA AVEL;;;;;
    call limpiar_buffer
    call esconder_mouse
    call pagina_pass
termino_pass:
    call reset
    call mostrar_mouse
    call check_ayuda_buttons


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;PANTALLA CONTRASEÑA;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pagina_pass:
	;configuracion para contar cantidad de combinatorias
	MOV AH,0h
	MOV DS:[0310H],AH
	
	;cant de chars por rango en el ascii	
	MOV AH,16d
	MOV DS:[0300H],AH
	MOV AH,10d
	MOV DS:[0301H],AH
	MOV AH,7d
	MOV DS:[0302H],AH
	MOV AH,26d
	MOV DS:[0303H],AH
	MOV AH,6d
	MOV DS:[0304H],AH
	MOV AH,26d
	MOV DS:[0305H],AH
	MOV AH,5d
	MOV DS:[0306H],AH
	;configurando 
	CALL reset
	
	;empezar a escribir en estas filas y columnas
	MOV DH,09d ;fila
	MOV DL,11d ;columna

	CALL escribir_pass 

	JMP fin_pass

escribir_pass:
	CALL pos_car
	CALL leer_car
	CALL validar ;validacion si es backspace o si es enter para terminar
	CALL mostrar_char
	CALL rango_ascii
	pusha 
        MOV SI,0h
        MOV AL,00h
        CALL cant_combinatorias
        CALL niv_seguridad
	CALL imprimir_barra
	popa
	INC DL
	JMP escribir_pass
	RET

validar:
	CMP AL,08h ;es backspace
	JE borrar_entrada
	CMP DL,28d
	JAE fin_pass
	CMP AL,0DH
	JE fin_pass

	;CARGANDO CANTIDAD DE CARACTERES Y AUMENTANDO
	MOV AH,DS:[0310H]
	ADD AH,01H
	MOV DS:[0310H],AH
	RET

borrar_entrada:
	DEC DL ;RETROCEDIENDO EL CARRITO 
	CALL pos_car
	CALL leer_ascii_car	
	MOV AL,20H ;CARGANDO UN ESPACIO PARA MOSTRAR

	;borrando 1 a la cantidad de caracteres
	MOV AH,DS:[0310H]
	DEC AH
	MOV DS:[0310H],AH
	MOV AH,0H
	DEC DL
	JMP return_general

niv_seguridad:
	MOV AX,0000H
	MOV BX,0000H
	MOV AL,DS:[0312H] ;cant de asciis posibles
	MOV BL,DS:[0310H] ;cant de caracteres en la cadena
	CMP BL,06D
	JBE nivel_uno
	CMP BL,10D
	JBE nivel_dos
	CMP BL,12D
	JBE nivel_tres
	JA nivel_cuatro
	RET
	
nivel_uno:
	MOV CL,01H
	MOV DS:[0313H],CL
	JMP return_general	

nivel_dos:
	MOV CL,02H
	CMP AL,36d
	JA nivel_tres
	MOV DS:[0313H],CL
	JMP return_general

nivel_tres:
	MOV CL,03H
	CMP AL,62d
	JA nivel_cuatro
	MOV DS:[0313H],CL
	JMP return_general

nivel_cuatro:
	MOV CL,04H
	CMP AL,78d
	JAE nivel_cinco
	MOV DS:[0313H],CL
	JMP return_general

nivel_cinco:
	MOV CL,05H
        CMP AL,84d
	JA nivel_seis
	MOV DS:[0313H],CL
	JMP return_general

nivel_seis:
	MOV CL,06H
	MOV DS:[0313H],CL
	JMP return_general

leer_ascii_car:
	MOV AH,08H
	MOV BH,00H
	INT 10H
	MOV DS:[030FH],AL
	MOV AH,00H
	RET

cant_combinatorias:
	MOV BH, DS:[0300H + SI]
	MOV AH, DS:[0307H + SI]
	INC SI
	CALL aumentar_cuenta
	CMP SI,07H
	JB cant_combinatorias
	MOV DS:[0312H],AL
	RET

aumentar_cuenta:
	CMP AH,01H
	JNE return_general
	ADD AL,BH
	RET
	
rango_ascii:
	CALL cambiar_bandera
	MOV AL,DS:[030FH]
	CMP AL,47d
	JBE primer_car_special_ascii
	CMP AL,57d
	JBE numeros_ascii
	CMP AL,64d
	JBE segundo_car_special_ascii
	CMP AL,90d
	JBE alfabeto_mayuscula_ascii
	CMP AL,96d
	JBE tercer_car_special_ascii
	CMP AL,122d
	JBE alfabeto_minuscula_ascii
	CMP AL,127d
	JBE cuarto_car_special_ascii
return_general: 
	RET

cambiar_bandera:
	MOV AH,01H
	CMP AL,20H
	JNE return_general
	MOV AH,00H
	RET

primer_car_special_ascii:
	MOV DS:[0307H],AH
	JMP return_general

numeros_ascii:
	MOV DS:[0308H],AH
	JMP return_general

segundo_car_special_ascii:
	MOV DS:[0309H],AH 
	JMP return_general	

alfabeto_mayuscula_ascii:
	MOV DS:[030AH],AH
	JMP return_general

tercer_car_special_ascii:
	MOV DS:[030BH],AH 
	JMP return_general

alfabeto_minuscula_ascii:
	MOV DS:[030CH],AH
	JMP return_general

cuarto_car_special_ascii:
	MOV DS:[030DH],AH
	JMP return_general

reset:
        MOV AL,0h
	MOV DS:[0313h],AL
	MOV SI,0H
	CALL aux_reset
	MOV DH,09D
	MOV DL,11D
	RET

aux_reset:
	MOV AH,0H
	MOV DS:[0307H + SI],AH
	INC SI
	CMP SI,30d
	JBE aux_reset
	RET

fin_pass:
	;calculando cantidad de combinatorias
	MOV SI,0h
	MOV AL,00H
	MOV AH,00h;
	CALL cant_combinatorias
	
	

      
	mov al, 0
	mov ds:[200h], al
	mov cx, 30
	mov dx, 115
	mov ax, 293
	mov bx, 147
	call cuadrado
	;MOVIENDOME para mostrar cant de combinatorias
	MOV DH,15d
	MOV DL,30d
	CALL pos_car
	MOV AH,00H ;limpio AH para mandar AX a mostrar
	MOV AL,DS:[0312H]
	CALL imprimir_numero	
	mov dx, offset txt_iter
	mov al, 44
	mov ah, 15
	call print_str
	;mostrando cantidad de caracteres
	MOV DL,32d
	MOV DH,15d
	mov al, "^"
	call pos_car
	call mostrar_char
	MOV DL,33d
	MOV DH,15d
	CALL pos_car
	MOV AL,DS:[0310H]	
	MOV AH,00H
	CALL imprimir_numero

	;mostrando cantidad nivel
	MOV DH,17d
	MOV DL,18d
	CALL pos_car
	MOV AL,DS:[0313H]	
	MOV AH,00H
	CALL imprimir_numero

	;consiguiendo nivel de seguridad para bruteforce
	MOV DH,17d
	MOV DL,08d
	CALL pos_car
	;CALL calculo_bruteforce
	CALL niv_seguridad
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;colocando nivel de seguridad en 0313h;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV AL,DS:[0313H]
	call imprimir_barra
	; CALL imprimir_numero

	;mostrando total
	jmp termino_pass

imprimir_barra:
   mov al, 255
   mov ds:[200h], al
   mov cx, 30
   mov dx, 130
   mov ax, 293
   mov bx, 175
   call cuadrado
   mov al, 0
   mov ds:[200h], al
   mov cx, 30
   mov dx, 130
   mov ax, 293
   mov bx, 147
   call cuadrado
barra_lvl1:
   mov al, 4
   mov ds:[200h], al
   mov cx, 30
   mov dx, 150
   mov ax, 43
   mov bx, 175
   call cuadrado
   mov al, ds:[0313h]
   cmp al, 1
   ja barra_lvl2
   pusha
   mov dx, offset txt_unsafe0
   mov al, 4
   mov ah, 17
   call print_str
   popa
   ret
barra_lvl2:
   mov al, 40
   mov ds:[200h], al
   mov cx, 30
   mov dx, 150
   mov ax, 83
   mov bx, 175
   call cuadrado
   mov al, ds:[0313h]
   cmp al, 2
   ja barra_lvl3
   pusha
   mov dx, offset txt_unsafe1
   mov al, 4
   mov ah, 17
   call print_str
   popa
   ret
barra_lvl3:
   mov al, 42
   mov ds:[200h], al
   mov cx, 30
   mov dx, 150
   mov ax, 149
   mov bx, 175
   call cuadrado
   mov al, ds:[0313h]
   cmp al, 3
   ja barra_lvl4
   pusha
   mov dx, offset txt_unsafe2
   mov al, 4
   mov ah, 17
   call print_str
   popa
   ret
barra_lvl4:
   mov al, 43
   mov ds:[200h], al
   mov cx, 30
   mov dx, 150
   mov ax, 197
   mov bx, 175
   call cuadrado
   mov al, ds:[0313h]
   cmp al, 4
   ja barra_lvl5
   pusha
   mov dx, offset txt_safe0
   mov al, 4
   mov ah, 17
   call print_str
   popa
   ret
barra_lvl5:
   mov al, 45
   mov ds:[200h], al
   mov cx, 30
   mov dx, 150
   mov ax, 245
   mov bx, 175
   call cuadrado
   mov al, ds:[0313h]
   cmp al, 5
   ja barra_lvl6
   pusha
   mov dx, offset txt_safe1
   mov al, 4
   mov ah, 17
   call print_str
   popa
   ret
barra_lvl6:
   mov al, 49
   mov ds:[200h], al
   mov cx, 30
   mov dx, 150
   mov ax, 293
   mov bx, 175
   call cuadrado
   pusha
   mov dx, offset txt_safe2
   mov al, 4
   mov ah, 17
   call print_str
   popa
   ret
   

calculo_bruteforce:
	MOV CL,DS:[0310H] ;cantidad de caracteres en la cadena
	MOV SI,0H
	MOV AX,0000H
	CALL cant_combinatorias ;carga en AL la cantidad de combinaciones posibles por cada posicion de la cadena
	MOV BX,AX
	CMP CL,01H
	JA aux_bruteforce
	RET
	
aux_bruteforce:
	MUL BX
	DEC CL
	CMP CL,01H
	JA aux_bruteforce
	JMP return_general

leer_car:
	MOV AH,00H
	INT 16H
	;CARGANDO VALOR LEIDO A 030F
	MOV DS:[030FH],AL
	RET

mostrar_char:
	MOV AH,09H
	MOV BH,00b
	MOV BL,0111b
	MOV CX,01H
	INT 10H
	RET

pos_car:
	MOV AH,02H
	MOV BH,00H ;PAGINA
	INT 10H
	RET

imprimir_numero:
   mov cx, 0

proximo_digito: 
   mov dx, 0
   mov bx, 10
   cmp ax, bx
   jb cociente
   div bx
   push dx
   inc cx

jmp proximo_digito

cociente:
   inc cx
   push ax

imprimir:
   pop ax
   add ax, 30h             
   mov ah, 0Eh
   mov bh, 0
   mov bl, 0110b
   push cx
   mov cx, 1
   int 10h
   pop cx
   dec cx
   jnz imprimir
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;TERMINA PASSSCREEN;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dibujar_pantalla_base:
    mov ds:[0200h], al
    mov cx, 0
    mov dx, 0
    mov ax, 320
    mov bx, 200
    call cuadrado
    ;dibujar margen 1
    mov al, 1111b
    mov ds:[0208h], al
    mov cx, 3
    mov dx, 3
    mov ax, 317
    mov bx, 197
    call margen
    mov al, 1111b
    mov ds:[0208h], al
    mov cx, 5
    mov dx, 5
    mov ax, 315
    mov bx, 195
    call margen
    ret 

iniciar_mouse:
    call mostrar_mouse
    mov ax, 0001h
    int 33h
    ret

mostrar_mouse:
    mov ax, 0001h
    int 33h
    ret

esconder_mouse:
    mov ax, 0002h
    int 33h
    ret

;uses 0208h for internal color
margen:
    pusha
    mov al, 0000b
    mov ds:[0200h], al
    popa
    pusha
    call cuadrado
    popa
    pusha
    mov al, ds:[0208h]
    mov ds:[0200h], al
    popa
    add cx, 1
    add dx, 1
    sub ax, 1
    sub bx, 1
    call cuadrado
    ret


check_menu_buttons:
    mov ax, 0005h
    int 33h
    mov ax, 0006h
    int 33h
check_exit_btn:
    mov ax, 0003h
    int 33h
    cmp dx, 17
    jb check_continue_btn
    cmp dx, 38
    ja check_continue_btn
    cmp cx, 500
    jb check_continue_btn
    cmp cx, 600
    ja check_continue_btn
    jmp check_click_exit
check_continue_btn:
    mov ax, 0003h
    int 33h
    cmp dx, 148
    jb check_tip_btn
    cmp dx, 175
    ja check_tip_btn
    cmp cx, 325
    jb check_tip_btn
    cmp cx, 550
    ja check_tip_btn
    jmp check_click_continue
check_tip_btn:                ;check tag also redibujars normal state buttons
    cmp dx, 148                    ;in case none is being clicked
    jb check_menu_buttons
    cmp dx, 175
    ja check_menu_buttons
    cmp cx, 150
    jb check_menu_buttons
    cmp cx, 280
    ja check_menu_buttons
    jmp check_click_tip

check_click_exit:
    mov ax, 0005h
    mov bx, 0000h ;left button
    int 33h
    cmp bx, 0001h
    jne check_menu_buttons
    call dibujar_exit_btn_click 
    call dibujar_exit_btn_click 
    call dibujar_exit_btn_click 
check_release_exit:
    mov ax, 0006h
    mov bx, 0000h ;left button
    int 33h
    cmp bx, 0001h
    jne check_release_exit
    mov ax, 4c00h
    int 21h

check_click_tip:
    mov ax, 0005h
    mov bx, 0000h
    int 33h
    cmp bx, 0001h
    jne check_menu_buttons
    call dibujar_tip_btn_click
    call dibujar_tip_btn_click
    call dibujar_tip_btn_click
check_release_tip:
    mov ax, 0006h
    mov bx, 0000h ;left button
    int 33h
    cmp bx, 0001h
    jnz check_release_tip
    jmp pantalla_ayuda

check_click_continue:
    mov ax, 0005h
    mov bx, 0000h
    int 33h
    cmp bx, 0001h
    jne check_menu_buttons
    call dibujar_continue_btn_click
    call dibujar_continue_btn_click
    call dibujar_continue_btn_click
check_release_continue:
    mov ax, 0006h
    mov bx, 0000h ;left button
    int 33h
    cmp bx, 0001h
    jnz check_release_continue
    jmp pantalla_password

check_ayuda_buttons:
    mov ax, 0005h
    int 33h
    mov ax, 0006h
    int 33h
check_regresar_button:
    mov ax, 0003h
    int 33h
    cmp dx, 17
    jb check_ayuda_buttons
    cmp dx, 38
    ja check_ayuda_buttons
    cmp cx, 350
    jb check_ayuda_buttons
    cmp cx, 600
    ja check_ayuda_buttons
check_click_regresar:
    mov ax, 0005h
    mov bx, 0000h ;left button
    int 33h
    cmp bx, 0001h
    jne check_ayuda_buttons
    call dibujar_regresar_btn_click 
    call dibujar_regresar_btn_click 
    call dibujar_regresar_btn_click 
check_release_regresar:
    mov ax, 0006h
    mov bx, 0000h ;left button
    int 33h
    cmp bx, 0001h
    jne check_release_regresar
    call esconder_mouse
    popa
    jmp pantalla_menu

dibujar_caja_titulo:    
    mov al, 6
    mov ds:[0200h], al
    mov cx, 49
    mov dx, 51
    mov ax, 264
    mov bx, 122
    call cuadrado
    mov cx, 36
    mov dx, 58
    mov ax, 277
    mov bx, 113
    call cuadrado
    mov al, 42
    mov ds:[0200h], al
    mov cx, 52
    mov dx, 48
    mov ax, 267
    mov bx, 119
    call cuadrado
    mov cx, 39
    mov dx, 56
    mov ax, 280
    mov bx, 111
    call cuadrado
    mov al, 42
    mov ds:[0208h], al
    mov cx, 41
    mov dx, 60
    mov ax, 275
    mov bx, 107
    call margen
    mov cx, 54
    mov dx, 52
    mov ax, 263
    mov bx, 116
    call margen
    mov al, 0
    mov ds:[0200h], al
    mov cx, 77
    mov dx, 73
    mov ax, 241
    mov bx, 97
    call cuadrado
    mov al, 15
    mov ah, 10
    mov dx, offset ttle
    call print_str
    ret      

dibujar_btn:    
    pusha ;save ax
    mov al, 126
    mov ds:[0200h], al
    popa ;restore ax
    pusha ;save restored registers
    sub cx, 3
    add dx, 3
    sub ax, 3
    add bx, 3
    call cuadrado
    popa ;restore original registers
    pusha
    mov al, 54
    mov ds:[0200h], al
    popa
    call cuadrado
    ret      

dibujar_btn_click:
    pusha
    call esconder_mouse
    popa
    pusha
    mov al, 255
    mov ds:[0200h], al
    popa
    pusha
    sub cx, 3
    add bx, 3
    call cuadrado
    popa
    pusha
    mov al, 54
    mov ds:[0200h], al
    popa
    pusha
    sub cx, 3
    add dx, 3
    sub ax, 3
    add bx, 3
    call cuadrado
    popa
    pusha
    call mostrar_mouse
    popa
    ret      

dibujar_exit_btn_click:
    mov cx, 253
    mov dx, 17
    mov ax, 302
    mov bx, 35
    call dibujar_btn_click
    call esconder_mouse
    mov dx, offset txt_exit
    mov al, 32
    mov ah, 3
    call print_str
    call mostrar_mouse
    ret

dibujar_tip_btn_click:
    mov cx, 78
    mov dx, 148
    mov ax, 140
    mov bx, 172
    call dibujar_btn_click
    call esconder_mouse
    mov dx, offset txt_tips
    mov al, 11
    mov ah, 20
    call print_str
    call mostrar_mouse
    ret

dibujar_continue_btn_click:
    call esconder_mouse
    mov cx, 168
    mov dx, 148
    mov ax, 260
    mov bx, 172
    call dibujar_btn_click
    mov dx, offset txt_continue
    mov al, 22
    mov ah, 20
    call print_str
    call mostrar_mouse
    ret

dibujar_regresar_btn_click:
    mov cx, 223
    mov dx, 17
    mov ax, 302
    mov bx, 35
    call dibujar_btn_click
    call esconder_mouse
    mov dx, offset txt_regresar
    mov al, 29
    mov ah, 3
    call print_str
    call mostrar_mouse
    ret

limpiar_buffer:
    mov ah,01h
    int 16h
    jnz limpiar_aux
    ret

limpiar_aux:
    MOV AH,00H
    INT 16H
    ;CARGANDO VALOR LEIDO A 030F
    MOV DS:[030FH],AL
    jmp limpiar_buffer


;al and ah x and y
;dx string offset
print_str:
    push dx
    mov dl, al
    mov dh, ah
    mov ah, 2
    mov bh, 0
    mov bl, 0010b
    int 10h
    pop dx
    mov ah, 9
    int 21h
    ret

cuadrado:
    mov ds:[0203h], ax
    mov ds:[0205h], bx 
    mov ds:[0201h], cx ;will use 0201h and 0202h
    cuadrado_aux:   
	mov cx, ds:[0201h]   
	call hor_line
	inc dx
	cmp dx, bx
	jne cuadrado_aux 
	jmp end_cuadrado   
    hor_line: 
	call putpixel
	inc cx
	cmp cx, ax
	jne hor_line
	ret 
    putpixel:
	mov al, ds:[0200h]
	mov ah, 0ch
	mov bh, 00h
	int 10h
	mov ax, ds:[0203h]
	mov bx, ds:[0205h]
	ret
end_cuadrado: ret
; ------------------------------------------------------------------------------------------------
Code Ends
End Start		;Fin de Programa

