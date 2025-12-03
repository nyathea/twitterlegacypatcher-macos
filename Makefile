CC = $(shell xcrun --find clang)
SDKROOT = $(shell xcrun --sdk macosx --show-sdk-path)

TWEAK_NAME = TwitterLegacyPatcher
DYLIB_NAME = lib$(TWEAK_NAME).dylib

CFLAGS = -Wall -Wextra -O2 -fmodules -fobjc-arc \
         -arch x86_64 -arch arm64 -arch arm64e \
         -isysroot $(SDKROOT) -iframework $(SDKROOT)/System/Library/Frameworks

LDFLAGS = -framework Foundation \
          -framework Cocoa \
          -framework Security \
          -F$(SDKROOT)/System/Library/Frameworks

SRCS = TwitterLegacyPatcher.m \
       Patches/TWCertificateBypass.m \
       Patches/TWAdBlocker.m \
       Patches/TWAccountEnhancements.m \
       Patches/TWMediaEnhancements.m \
       Patches/TWVersionSpoofer.m \
       Patches/TWAboutInfo.m \
       Patches/TWVerifiedStatus.m \
       Utilities/TWRuntime.m

INCLUDES = -I. -IPatches -IUtilities
AMMONIA_TWEAKS_DIR = /var/ammonia/core/tweaks

.PHONY: all clean install uninstall

all: build/$(DYLIB_NAME)

build:
	mkdir -p build

build/$(DYLIB_NAME): $(SRCS) | build
	$(CC) $(CFLAGS) $(INCLUDES) -dynamiclib \
		-install_name @rpath/$(DYLIB_NAME) \
		-compatibility_version 1.0.0 -current_version 1.0.0 \
		$(SRCS) -o $@ $(LDFLAGS) -L$(SDKROOT)/usr/lib

clean:
	rm -rf build

install: all
	sudo rm -f $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME)
	sudo rm -f $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME).blacklist
	sudo rm -f $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME).whitelist
	sudo cp build/$(DYLIB_NAME) $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME)
	sudo cp $(DYLIB_NAME).blacklist $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME).blacklist
	sudo cp $(DYLIB_NAME).whitelist $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME).whitelist

uninstall:
	sudo rm -f $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME)
	sudo rm -f $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME).blacklist
	sudo rm -f $(AMMONIA_TWEAKS_DIR)/$(DYLIB_NAME).whitelist
