module Qt6
  # Wraps `QWizardPage`.
  class WizardPage < Widget
    @complete_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter complete_changed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a wizard page with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_wizard_page_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Returns the page title.
    def title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_wizard_page_title(to_unsafe))
    end

    # Sets the page title and returns it.
    def title=(value : String) : String
      LibQt6.qt6cr_wizard_page_set_title(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the page subtitle.
    def sub_title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_wizard_page_sub_title(to_unsafe))
    end

    # Sets the page subtitle and returns it.
    def sub_title=(value : String) : String
      LibQt6.qt6cr_wizard_page_set_sub_title(to_unsafe, value.to_unsafe)
      value
    end

    # Sets the pixmap for one of the page decoration roles.
    def set_pixmap(which : WizardPixmap, pixmap : QPixmap) : QPixmap
      LibQt6.qt6cr_wizard_page_set_pixmap(to_unsafe, which.value, pixmap.to_unsafe)
      pixmap
    end

    # Returns the pixmap for one of the page decoration roles.
    def pixmap(which : WizardPixmap) : QPixmap
      QPixmap.wrap(LibQt6.qt6cr_wizard_page_pixmap(to_unsafe, which.value), true)
    end

    # Returns `true` when this page finishes the wizard.
    def final_page? : Bool
      LibQt6.qt6cr_wizard_page_is_final_page(to_unsafe)
    end

    # Marks the page as final or non-final.
    def final_page=(value : Bool) : Bool
      LibQt6.qt6cr_wizard_page_set_final_page(to_unsafe, value)
      value
    end

    # Returns `true` when this page acts as a commit page.
    def commit_page? : Bool
      LibQt6.qt6cr_wizard_page_is_commit_page(to_unsafe)
    end

    # Marks the page as a commit page or not.
    def commit_page=(value : Bool) : Bool
      LibQt6.qt6cr_wizard_page_set_commit_page(to_unsafe, value)
      value
    end

    # Returns the owning wizard, if this page is currently installed in one.
    def wizard : Wizard?
      handle = LibQt6.qt6cr_wizard_page_wizard(to_unsafe)
      handle.null? ? nil : Wizard.wrap(handle)
    end

    # Returns the current value of a registered wizard field.
    def field(name : String) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_wizard_page_field(to_unsafe, name.to_unsafe))
    end

    # Replaces the current value of a registered wizard field.
    def set_field(name : String, value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_wizard_page_set_field(to_unsafe, name.to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    # Sets per-page button text and returns it.
    def set_button_text(which : WizardButton, value : String) : String
      LibQt6.qt6cr_wizard_page_set_button_text(to_unsafe, which.value, value.to_unsafe)
      value
    end

    # Returns the page-local button text override for the given button.
    def button_text(which : WizardButton) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_wizard_page_button_text(to_unsafe, which.value))
    end

    # Returns `true` when the page currently considers itself complete.
    def complete? : Bool
      LibQt6.qt6cr_wizard_page_is_complete(to_unsafe)
    end

    # Runs page validation.
    def validate_page : Bool
      LibQt6.qt6cr_wizard_page_validate_page(to_unsafe)
    end

    # Returns the next page id according to the current page logic.
    def next_id : Int32
      LibQt6.qt6cr_wizard_page_next_id(to_unsafe)
    end

    # Registers a wizard field using Qt's default property and changed signal for the widget type.
    def register_field(name : String, widget : Widget) : Widget
      LibQt6.qt6cr_wizard_page_register_field(to_unsafe, name.to_unsafe, widget.to_unsafe)
      widget
    end

    # Registers a wizard field using an explicit property and changed signal for the widget type.
    def register_field(name : String, widget : Widget, property : String, changed_signal : String) : Widget
      LibQt6.qt6cr_wizard_page_register_field_with_property(
        to_unsafe,
        name.to_unsafe,
        widget.to_unsafe,
        property.to_unsafe,
        changed_signal.to_unsafe
      )
      widget
    end

    # Registers a block to run when the page completeness changes.
    def on_complete_changed(&block : ->) : self
      @complete_changed.connect { block.call }
      self
    end

    protected def emit_complete_changed : Nil
      @complete_changed.emit
    end

    private def register_callbacks : Nil
      @complete_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_wizard_page_on_complete_changed(to_unsafe, COMPLETE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private COMPLETE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(WizardPage).unbox(userdata).emit_complete_changed
    end
  end
end
