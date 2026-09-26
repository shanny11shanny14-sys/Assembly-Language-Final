
.data
  msg1:   .asciz "*****Print Name*****\n"
  msg2:   .asciz "*****End Print*****\n"
  teamNo: .asciz "Team 2\n"
  name1:  .asciz "Hsieh Tsai-Ling\n"
  name2:  .asciz "Cao Xiang-Ting\n"
  name3:  .asciz "Xu Yu-Xuan\n"

.text
  .global name   @ Function
  .global teamNo @ String
  .global name1  @ String
  .global name2  @ String
  .global name3  @ String

  name:
    stmfd sp!, {lr}

    ldr   r0, =msg1   @ r0 = "*****Print Name*****\n"
    bl    printf
    ldr   r0, =teamNo
    bl    printf
    ldr   r0, =name1
    bl    printf
    ldr   r0, =name2
    bl    printf
    ldr   r0, =name3
    bl    printf
    ldr   r0, =msg2   @ r0 = "*****End Print*****\n"
    bl    printf

    ldmfd sp!,{lr}
    mov   pc, lr

