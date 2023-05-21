MACRO subBytes input,sBox  
     Local L1
     
     mov CX,16  ; As the length of each row in s box 16 element
     mov SI,0
     L1: mov AL,input[SI]  ; 
         mov BL,10h   
         div BL    ;  
         mov DL,AH  ;  
         mul BL      
         add AX,DX    
         mov BX,AX    
         mov DL,sBox[BX] 
         mov input[SI],DL ; the new value in the s box
         inc SI
    LOOP L1
     
  ENDM

  MACRO shiftRows input     ; after subbytes stage
   Local L2
   Local L3
   Local End1  
   Local increment  
   
   mov CX,4   
   mov SI,0   ; counter on cells
   ; check wich row 
   L3: mov BX,CX 
        mov DX,4
        sub DX,BX
        jz increment
        jnz L2 
   ; loop for jumping to the next row by adding 4 as the input row size is 4 cells
   increment: add SI,4
              Loop L3
   L2:  cmp CX,0 
        jz  End1
        mov AL,input[0+SI] 
        mov BL, input[1+SI]
        mov input[0+SI],BL
        mov BL, input[2+SI]
        mov input[1+SI],BL
        mov BL, input[3+SI]
        mov input[2+SI],BL
        mov input[3+SI],AL 
        dec DX
        jnz L2
        jz increment 
   
   End1:
   ENDM
    
    
  MACRO mixColumns input,moduolo   
   Local multip1
   Local multip2
   Local multip3  
   Local L5
   Local L6
   Local End1 
   Local M2 
   Local M3
   
  
   mov SI,0
   mov BP,0    
   mov DI,0 
   ; this loop loops over the rows and check if element 1 , 2 , 3 
   L5: mov AX,4
       mul BP
       add AX,DI 
       mov BX,AX
       mov CH,input[BX]
       mov AX,4
       mul SI
       add AX,BP
       mov BX,AX
       mov CL,moduolo[BX]
       cmp CL,1
       jz multip1
       cmp CL,2
       jz multip2
       cmp CL,3
       jz multip3
   L6: inc BP
       cmp BP,4
       jnz L5 
       pop AX
       pop BX
       xor AX,BX
       pop BX
       xor AX,BX
       pop BX
       xor AX,BX
       push AX
       inc SI
       mov BP,0
       cmp SI,4
       jnz L5
       pop AX
       mov input[12+DI],AH
       pop AX
       mov input[8+DI],AH
       pop AX
       mov input[4+DI],AH
       pop AX
       mov input[0+DI],AH 
       mov SI,0
       inc DI
       cmp DI,4
       jnz L5
       jz End1
     
 
   multip1:add CH,0
           push CX
           jmp L6   
   
   multip2:add CH,0
   js M2
   sal CH,1   
   push CX
   jmp L6 
   M2:sal CH,1 
   xor CH,1Bh
   push CX
   jmp L6      
               
   multip3:mov BL,CH 
   add CH,0
   js M3
   sal CH,1  
   xor CH,BL
   push CX
   jmp L6   
   M3: sal CH,1 
   xor CH,1Bh
   xor CH,BL  
   push CX
   jmp L6 
   
   
   End1:
   ENDM
   
    
    MACRO addRoundKey input,cipherKey  
    Local L4     
      mov SI,0
  L4: mov AL,input[SI]
      mov AH,cipherKey[SI]   
      XOR AL,AH
      mov input[SI],AL
      inc SI
      cmp SI,16                      
      jnz L4  
      ENDM
            
  MACRO columnzero cipherKey,sBox, roundKey  
     Local L7  
     mov AL,cipherkey[3]
     mov temp[0],AL
     mov AL,cipherkey[7]
     mov temp[1],AL
     mov AL,cipherkey[11]
     mov temp[2],AL
     mov AL,cipherkey[15]
     mov temp[3],AL
    mov AL,cipherkey[3]
    mov BL,cipherkey[7]
    mov roundKey[3],BL
    mov BL,cipherkey[11]
    mov roundKey[7],BL
    mov BL,cipherkey[15]
    mov roundKey[11],BL
    mov roundKey[15],AL
    mov CX,4
    mov SI,3
    L7: mov AL, roundKey[SI]
         mov BL,10h
         div BL
         mov DL,AH
         mul BL 
         add AX,DX
         mov BX,AX
         mov DL,sBox[BX]
         mov roundKey[SI],DL 
         add SI,4
    LOOP L7  
    mov AL,roundKey[3]  
    mov BL,rCon[0+DI]
    xor BL,AL
    mov roundKey[3],BL
    mov AL,roundKey[7]  
    mov BL,rCon[10+DI]
    xor BL,AL
    mov roundKey[7],BL  
    mov AL,roundKey[11]  
    mov BL,rCon[20+DI]
    xor BL,AL
    mov roundKey[11],BL
    mov AL,roundKey[15]  
    mov BL,rCon[30+DI]
    xor BL,AL
    mov roundKey[15],BL  
    
    mov AL,roundKey[3]  
    mov BL,cipherkey[0]
    xor BL,AL
    mov roundKey[0],BL
    mov AL,roundKey[7]  
    mov BL,cipherkey[4]
    xor BL,AL
    mov roundKey[4],BL  
    mov AL,roundKey[11]  
    mov BL,cipherkey[8]
    xor BL,AL
    mov roundKey[8],BL
    mov AL,roundKey[15]  
    mov BL,cipherkey[12]
    xor BL,AL
    mov roundKey[12],BL 
    inc DI
    push DI 
    mov AL,temp[0]
    mov cipherkey[3],AL 
    mov AL,temp[1]
    mov cipherkey[7],AL
    mov AL,temp[2]
    mov cipherkey[11],AL
    mov AL,temp[3]
    mov cipherkey[15],AL
    
    ENDM
     
     
   
    MACRO keyOnetwoThree roundKey,cipherKey  
    Local L8 
    Local end1    
     mov SI,1 
     mov BP,0
    L8: mov AX,4 
         mul BP 
         add AX,SI
         dec AX  
         mov BX,AX
         mov CL,roundkey[BX]  
         mov AX,4 
         mul BP 
         add AX,SI 
         mov BX,AX  
         mov DL, cipherkey[BX]
         Xor DL,CL  
         mov roundkey[BX],DL
         inc BP
         cmp BP,4
         jnz L8
         inc SI
         mov BP,0
         cmp SI,4
         jnz L8
         jz  end1
   end1:  
    ENDM
    
    
