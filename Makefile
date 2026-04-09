QT_PKG ?= Qt6Widgets Qt6Svg
PKG_CONFIG ?= pkg-config
CXX ?= c++
AR ?= ar

BUILD_SCRIPT := scripts/build_qt6cr.sh

.PHONY: native spec example-hello example-counter example-shell example-events example-render clean

native:
	QT_PKG='$(QT_PKG)' PKG_CONFIG=$(PKG_CONFIG) CXX=$(CXX) AR=$(AR) CXXFLAGS='$(CXXFLAGS)' sh $(BUILD_SCRIPT)

spec:
	crystal spec

example-hello:
	crystal run examples/hello_world.cr

example-counter:
	crystal run examples/counter.cr

example-shell:
	crystal run examples/editor_shell.cr

example-events:
	crystal run examples/event_monitor.cr

example-render:
	crystal run examples/rendering_stack.cr

clean:
	rm -rf ext/qt6cr/build
