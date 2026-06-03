module Qt6
  # Base wrapper for owned Qt objects.
  #
  # This class is responsible for deterministic teardown and for surfacing the
  # native `destroyed` signal into Crystal.
  class QObject
    include ManagedResource

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    getter to_unsafe : LibQt6::Handle
    @destroyed_signal : Signal() = Signal().new
    @object_name_changed : Signal(String) = Signal(String).new
    @owned : Bool = false
    @destroyed = false
    @destroyed_userdata : LibQt6::Handle = Pointer(Void).null
    @object_name_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter object_name_changed : Signal(String)

    # Creates a QObject with an optional native parent.
    def initialize(parent : QObject? = nil)
      initialize(LibQt6.qt6cr_object_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(@to_unsafe : LibQt6::Handle, @owned : Bool)
      @destroyed_signal = Signal().new
      @object_name_changed = Signal(String).new
      @destroyed_userdata = Box.box(self.as(QObject))
      @object_name_changed_userdata = Box.box(self.as(QObject))
      LibQt6.qt6cr_object_on_destroyed(@to_unsafe, OBJECT_DESTROYED_TRAMPOLINE, @destroyed_userdata)
      LibQt6.qt6cr_object_on_object_name_changed(@to_unsafe, OBJECT_NAME_CHANGED_TRAMPOLINE, @object_name_changed_userdata)
      Qt6.track_object(self)
    end

    # Explicitly releases the wrapped native object when this wrapper owns it.
    def release : Nil
      return if @destroyed || !@owned

      LibQt6.qt6cr_object_destroy(@to_unsafe)
    end

    # Returns `true` after Qt has destroyed the native object.
    def destroyed? : Bool
      @destroyed
    end

    # Emits when the underlying Qt object is destroyed.
    def destroyed : Signal()
      @destroyed_signal
    end

    # Registers a block to run when the Qt object name changes.
    def on_object_name_changed(&block : String ->) : self
      @object_name_changed.connect { |value| block.call(value) }
      self
    end

    # Returns the Qt object name used for lookup and persisted main-window state.
    def object_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_object_object_name(@to_unsafe))
    end

    # Sets the Qt object name and returns the assigned value.
    def object_name=(value : String) : String
      LibQt6.qt6cr_object_set_object_name(@to_unsafe, value.to_unsafe)
      value
    end

    # Blocks or unblocks this object's signal emissions.
    def block_signals=(value : Bool) : Bool
      LibQt6.qt6cr_object_block_signals(@to_unsafe, value)
    end

    # Returns `true` when signal delivery is currently blocked.
    def signals_blocked? : Bool
      LibQt6.qt6cr_object_signals_blocked(@to_unsafe)
    end

    # Returns this object's native parent, if one is assigned.
    def parent : QObject?
      handle = LibQt6.qt6cr_object_parent(@to_unsafe)
      handle.null? ? nil : QObject.wrap(handle)
    end

    # Reparents this object and returns the assigned parent.
    def parent=(value : QObject?) : QObject?
      LibQt6.qt6cr_object_set_parent(@to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      @owned = false unless value.nil?
      value
    end

    # Qt-style parent setter.
    def set_parent(value : QObject?) : self
      self.parent = value
      self
    end

    # Returns this object's direct children as non-owning QObject wrappers.
    def children : Array(QObject)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_object_children(@to_unsafe)).map do |handle|
        QObject.wrap(handle)
      end
    end

    # Returns the number of direct child QObjects.
    def child_count : Int32
      children.size.to_i32
    end

    # Finds the first child with the given object name.
    def find_child(name : String = "", recursive : Bool = true) : QObject?
      options = recursive ? 0x1 : 0x0
      handle = LibQt6.qt6cr_object_find_child(@to_unsafe, name.to_unsafe, options)
      handle.null? ? nil : QObject.wrap(handle)
    end

    # Finds children with the given object name.
    def find_children(name : String = "", recursive : Bool = true) : Array(QObject)
      options = recursive ? 0x1 : 0x0
      Qt6.copy_and_release_handles(LibQt6.qt6cr_object_find_children(@to_unsafe, name.to_unsafe, options)).map do |handle|
        QObject.wrap(handle)
      end
    end

    # Returns `true` when this object inherits the named Qt class.
    def inherits?(class_name : String) : Bool
      LibQt6.qt6cr_object_inherits(@to_unsafe, class_name.to_unsafe)
    end

    # Returns `true` when this object is a QWidget subclass.
    def widget_type? : Bool
      LibQt6.qt6cr_object_is_widget_type(@to_unsafe)
    end

    # Returns `true` when this object is a QWindow subclass.
    def window_type? : Bool
      LibQt6.qt6cr_object_is_window_type(@to_unsafe)
    end

    # Returns `true` when this object is a Qt Quick item.
    def quick_item_type? : Bool
      LibQt6.qt6cr_object_is_quick_item_type(@to_unsafe)
    end

    # Returns `true` when this object is exposed to QML.
    def qml_exposed? : Bool
      LibQt6.qt6cr_object_is_qml_exposed(@to_unsafe)
    end

    # Returns a dynamic or declared Qt property using the shared ModelData bridge.
    def property(name : String) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_object_property(@to_unsafe, name.to_unsafe))
    end

    # Sets a dynamic or declared Qt property and returns whether Qt accepted it.
    def set_property(name : String, value) : Bool
      LibQt6.qt6cr_object_set_property(@to_unsafe, name.to_unsafe, Qt6.model_data_to_native(value))
    end

    # Removes a dynamic property by setting an invalid QVariant.
    def clear_property(name : String) : Bool
      set_property(name, nil)
    end

    # Returns the names of dynamic properties currently stored on this object.
    def dynamic_property_names : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_object_dynamic_property_names(@to_unsafe))
    end

    # Schedules this object for deletion through Qt's event loop.
    def delete_later : self
      LibQt6.qt6cr_object_delete_later(@to_unsafe)
      self
    end

    # Dumps this object's tree to Qt's debug output.
    def dump_object_tree : self
      LibQt6.qt6cr_object_dump_object_tree(@to_unsafe)
      self
    end

    # Dumps this object's metadata to Qt's debug output.
    def dump_object_info : self
      LibQt6.qt6cr_object_dump_object_info(@to_unsafe)
      self
    end

    # Starts a basic QObject timer and returns its Qt timer id.
    def start_timer(interval : Int, timer_type : TimerType = TimerType::CoarseTimer) : Int32
      LibQt6.qt6cr_object_start_timer(@to_unsafe, interval.to_i32, timer_type.value)
    end

    # Stops a basic QObject timer previously started with `start_timer`.
    def kill_timer(timer_id : Int) : self
      LibQt6.qt6cr_object_kill_timer(@to_unsafe, timer_id.to_i32)
      self
    end

    # Installs an event filter on this object.
    def install_event_filter(filter : EventFilter) : EventFilter
      LibQt6.qt6cr_object_install_event_filter(@to_unsafe, filter.to_unsafe)
      filter
    end

    # Removes an event filter from this object.
    def remove_event_filter(filter : EventFilter) : EventFilter
      LibQt6.qt6cr_object_remove_event_filter(@to_unsafe, filter.to_unsafe)
      filter
    end

    # Qt-style alias for `object_name=`.
    def set_object_name(value : String) : self
      self.object_name = value
      self
    end

    # Marks this object as owned by a native parent so the wrapper stops trying
    # to release it directly.
    def adopt_by_parent! : Nil
      @owned = false
    end

    # Marks this wrapper as responsible for releasing the native object again.
    def assume_ownership! : Nil
      return if @destroyed

      @owned = true
    end

    protected def mark_destroyed_from_qt : Nil
      return if @destroyed

      @destroyed = true
      Qt6.untrack_object(self)
      @destroyed_signal.emit
    end

    protected def emit_object_name_changed(value : UInt8*) : Nil
      @object_name_changed.emit(Qt6.copy_string(value))
    end

    private OBJECT_DESTROYED_TRAMPOLINE = ->(userdata : Void*) do
      Box(QObject).unbox(userdata).mark_destroyed_from_qt
    end

    private OBJECT_NAME_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(QObject).unbox(userdata).emit_object_name_changed(value)
    end
  end
end