MACRO inputStream input 
mov BX,0
mov CL,0
mov AH,1
mov SI,0
for:
INT 21H
cmp AL,0D
JZ increment
cmp AL,41H
JGE letter


Digit:sub AL,48
shl BX,CL
or BL,AL
mov Data[SI+2],AL
jmp increment


letter: sub AL,37H
mov Data[SI+2],AL 

increment:inc SI
cmp SI,32
jnz for      

mov SI,0
mov BP,0
for1: mov AL,Data[SI+2]
mov BL,16
mul BL
mov BL,Data[SI+3]
add AL,BL 
adc AH,0
mov input[BP],AL
inc BP
add SI,2
cmp BP,16
jnz for1
 
ENDM

;inputStream1 PROC  
;mov BX,0
;mov CL,0
;mov AH,1
;mov SI,0
;for:
;INT 21H
;cmp AL,0D
;JZ increment
;cmp AL,41H
;JGE letter


;Digit:sub AL,48
;shl BX,CL
;or BL,AL
;mov Data[SI+2],AL
;jmp increment


;letter: sub AL,37H
;mov Data[SI+2],AL 

;increment:inc SI
;cmp SI,32
;jnz for      

;mov SI,0
;mov BP,0
;for1: mov AL,Data[SI+2]
;mov BL,16
;mul BL
;mov BL,Data[SI+3]
;add AL,BL 
;adc AH,0
;mov input[BP],AL
;inc BP
;add SI,2
;cmp BP,16
;jnz for1
;ret 
;endp

MACRO outputStream input 
 mov SI,0 
    mov AH,2
    for4:mov CX,4 
    mov BH,input[SI]
    mov BL,input[SI+1]
    for5:mov DL,BH
    shr DL,4
    shl BX,4
    
    cmp DL,10
    jge letter1
    
    digit1: add DL,48
    int 21h
    Loop for5
    add SI,2
    cmp SI,16
    jnz for4
    jmp end1
   
    
    letter1:add DL,55 
    int 21h
    loop for5
    add SI,2
    cmp SI,16
    jnz for4 
    mov AH,4CH
    int 21h   
endm    

;outputStream1 PROC 
;mov SI,0 
;    mov AH,2
;    for4:mov CX,4 
;    mov BH,input[SI]
;    mov BL,input[SI+1]
;    for5:mov DL,BH
;    shr DL,4
;    shl BX,4
    
;    cmp DL,10
;    jge letter1
    
;    digit1: add DL,48
;    int 21h
;    Loop for5
;    add SI,2
;    cmp SI,16
;    jnz for4
;    jmp end1
   
    
;    letter1:add DL,55 
;    int 21h
;    loop for5
;    add SI,2
;    cmp SI,16
;    jnz for4 
;   mov AH,4CH
;   int 21h   
    
