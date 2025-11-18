DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'

    ORG 100H
    str1 DB 0DH, 0AH, 'What can i say ', 0
    
    ORG 200H
    str2 DB 'Mamba out!', 0    
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

    ; 双指针拼接字符串
    ; 指针SI指向str2开头
    ; 指针DI指向str1结尾
    LEA SI, str2
    LEA DI, str1

FOR_STR1:
    MOV AL, [DI]
    CMP AL, 0
    JE NEXT

    INC DI
    JMP FOR_STR1

    ; 此时DI指向str1结尾，SI指向str2开头
NEXT:
    MOV AL, [SI]
    MOV [DI], AL
    CMP AL, 0
    JE OUTPUT

    INC SI
    INC DI
    JMP NEXT

OUTPUT:
    ; 输出拼接后的字符串
    MOV BYTE PTR [DI], '$'

    LEA DX, str1
    MOV AH, 9
    INT 21H

    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN