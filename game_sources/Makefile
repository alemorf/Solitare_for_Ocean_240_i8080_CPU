C_FILES=$(wildcard *.c)
H_FILES=$(wildcard *.h)

all: files sol.com sol_.com

.PHONY: clean files

files:
	find . -type f >sol.files
	touch sol.creator

format:
	clang-format -i *.c *.h convert_resources/*.cpp convert_resources/*.h

sol_.com: $(C_FILES) $(H_FILES)
	../c8080/c8080 -OCPM -DARCH_CPM -o$@ $(C_FILES)

sol.com: sol_.com
	../c8080/pack_cpm $@ $<
	cp sol.com /home/alemorf/a/work/ocean_8/files
	cd /home/alemorf/a/work/ocean_8 && make

resources.c: resources.png ./convert_resources/convert_resources 
	./convert_resources/convert_resources

convert_resources/convert_resources: convert_resources/*.cpp convert_resources/*.h
	g++ -o$@ --std=c++17 convert_resources/*.cpp -lpng

clean:
	rm -f sol.com
