###################################################
#        -----------Data-----------               #
###################################################
    .data
################# Test Big Ints ###################
compressTest: .word 4 0 0 0 3                     # for compress test
number0: .word 1 8                                # 8, first digit is the n
number1: .word 2 6 4                              # 64
number2: .word 3 1 2 3                            # 123
################# Print messages ##################
newline: .asciiz "\n"
msg:  .asciiz "Small Prime Tests"
msg1: .asciiz "Compress Test"
msg2: .asciiz "Function: print called\n"
msg3: .asciiz "Success!"
###################################################
#        -----------TEXT-----------               #
###################################################
    .text
##################### Main ########################
main:
    li $a0, 1
    jal digit_to_big
    move $a0, $v0
    jal print_big

    b end_program
    jal small_prime_test_run                    # run the small prime tests
    #jal digit_to_big
    #li  $a0, 3923
    #jal print_big
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
        b end_program

################### is_small_prime ###############
is_small_prime:
    sub $t0, $a0, 1                             # $t0 = p ($a0) -1
    li $t1, 2                                   # Create an i starting at 2 in $t1
    move $t2, $a0                               # $t2 = p
#    la $a0, msg1                                # load print message
 #   li $v0, 4                                   # print instruction call
 #   syscall                                     # Call the system call 4, to print
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
     li $t4, 4                                  # get digit to multiply
     mul $t5, $t1, $t4                          # $t5 = number array size
     add $t0, $t0, $t5                          # move pointer(t0) to the bottom of the stack
     li $v0, 1                                  # set syscall to print integer, can be done outside loop
    print_big.loop:
        bltz $t2, print_big.end                 # c < 0 -- the inverse of c >= 0
        lw $t3, ($t0)                           # derefrence the pointer
        move $a0, $t3                           # load the digits[c] into the print
        syscall                                 # call the print
        addi $t0, -4                            # decrease word by 1 byte
        addi $t2, -1                            # decrement by 4 for words
        b print_big.loop                        # loop to top again
    print_big.end:
        la $a0, newline                         # load adress of new line from .data
        li $v0, 4                               # print string syscall
        syscall                                 # call syscall
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
    add  $t2, $t0                              # go to the end of a digits array
    mul  $t3, $t3, $t5                         # $t3 =  4 * b.n
    add  $t3, $t1                              # go to the end of b digits array
    compare_big.loop:
        bltz $t4, compare_big.return_z         # if i < 0, end the loop
        lw $t6, ($t2)                          # load a digit to $t6
        lw $t7, ($t3)                          # load b digit to $t7
        bgt  $t6, $t7, compare_big.return_neg  # a.digits[i] > b.digits[i]
        blt  $t6, $t7, compare_big.return_pos  # a.digits[i] < b.digits[i]
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
############### shift_right ####################
shift_right:

############### shift_left #####################
shift_left:



#compress:


#sub_big:
#mult_big:
#sub_big:
#pow_big:

#mod_big:
#LLT:
