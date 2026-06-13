## Originally by David Hill, 2015, taken from DUHeresy.

ACC = gdcc-acc
CC = gdcc-cc
LD = gdcc-ld

ACCFLAGS = --target-engine Zandronum
CFLAGS =  --warn-all --zero-null-StrEn --bc-zdacs-Sta-array 62 --target-engine Zandronum
CFLAGS_LIBC = --zero-null-StrEn --bc-zdacs-Sta-array 62 --target-engine Zandronum

.PHONY: cleanir

SPL_H = $(shell find source/ -type f -name *.h)

SPL_C_SRC = $(shell find source/ -type f -name *.c)

SPL_C_IR = $(patsubst source/%.c,build/%.ir,$(SPL_C_SRC))

SPL_ACS_SRC = $(shell find source/ -type f -name *.acs)

SPL_ACS_IR = $(patsubst source/%.acs,build/%.ir,$(SPL_ACS_SRC))

SPL_IR = $(SPL_C_IR) $(SPL_ACS_IR)

all: build/ acs/ acs/lisptest.o

clean:
	rm -f acs/*.o
	rm -rf build

cleanir:
	rm -rf build

build/:
	mkdir "build"

acs/:
	mkdir "acs/"

##
## libGDCC
##

build/libGDCC.ir:
	gdcc-makelib $(CFLAGS_LIBC) -co $@ libGDCC libc

## -I/usr/local/share/gdcc/lib/inc/C/

acs/lisptest.o: build/lisptest.ir
	$(LD) $(CFLAGS) -o $@ $^

build/lisptest.ir: build/libGDCC.ir $(SPL_C_IR) $(SPL_ACS_IR)
	$(LD) $(CFLAGS) -co $@ $^

build/%.ir: source/%.c
	$(CC) $(CFLAGS) -co $@ $<
