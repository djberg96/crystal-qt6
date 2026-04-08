QT_PKG ?= Qt6Widgets
PKG_CONFIG ?= pkg-config
CXX ?= c++
AR ?= ar

BUILD_SCRIPT := scripts/build_qt6cr.sh

.PHONY: native spec example-hello example-counter clean

native:
	QT_PKG=$(QT_PKG) PKG_CONFIG=$(PKG_CONFIG) CXX=$(CXX) AR=$(AR) CXXFLAGS='$(CXXFLAGS)' sh $(BUILD_SCRIPT)

spec:
	crystal spec

example-hello:
	crystal run examples/hello_world.cr

example-counter:
	crystal run examples/counter.cr

clean:
	rm -rf ext/qt6cr/build
