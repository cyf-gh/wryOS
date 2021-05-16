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
SYS_WYOS=$(OBJPATH)/wryos.sys
ASM_WYOS=$(SRCPATH)/wryos.asm
$(SYS_WYOS): $(ASM_WYOS) Makefile
	nasm $(ASM_WYOS) -o $(SYS_WYOS)

# image
$(IMG) : $(BIN_IPL) $(SYS_WYOS) Makefile
	echo "image"

img:
	make -r $(BIN_IPL)
	make -r $(SYS_WYOS)
	dd if=$(BIN_IPL) of=$(IMG) bs=512 count=1 conv=notrunc
	sudo mount -o loop $(IMG) $(MP)
	sudo cp -fv $(SYS_WYOS) $(MP)
	ls $(MP)
	sudo umount $(MP)

clean:
	rm -rf ./obj/*
	cd obj
	ls -al
	cd -
	echo "clear image"
	sudo mount -o loop $(IMG) $(MP)
	sudo rm -rf $(MP)/*
	sudo umount $(MP)

forceumount:
	sudo umount $(MP)

run:
	bochs -f bochs.src

dbg:
	make img
	make run