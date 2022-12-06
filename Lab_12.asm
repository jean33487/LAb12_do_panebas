TITLE Nome:Jean Piton RA:22013310
.MODEL SMALL
.DATA
    linha DB 4
    coluna DB 4
    offsetlinha DW 8     ;linha x2
    MATRIZ DW ?,?,?,?    ;matriz
            DW ?,?,?,?
            DW ?,?,?,?
            DW ?,?,?,?

    MATRIZ2 DW ?,?,?,?   ;matriz auxiliar
            DW ?,?,?,?
            DW ?,?,?,?
            DW ?,?,?,?

    msg1 DB "Insira os valores da matriz:",10,"$"
    msg2 DB 10,"Matriz original:",10,"$"
    msg3 DB 10,"Matriz Transposta:",10,"$"
.CODE

main PROC
    MOV AX,@DATA        ;inicialização das matrizes
    MOV DS,AX
    MOV AH,09
    LEA DX,msg1
    INT 21h
    CALL RECEBA         ;entrada de dados na matriz
    MOV AH,09
    LEA DX,msg2         
    INT 21h
    CALL PRINT          ;impressão da matriz
    MOV AH,09
    LEA DX,msg3
    INT 21h             
    CALL INVERTER       ;inversão da matriz
    CALL PRINT          ;impressão da matriz invertida
    MOV ah,4Ch
    INT 21h
main ENDP

;description
RECEBA PROC
    XOR SI,SI           ;index
    MOV CL,linha            ;loop linha
    MOV CH,coluna            ;loop coluna
    LOOPlinha:
    LOOPcol:
    MOV AH,1h           ;input
    INT 21h
    AND AX,00FFh        ;mascara para pegar o apenas o input em AL
    SUB AX,30h          ;char para numero
    MOV MATRIZ[SI],AX   ;preenchimento da matriz
    ADD SI,2            ;index anda de 2 em 2
    DEC CH
    JNZ LOOPcol
    MOV AH,2            ;quebra de linha
    MOV DL,10
    INT 21h
    MOV CH,coluna
    DEC CL
    JNZ LOOPlinha
    RET
RECEBA ENDP

;description
PRINT PROC
    MOV CH,coluna                    ;LOOP1
    MOV CL,linha                    ;LOOP2
    XOR BX,BX                   ;index linha
    XOR SI,SI                   ;index coluna
    MOV AH,2h
    LOOP2:
    LOOP1:
    MOV DX,MATRIZ[BX][SI]       ;elemento a ser impresso
    ADD DX,30h                  ;numero para char
    INT 21h
    ADD SI,2                    ;index coluna anda de 2 em 2
    DEC CH
    JNZ LOOP1
    XOR SI,SI                   ;index coluna reset
    ADD BX,offsetlinha                    ;index linha vai para proxima linha
    MOV CH,coluna                    ;loop de coluna reset
    MOV DL,10                   ;quebra de linha
    INT 21h
    DEC CL
    JNZ LOOP2
    RET
PRINT ENDP

;description
INVERTER PROC
    ;inversão de matriz para matriz2
    MOV CH,coluna                ;loop coluna
    MOV CL,linha                ;loop linha
    MOV BX,-2               ;inicialização do index da matriz
    MOV DI,offsetlinha
    NEG DI               ;inicialização do index da matriz2
    LOOP4:
    LOOP3:
    ADD BX,2                ;index da matriz anda de 2 em 2
    ADD DI,offsetlinha                ;index da matriz invertida anda de 8 em 8
    MOV DX, MATRIZ[BX]      ;passagem da matriz para matriz2
    MOV MATRIZ2[DI],DX
    DEC CH
    JNZ LOOP3
    SUB DI,30               ;o index da próxima linha de uma matriz invertida se faz subtraindo 22, mas devido ao ADD 8 no inicio subtraimos 30
    MOV CH,coluna
    DEC CL
    JNZ LOOP4

    ;mover matriz2 para a matriz

    MOV CH,coluna                ;loop coluna
    MOV CL,linha                ;loop linha
    XOR BX,BX               ;index linha
    XOR SI,SI               ;index coluna
    LOOP6:
    LOOP5:
    MOV DX,MATRIZ2[BX][SI]  ;passagem da matriz2 para matriz
    MOV MATRIZ[BX][SI],DX
    ADD SI,2                ;index de coluna anda de 2 em 2
    DEC CH
    JNZ LOOP5
    XOR SI,SI               ;reset do index da coluna
    ADD BX,offsetlinha                ;index da linha pula para próxima linha
    MOV CH,coluna                ;reset do loop de coluna
    DEC CL
    JNZ LOOP6
    RET
INVERTER ENDP

end main
