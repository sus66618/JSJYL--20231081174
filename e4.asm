DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
    DA DW -23,12,-6,20,-10,2,45,32 ; 自定义内存中的有符号数
    CNT EQU ($ - DA) / 2 ; 数组元素个数
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

    LEA SI, DA
    MOV CX, CNT  

    ; 入栈循环
FOR_PUSH:
    MOV AX, [SI]
    PUSH AX
    ADD SI, 2
    LOOP FOR_PUSH

    LEA SI, DA
    MOV CX, CNT

    ; 出栈循环
FOR_POP:
    POP AX
    MOV [SI], AX
    ADD SI, 2
    LOOP FOR_POP

    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN