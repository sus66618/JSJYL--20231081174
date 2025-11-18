DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
    DA DB 23,12,6,20,10,2,45,32 ; 自定义内存中的无符号数
    CNT EQU $ - DA ; 数组元素个数
    MAX DB 0       ; 存储最大值
    SUM DB 0       ; 存储和
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

    ; 计算最大值和总和
    LEA SI, DA      ; SI指向DA数组
    MOV CX, CNT     ; 元素个数
    MOV AL, [SI]    ; 初始化最大值
    MOV BL, 0       ; 初始化和为0

FOR:
    ADD BL, [SI]    ; 累加当前元素到和
    CMP [SI], AL    ; 比较当前元素与最大值
    JA MAX_UPDATE

UPDATE:
    INC SI          ; 移动到下一个元素
    SUB CX, 1
    CMP CX, 0
    JE OVER
    JMP FOR

MAX_UPDATE:
    MOV AL, [SI]    ; 更新最大值
    JMP UPDATE
    
OVER:
    MOV MAX, AL     ; 存储最大值
    MOV SUM, BL     ; 存储总和
    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN