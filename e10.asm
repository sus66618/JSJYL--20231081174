; 端口地址定义（PC机标准端口）
TIMER_PORT EQU 40H     ; 8253定时器2数据口
TIMER_CTRL EQU 43H     ; 8253控制口
PPI_B_PORT EQU 61H     ; 8255的PB口

DATA SEGMENT
    ; 音符对应的8253计数初值表
    MES DB 0DH,0AH,'SSY20231081174',0DH,0AH,'$'
    FREQ_TABLE DW 0533H, 04A8H, 041EH, 03F0H, 038AH, 0328H, 02D0H
DATA ENDS

STACK SEGMENT STACK
    DW 256 DUP(?)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK
MAIN:
    MOV AX, DATA
    MOV DS, AX

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

; 检测键盘输入并发声
KEY_SCAN:
    MOV AH, 01H         ; 检测键盘缓冲区是否有输入
    INT 16H
    JZ KEY_SCAN  

    MOV AH, 00H         ; 读取按键
    INT 16H

    CMP AL, '1'         ; 检查是否为1~7键
    JB KEY_SCAN         
    CMP AL, '7'
    JA KEY_SCAN         

    ; 计算按键对应的频率表索引
    SUB AL, '1'
    MOV BL, AL
    MOV BH, 0
    SHL BX, 1

    ; 初始化8253定时器2，产生对应频率方波
    MOV DX, TIMER_CTRL
    MOV AL, 10110110B 
    OUT DX, AL

    MOV DX, TIMER_PORT
    MOV AX, FREQ_TABLE[BX]  ; 取计数初值
    OUT DX, AL              ; 输出低8位
    MOV AL, AH
    OUT DX, AL              ; 输出高8位

    ; 打开扬声器
    IN AL, PPI_B_PORT
    OR AL, 00000011B    ; 置PB0和PB1为1
    OUT PPI_B_PORT, AL

    ; 等待按键释放
WAIT_RELEASE:
    MOV AH, 01H
    INT 16H
    JNZ WAIT_RELEASE    ; 按键未释放则等待

    ; 关闭扬声器
    IN AL, PPI_B_PORT
    AND AL, 11111110B
    OUT PPI_B_PORT, AL

    JMP KEY_SCAN

EXIT:
    IN AL, PPI_B_PORT
    AND AL, 11111110B
    OUT PPI_B_PORT, AL

    MOV AX, 4C00H
    INT 21H
CODE ENDS
END MAIN