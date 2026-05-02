module Qt6
  # Wraps `QWizard`.
  class Wizard < Dialog
    @current_id_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_id_changed : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a wizard with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_wizard_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Adds a page and returns its assigned page id.
    def add_page(page : WizardPage) : Int32
      id = LibQt6.qt6cr_wizard_add_page(to_unsafe, page.to_unsafe)
      page.adopt_by_parent!
      id
    end

    # Installs a page at an explicit id and returns it.
    def set_page(id : Int, page : WizardPage) : WizardPage
      LibQt6.qt6cr_wizard_set_page(to_unsafe, id.to_i32, page.to_unsafe)
      page.adopt_by_parent!
      page
    end

    # Removes the page for the given id.
    def remove_page(id : Int) : self
      LibQt6.qt6cr_wizard_remove_page(to_unsafe, id.to_i32)
      self
    end

    # Returns the page for the given id, if present.
    def page(id : Int) : WizardPage?
      handle = LibQt6.qt6cr_wizard_page(to_unsafe, id.to_i32)
      handle.null? ? nil : WizardPage.wrap(handle)
    end

    # Returns `true` when the page has already been visited.
    def has_visited_page?(id : Int) : Bool
      LibQt6.qt6cr_wizard_has_visited_page(to_unsafe, id.to_i32)
    end

    # Returns the visited page ids in visit order.
    def visited_ids : Array(Int32)
      Qt6.copy_and_release_ints(LibQt6.qt6cr_wizard_visited_ids(to_unsafe))
    end

    # Returns every registered page id.
    def page_ids : Array(Int32)
      Qt6.copy_and_release_ints(LibQt6.qt6cr_wizard_page_ids(to_unsafe))
    end

    # Returns the start page id.
    def start_id : Int32
      LibQt6.qt6cr_wizard_start_id(to_unsafe)
    end

    # Sets the start page id and returns it.
    def start_id=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_wizard_set_start_id(to_unsafe, int_value)
      int_value
    end

    # Returns the current page widget, if any.
    def current_page : WizardPage?
      handle = LibQt6.qt6cr_wizard_current_page(to_unsafe)
      handle.null? ? nil : WizardPage.wrap(handle)
    end

    # Returns the currently selected page id.
    def current_id : Int32
      LibQt6.qt6cr_wizard_current_id(to_unsafe)
    end

    # Changes the current page id and returns it.
    def current_id=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_wizard_set_current_id(to_unsafe, int_value)
      int_value
    end

    # Returns the current value of a registered wizard field.
    def field(name : String) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_wizard_field(to_unsafe, name.to_unsafe))
    end

    # Replaces the current value of a registered wizard field.
    def set_field(name : String, value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_wizard_set_field(to_unsafe, name.to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    # Navigates backward.
    def back : self
      LibQt6.qt6cr_wizard_back(to_unsafe)
      self
    end

    # Navigates forward.
    def next : self
      LibQt6.qt6cr_wizard_next(to_unsafe)
      self
    end

    # Runs wizard-level validation for the current page.
    def validate_current_page : Bool
      LibQt6.qt6cr_wizard_validate_current_page(to_unsafe)
    end

    # Restarts the wizard from the start page.
    def restart : self
      LibQt6.qt6cr_wizard_restart(to_unsafe)
      self
    end

    # Returns the configured wizard style.
    def wizard_style : WizardStyle
      WizardStyle.from_value(LibQt6.qt6cr_wizard_wizard_style(to_unsafe))
    end

    # Sets the wizard style and returns it.
    def wizard_style=(value : WizardStyle) : WizardStyle
      LibQt6.qt6cr_wizard_set_wizard_style(to_unsafe, value.value)
      value
    end

    # Enables or disables a single wizard option.
    def set_option(option : WizardOption, value : Bool = true) : Bool
      LibQt6.qt6cr_wizard_set_option(to_unsafe, option.value, value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : WizardOption) : Bool
      LibQt6.qt6cr_wizard_test_option(to_unsafe, option.value)
    end

    # Returns the current option flags.
    def options : WizardOption
      WizardOption.from_value(LibQt6.qt6cr_wizard_options(to_unsafe))
    end

    # Replaces the current option flags and returns them.
    def options=(value : WizardOption) : WizardOption
      LibQt6.qt6cr_wizard_set_options(to_unsafe, value.value)
      value
    end

    # Returns the text shown on the given wizard button.
    def button_text(which : WizardButton) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_wizard_button_text(to_unsafe, which.value))
    end

    # Sets the text shown on the given wizard button and returns it.
    def set_button_text(which : WizardButton, value : String) : String
      LibQt6.qt6cr_wizard_set_button_text(to_unsafe, which.value, value.to_unsafe)
      value
    end

    # Returns the underlying wizard button widget, if present.
    def button(which : WizardButton) : AbstractButton?
      handle = LibQt6.qt6cr_wizard_button(to_unsafe, which.value)
      handle.null? ? nil : AbstractButton.wrap(handle)
    end

    # Sets the pixmap for one of the wizard decoration roles.
    def set_pixmap(which : WizardPixmap, pixmap : QPixmap) : QPixmap
      LibQt6.qt6cr_wizard_set_pixmap(to_unsafe, which.value, pixmap.to_unsafe)
      pixmap
    end

    # Returns the pixmap for one of the wizard decoration roles.
    def pixmap(which : WizardPixmap) : QPixmap
      QPixmap.wrap(LibQt6.qt6cr_wizard_pixmap(to_unsafe, which.value), true)
    end

    # Registers a block to run when the current page id changes.
    def on_current_id_changed(&block : Int32 ->) : self
      @current_id_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_id_changed(value : Int32) : Nil
      @current_id_changed.emit(value)
    end

    private def register_callbacks : Nil
      @current_id_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_wizard_on_current_id_changed(to_unsafe, CURRENT_ID_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private CURRENT_ID_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(Wizard).unbox(userdata).emit_current_id_changed(value)
    end
  end
end
