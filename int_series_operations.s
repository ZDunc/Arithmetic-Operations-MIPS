#####################################################
#         Calculates the sum, mean, min,            #
#     max, and variance of a series of numbers.     #
#####################################################

#DATA SEGMENT___________________________________________________________________
  .data

#Declare strings in memory
  Prompt: .asciiz "Enter integer values, one per line, terminated by a negative value."
  NL:     .asciiz "\n"
  Sum:    .asciiz "     Sum is: "
  Min:    .asciiz "     Min is: "
  Max:    .asciiz "     Max is: "
  Mean:   .asciiz "    Mean is: "
  Vari:   .asciiz "Variance is: "

  .align 2

  List: .space 400

#TEXT SEGMENT___________________________________________________________________
  .text
  .globl main

main:

  #INTRO MESSAGE
  li $v0, 4                     #Change syscall to print string
  la $a0, Prompt                #Load address of Name string
  syscall                       #Print Name to console
  la $a0, NL                    #Load address of Title string
  syscall                       #Print

  #INITIALIZE COUNTER, MAX INPUT, SUM, SUM^2, MIN, MAX
  li $t0, 0                     #COUNTER = 0
  li $s0, 0                     #SUM = 0
  li $s1, 0                     #SUM OF EACH NUM^2 = 0
  li $s2, 0                     #MIN = 0
  li $s3, 0                     #MAX = 0

FirstInput:
  li $v0, 5                     #Change syscall to read int
  syscall                       #Read an integer
  move $t2, $v0                 #Store latest int in temp2
  move $s2, $t2                 #Store first int in min
  move $s3, $t2                 #Store first in in max
  j Skip                        #Jump to Skip (already read first int)

#READ INPUT LOOP________________________________________________________________

Input:
  li $v0, 5                     #Change syscall to read int
  syscall                       #Read an integer
  move $t2, $v0                 #Store latest int in temp2

Skip:
  la $t3, List                  #Load address of list into temp3
  sll $t4, $t0, 2               #Determine offset from List into temp4
  addu $t4, $t4, $t3            #Add offset and Temp address
  sw $t2, 0($t4)                #Store in memory
  blez $t2, EndLoop             #If latest int is negative, branch to EndLoop

  #Update COUNTER, SUM, SUM^2, MIN, MAX
  addi $t0, $t0, 1              #COUNTER++
  add $s0, $s0, $t2             #SUM = SUM + INT
  mul $t5, $t2, $t2             #Current int SQUARED
  add $s1, $s1, $t5             #SUM^2 = SUM^2 + Current int SQUARED
  slt $t6, $t2, $s2             #If $t2 is less than $s2, $t6 = 1, if not = 0
  beq $t6, $zero, KeepMin       #IF $t6==0, skip to KeepMin (keep current MIN)
  move $s2, $t2                 #Update MIN with current int

KeepMin:
  sgt $t6, $t2, $s3             #If $t2>$s3, $t6=1, if not = 0
  beq $t6, $zero, KeepMax       #IF $t6==0, skip to KeepMax (keep current MAX)
  move $s3, $t2                 #Update MAX with current int

KeepMax:
  j Input                       #Return to Input to read next value

EndLoop:

#PRINT ARRAY CODE (to check input is read correctly)
#  la $t3, List
#Print:
#  lw $t7, 0($t3)
#  li $v0, 1
#  move $a0, $t7
#  syscall
#  addi $t3, $t3, 4
#  bgtz $t7, Print


#MATH CALCULATIONS AND PRINT____________________________________________________

  mul $t8, $s0, $s0               #$t8 = SUM^2

  #CONVERT TO FLOATING POINT
  mtc1 $t8, $f0                   #SUM^2 stored in $f0
  mtc1 $t0, $f1                   #COUNTER stored in $f1
  mtc1 $s1, $f2                   #SUM OF EACH NUM^2 stored in $f2
  mtc1 $s0, $f3                   #MEAN stored in $f3
  cvt.s.w $f0, $f0                #Convert SUM^2 to float
  cvt.s.w $f1, $f1                #Convert COUNTER to float
  cvt.s.w $f2, $f2                #Convert SUM OF EACH NUM^2 to float
  cvt.s.w $f3, $f3                #Convert MEAN to float


  #Floating Point Operations for
  div.s $f3, $f3, $f1             #MEAN = SUM/COUNTER

  div.s $f4, $f0, $f1             #$f4 = SUM^2/COUNTER
  sub.s $f5, $f2, $f4             #$f0 = (SUM OF EACH NUM^2 - SUM^2/COUNTER)
  div.s $f6, $f5, $f1             #$f4 = ($f0)/COUNTER    [VARIANCE]


  #PRINT SUM, MIN, MAX
  li $v0, 4                       #Change syscall to print sting
  la $a0, Sum                     #Load address of Sum
  syscall                         #Print to console
  li $v0, 1                       #Change syscall to print int
  move $a0, $s0                   #Move $s0 address to $a0
  syscall                         #Print to console
  li $v0, 4                       #Change syscall to print string
  la $a0, NL                      #Load address of NL
  syscall                         #Print to console

  #PRINT MIN                      #ABBREVIATED COMMENTS BELOW, REFER TO ABOVE
  li $v0, 4
  la $a0, Min
  syscall                         #Print Min string
  li $v0, 1
  move $a0, $s2
  syscall                         #Print min value
  li $v0, 4
  la $a0, NL
  syscall                         #Print NL

  #PRINT MAX
  li $v0, 4
  la $a0, Max
  syscall                         #Print Max string
  li $v0, 1
  move $a0, $s3
  syscall                         #Print max value
  li $v0, 4
  la $a0, NL
  syscall                         #Print NL

  #PRINT Mean
  li $v0, 4
  la $a0, Mean
  syscall                         #Print Mean string
  li $v0, 2
  mov.s $f12, $f3
  syscall                         #Print mean value
  li $v0, 4
  la $a0, NL
  syscall                         #Print NL

  #PRINT Variance
  li $v0, 4
  la $a0, Vari
  syscall                         #Print Vari string
  li $v0, 2
  mov.s $f12, $f6
  syscall                         #Print variance value
  li $v0, 4
  la $a0, NL
  syscall                         #Print NL


  jr $ra                          #Return to caller
