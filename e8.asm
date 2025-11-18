DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
    var DW 6666H
    buf DB 20 DUP(?) ; 存放非压缩BCD码
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

    ; 将6666H转换为非压缩BCD码
    MOV AX, var
    LEA DI, buf
    MOV BX, 10
    MOV CX, 0

FOR_PUSH:
    MOV DX, 0
    DIV BX          ; AX = AX / 10, DX = AX % 10
    PUSH DX         ; 余数入栈
    INC CX
    CMP AX, 0
    JA FOR_PUSH

FOR_POP:
    POP DX
    MOV [DI], DL 
    INC DI         
    LOOP FOR_POP

    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN