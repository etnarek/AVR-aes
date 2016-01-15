###############################################################################
# Makefile for the project $(PROJECT)
###############################################################################

## General Flags
PROJECT = main
MCU = atmega328p
TARGET = $(PROJECT).elf
CC = avr-gcc

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -gdwarf-2 -Os -std=gnu99 -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -g -DARDUINO=106 -DF_CPU=16000000L -ffunction-sections -fdata-sections -w -fno-exceptions
#CFLAGS += -MD -MP -MT $(*F).o -MF dep/$(@F).d 

## Assembly specific flags
ASMFLAGS = $(COMMON)
ASMFLAGS += $(CFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,-gdwarf2

## Linker flags
LDFLAGS = $(COMMON)
LDFLAGS +=-Wl,-Os -Wl,--gc-sections


## Intel Hex file production flags
HEX_FLASH_FLAGS = -R .eeprom

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0 --no-change-warnings

## Push flags
PUSH=/usr/share/arduino/hardware/tools/avrdude
PORT=/dev/ttyACM0
BAUDRATE=115200
CONFIGFILE=-C /usr/share/arduino/hardware/tools/avrdude.conf
PUSHFLAGS=$(CONFIGFILE) -c arduino -p $(MCU) -P $(PORT) -b $(BAUDRATE) -D

## Objects that must be built in order to link
SOURCES=$(wildcard *.c) 
ASMSOURCES=$(wildcard *.S)
AASMSOURCES=$(wildcard *.asm)
OBJECTS=$(patsubst %.c,%.o,$(SOURCES)) $(patsubst %.S,%.o,$(ASMSOURCES)) $(patsubst %.asm,%.o,$(AASMSOURCES))

## Objects explicitly added by the user

## Build
all: $(TARGET) $(PROJECT).hex $(PROJECT).eep $(PROJECT).lss size

## Compile
%.o:%.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<
%.o:%.S
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

%.o:%.asm
	avr-as $(INCLUDES) $(COMMON) -c $<

##Link
$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LINKONLYOBJECTS) $(LIBDIRS) $(LIBS) -o $(TARGET)

%.hex: $(TARGET)
	avr-objcopy -O ihex $(HEX_FLASH_FLAGS)  $< $@

%.eep: $(TARGET)
	-avr-objcopy $(HEX_EEPROM_FLAGS) -O ihex $< $@ || exit 0

%.lss: $(TARGET)
	avr-objdump -h -S $< > $@

size: ${TARGET}
	@echo
	@avr-size -C --mcu=${MCU} ${TARGET}

## Push to arduino
push:all
	$(PUSH) $(PUSHFLAGS) -U flash:w:$(PROJECT).hex:i

test:push
	python test/test.py

## Clean target
.PHONY: clean
clean:
	-rm -rf $(OBJECTS) $(PROJECT).elf $(PROJECT).hex $(PROJECT).eep $(PROJECT).lss $(PROJECT).map


