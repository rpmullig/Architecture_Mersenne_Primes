###################################################
#        -----------Data-----------               #
###################################################
    .data
################# Test Big Ints ###################
number5: .word 4 0 0 0 7
buffer0: .byte 1404

compressTest: .word 4 3 0 0 0
buffer1: .byte 1404

number4: .word 1 3
buffer2: .byte 1404

compare1a: .word 2 2 4
buffer3: .byte 1404

compare1b: .word 2 0 3
buffer4: .byte 1404

compare2a: .word 2 0 3
buffer5: .byte 1404

compare2b: .word 2 2 4
buffer6: .byte 1404

compare3a: .word 2 2 4
buffer8: .byte 1404

compare3b: .word 2 2 4
buffer9: .byte 1404

number0: .word 1 8
buffer10: .byte 1404

number1: .word 3 6 4 4
buffer11: .byte 1404

number2: .word 3 1 2 3
buffer13: .byte 1404

number3: .word 1 2
buffer14: .byte 1404

number6: .word 1 7
buffer15: .byte 1404


number7: .word 1 3
buffer16: .byte 1404

number11: .word 2 0 3
buffer17: .byte 1404

number12: .word 2 2 4
buffer18: .byte 1404

number8: .word 2 2 4
buffer19: .byte 1404

number9: .word 8 0 0 0 0 0 0 0 1
buffer20: .byte 1404

number10: .word 7 0 0 0 0 0 0 9
buffer21: .byte 1404

number13: .word 1 3
buffer22: .byte 1404

number14: .word 1 3
buffer23: .byte 1404

number15: .word 2 2 4
buffer24: .byte 1404

number16: .word 1 7
buffer25: .byte 1404

number17: .word 1 3
buffer26: .byte 1404

number18: .word 2 2 4
buffer27: .byte 1404

number19: .word 2 2 1
buffer28: .byte 1404

number20: .word 10 0 0 0 0 0 0 0 0 0 9
buffer29: .byte 1404

number21: .word 7 1 2 3 4 5 6 7
buffer30: .byte 1404
################# Print messages ##################
newline: .asciiz "\n"
msg:  .asciiz "Small Prime Tests"
msg1: .asciiz "Compare Tests"
msg2: .asciiz "Compress Tests"
msg3: .asciiz "Shift Right Tests"
msg4: .asciiz "Shift Left Tests"
msg5: .asciiz "Multiplication Tests"
msg6: .asciiz "Power Tests"
msg7: .asciiz "Subtraction Tests"
debug_msg: .asciiz "Debug\n"
###################################################
#        -----------TEXT-----------               #
###################################################
    .text
