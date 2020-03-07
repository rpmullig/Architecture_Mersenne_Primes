    .data

    .text
compress:

digit_to_big:

print_big:


sub_big:

mult_big:

sub_big:

pow_big:

compare_big:

shift_right:

shift_left:



mod_big:

LLT:

is_small_prime:
    sub $t0, $a0, 1                             # p -1
    li $t1, 2                                   # i
is_small_prime.loop:
    blt $t0, $t1, is_small_prime.end_loop
# modulo
    div $a0, $t1                                # result in a different register
    mfhi $t2                                    # move the result for modul o
#if statement
    beqz $t2, is_small_prime.true
# increment the loop
    addi $t0, 1
    b is_small_prime.loop
is_small_prime.end_loop:                        # exited the loop as not prime
    li $v0, 1                                   # return 1
    jr $ra
is_small_prime.not_true:                        # then it's a prime
    li $v0, 0                                   # return 0
    jr $ra

main:

    move $t0, 2
main.loop:



    jr $ra