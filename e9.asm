DATA SEGMENT
    MES DB 0DH,0AH,'SSY20231081174',0DH,0AH,'$'
    VAR DB 66H,66H,66H,66H ; 存放4个BCD码字节
    RESULT DB 4 DUP(0)
    TEMP DB 0 ; 临时存储
DATA ENDS

SSG SEGMENT
    DW 256 DUP(?)
SSG ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:SSG
MAIN:
    ; 初始化段寄存器和堆栈指针
    MOV AX, DATA
    MOV DS, AX

    MOV AX, SSG
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

    ; 初始化32位结果
    MOV WORD PTR RESULT[0], 0
    MOV WORD PTR RESULT[2], 0

    MOV CX, 4
    LEA SI, VAR
    MOV DI, 0

PROCESS_BYTE:
    MOV AL, [SI] ; 取一个字节，包含2个BCD数字(98H,76H,54H,32H)
    INC SI

    ; 处理高4位BCD数字
    MOV BL, AL
    AND BL, 0F0H ; 取高4位
    SHR BL, 1    ; 右移4位
    SHR BL, 1            
    SHR BL, 1          
    SHR BL, 1          
    CALL ADD_NEW ; 调用子程序，将数字加入结果

    ; 处理低4位BCD数字
    MOV BL, AL
    AND BL, 0FH  ; 取低4位
    CALL ADD_NEW ; 调用子程序，将数字加入结果

    LOOP PROCESS_BYTE
    JMP OVER

; 子程序：RESULT = RESULT * 10 + DIGIT
ADD_NEW PROC
    PUSH CX
    PUSH AX
    PUSH DX
    
    ; 将BCD数字保存到内存临时变量
    MOV TEMP, BL
    
    ; 取RESULT
    MOV AX, WORD PTR RESULT[0]
    MOV DX, WORD PTR RESULT[2]
    
    ; 保存原始结果到临时寄存器
    MOV CX, DX
    MOV BX, AX

    ; 计算 RESULT * 2
    SHL AX, 1
    RCL DX, 1

    ; 保存 RESULT * 2
    PUSH DX
    PUSH AX

    ; 计算 RESULT * 8
    MOV AX, BX
    MOV DX, CX
    SHL AX, 1
    RCL DX, 1
    SHL AX, 1
    RCL DX, 1
    SHL AX, 1
    RCL DX, 1

    ; RESULT * 10 = RESULT*8 + RESULT*2
    POP BX    ; RESULT*2 低16 -> BX
    POP CX    ; RESULT*2 高16 -> CX

    ADD AX, BX
    ADC DX, CX

    ; 从内存恢复BCD数字并加上当前数字
    MOV BL, TEMP
    MOV CH, 0
    MOV CL, BL
    ADD AX, CX
    ADC DX, 0

    ; 存回 RESULT
    MOV WORD PTR RESULT[0], AX
    MOV WORD PTR RESULT[2], DX

    POP DX
    POP AX
    POP CX
    RET
ADD_NEW ENDP

OVER:
    MOV AX, WORD PTR RESULT[0]
    MOV BX, WORD PTR RESULT[2]
    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN