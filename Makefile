ASM = nasm

SRC_DIR = src
BUILD_DIR = build

.PHONY: all floppy_image kernel bootloader clean always

### FLOPPY IMAGE

floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel

# Create a blank floppy image (1.44MB)
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880

# Format the floppy image with FAT12 filesystem		
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img

# Write the bootloader to the floppy image
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc

# Copy the kernel to the floppy image
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::/kernel.bin"


### BOOTLOADER

bootloader: $(BUILD_DIR)/bootloader.bin

# Assemble the bootloader source code into a binary file
$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin


### KERNEL

kernel: $(BUILD_DIR)/kernel.bin

# Assemble the kernel source code into a binary file
$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin


### ALWAYS

always:
	@mkdir -p $(BUILD_DIR)

### CLEAN

clean:
	@rm -rf $(BUILD_DIR)/*