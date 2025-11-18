DATA SEGMENT
    MES DB 0AH,0DH,'SSY20231081174',0AH,0DH,'$'
    DA DW 2300,-1322,666,-20,10,-2,45,32 ; 自定义内存中的有符号数
    CNT EQU ($ - DA) / 2  ; 数组元素个数
    MAX DW 0              ; 存储最大值
    MIN DW 0              ; 存储最小值
    SUM DB 4 DUP(0)       ; 存储和
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

    ; 冒泡排序
    MOV CX, CNT
    DEC CX          ; 需要CNT-1轮

    ; 外层循环
OUTER:
    PUSH CX         ; 保存外层循环计数
    LEA SI, DA      ; 每轮从头开始
    
    ; 内层循环
INNER:
    MOV AX, [SI]    ; 取当前元素
    MOV BX, [SI+2]  ; 取下个元素

    CMP AX, BX
    JGE NO_SWAP     ; 如果AX>=BX，不交换

    MOV [SI], BX    ; 交换位置
    MOV [SI+2], AX
    
NO_SWAP:
    ADD SI, 2       ; 移动到下一对
    LOOP INNER
    
    POP CX          ; 恢复外层循环计数
    LOOP OUTER
    JMP DONE

DONE:
    ; 最大值和最小值
    LEA SI, DA
    MOV AX, [SI]    ; 第一个元素是最大值
    MOV MAX, AX
    
    MOV SI, CNT
    DEC SI
    SHL SI, 1         ; 计算偏移地址
    ADD SI, OFFSET DA ; 指向最后一个元素
    MOV AX, [SI]      ; 最后一个元素是最小值
    MOV MIN, AX
    
    ; 计算总和
    LEA SI, DA
    MOV CX, CNT
    MOV WORD PTR SUM[0], 0     ; 低16位清零
    MOV WORD PTR SUM[2], 0     ; 高16位清零
    
SUMLOOP:
    MOV AX, [SI]    ; 取16位数
    CWD             ; 符号扩展为DX:AX
    ADD WORD PTR SUM[0], AX    ; 加低16位
    ADC WORD PTR SUM[2], DX    ; 带进位加高16位
    ADD SI, 2
    LOOP SUMLOOP

OVER:
    MOV AX, 4C00H
    INT 21H

CODE ENDS
END MAIN