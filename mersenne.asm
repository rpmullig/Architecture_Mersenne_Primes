###################################################
#        -----------Data-----------               #
###################################################
    .data
################# Test Big Ints ###################
number0: .word 1 8                                # 8, first digit is the n
number1: .word 2 6 4                              # 64
number2: .word 3 1 2 3                            # 123
################# Print messages ##################
newline: .asciiz "\n"
msg:  .asciiz "Function: main called \n"
msg1: .asciiz "Function: Is_small_prime_test  called\n"
msg2: .asciiz "Function: print called\n"
msg3: .asciiz "Success!"
###################################################
#        -----------TEXT-----------               #
###################################################
    .text
##################### Main ########################
main:
# print main message function
    la $a0, msg
    li $v0, 4
    syscall
   # li $v0, 100
   # li $a0, 81
   # jal is_small_prime                          # got to is_small_prime
   # move $a0, $v0                               # store the result
   # li $v0, 1
   # syscall
    li $a0, 5
    jal digit_to_big
    move $a0, $v0
    jal print_big
    li $v0, 10
    syscall
################### is_small_prime ###############
is_small_prime:
    sub $t0, $a0, 1                             # $t0 = p ($a0) -1
    li $t1, 2                                   # Create an i starting at 2 in $t1
    move $t2, $a0                               # $t2 = p
    la $a0, msg1                                # load print message
    li $v0, 4                                   # print instruction call
    syscall                                     # Call the system call 4, to print
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
    syscall                                     # Syscall 9, to allocate
    move $t1, $v0                               # 1404 bytes for b placed on heap, move to $t1
    li $t2, 1                                   # using to set n as 1
    sw $t1, 0($t2)                              # b.n =1
    addi $t1, 4                                 # increment to digits[0] index by adding 4 bytes
    sw $t1, 0($t0)                              # digits[0] = a
    addi $t1, -4                                # move back to beginning of Bigint b
    move $v0, $t1                               # Put address into the return parameter
    jr $ra                                      # exit

############### compare_big ####################
compare_big:

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
