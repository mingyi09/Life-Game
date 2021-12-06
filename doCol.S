	// file header
	.arch armv6           		// armv6 architecture
	.arm		      		// arm 32-bit instruction set
	.fpu vfp	      		// floating point co-processor
	.syntax unified	      		// modern syntax

	.text 				// start of text segment
	// ======
	

        .global asm_doCol
	// ====== DO NOT EDIT ANYTHING ABOVE THIS LINE ======
        // !!! SET FP_OFFSET TO THE NUMBER OF (SAVED REGISTERS -1 * 4)
        // definitions that apply to the entire source file
        .equ 	FP_OFFSET, 32 // (# of saved regs - 1) * 4
	
	// asm_doCol(belem *dest,	// r0
	//           belem *src,	// r1
	//           size_t rows,	// r2
	//           size_t cols)	// r3

asm_doCol:	
	push {R4-R10, fp, lr}			//save preserved registers as needed
	add fp, sp, #FP_OFFSET		// DO NOT EDIT THIS LINE

	MOV R4, #1 //R4 = 1; line_index indicator
	SUB R5, R2, #1 //R5 = R2-1; Upper bound of the while loop

WHILE:
	CMP R4, R5 //while (line_index<rows-1) ; row by row
	BGE end_while 
	MOV R6, #0 //R6 = 0; the count of neighbors

	//count the number of neighbors
	MOV R7, #0 //R7 = 0
	SUB R7, R7, R3 //R7 = -cols; 

for:
	CMP R7, R3 //for (R7=-cols; R7 <= cols; R7+cols)
	BGT end_for 
	LDRB R8, [R1, R7] // R8 = *(src + R7) 
	ADD R6, R6, R8 //R6+=R8; count middle neighbors

	ADD R7, R7, #1
	LDRB R8, [R1, R7] // R8 = *(src + R7 +1)
	ADD R6, R6, R8 //R6+=R8; count right neighbors

	SUB R7, R7, #2
	LDRB R8, [R1, R7] // R8 = *(src + R7 -1)
	ADD R6, R6, R8 //R6-=R8; count left neighbors
	ADD R7, R7, #1 //R7++; return back to R7 value

	ADD R7, R7, R3 //R7 += cols;
	B for
end_for:

	LDRB R9, [R1] // R9 = *(src)
	STRB R9, [R0] // *(dest) = R9
	SUB R6, R6, R9 // R6 -= R9; R6 records all neighbors' counts

	//test alive or not
	CMP R9, #0   //if (*(src)==0)
	BNE alive
	CMP R6, #3   //if (count==3)
	BNE DONE
	MOV R10, #1  // R10 = 1;
	STRB R10, [R0] // *(dest) = 1;
	B DONE

alive:       //if (*(src)==1)
	CMP R6, #2 //if (count==2)
	BEQ DONE
	CMP R6, #3 //if (count==3)
	BEQ DONE
	MOV R10, #0 //R10 = 0;
	STRB R10, [R0] // *(dest) = 0;
DONE:

	ADD R4, R4, #1 // R4++; line index increases;
	ADD R1, R1, R3 // src+=cols 
	ADD R0, R0, R3 // dest+=cols

	B WHILE
end_while:

exit:	
	sub sp, fp, #FP_OFFSET		// DO NOT EDIT THIS LINE
	pop {R4-R10, fp, lr}			// TODO restore preserved registers as needed
	bx lr				// DO NOT EDIT THIS LINE
	
