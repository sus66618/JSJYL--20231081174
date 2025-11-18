DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
    MES1 DB 'The result is: ',0AH,0DH,'$'
    var DW 6666H
DATA ENDS

SSG SEGMENT
    DW 256 DUP(?)
SSG ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:SSG
MAIN:
    ; 初始化段寄存器和堆栈指针
    MOV AX, SEG DATA
    MOV DS, AX
    MOV AX, SEG SSG
    MOV SS, AX
    MOV SP, 0200h

    ; 显示提示信息:电自2302宿晟源20231081174
    LEA DX,MES
    MOV AH,9
    INT 21H

    MOV DL, 0DH ; 回车
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH ; 换行  
    MOV AH, 02H
    INT 21H       

    LEA DX,MES1
    MOV AH,9
    INT 21H

    MOV AX, var
    TEST AX, AX 
    JNS NEXT

    PUSH AX
    MOV DL,'-'
    MOV AH,2
    INT 21H

    POP AX
    NEG AX

NEXT:
    MOV CX,0  ; 计数器清零
    MOV BX,10 ; 除数10

    ; 循环除以10，直到AX为0
FOR:
    MOV DX,0
    DIV BX      ; AX = AX / 10, DX = AX % 10
    PUSH DX     ; 余数入栈
    INC CX      ; 计数器加1
    CMP AX,0
    JA FOR

    ; 依次出栈并输出
OUTPUT:
    POP DX
    ADD DL,'0' ; 转换为字符
    MOV AH,2
    INT 21H
    LOOP OUTPUT

    MOV AX, 4C00H ; 后续:CODE ENDS END MAIN
    INT 21H

CODE ENDS
END MAIN