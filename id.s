        .data
msg_id_title:      .asciz "*****Input ID*****\n"
msg_id_m1:         .asciz "** Please Enter Member 1 ID : **\n"
msg_id_m2:         .asciz "** Please Enter Member 2 ID : **\n"
msg_id_m3:         .asciz "** Please Enter Member 3 ID : **\n"
msg_print_title:   .asciz "*****Print Team Member ID and ID Summation*****\n"
msg_id_line:       .asciz "%d\n"
msg_sum:           .asciz "ID Summation = %d\n"
msg_id_end:        .asciz "*****End Print*****\n\n"
fmt_int:           .asciz "%d"

        .text
        .global id          @ void id(int *id1, int *id2, int *id3, int *idSum);

id:
        @ 進來時：
        @   r0 = &id1   (main 裡的變數位址)
        @   r1 = &id2
        @   r2 = &id3
        @   r3 = &idSum

        stmfd   sp!, {r4-r7, lr}   

        mov     r4, r0     @ r4 = &id1
        mov     r5, r1     @ r5 = &id2
        mov     r6, r2     @ r6 = &id3
        mov     r7, r3     @ r7 = &idSum


        ldr     r0, =msg_id_title
        bl      printf

        ldr     r0, =msg_id_m1
        bl      printf
        ldr     r0, =fmt_int
        mov     r1, r4          @ &id1
        bl      scanf           @ scanf("%d", &id1);

  
        ldr     r0, =msg_id_m2
        bl      printf
        ldr     r0, =fmt_int
        mov     r1, r5          @ &id2
        bl      scanf           @ scanf("%d", &id2);

        ldr     r0, =msg_id_m3
        bl      printf
        ldr     r0, =fmt_int
        mov     r1, r6          @ &id3
        bl      scanf           @ scanf("%d", &id3);


        ldr     r0, [r4]        @ r0 = id1
        ldr     r1, [r5]        @ r1 = id2
        add     r2, r0, r1      @ r2 = id1 + id2

        ldr     r3, [r6]        @ r3 = id3
        add     r2, r2, r3      @ r2 = id1 + id2 + id3

		str     r2, [r7]

        ldr     r0, =msg_print_title
        bl      printf

        ldr     r1, [r4]
        ldr     r0, =msg_id_line
        bl      printf

        ldr     r1, [r5]
        ldr     r0, =msg_id_line
        bl      printf

        ldr     r1, [r6]
        ldr     r0, =msg_id_line
        bl      printf

        ldr     r1, [r7]
        ldr     r0, =msg_sum
        bl      printf

        ldr     r0, =msg_id_end
        bl      printf


        ldmfd   sp!, {r4-r7, lr}
        bx      lr
