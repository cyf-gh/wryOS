OBJPATH= ./obj
SRCPATH= ./src
IMG=./bin/a.img
# mount point
MP=./.mount

BIN_IPL=$(OBJPATH)/boot.bin
ASM_IPL=$(SRCPATH)/boot.asm
# boot
$(BIN_IPL): $(ASM_IPL) Makefile
	nasm $(ASM_IPL) -o $(BIN_IPL)

# functional
SYS_YJOS=$(OBJPATH)/wryos.sys
ASM_YJOS=$(SRCPATH)/wryos.asm
$(SYS_YJOS): $(ASM_YJOS) Makefile
	nasm $(ASM_YJOS) -o $(SYS_YJOS)
 
# image
$(IMG) : $(BIN_IPL) $(SYS_YJOS) Makefile
	echo "image"

img:
	make -r $(BIN_IPL)
	make -r $(SYS_YJOS)	
	dd if=$(BIN_IPL) of=$(IMG) bs=512 count=1 conv=notrunc
	sudo mount -o loop $(IMG) $(MP)
	sudo cp -fv $(SYS_YJOS) $(MP)
	ls $(MP)
	sudo umount $(MP)

clean:
	rm -rf ./obj/*
	cd obj
	ls -al
	cd -

run:
	bochs -f bochs.src

dbg:
	make img
	make run