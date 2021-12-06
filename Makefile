EXE = mclife
all: $(EXE)

SRC   = doCol.S main.c
OBJ  = doCol.o main.o

# special libraries
LIBDIR  = -L/home/linux/ieng6/cs30fa21c/public/local/arm/lib
LIB   = $(LIBDIR) -lcse30liferv -lcse30life

# select the compiler and flags you can override on the command line
CC    = gcc 
DEBUG = -g -gstabs+
CSTD  = -std=c11
WARN  = -Wall -Wextra
CFLAGS = -I. -D_POSIX_C_SOURCE $(DEBUG) $(WARN) $(CTDO)


# select the assembler
AS      = gcc
ASLIST  = -Wa,-adhln
ASFLAGS = -I. $(DEBUG)

%.o : %.s
	$(AS) -c $(ASFLAGS) $< -o $@

$(EXE) : $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $(LIB) -o $@


.PHONY: clean
clean:
	rm -f $(OBJ) $(EXE)
