require "spec"
require "../src/qt6"
require "./support/qt6_spec_support"

def app
  Qt6.application(["crystal-qt6-spec"])
end