##################### Main ########################
main:
    b small_prime_test_run                      # run the small prime tests
    b end_program
    end_program:
        li $v0, 10
        syscall
    print_message:
        li $v0, 4
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        jr $ra
    print_int:
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        jr $ra
    small_prime_test_run:
        la $a0, msg                                 # load "Small Prime Tests"
        jal print_message                           # see print message
        li $a0, 7                                   # load 7 for small prime test
        jal is_small_prime                          # run the code
        move $a0, $v0
        jal print_int
        li $a0, 81                                  # load 81 for small prime test
        jal is_small_prime                          # run the code
        move $a0, $v0
        jal print_int
        li $a0, 127                                 # load 127 for small prime test
        jal is_small_prime                          # run the code
        move $a0, $v0
        jal print_int

    compress_test:
        la $a0, msg2                             # load "Compare Tests"
        jal print_message
        la $a0, compressTest
        jal compress
        move $a0, $v0
        jal print_big
    shift_right_test:
        la $a0, msg3                                 # load "Small Prime Tests"
        jal print_message
        la $a0, number4
        jal shift_right
        jal shift_right
        jal shift_right
        la $a0, number4
        jal print_big
    shift_left_test:
        la $a0, msg4                                 # load "Small Prime Tests"
        jal print_message
        la $a0, number5
        jal shift_left
        jal shift_left
        jal print_big
    compare_test:
        la $a0, msg1                             # load "Compare Tests"
        jal print_message
        la $a0, compare1a
        la $a1, compare1b
        jal compare_big
        move $a0, $v0
        jal print_int
        la $a0, compare1b
        la $a1, compare1a
        jal compare_big
        move $a0, $v0
        jal print_int
        la $a0, compare3a
        la $a1, compare3b
        jal compare_big
        move $a0, $v0
        jal print_int
     mult_test:
        la $a0, msg5                             # load "Multiplication Tests"
        jal print_message
        jal init_big_int
        move $a2, $v0                           # return from big int is stack pointer
        la $a0, number6
        la $a1, number7
        jal mult_big                            # three argument
        move $a0, $v0                           # stack pointer has a word
        jal print_big
        move $a2, $v0                           # return from big int is stack pointer
        jal exit_big_int
        jal init_big_int
        move $a2, $v0
        la $a0, number11
        la $a1, number12
        jal mult_big                            # three argument
        move $a0, $v0                           # stack pointer has a word
        jal print_big
        jal exit_big_int
        jal init_big_int
        move $a2, $v0
        la $a0, number9
        la $a1, number10
        jal mult_big                            # three argument
        move $a0, $v0                           # stack pointer has a word
        jal print_big
        jal exit_big_int
    pow_test:
        la $a0, msg6                             # load "Small Prime Tests"
        jal print_message                        # see print message
        la $a0, number14                         # a = Bigint 4
        li $a1, 4
        jal pow_big
        move $a0, $v0
        jal print_big
        la $a0, number15                         # a = Bigint 4
        li $a1, 42
        jal pow_big
        move $a0, $v0
        jal print_big
    sub_test:
        la $a0, msg7                             # load "Small Prime Tests"
        jal print_message                        # see print message
        la $a0, number16
        la $a1, number17
        jal sub_big
        move $a0, $v0
        jal print_big
        la $a0, number18
        la $a1, number19
        jal sub_big
        move $a0, $v0
        jal print_big
        la $a0, number20
        la $a1, number21
        jal sub_big
        move $a0, $v0
        jal print_big
        b end_program
     debug:
        move $t1, $a0
        move $t2, $v0
        la $a0, debug_msg
        li $v0, 6
        syscall
        move $a0, $t1
        move $v0, $t2
        #b back


################### is_small_prime ###############
is_small_prime:
    sub $t0, $a0, 1                             # $t0 = p ($a0) -1
    li $t1, 2                                   # Create an i starting at 2 in $t1
    move $t2, $a0                               # $t2 = p
    is_small_prime.loop:
        blt $t0, $t1, is_small_prime.break_loop # modulo p ($a0) % i (
        div $t2, $t1                            # result in a different register
        mfhi $t3                                # move the result for modulo
        beqz $t3, is_small_prime.end_false      # branch to 0
        addi $t1, 1                             # increment the loop
        b is_small_prime.loop
    is_small_prime.break_loop:                  # exited the loop as not prime
        li $v0, 1                               # return 1
        jr $ra
    is_small_prime.end_false:                   # then it's a prime
        li $v0, 0                               # return 0
        jr $ra

################### print_big ###################
print_big:
     move $t0, $a0                              # get the input b to $t0, need $a0 for syscalls
     move $t7, $a0
     lw $t1, 0($t0)                             # load the n -- big int struct size
     move $t2, $t1                              # copy the n
     #add $t2, $t2, -1                           # c, subtract one from n
     mul $t5, $t1, 4                            # $t5 = number array size
     add $t0, $t0, $t5                          # move pointer(t0) to the bottom of the stack
    print_big.loop:
        beq $t2, 0, print_big.end               # c < 0 -- the inverse of c >= 0
        lw $t3, ($t0)                           # derefrence the pointer
        move $a0, $t3                           # load the digits[c] into the print
        li $v0, 1                                  # set syscall to print integer, can be done outside loop
        syscall                                 # call the print
        addi $t0, -4                            # decrease word by 1 byte
        addi $t2, -1                            # decrement by 4 for words
        b print_big.loop                        # loop to top again
    print_big.end:
        la $a0, newline                         # load adress of new line from .data
        li $v0, 4                               # print string syscall
        syscall                                 # call syscall
        move $v0, $t7
        jr $ra                                  # exit the function

