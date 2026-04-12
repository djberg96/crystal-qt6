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
