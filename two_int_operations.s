#####################################################
#          Read in two numbers and find             #
#          the sum, difference, product,            #
#           and the quotient/remainder.             #
#####################################################

#DATA SEGMENT___________________________________________________________________
  .data

#Declare strings in memory
  Name: .asciiz "Zach Duncan\n"
  Title: .asciiz "Assignment #4\n"
  Descrip: .asciiz "Description: Read in two numbers and find the sum, \n"
  Descrip2: .asciiz "difference, product, and the quotient/remainder.\n"
  Prompt: .asciiz "Enter a integer greater than 0: "
  Prompt2: .asciiz "Enter another integer greater than 0: "
  Add: .asciiz " + "
  Sub: .asciiz " - "
  Mult: .asciiz " * "
  Div: .asciiz " / "
  Rem: .asciiz " rem "
  Eq: .asciiz "="
  NL: .asciiz "\n"
  Error: .asciiz "This integer is less than 1. Exiting program."
  End: .asciiz "Program concluding. Have a great day!"

  .align 2                      #Align next datum on every fourth boundary

#TEXT SEGMENT___________________________________________________________________
  .text
  .globl main

main:

  #Print Introduction - name, program title, and description of program

  li $v0, 4                     #Change syscall to print string
  la $a0, Name                  #Load address of Name string
  syscall                       #Print Name to console

                                #NOTE: syscall already set to print string
  la $a0, Title                 #Load address of Title string
  syscall                       #Print Title to console

  la $a0, Descrip               #Load address of Descrip string
  syscall                       #Print Description1 to console

  la $a0, Descrip2              #Load address of Descrip2 string
  syscall                       #Print Description2 to console

  #Print Prompt, read integer, check if it is valid
  la $a0, Prompt                #Load address of Prompt string
  syscall                       #Print prompt to console
  li $v0, 5                     #Change syscall to read int
  syscall                       #Read an int from user
  move $s0, $v0                 #Move int into $s0

  li $t0, 1                     #Set temp0 to 1 to check if int is <1 below
Check:
  slt $t1, $s0, $t0             #If $s0 is less than $t0, $t1 = 1
  beq $t1, $zero, Skip          #If $t1 = 0, user input is positive, go to Skip
  li $v0, 4                     #Change syscall to print string
  la $a0, Error                 #Load address of Error string
  syscall                       #Print String
  jr $ra                        #End program after invalid input.

Skip:                           #If input is valid --> CONTINUE
  #Print Prompt2, read second integer, then move to temp1 register
  li $v0, 4                     #Change syscall to print string
  la $a0, Prompt2               #Load address of Prompt2 string
  syscall                       #Print Prompt2 to console
  li $v0, 5                     #Change syscall to read int
  syscall                       #Read int from user
  move $s1, $v0                 #Move int into $s1

Check2:
  slt $t1, $s1, $t0             #If $s1 is less than $t0, $t1 = 1
  beq $t1, $zero, Skip2         #If $t1 = 0, user input is positive, jump ahead
  li $v0, 4                     #Change syscall to print string
  la $a0, Error                 #Load address of Error string
  syscall                       #Print String
  jr $ra                        #End program after invalid input.

Skip2:                          #If input is valid --> CONTINUE

#MATH OPERATIONS________________________________________________________________

  addu $s2, $s0, $s1            #s2 = s0 + s1
  subu $s3, $s0, $s1            #s3 = s0 - s1
  mul $s4, $s0, $s1             #s4 = s0 x s1
  divu $s0, $s1                 #s0 divided by s1
  mflo $s5                      #Put $lo (quotient) into s5
  mfhi $s6                      #Put $hi (remainder) into s6

#PRINT RESULTS__________________________________________________________________

  #ADDITION PRINT
  #Print Int1, Add string, Int2, equals char, temp2 (the sum), newline
  li $v0, 1                     #Change syscall to print int
  move $a0, $s0                 #Move s0 into a0
  syscall                       #print Int1
  li $v0, 4                     #Change syscall to print string
  la $a0, Add                   #Load address of Add string
  syscall                       #Print Add string
  li $v0, 1                     #Change syscall to print int
  move $a0, $s1                 #move s1 to a0
  syscall                       #Print Int2
  li $v0, 4                     #Change syscall to print string
  la $a0, Eq                    #Load address of Eq string
  syscall                       #Print equal string
  li $v0, 1                     #Change syscall to print int
  move $a0, $s2                 #Move sum into s2
  syscall                       #Print sum
  li $v0, 4                     #Change syscall to print string
  la, $a0, NL                   #Load address of newline
  syscall                       #Print newline

    #REFER TO ABOVE COMMENTS WHICH CLOSELY RESEMBLE FOLLOWING CODE

  #SUBTRACTION PRINT
  #Print Int1, Sub string, Int2, Eq string, temp3 (the difference), newline
  li $v0, 1
  move $a0, $s0
  syscall                       #Print Int1
  li $v0, 4
  la $a0, Sub
  syscall                       #Print Sub string
  li $v0, 1
  move $a0, $s1
  syscall                       #Print Int2
  li $v0, 4
  la $a0, Eq
  syscall                       #Print Eq string
  li $v0, 1
  move $a0, $s3
  syscall                       #Print difference
  li $v0, 4
  la, $a0, NL
  syscall                       #Print newline

  #MULTIPLICATION PRINT
  #Print Int1, Mult string, Int2, Eq string, temp4 (the product), newline
  li $v0, 1
  move $a0, $s0
  syscall                       #Print Int1
  li $v0, 4
  la $a0, Mult
  syscall                       #Print Mult string
  li $v0, 1
  move $a0, $s1
  syscall                       #Print Int2
  li $v0, 4
  la $a0, Eq
  syscall                       #Print Eq string
  li $v0, 1
  move $a0, $s4
  syscall                       #Print product
  li $v0, 4
  la, $a0, NL
  syscall                       #Print newline

  #DIVISION PRINT
  #Print Int1, Div string, Int2, Eq string, temp5 (quotient),
      #Rem string, temp6 (remainder), newline
  li $v0, 1
  move $a0, $s0
  syscall                       #Print Int1
  li $v0, 4
  la $a0, Div
  syscall                       #Print Div string
  li $v0, 1
  move $a0, $s1
  syscall                       #Print Int2
  li $v0, 4
  la $a0, Eq
  syscall                       #Print Eq string
  li $v0, 1
  move $a0, $s5
  syscall                       #Print quotient
  li $v0, 4
  la $a0, Rem
  syscall                       #Print Rem string
  li $v0, 1
  move $a0, $s6
  syscall                       #Print remainder
  li $v0, 4
  la, $a0, NL
  syscall                       #Print newline

#END PROGRAM____________________________________________________________________

  #Print End Message
  li $v0, 4                     #Change syscall to print string
  la $a0, End                   #Load address of End string
  syscall                       #Print End to console

  jr $ra                        #return to caller
