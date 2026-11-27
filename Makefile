CC      := gcc
CFLAGS  := -std=c11 -Wall -Wextra -Wpedantic -g -Iinclude

HDR     := $(wildcard include/yads/*.h)
SRC     := $(wildcard src/*.c)
OBJ     := $(patsubst src/%.c,build/%.o,$(SRC))
LIB     := build/libyads.a
TESTS   := $(patsubst tests/%.c,build/%,$(wildcard tests/test_*.c))

all: $(LIB)

# pack all object files into one static library
$(LIB): $(OBJ)
	ar rcs $@ $^

# compile each .c into a .o (rebuild if any header changes)
build/%.o: src/%.c $(HDR) | build
	$(CC) $(CFLAGS) -c $< -o $@

# each test = one executable linked against libyads.a
build/test_%: tests/test_%.c $(LIB) $(HDR)
	$(CC) $(CFLAGS) $< -Lbuild -lyads -o $@

build:
	mkdir -p build

test: $(TESTS)
	@for t in $(TESTS); do echo "== $$t"; ./$$t || exit 1; done

memcheck: $(TESTS)
	@for t in $(TESTS); do valgrind --leak-check=full --error-exitcode=1 ./$$t || exit 1; done

clean:
	rm -rf build

.PHONY: all test memcheck clean