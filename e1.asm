DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
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

    ; 输入一个字符
    MOV AH, 1
    INT 21H 

    MOV DH, AL ;  备份

    MOV DL, 0DH ; 回车
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH ; 换行  
    MOV AH, 02H
    INT 21H       

    ; 判断是否为大写字母 A-Z（容错性）
    CMP DH, 'A'
    JB OUTPUT        ; 小于'A'，直接输出
    CMP DH, 'Z'
    JA OUTPUT        ; 大于'Z'，直接输出

    ; 输出该字符
    ADD DH, 20H ; 大写转小写
    MOV DL, DH
    MOV AH, 2
    INT 21H

    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN