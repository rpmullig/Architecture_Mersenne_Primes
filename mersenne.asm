###################################################
#        -----------Data-----------               #
###################################################
    .data
################# Test Big Ints ###################
number5: .word 4 0 0 0 7 
compressTest: .word 4 3 0 0 0 
number4: .word 1 3 
compare1a: .word 2 4 2 
compare1b: .word 2 3 0 
compare2a: .word 2 3 0 
compare2b: .word 2 4 2 
compare3a: .word 2 4 2 
compare3b: .word 2 4 2 
number0: .word 1 8 
number1: .word 3 6 4 4 
number2: .word 3 1 2 3 
################# Print messages ##################
newline: .asciiz "\n"
msg:  .asciiz "Small Prime Tests"
msg1: .asciiz "Compare Tests"
msg2: .asciiz "Compress Test"
msg3: .asciiz "Shift Right Test"
msg4: .asciiz "Shift Left Test"
###################################################
#        -----------TEXT-----------               #
###################################################
    .text
##################### Main ########################
main:
    b small_prime_test_run                    # run the small prime tests
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
        la $a0, compare2a
        la $a1, compare2b
        jal compare_big
        move $a0, $v0
        jal print_int
        la $a0, compare3a
        la $a1, compare3b
        jal compare_big
        move $a0, $v0
        jal print_int
        b end_program

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
     lw $t1, 0($t0)                             # load the n -- big int struct size
     move $t2, $t1                              # copy the n
     addi $t2, -1                               # c, subtract one from n
     mul $t5, $t1, 4                            # $t5 = number array size
     add $t0, $t0, $t5                          # move pointer(t0) to the bottom of the stack
    print_big.loop:
        blt $t2, 0, print_big.end               # c < 0 -- the inverse of c >= 0
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
        move $v0, $a0
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
    blt  $t3, $t2, compare_big.return_pos      # ? b.n < a.n : 1
    move $t4, $t2                              # $t4 = i = a.n/$t2
    addi $t4, -1                               # i = a.n - 1
    li   $t5, 4                                # need to get the byte offset
    mul  $t2, $t2, $t5                         # $t2 =  4 * a.n
    add  $t2, $t0, $t2                         # go to the end of a digits array
    mul  $t3, $t3, $t5                         # $t3 =  4 * b.n
    add  $t3, $t1, $t3                         # go to the end of b digits array
    compare_big.loop:
        bltz $t4, compare_big.return_z         # if i < 0, end the loop
        lw $t6, ($t2)                          # load a digit to $t6
        lw $t7, ($t3)                          # load b digit to $t7
        bgt  $t6, $t7, compare_big.return_pos  # a.digits[i] > b.digits[i] : 1
        blt  $t6, $t7, compare_big.return_neg  # a.digits[i] < b.digits[i] : -1
        addi $t2, -4                           # move to next digit in a digits array
        addi $t3, -4                           # move to next digit in b digits array
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
     move $t0, $a0                             # load address
     move $t6, $a0
     lw $t1, 0($t0)                            # get n
     move $t2, $t1                             # copy n to calculate offset
     mul $t5, $t2, 4                           # get offset
     add $t0, $t0, $t5                         #
    compress.loop:
        blez $t2, compress.return              #
        lw $t4, 0($t0)                         # digits[i] overwritting because we can
        bnez $t4, compress.return              #
        sub $t0, 4                              # redude the address by one
        sub $t2, 1                              # n
        b compress.loop
    compress.return:
        sw $t2, 0($t6)                         # store the update n value
        move $v0, $t6
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
    move $t0, $a0
    lw $t1, 0($t0)
    li $t2, 0
    add $t3, $t0, 4
    shift_left.loop:
        beq $t2, $t1, shift_left.return
        lw $t4, 4($t3)
        sw $t4, ($t3)
        add $t2, 1
        add $t3, 4
        b shift_left.loop
    shift_left.return:
        sub $t1, 1
        sw $t1, 0($t0)
        move $v0, $t0
        jr $ra

init_big_int:
    subu $sp, $sp, 1404                     # move the stack pointer down one bigint size
    move $t0, $sp

    li $t1, 0
    sw $t1, ($t0)

    li $t2, 0

    init_big_int.loop:
        beg $t2, $21, init_big_int.return
        add $t0, 4
        sw $0, ($t0)
        add $t2, 1
        b init_big_int.loop


    init_big_ing.return:
        move $v0, $sp
        jr $ra


############### mult_big #####################
mult_big:
    subu $sp, $sp, 36                       # push the stack frame
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)

    move $s0, $a0                           # load a into $s0
    move $s1, $a1                           # load b into $s1
    move $s2, $a2                           # load c into $s2, no need to do the loop
    lw $s3, 0($s1)                          # load a.n int $s3
    lw $s4, 0($s1)                          # load b.n int $s4

    li $s5, 0                               # i = 0
    mult_big.loopOne:
        beg $s5, $s4, mult_big.loopOneExit
        li $s6, 0                          # carry = 0
        move $s7, $s5                      # initilize j
        move $t9, $s3                      # a.n + i
        add $t9, $t9, $s5
        mult_big.loopTwo:
            beg $s7, $t9, mult_big.loopTwoExit


        mult_big.loopTwoExit:

        b mult_big.loopOne                     #

        mult_big.loopOneExit:



    lw $ra, ($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s, 32($sp)

    subu $sp, $sp, 36                          # remove the stack frame


#pow_big:

#sub_big:

#sub_big:


#mod_big:
#LLT:
