;ret
;endp
 ORG 100h             
  .data segment                                                     
   ;dataOut 33,?,33 DUP(?)
   input DB 0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h 
   sBox DB 63H,7CH,77H,7BH,0F2H,6BH,6FH,0C5H,30H,1H,67H,2BH,0FEH,0D7H,0ABH,76H
       DB 0CAH,82H,0C9H,7dH,0FAH,59H,47H,0F0H,0ADH,0D4H,0A2H,0AFH,9CH,0A4H,72H,0C0H
       DB 0B7H,0FDH,93H,26H,36H,3FH,0F7H,0CCH,34H,0A5H,0E5H,0F1H,71H,0D8H,31H,15H
       DB 4H,0C7H,23H,0C3H,18H,96H,5H,9AH,7H,12H,80H,0E2H,0EBH,27H,0B2H,75H
       DB 9H,83H,2CH,1AH,1BH,6EH,5AH,0A0H,52H,3BH,0D6H,0B3H,29H,0E3H,2FH,84H
       DB 53H,0D1H,0H,0FDH,20H,0FCH,0B1H,5BH,6AH,0CBH,0BEH,39H,4AH,4CH,58H,0CfH
       DB 0D0H,0EFH,0AAH,0FBH,43H,4DH,33H,85H,45H,0F9H,2H,7FH,50H,3CH,9FH,0A8H
       DB 51H,0A3H,40H,8FH,92H,9DH,38H,0F5H,0BCH,0B6H,0DAH,21H,10H,0FFH,0F3H,0D2H
       DB 0CDH,00CH,13H,0ECH,5FH,97H,44H,17H,0C4H,0A7H,7EH,3DH,64H,5DH,19H,73H
       DB 60H,81H,4FH,0DCH,22H,2AH,90H,88H,46H,0EEH,0B8H,14H,0DEH,5EH,0BH,0DBH
       DB 0E0H,32H,3AH,0AH,49H,6H,24H,5CH,0C2H,0D3H,0ACH,62H,91H,95H,0E4H,79H
       DB 0E7H,0C8H,37H,6DH,8DH,0D5H,4EH,0A9H,6CH,56H,0F4H,0EAH,65H,7AH,0AEH,8H
       DB 0BAH,78H,25H,2EH,1CH,0A6H,0B4H,0C6H,0E8H,0DDH,74H,1FH,4BH,0BDH,8BH,8AH
       DB 70H,3EH,0B5H,66H,48H,3H,0F6H,0EH,61H,35H,57H,0B9H,86H,0C1H,1DH,9EH
       DB 0E1H,0F8H,98H,11H,69H,0D9H,8EH,94H,9BH,1EH,87H,0E9H,0CEH,55H,28H,0DFH
       DB 8CH,0A1H,89H,0DH,0BFH,0E6H,42H,68H,41H,99H,2DH,0FH,0B0H,54H,0BBH,16H     
 ;input DB 32H,88H,31H,0E0H,43H,5AH,31H,37H,0F6H,30H,98H,07h,0A8H,8DH,0A2H,34H
 cipherKey DB 2bH,28H,0abH,09H,7eH,0aeH,0f7H,0cfH,15H,0d2H,15H,4fH,16H,0a6H,88H,3cH    
 moduolo  DB 02H,03H,01H,01H,01H,02H,03H,01H,01H,01H,02H,03H,03H,01H,01H,02H
 rCon DB 01H,02H,04H,08H,10H,20H,40H,80H,1bH,36H
      DB 0H,0H,0H,0H,0H,0H,0H,0H,0H,0H
      DB 0H,0H,0H,0H,0H,0H,0H,0H,0H,0H
      DB 0H,0H,0H,0H,0H,0H,0H,0H,0H,0H   
 roundKey DB 0H,0H,0H,0H
          DB 0H,0H,0H,0H
          DB 0H,0H,0H,0H   
          DB 0H,0H,0H,0H
 temp DB 0H,0H,0H,0H 
 Data DB 33,?,33 DUP(?)
 .code segment
  ;call inputStream1 input    
  inputStream input, Data
  addRoundKey input,cipherKey 
    mov AX,0
    mov BX,0
    mov DX,0   
    mov SI,0
    mov BP,0
    subBytes input,sBox  
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    shiftRows input
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    mixColumns input,moduolo 
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0 
    mov DI,0  
    columnzero cipherKey,sBox, roundKey 
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    keyOnetwoThree roundKey,cipherKey
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    addRoundKey input,roundKey 
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    mov CX,8
    L9:push CX 
    subBytes input,sBox  
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    shiftRows input 
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    mixColumns input,moduolo  
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0 
    pop CX 
    pop DI 
    push CX
    columnzero roundKey,sBox, roundKey  
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0       
    keyOnetwoThree roundKey, roundKey 
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    addRoundKey input,roundKey 
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0 
    pop DI
    pop CX 
    push DI
    loop L9  
    subBytes input,sBox  
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    shiftRows input   
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0  
    pop DI
    columnzero roundKey,sBox, roundKey  
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    keyOnetwoThree roundKey, roundKey
    mov AX,0
    mov BX,0
    mov DX,0  
    mov SI,0
    mov BP,0
    addRoundKey input,roundKey
    outputStream input,Data  
    ;call outputStream1 input
    pop DI
end1:  
RET