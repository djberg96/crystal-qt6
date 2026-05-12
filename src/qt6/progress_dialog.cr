module Qt6
  # Wraps `QProgressDialog`.
  class ProgressDialog < Dialog
    @canceled : Signal() = Signal().new
    @canceled_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the dialog is canceled.
    getter canceled : Signal()

    # Creates a progress dialog with the usual label, cancel text, and range.
    def initialize(parent : Widget? = nil, label_text : String = "", cancel_button_text : String = "", minimum : Int = 0, maximum : Int = 100)
      initialize(
        LibQt6.qt6cr_progress_dialog_create(
          parent.try(&.to_unsafe) || Pointer(Void).null,
          label_text.to_unsafe,
          cancel_button_text.to_unsafe,
          minimum,
          maximum
        ),
        parent.nil?
      )
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @canceled = Signal().new
      @canceled_userdata = Box.box(self)
      LibQt6.qt6cr_progress_dialog_on_canceled(to_unsafe, CANCELED_TRAMPOLINE, @canceled_userdata)
    end

    # Returns the progress label text.
    def label_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_progress_dialog_label_text(to_unsafe))
    end

    # Sets the progress label text.
    def label_text=(value : String) : String
      LibQt6.qt6cr_progress_dialog_set_label_text(to_unsafe, value.to_unsafe)
      value
    end

    # Sets the cancel button text.
    def cancel_button_text=(value : String) : String
      LibQt6.qt6cr_progress_dialog_set_cancel_button_text(to_unsafe, value.to_unsafe)
      value
    end

    # Replaces the progress label widget.
    def label=(value : Label?) : Label?
      LibQt6.qt6cr_progress_dialog_set_label(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.adopt_by_parent! unless value.nil?
      value
    end

    # Replaces the cancel button widget.
    def cancel_button=(value : PushButton?) : PushButton?
      LibQt6.qt6cr_progress_dialog_set_cancel_button(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.adopt_by_parent! unless value.nil?
      value
    end

    # Replaces the embedded progress bar widget.
    def bar=(value : ProgressBar?) : ProgressBar?
      LibQt6.qt6cr_progress_dialog_set_bar(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.adopt_by_parent! unless value.nil?
      value
    end

    # Returns the minimum progress value.
    def minimum : Int32
      LibQt6.qt6cr_progress_dialog_minimum(to_unsafe)
    end

    # Sets the minimum progress value.
    def minimum=(value : Int) : Int32
      LibQt6.qt6cr_progress_dialog_set_minimum(to_unsafe, value)
      value.to_i32
    end

    # Returns the maximum progress value.
    def maximum : Int32
      LibQt6.qt6cr_progress_dialog_maximum(to_unsafe)
    end

    # Sets the maximum progress value.
    def maximum=(value : Int) : Int32
      LibQt6.qt6cr_progress_dialog_set_maximum(to_unsafe, value)
      value.to_i32
    end

    # Updates the progress range.
    def range=(value : Range(Int, Int)) : self
      LibQt6.qt6cr_progress_dialog_set_range(to_unsafe, value.begin, value.end)
      self
    end

    # Returns the current progress value.
    def value : Int32
      LibQt6.qt6cr_progress_dialog_value(to_unsafe)
    end

    # Sets the current progress value.
    def value=(value : Int) : Int32
      LibQt6.qt6cr_progress_dialog_set_value(to_unsafe, value)
      value.to_i32
    end

    # Returns the preferred dialog size for the current label and controls.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_progress_dialog_size_hint(to_unsafe))
    end

    # Returns whether the dialog closes automatically at completion.
    def auto_close? : Bool
      LibQt6.qt6cr_progress_dialog_auto_close(to_unsafe)
    end

    # Enables or disables automatic closing.
    def auto_close=(value : Bool) : Bool
      LibQt6.qt6cr_progress_dialog_set_auto_close(to_unsafe, value)
      value
    end

    # Returns whether the dialog resets itself automatically.
    def auto_reset? : Bool
      LibQt6.qt6cr_progress_dialog_auto_reset(to_unsafe)
    end

    # Enables or disables automatic reset.
    def auto_reset=(value : Bool) : Bool
      LibQt6.qt6cr_progress_dialog_set_auto_reset(to_unsafe, value)
      value
    end

    # Returns the minimum time in milliseconds before the dialog appears.
    def minimum_duration : Int32
      LibQt6.qt6cr_progress_dialog_minimum_duration(to_unsafe)
    end

    # Sets the minimum show delay in milliseconds.
    def minimum_duration=(value : Int) : Int32
      LibQt6.qt6cr_progress_dialog_set_minimum_duration(to_unsafe, value)
      value.to_i32
    end

    # Returns `true` after the user cancels the dialog.
    def was_canceled? : Bool
      LibQt6.qt6cr_progress_dialog_was_canceled(to_unsafe)
    end

    # Cancels the dialog.
    def cancel : self
      LibQt6.qt6cr_progress_dialog_cancel(to_unsafe)
      self
    end

    # Resets the dialog state.
    def reset : self
      LibQt6.qt6cr_progress_dialog_reset(to_unsafe)
      self
    end

    # Qt-style alias for `label_text=`.
    def set_label_text(value : String) : self
      self.label_text = value
      self
    end

    # Qt-style alias for `cancel_button_text=`.
    def set_cancel_button_text(value : String) : self
      self.cancel_button_text = value
      self
    end

    # Qt-style alias for `label=`.
    def set_label(value : Label?) : self
      self.label = value
      self
    end

    # Qt-style alias for `cancel_button=`.
    def set_cancel_button(value : PushButton?) : self
      self.cancel_button = value
      self
    end

    # Qt-style alias for `bar=`.
    def set_bar(value : ProgressBar?) : self
      self.bar = value
      self
    end

    # Qt-style alias for `minimum=`.
    def set_minimum(value : Int) : self
      self.minimum = value
      self
    end

    # Qt-style alias for `maximum=`.
    def set_maximum(value : Int) : self
      self.maximum = value
      self
    end

    # Qt-style alias for `range=`.
    def set_range(minimum : Int, maximum : Int) : self
      self.range = minimum..maximum
      self
    end

    # Qt-style alias for `value=`.
    def set_value(value : Int) : self
      self.value = value
      self
    end

    # Qt-style alias for `auto_close=`.
    def set_auto_close(value : Bool) : self
      self.auto_close = value
      self
    end

    # Qt-style alias for `auto_reset=`.
    def set_auto_reset(value : Bool) : self
      self.auto_reset = value
      self
    end

    # Qt-style alias for `minimum_duration=`.
    def set_minimum_duration(value : Int) : self
      self.minimum_duration = value
      self
    end

    # Registers a block to run when the dialog is canceled.
    def on_canceled(&block : ->) : self
      @canceled.connect { block.call }
      self
    end

    protected def emit_canceled : Nil
      @canceled.emit
    end

    private CANCELED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ProgressDialog).unbox(userdata).emit_canceled
    end
  end
end
