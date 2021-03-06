LOVEWIN32PATH=~/devfiles/love-0.9.0-win32
LOVEWIN64PATH=~/devfiles/love-0.9.0-win64

all: love winpack

builddir:
	mkdir -p build

love: builddir
	zip -9 -T -r build/SimDare.love *

winpack: win32pack win64pack

winbin: win32bin win64bin

win32bin: love
	mkdir -p build/32
	cat $(LOVEWIN32PATH)/love.exe build/SimDare.love > build/32/SimDare32.exe

win64bin: love
	mkdir -p build/64
	cat $(LOVEWIN64PATH)/love.exe build/SimDare.love > build/64/SimDare64.exe

win32pack: win32bin
	cp $(LOVEWIN32PATH)/SDL2.dll build/32
	cp $(LOVEWIN32PATH)/OpenAL32.dll build/32
	cp $(LOVEWIN32PATH)/DevIL.dll build/32
	cp $(LOVEWIN32PATH)/love.dll build/32
	cp $(LOVEWIN32PATH)/mpg123.dll build/32
	cp $(LOVEWIN32PATH)/msvcr110.dll build/32
	cp $(LOVEWIN32PATH)/lua51.dll build/32
	cp $(LOVEWIN32PATH)/msvcp110.dll build/32
	cp $(LOVEWIN32PATH)/license.txt build/32
	zip -9 -T build/SimDare32.zip build/32/*

win64pack: win64bin
	cp $(LOVEWIN64PATH)/SDL2.dll build/64
	cp $(LOVEWIN64PATH)/OpenAL32.dll build/64
	cp $(LOVEWIN64PATH)/DevIL.dll build/64
	cp $(LOVEWIN64PATH)/love.dll build/64
	cp $(LOVEWIN64PATH)/mpg123.dll build/64
	cp $(LOVEWIN64PATH)/msvcr110.dll build/64
	cp $(LOVEWIN64PATH)/lua51.dll build/64
	cp $(LOVEWIN64PATH)/msvcp110.dll build/64
	cp $(LOVEWIN64PATH)/license.txt build/64
	zip -9 -T build/SimDare64.zip build/64/*

clean:
	rm -rf build/
