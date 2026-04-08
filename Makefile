QT_PKG ?= Qt6Widgets
PKG_CONFIG ?= pkg-config
CXX ?= clang++
AR ?= ar

BUILD_DIR := ext/qt6cr/build
INCLUDE_DIR := ext/qt6cr/include
SRC := ext/qt6cr/src/qt6cr.cpp
OBJ := $(BUILD_DIR)/qt6cr.o
LIB := $(BUILD_DIR)/libqt6cr.a

CXXFLAGS += -std=c++17 -fPIC -I$(INCLUDE_DIR) $(shell $(PKG_CONFIG) --cflags $(QT_PKG))

.PHONY: native spec example-hello example-counter clean

native: $(LIB)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ): $(SRC) $(INCLUDE_DIR)/qt6cr.h | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $(SRC) -o $(OBJ)

$(LIB): $(OBJ)
	rm -f $(LIB)
	$(AR) rcs $(LIB) $(OBJ)

spec: native
	crystal spec

example-hello: native
	crystal run examples/hello_world.cr

example-counter: native
	crystal run examples/counter.cr

clean:
	rm -rf $(BUILD_DIR)