############### digit_to_big ####################
digit_to_big:
    move $t0, $a0                               # move from the argument to $t0 to store
    li $a0, 1404                                # 4 bites for n, then 350 * 4 =  4 + 1400
    li $v0, 9                                   # Allocation system call
    syscall                                     # Syscall 9, to allocate an address
    move $t1, $v0                               # 1404 bytes for b placed on heap, move to $t1
    li $t2, 1                                   # using to set n as 1
    sw $t2, 0($t1)                              # b.n = 1
    sw $t0, 4($t1)                              # digits[0] = int a (came in as input)
    move $v0, $t1                               # Put address into the return parameter
    jr $ra                                      # exit

############### compare_big ####################
compare_big:
    move $t0, $a0                              # address of a = $t0
    move $t1, $a1                              # address of b = $t1
    lw   $t2, 0($t0)                           # a.n = $t2
    lw   $t3, 0($t1)                           # b.n = $t2
    blt  $t2, $t3, compare_big.return_neg      # ? a.n < b.n : -1
    bgt  $t2, $t3, compare_big.return_pos      # ? b.n < a.n : 1
    move $t4, $t2                              # $t4 = i = a.n/$t2
    #addi $t4, -1                               # i = a.n - 1
    mul  $t2, $t2, 4                           # $t2 =  4 * a.n
    add  $t2, $t0, $t2                         # go to the end of a digits array
    mul  $t3, $t3, 4                           # $t3 =  4 * b.n
    add  $t3, $t1, $t3                         # go to the end of b digits array
    compare_big.loop:
        beq $t4, 0, compare_big.return_z       # if i == 0, end the loop
        lw $t6, ($t2)                          # load a digit to $t6
        lw $t7, ($t3)                          # load b digit to $t7
        blt  $t6, $t7, compare_big.return_neg  # a.digits[i] > b.digits[i] : -1
        blt  $t7, $t6, compare_big.return_pos  # a.digits[i] < b.digits[i] : 1
        add $t2, $t2, -4                       # move to next digit in a digits array
        add $t3, $t3, -4                      # move to next digit in b digits array
        addi $t4, -1                           # i--
        b compare_big.loop                     # go to top of loop
    compare_big.return_z:
        li $v0, 0                              # break on loop condition
        jr $ra                                 # return 0
    compare_big.return_neg:
        li $v0, -1
        jr $ra
    compare_big.return_pos:
        li $v0, 1
        jr $ra

