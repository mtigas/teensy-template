# The name of your project (used to name the compiled .hex file)
# TARGET = $(notdir $(CURDIR))
TARGET = MyProject

TEENSYDUINO_PATH = /Users/mtigas/Applications/Teensyduino.app
TEENSY = 40
TEENSYDUINO=152
ARDUINO = 10810

TEENSY_CORE_SPEED = 528000000
# teensy 4.0 default is 600mhz (600000000)
# teensy40.menu.speed.1008.build.fcpu=1008000000
# teensy40.menu.speed.960.build.fcpu=960000000
# teensy40.menu.speed.912.build.fcpu=912000000
# teensy40.menu.speed.816.build.fcpu=816000000
#      CoreMark 1.0 : 3518.65
# teensy40.menu.speed.720.build.fcpu=720000000
#      CoreMark 1.0 : 3104.63
# teensy40.menu.speed.600.build.fcpu=600000000
#      CoreMark 1.0 : 2587.15
# teensy40.menu.speed.528.build.fcpu=528000000
#      CoreMark 1.0 : 2276.69
# teensy40.menu.speed.450.build.fcpu=450000000
#      CoreMark 1.0 : 1940.37
# teensy40.menu.speed.396.build.fcpu=396000000
#      CoreMark 1.0 : 1707.46
# teensy40.menu.speed.150.build.fcpu=150000000
# teensy40.menu.speed.24.build.fcpu=24000000
#
# Arduino MKR1010WIFI
#      CoreMark 1.0 : 51.82

# configurable options
OPTIONS = -DUSB_SERIAL -DLAYOUT_US_ENGLISH

# directory to build in
BUILDDIR = "$(abspath $(CURDIR)/build)"

# unset to skip using ccache
CCACHE = /Users/mtigas/homebrew/bin/ccache

#************************************************************************
# Location of Teensyduino utilities, Toolchain, and Arduino Libraries.
# To use this makefile without Arduino, copy the resources from these
# locations and edit the pathnames.  The rest of Arduino is not needed.
#************************************************************************

TOOLSPATH = $(abspath $(TEENSYDUINO_PATH)/Contents/Java/hardware/tools)

# path location for Teensy Loader, teensy_post_compile and teensy_reboot
# TOOLSPATH = $(CURDIR)/tools

# path location for Teensy 3 core
# COREPATH = teensy4
# COREPATH=/Users/mtigas/Library/Arduino15/packages/arduino/hardware/avr/cores/teensy4
COREPATH = $(abspath $(TEENSYDUINO_PATH)/Contents/Java/hardware/teensy/avr/cores/teensy4)

# path location for Arduino libraries
# LIBRARYPATH = libraries
#LIBRARYPATH = $(abspath $(ARDUINOPATH)/packages/arduino/hardware/avr/libraries)
# LIBRARYPATH = /Users/mtigas/Documents/Arduino/libraries
# LIBRARYPATH = $(abspath $(TEENSYDUINO_PATH)/Contents/Java/hardware/teensy/avr/libraries)

# path location for the arm-none-eabi compiler
COMPILERPATH = $(TOOLSPATH)/arm/bin

#************************************************************************
# Settings below this point usually do not need to be edited
#************************************************************************




OPTFLAGS = -O3     -ffast-math -fpeel-loops     -funroll-loops -ftree-vect-loop-version -ftree-vectorize    -fpredictive-commoning -ftree-slp-vectorize -ftree-loop-vectorize -fvect-cost-model -fvect-cost-model=dynamic -funswitch-loops -faggressive-loop-optimizations -fselective-scheduling -fsel-sched-pipelining -fsel-sched-pipelining-outer-loops

LD_OPTFLAGS = $(OPTFLAGS) -fuse-linker-plugin

# compiler options specific to teensy version
# ifeq ($(TEENSY), 30)
# 		CPPFLAGS += -D__MK20DX128__ -mcpu=cortex-m4
# 		MCU_LD = $(COREPATH)/mk20dx128.ld
# 		LDFLAGS += -mcpu=cortex-m4 -T$(MCU_LD)
# else ifeq ($(TEENSY), 31)
# 		CPPFLAGS += -D__MK20DX256__ -mcpu=cortex-m4
# 		MCU_LD = $(COREPATH)/mk20dx256.ld
# 		LDFLAGS += -mcpu=cortex-m4 -T$(MCU_LD)
# else ifeq ($(TEENSY), LC)
# 		CPPFLAGS += -D__MKL26Z64__ -mcpu=cortex-m0plus
# 		MCU_LD = $(COREPATH)/mkl26z64.ld
# 		LDFLAGS += -mcpu=cortex-m0plus -T$(MCU_LD)
# 		LIBS += -larm_cortexM0l_math
# else ifeq ($(TEENSY), 35)
# 		CPPFLAGS += -D__MK64FX512__ -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
# 		MCU_LD = $(COREPATH)/mk64fx512.ld
# 		LDFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T$(MCU_LD)
# 		LIBS += -larm_cortexM4lf_math
# else ifeq ($(TEENSY), 36)
# 		CPPFLAGS += -D__MK66FX1M0__ -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
# 		MCU_LD = $(COREPATH)/mk66fx1m0.ld
# 		LDFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T$(MCU_LD)
# 		LIBS += -larm_cortexM4lf_math
# else ifeq ($(TEENSY), 40)
ifeq ($(TEENSY), 40)
		MCU=IMXRT1062
		MCU_LD = $(COREPATH)/imxrt1062.ld
		MCU_OPTIONS = -D__$(MCU)__ -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb
		MCU_LDFLAGS = -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb
		MCU_LIBS = -larm_cortexM7lfsp_math -lstdc++
