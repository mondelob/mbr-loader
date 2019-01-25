# mbr-loader - MBR loader
# Copyright (C) 2019  Bruno Mondelo

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

.PHONY: all clean dist
.PRECIOUS: %.o %.out

AS := fasm
LD := ld

AUXFILES := Makefile README.md LICENSE
PROJDIRS := src
SRCFILES := $(shell find $(PROJDIRS) -type f -name "*.s")

OBJFILES := src/boot.o
OUTFILES := src/boot.out
BINFILES := boot.bin

ALLFILES := $(AUXFILES) $(SRCFILES)

all: $(BINFILES)

clean:
	-@$(RM) $(wildcard $(OBJFILES) $(OUTFILES) $(BINFILES) mbrloader.tar.gz)

dist:
	@tar czf mbrloader.tar.gz $(ALLFILES)

%.o: %.s Makefile
	@$(AS) $< $@

%.out: %.o Makefile
	@$(LD) -o $@ $< -Ttext 0x0600

boot.bin: src/boot.out src/std/macros.inc src/std/functions.inc \
src/mbr/macros.inc src/mbr/partitions.inc
	@objcopy -O binary -j .text $< $@
