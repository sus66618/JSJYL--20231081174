DATA SEGMENT
    MES1 DB 'Please enter num:',0DH,0AH,'$'
    MES2 DB 'Result:',0DH,0AH,'$'
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
    NUM DB 50,?,50 DUP(?) ; 存储输入的数字
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

    ; 显示提示信息1
    LEA DX,MES1
    MOV AH,9
    INT 21H

    ; 获取输入字符串
    LEA DX,NUM
    MOV AH,10
    INT 21H

    MOV DL, 0DH ; 回车
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH ; 换行  
    MOV AH, 02H
    INT 21H

    MOV BX,0 ; 存储数值
    MOV CX,4 ; 输入字符数
    LEA SI,NUM+2

    ; 计算数值(1*1000+0*100+2*10+4*1=1024)
    ; 外层循环依次取'1''0''2''4'
FOR_OUTER:
    MOV AH,0
    PUSH CX
    SUB CX,1
    MOV AL,[SI]
    SUB AL,'0'
    
    ; 内层循环计算权重(10的幂)
FOR_INNER:
    CMP CX,0
    JE NEXT
    MOV DL,10
    MUL DL
    LOOP FOR_INNER

NEXT:
    POP CX
    ADD BX,AX
    INC SI
    LOOP FOR_OUTER

    ; 显示提示信息2
    LEA DX,MES2
    MOV AH,9
    INT 21H

    MOV CX,4 ; 字符数

    ; 输出结果
FOR_CHAR:
    PUSH BX
    PUSH CX

    MOV AX, CX     ; AX = 4,3,2,1
    DEC AX         ; AX = 3,2,1,0
    MOV CL, 4
    MUL CL         ; 移位位数 = AL*4
    MOV CL, AL
    SHR BX, CL     ; 右移相应位数
    AND BX, 000FH
    ADD BL, '0'

    MOV DL, BL     ; 输出字符
    MOV AH, 2
    INT 21H

    POP CX
    POP BX
    LOOP FOR_CHAR

    MOV DL,'H'
    MOV AH,2
    INT 21H

    MOV AX, 4C00H
    INT 21H
CODE ENDS
END MAIN