else
		$(error Invalid setting for TEENSY)
endif


#############################################

OPTIONS += -D__$(MCU)__ -DARDUINO=$(ARDUINO) -DTEENSYDUINO=$(TEENSYDUINO) -DF_CPU=$(TEENSY_CORE_SPEED) -DARDUINO_TEENSY$(TEENSY)

# CPPFLAGS = compiler options for C and C++
CPPFLAGS = -Wall -g $(OPTFLAGS) $(MCU_OPTIONS) -ffunction-sections -fdata-sections -MMD $(OPTIONS) -Isrc -I$(COREPATH)

# compiler options for C++ only
# CXXFLAGS = -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti
CXXFLAGS = -std=gnu++14 -felide-constructors -fno-exceptions -fno-rtti -fpermissive -Wno-error=narrowing

# compiler options for C only
CFLAGS =
# linker options
LDFLAGS = $(LD_OPTFLAGS) -Wl,--gc-sections,--relax,--as-needed $(SPECS) $(MCU_OPTIONS) -T$(MCU_LD) $(MCU_LDFLAGS)

# additional libraries to link
LIBS = -lm $(MCU_LIBS)

# names for the compiler programs
CC = $(CCACHE) $(abspath $(COMPILERPATH))/arm-none-eabi-gcc
LD = $(CCACHE) $(abspath $(COMPILERPATH))/arm-none-eabi-ld
CXX = $(CCACHE) $(abspath $(COMPILERPATH))/arm-none-eabi-g++
OBJCOPY = $(CCACHE) $(abspath $(COMPILERPATH))/arm-none-eabi-objcopy
SIZE = $(CCACHE) $(abspath $(COMPILERPATH))/arm-none-eabi-size

# automatically create lists of the sources and objects
LC_FILES := $(wildcard $(LIBRARYPATH)/*/*.c)
LCPP_FILES := $(wildcard $(LIBRARYPATH)/*/*.cpp)
TC_FILES := $(wildcard $(COREPATH)/*.c)
TCPP_FILES := $(wildcard $(COREPATH)/*.cpp)
C_FILES := $(wildcard src/*.c)
CPP_FILES := $(wildcard src/*.cpp)
INO_FILES := $(wildcard src/*.ino)

# include paths for libraries
L_INC := $(foreach lib,$(filter %/, $(wildcard $(LIBRARYPATH)/*/)), -I$(lib))

SOURCES := $(C_FILES:.c=.o) $(CPP_FILES:.cpp=.o) $(INO_FILES:.ino=.o) $(TC_FILES:.c=.o) $(TCPP_FILES:.cpp=.o) $(LC_FILES:.c=.o) $(LCPP_FILES:.cpp=.o)
OBJS := $(foreach src,$(SOURCES), $(BUILDDIR)/$(src))

all: hex

build: $(TARGET).elf

hex: $(TARGET).hex

# post_compile: $(TARGET).hex
# 	@$(abspath $(TOOLSPATH))/teensy_post_compile -file="$(basename $<)" -path="$(CURDIR)" -tools="$(abspath $(TOOLSPATH))"
# 
# reboot:
# 	@-$(abspath $(TOOLSPATH))/teensy_reboot
# 
# upload: post_compile reboot
upload: $(TARGET).hex
	/Users/mtigas/homebrew/bin/teensy_loader_cli $(TARGET).hex -v -w --mcu=$(MCU)

$(BUILDDIR)/%.o: %.c
	@echo -e "[CC]\t$<"
	@mkdir -p "$(dir $@)"
	@$(CC) $(CPPFLAGS) $(CFLAGS) $(L_INC) -o "$@" -c "$<"

$(BUILDDIR)/%.o: %.cpp
	@echo -e "[CXX]\t$<"
	@mkdir -p "$(dir $@)"
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(L_INC) -o "$@" -c "$<"

$(BUILDDIR)/%.o: %.ino
	@echo -e "[CXX]\t$<"
	@mkdir -p "$(dir $@)"
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(L_INC) -o "$@" -x c++ -include Arduino.h -c "$<"

$(TARGET).elf: $(OBJS) $(MCU_LD)
	@echo -e "[LD]\t$@"
	@$(LD) $(LDFLAGS) -o "$@" $(OBJS) $(LIBS)

%.hex: %.elf
	@echo -e "[HEX]\t$@"
	@$(SIZE) "$<"
	@$(OBJCOPY) -O ihex -R .eeprom "$<" "$@"

# compiler generated dependency info
-include $(OBJS:.o=.d)

clean:
	@echo Cleaning...
	@rm -rf "$(BUILDDIR)"
	@rm -f "$(TARGET).elf" "$(TARGET).hex"