################ compress ######################
compress:

     subu $sp, $sp, 68                       # push the stack frame
     sw $ra, ($sp)
     sw $s0, 4($sp)
     sw $s1, 8($sp)
     sw $s2, 12($sp)
     sw $s3, 16($sp)
     sw $s4, 20($sp)
     sw $s5, 24($sp)
     sw $s6, 28($sp)
     sw $s7, 32($sp)
     sw $t0, 36($sp)
     sw $t1, 40($sp)
     sw $t2, 44($sp)
     sw $t3, 48($sp)
     sw $t4, 52($sp)
     sw $t5, 56($sp)
     sw $t6, 60($sp)
     sw $t7, 64($sp)


     move $t0, $a0                             # load address from argument
     move $t6, $a0                             # load again
     lw $t1, 0($t0)                            # get n
     move $t2, $t1                             # copy n to calculate offset
     mul $t5, $t2, 4                           # get offset
     add $t0, $t0, $t5                         #
    compress.loop:
        blt $t2, 1, compress.return            # *******CHECK THIS!!! **********
        lw $t4, 0($t0)                         # digits[i] overwritting because we can
        bnez $t4, compress.return              #
        sub $t0, 4                             # redude the address by one
        sub $t2, 1                             # n
        b compress.loop
    compress.return:
        sw $t2, 0($t6)                         # store the update n value
        move $v0, $t6

        lw $ra, ($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        lw $s6, 28($sp)
        lw $s7, 32($sp)
        lw $t0, 36($sp)
        lw $t1, 40($sp)
        lw $t2, 44($sp)
        lw $t3, 48($sp)
        lw $t4, 52($sp)
        lw $t5, 56($sp)
        lw $t6, 60($sp)
        lw $t7, 64($sp)
        addu $sp, $sp, 68                         # remove the stack frame

        jr $ra

############### shift_right ####################
shift_right:
    move $t0, $a0                             # load word
    lw $t1, ($t0)                             # load i = n
    move $t2, $t1                             # copy n to calculate offset
    add $t3, $t1, 1
    mul $t4, $t3, 4                           # get offset
    add $t5, $t0, $t4                         # $t0 = address + offset
    shift_right.loop:
        beq $t2, 0, shift_right.return
        lw $t6, -4($t5)                       # digts[i-1] = $t4
        sw $t6, ($t5)                         # digits[i] = $t4
        sub $t5, 4                            # move index
        sub $t2, 1                            # i--
        b shift_right.loop                    # go to the top
    shift_right.return:
        sw $0, ($t5)                          # first value is the n, so second should be 0
        add $t1, 1                            # $t5 = n + 1
        sw $t1, ($t0)                         # a.n = n + 1
        jr $ra


############### shift_left #####################
shift_left:
    move $t0, $a0                              # load word
    lw $t1, 0($t0)                             # load i = a.n
    li $t2, 0                                  # i
    add $t3, $t0, 4                            # $t3 => digits[0]
    shift_left.loop:
        beq $t2, $t1, shift_left.return        # i == a.n
        lw $t4, 4($t3)                         # $t4 = a.digits[i+1]
        sw $t4, 0($t3)                         # a.digits[i] = $t4 = a.digits[i+1]
        add $t2, 1                             # i++
        add $t3, 4                             # offset
        b shift_left.loop                      # go to the top again
    shift_left.return:
        sub $t1, 1                             # $t1 = a.n - 1
        sw $t1, 0($t0)                         # a.n = $t1 = a.n - 1
        move $v0, $t0                          # put a * into reutrn
        jr $ra

############# subroutine: init_big_int ########
init_big_int:
    subu $sp, $sp, 1404                       # move the stack pointer down one bigint size

    subu $sp, $sp, 68                       # push the stack frame
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    sw $t0, 36($sp)
    sw $t1, 40($sp)
    sw $t2, 44($sp)
    sw $t3, 48($sp)
    sw $t4, 52($sp)
    sw $t5, 56($sp)
    sw $t6, 60($sp)
    sw $t7, 64($sp)

    move $t0, $sp                             # store stack pointer in $t0
    addu $t0, $t0, 68

    li $t1, 350                               # $t1 = 0
    sw $t1, ($t0)                             # new_big_int.n = 350

    li $t2, 0                                 # $t2 = 0

    init_big_int.loop:
        beq $t2, $t1, init_big_int.return     # $t2 = 0 == 350 ? branch to exit
        add $t0, 4                            # $t0 = pointer to stack
        sw $zero, ($t0)                       # digits[i] = 0
        add $t2, 1                            # i++
        b init_big_int.loop                   # go to the top agian
    init_big_int.return:
       lw $ra, ($sp)
       lw $s0, 4($sp)
       lw $s1, 8($sp)
       lw $s2, 12($sp)
       lw $s3, 16($sp)
       lw $s4, 20($sp)
       lw $s5, 24($sp)
       lw $s6, 28($sp)
       lw $s7, 32($sp)
       lw $t0, 36($sp)
       lw $t1, 40($sp)
       lw $t2, 44($sp)
       lw $t3, 48($sp)
       lw $t4, 52($sp)
       lw $t5, 56($sp)
       lw $t6, 60($sp)
       lw $t7, 64($sp)
       addu $sp, $sp, 68                         # remove the stack frame

        move $v0, $sp                            # move stack pointer to return address
        jr $ra                                   # return


exit_big_int:
    addu $sp, $sp, 1404
    jr $ra

copy_big_init:
        subu $sp, $sp, 1404                      # move the stack pointer down one bigint size
        subu $sp, $sp, 36                        # push the stack frame
        sw $ra, ($sp)
        sw $s0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $s4, 20($sp)
        sw $s5, 24($sp)
        sw $s6, 28($sp)
        sw $s7, 32($sp)

        move $s0, $a0                           # $s0 = a (copy from this variable)
        lw $s1, 0($s0)                          # $s1 = a.n

        move $s2, $sp                           # $s2 = b (the variable copying the values to)
        addu $s2, $s2, 36                       # offet add to get back to stack pointer

        sw $s1, 0($s2)                          # b.n = a.n
        move $s3, $s1                           # i = a.n
        mul $s1, $s1, 4                         # a.n * 4
        add $s0, $s0, $s1                       # $s0 = the end of the a array
        add $s2, $s2, $s1                       # $s2 = end of the b array
        copy_big_init.loop:
            beq $s3, 0, copy_big_init.return    # i == 0, break (decrementing)
            lw $s4, ($s0)                       # $s4 = a.digits[i]
            sw $s4, 0($s2)                      # b.digits[i] = $s4 = a.digits[i]
            sub $s3, $s3, 1                     # i--
            sub $s2, $s2, 4                     # next b.digit
            sub $s0, $s0, 4                     # next a.digit
            b copy_big_init.loop                # go to top of loop
        copy_big_init.return:
            lw $ra, ($sp)
            lw $s0, 4($sp)
            lw $s1, 8($sp)
            lw $s2, 12($sp)
            lw $s3, 16($sp)
            lw $s4, 20($sp)
            lw $s5, 24($sp)
            lw $s6, 28($sp)
            lw $s7, 32($sp)
            addu $sp, $sp, 36               # remove the stack frame (36*4)
            move $v0, $sp                    # return b
            jr $ra


############### mult_big #####################
mult_big:
    subu $sp, $sp, 68                       # push the stack frame
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    sw $t0, 36($sp)
    sw $t1, 40($sp)
    sw $t2, 44($sp)
    sw $t3, 48($sp)
    sw $t4, 52($sp)
    sw $t5, 56($sp)
    sw $t6, 60($sp)
    sw $t7, 64($sp)

                                            # note big int already initizlied as all 0
    move $s1, $a0                           # load a into $s1
    move $s2, $a1                           # load b into $s2
    move $s0, $a2                           # load c into $s0, no need to do the loop
    lw $s3, 0($s1)                          # load a.n int $s3
    lw $s4, 0($s2)                          # load b.n int $s4

    li $s5, 0                               # i = 0
    mult_big.loopOne:
        beq $s5, $s4, mult_big.return       # i == b.n
        li $s6, 0                           # $s6 = carry = 0
        move $s7, $s5                       # $s6 = j = i =  $s5
        move $t9, $s3                       # $t9 = a.n
        add $t9, $t9, $s5                   # $t9 = a.n + i (for break condition)
        mult_big.inner_loop:
            beq $s7, $t9, mult_big.break_inner

            move $t0, $s2                   # start of b
            add $t0, 4                      # move to the b.digits[]
            mul $t1, $s5, 4                 # i * 4
            add $t0, $t0, $t1               # b.digits[i]
            lw $t3, ($t0)

            move $t0, $s1                   # start of a
            add $t0, 4                      # move to the a.digits[]
            move $t1, $s7                   # j
            sub $t1, $t1, $s5               # j - i
            mul $t2, $t1, 4                 # (j-1) * 4
            add $t0, $t0, $t2               # a.digits[j-i]
            lw $t4, ($t0)                   #

            mul $t5, $t3, $t4              # b.digits[i] * a.digits[j-1]

            move $t0, $s0                  # start of c
            add $t0, 4                     # move to the c.digitis[]
            mul $t1, $s7, 4                # j * 4
            add $t0, $t0, $t1              # c.digits[j]
            lw $t6, ($t0)

            add $t6, $t6, $t5               # c.digits[j] + b.digits[i] * a.digits[j-1]
            add $t6, $t6, $s6               # += carry **************

            li $t8, 10                      # $t8 = 10
            div $s6, $t6, $t8               # val / 10
            mfhi $t7                        # mod value to $t7
            sw $t7, 0($t0)                  # c.digits[j] = val % 10
            add $s7, 1                      # j++
            b mult_big.inner_loop           # restart inner loop
        mult_big.break_inner:
            beq $s6, 0, mult_big.skip_carry # carry == 0 ** double check this **
            add $t0, $t0, 4                 # j++
            lw $t1, ($t0)                   # $t1 = c.digits[j]
            add $t1, $t1, $s6               # $t1 = c.digits[j] + carry
            li $t8, 10                      # get 10
            div $s6, $t1, $t8               # val / 10
            mfhi $t2                        # mod value
            sw $t2, ($t0)                   # c.digits[j] = mod value $t2
        mult_big.skip_carry:
            add $s5, 1                      # i ++
            b mult_big.loopOne              # go to the top of the i loop


    mult_big.return:
        move $a0, $s0
        jal compress
        move $v0, $s0

        lw $ra, ($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        lw $s6, 28($sp)
        lw $s7, 32($sp)
        lw $t0, 36($sp)
        lw $t1, 40($sp)
        lw $t2, 44($sp)
        lw $t3, 48($sp)
        lw $t4, 52($sp)
        lw $t5, 56($sp)
        lw $t6, 60($sp)
        lw $t7, 64($sp)
        addu $sp, $sp, 68                          # remove the stack frame
        jr $ra                                     # Do not have to worry about return with init_big_int


############### pow_big #####################
pow_big:
    subu $sp, $sp, 68                       # push the stack frame
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    sw $t0, 36($sp)
    sw $t1, 40($sp)
    sw $t2, 44($sp)
    sw $t3, 48($sp)
    sw $t4, 52($sp)
    sw $t5, 56($sp)
    sw $t6, 60($sp)
    sw $t7, 64($sp)

    move $t1, $a1                               # $t1 = p
    move $t0, $a0                               # $t0 = Bigint a
    jal copy_big_init                           # create a copy b from stack
    move $t2, $v0                               # $t2 = b
    li $t3, 1                                   # i

    pow_big.loop:
        beq $t3, $t1, pow_big.return            # break and return

        jal init_big_int                        # add a varaible on stack
        move $t4, $v0                           # $t4 = c = new variable on stack
        move $a2, $t4                           # put c into arg register for mult
        move $a0, $t0                           # put a into arg register for mult
        move $a1, $t2                           # put b into arg register for mult
        jal mult_big                            # run mult
        move $t4, $v0                           # result
        lw $t5, 0($t4)                          # i = a.n
        sw $t5, 0($t2)                          # b = a.n
        mul $t6, $t5, 4                         # turn into byte offset
        add $t4, $t4, $t6                       # add offset byte offset for index
        add $t2, $t2, $t6                       # add offset byte offset for index
        copy:
            beq $t5, 0, end_copy                #
            lw $t7, ($t4)                       #
            sw $t7, ($t2)                       #
            sub $t4, 4                          #
            sub $t2, 4                          #
            sub $t5, 1                          #
            b copy                              # go to top
        end_copy:
        jal exit_big_int                        # remove result from stack
        add $t3, $t3, 1                         # i++

        b pow_big.loop                          # go to the top
    pow_big.return:

        jal exit_big_int                        # remoe the new variable b from the stack

        move $v0, $t2                           # return b

        lw $ra, ($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        lw $s6, 28($sp)
        lw $s7, 32($sp)
        lw $t0, 36($sp)
        lw $t1, 40($sp)
        lw $t2, 44($sp)
        lw $t3, 48($sp)
        lw $t4, 52($sp)
        lw $t5, 56($sp)
        lw $t6, 60($sp)
        lw $t7, 64($sp)
        addu $sp, $sp, 68                          # remove the stack frame

        jr $ra

############### sub_big #####################
sub_big:
    subu $sp, $sp, 68                       # push the stack frame
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    sw $t0, 36($sp)
    sw $t1, 40($sp)
    sw $t2, 44($sp)
    sw $t3, 48($sp)
    sw $t4, 52($sp)
    sw $t5, 56($sp)
    sw $t6, 60($sp)
    sw $t7, 64($sp)

    move $t0, $a0
    move $t1, $a1

    jal copy_big_init                           # create a copy of a via th stack



    lw $ra, ($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    lw $t0, 36($sp)
    lw $t1, 40($sp)
    lw $t2, 44($sp)
    lw $t3, 48($sp)
    lw $t4, 52($sp)
    lw $t5, 56($sp)
    lw $t6, 60($sp)
    lw $t7, 64($sp)
    addu $sp, $sp, 68                          # remove the stack frame

    jr $ra

############### mod_big #####################
#mod_big:


############### LLT #####################
#LLT:
















