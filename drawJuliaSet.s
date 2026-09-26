.data

.text
  .global drawJuliaSet

drawJuliaSet:
    stmfd sp!, {r4-r11, lr}     @ save callee-saved + lr  (9 regs = 36 bytes)
    mov   r10, r0               @ r10 = cX
    mov   r11, r1               @ r11 = cY
    adds  lr, sp, pc            @ (4) 
    ldr   r4, [sp, #36]         @ r4 = frame 

	sub sp, sp, #4

    mov   r5, #0                @ r5 = x = 0

loopX:
    cmp   r5, #640
    bge   DoneX
    mov   r6, #0                @ r6 = y = 0

loopY:
    cmp   r6, #480
    bge   DoneY

    @ zx = (1500*x - 480000) / 320
    ldr   r0, .constant         @ r0 = 1500
    mul   r0, r0, r5            @ r0 = 1500*x
    ldr   r1, .constant+4       @ r1 = 480000
    sub   r0, r0, r1            @ r0 = 1500*x - 480000
    mov   r1, #320
    bl    __aeabi_idiv
    mov   r8, r0                @ r8 = zx

    @ zy = (1000*y - 240000) / 240
    mov   r0, #1000
    mul   r0, r0, r6            @ r0 = 1000*y
    ldr   r1, .constant+8       @ r1 = 240000
    sub   r0, r0, r1            @ r0 = 1000*y - 240000
    mov   r1, #240
    bl    __aeabi_idiv
    mov   r9, r0                @ r9 = zy

    mov   r7, #255              @ r7 = i = 255

    mul   r0, r8, r8            @ r0 = zx*zx
    mul   r1, r9, r9            @ r1 = zy*zy
    add   r2, r0, r1            @ r2 = zx*zx + zy*zy
    ldr   r3, .constant+12      @ r3 = 4000000

    cmp   r2, r3
    bge   DoneWhile
    cmp   r7, #0
    ble   DoneWhile

While:
    @ tmp = (zx*zx - zy*zy)/1000 + cX
    sub   r0, r0, r1            @ r0 = zx*zx - zy*zy
    mov   r1, #1000
    bl    __aeabi_idiv          @ r0 = (zx*zx - zy*zy)/1000
    add   r12, r0, r10          @ r12 = tmp
    str   r12, [sp]             @  bl use r12

    @ zy = (2*zx*zy)/1000 + cY  == zy = zx*zy/500 + cY
    mul   r0, r8, r9            @ r0 = zx*zy
    mov   r1, #500
    bl    __aeabi_idiv          @ r0 = zx*zy/500
    add   r9, r0, r11           @ zy = ... + cY

    ldr   r12, [sp]             @ get_back tmp
    mov   r8, r12               @ zx = tmp

    sub   r7, r7, #1            @ i--

    @ next_round
    mul   r0, r8, r8            @ r0 = zx*zx
    mul   r1, r9, r9            @ r1 = zy*zy
    add   r2, r0, r1
    ldr   r3, .constant+12

    cmp   r2, r3
    bge   DoneWhile
    cmp   r7, #0
    ble   DoneWhile
    b     While

DoneWhile:
    @ color = (~(((i&0xff)<<8) | (i&0xff))) & 0xffff
    and   r7, r7, #0xff
    orr   r7, r7, r7, lsl #8
    ldr   r0, .constant+16
    bic   r7, r0, r7

    @ frame[y][x] = color
    mov   r0, r4                @ base
    mov   r1, #1280             @ 640*2 bytes per row
    mul   r1, r1, r6            @ y*1280
    add   r0, r0, r1
    add   r0, r0, r5, lsl #1    @ + x*2
    strh  r7, [r0]


    mov   r12, r7, lsl #8         
    eor   r12, r12, r7, lsr #5    
    add   r12, r12, r7, asr #10  
    orr   r12, r12, r12, ror #16
	
    cmp   r7, #0
    movle r12, r12          
    cmp   r5, #0
    addne r12, r12, #0      
    cmp   r6, #0
    eorpl r12, r12, #0      
	

    add   r6, r6, #1
    b     loopY

DoneY:
    add   r5, r5, #1
    b     loopX

DoneX:
	add sp, sp, #4                
    ldmfd sp!, {r4-r11, lr}
    mov   pc, lr

.constant:
    .word 1500
    .word 480000
    .word 240000
    .word 4000000
    .word 0xffff
