.section .data
filename: .asciz "input.txt"
read: .asciz "r"
yes_msg: .asciz "Yes\n"
no_msg: .asciz "No\n"

.section .text
.globl main

.extern fopen      #open file
.extern fseek      #moves file pointer
.extern ftell      #get current position
.extern fgetc      #read one character
.extern printf 
main:
    addi sp,sp,-16
    sd ra,0(sp)    #save return address

    la a0,filename   
    la a1,read
    call fopen       #fopen("input.txt","r")
    mv s0, a0       #s0=file pointer

    mv a0,s0         #a0=file pointer
    li a1,0           #offset=0
    li a2,2         #SEEK_END (move relative to end)
    call fseek      #pointer now at end of file

    mv a0,s0        #a0=file pointer
    call ftell      #returns current position ==file size
    mv s1,a0        #s1=file size

    li s2,0         #s2=left pointer
    addi s3,s1,-1   #s3=right pointer == size-1
loop:
    bge s2,s3,yes   #if left>=right loop done

    mv a0,s0        #file pointer
    mv a1,s2         #position=left pointer
    li a2,0           #SEEK_SET(from beginning)
    call fseek      #move pointer to left index

    mv a0,s0
    call fgetc      #read character at left index
    mv t0,a0       #store left char in t0

    mv a0,s0
    mv a1,s3      #position=right index
    li a2,0       #SEEK_SET
    call fseek    #move pointer to right index

    mv a0,s0
    call fgetc    #read character at right index
    mv t1,a0      #store right char in t1

    bne t0,t1,no    #if t0!=t1 not a palindrome

    addi s2,s2,1    #left++
    addi s3,s3,-1   #right--
    j loop
yes:
    la a0,yes_msg
    call printf     #print "Yes"
    j end
no:
    la a0,no_msg
    call printf     #print "No"
end:
    ld ra,0(sp)     #restore return address
    addi sp,sp,16
    ret             #return