QT_PKG ?= Qt6Widgets Qt6Svg Qt6SvgWidgets
PKG_CONFIG ?= pkg-config
CXX ?= c++
AR ?= ar

BUILD_SCRIPT := scripts/build_qt6cr.sh

.PHONY: native spec example-hello example-counter example-shell example-slice example-events example-render example-svg example-inspector clean

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

example-slice:
	crystal run examples/editor_vertical_slice.cr

example-events:
	crystal run examples/event_monitor.cr

example-render:
	crystal run examples/rendering_stack.cr

example-svg:
	crystal run examples/svg_widget_renderer.cr

example-inspector:
	crystal run examples/inspector_workbench.cr

clean:
	rm -rf ext/qt6cr/build
