module Qt6
  # Wraps `QProcess` for event-loop-aware child-process execution.
  class QProcess < QObject
    include IODeviceMethods

    @started : Signal() = Signal().new
    @finished : Signal(Int32, ProcessExitStatus) = Signal(Int32, ProcessExitStatus).new
    @error_occurred : Signal(ProcessError) = Signal(ProcessError).new
    @state_changed : Signal(ProcessState) = Signal(ProcessState).new
    @ready_read_standard_output : Signal() = Signal().new
    @ready_read_standard_error : Signal() = Signal().new
    @process_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter started : Signal()
    getter finished : Signal(Int32, ProcessExitStatus)
    getter error_occurred : Signal(ProcessError)
    getter state_changed : Signal(ProcessState)
    getter ready_read_standard_output : Signal()
    getter ready_read_standard_error : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.execute(program : String, arguments : Enumerable(String) = [] of String) : Int32
      with_string_pointers(arguments) do |pointers, count|
        LibQt6.qt6cr_process_execute(program.to_unsafe, pointers, count)
      end
    end

    def self.start_detached(program : String, arguments : Enumerable(String) = [] of String, working_directory : String = "") : ProcessStartResult
      with_string_pointers(arguments) do |pointers, count|
        ProcessStartResult.from_native(LibQt6.qt6cr_process_start_detached(program.to_unsafe, pointers, count, working_directory.to_unsafe))
      end
    end

    def self.split_command(command : String) : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_process_split_command(command.to_unsafe))
    end

    def self.system_environment : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_process_system_environment)
    end

    def self.null_device : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_process_null_device)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_process_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_process_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_process_callbacks
    end

    def start(program : String, arguments : Enumerable(String) = [] of String, mode : IODeviceOpenMode = IODeviceOpenMode::ReadWrite) : self
      QProcess.with_string_pointers(arguments) do |pointers, count|
        LibQt6.qt6cr_process_start(to_unsafe, program.to_unsafe, pointers, count, mode.value)
      end
      self
    end

    def start(mode : IODeviceOpenMode = IODeviceOpenMode::ReadWrite) : self
      LibQt6.qt6cr_process_start_configured(to_unsafe, mode.value)
      self
    end

    def start_command(command : String, mode : IODeviceOpenMode = IODeviceOpenMode::ReadWrite) : self
      LibQt6.qt6cr_process_start_command(to_unsafe, command.to_unsafe, mode.value)
      self
    end

    def start_detached : ProcessStartResult
      ProcessStartResult.from_native(LibQt6.qt6cr_process_start_detached_instance(to_unsafe))
    end

    def terminate : self
      LibQt6.qt6cr_process_terminate(to_unsafe)
      self
    end

    def kill : self
      LibQt6.qt6cr_process_kill(to_unsafe)
      self
    end

    def wait_for_started(msecs : Int = 30_000) : Bool
      LibQt6.qt6cr_process_wait_for_started(to_unsafe, msecs.to_i32)
    end

    def wait_for_finished(msecs : Int = 30_000) : Bool
      LibQt6.qt6cr_process_wait_for_finished(to_unsafe, msecs.to_i32)
    end

    def wait_for_ready_read(msecs : Int = 30_000) : Bool
      LibQt6.qt6cr_process_wait_for_ready_read(to_unsafe, msecs.to_i32)
    end

    def wait_for_bytes_written(msecs : Int = 30_000) : Bool
      LibQt6.qt6cr_process_wait_for_bytes_written(to_unsafe, msecs.to_i32)
    end

    def program : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_process_program(to_unsafe))
    end

    def program=(value : String) : String
      LibQt6.qt6cr_process_set_program(to_unsafe, value.to_unsafe)
      value
    end

    def arguments : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_process_arguments(to_unsafe))
    end

    def arguments=(values : Enumerable(String)) : Array(String)
      set_arguments(values)
      values.to_a
    end

    def set_arguments(values : Enumerable(String)) : self
      QProcess.with_string_pointers(values) do |pointers, count|
        LibQt6.qt6cr_process_set_arguments(to_unsafe, pointers, count)
      end
      self
    end

    def working_directory : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_process_working_directory(to_unsafe))
    end

    def working_directory=(value : String) : String
      LibQt6.qt6cr_process_set_working_directory(to_unsafe, value.to_unsafe)
      value
    end

    def process_id : Int64
      LibQt6.qt6cr_process_process_id(to_unsafe)
    end

    def state : ProcessState
      ProcessState.from_value(LibQt6.qt6cr_process_state(to_unsafe))
    end

    def error : ProcessError
      ProcessError.from_value(LibQt6.qt6cr_process_error(to_unsafe))
    end

    def exit_code : Int32
      LibQt6.qt6cr_process_exit_code(to_unsafe)
    end

    def exit_status : ProcessExitStatus
      ProcessExitStatus.from_value(LibQt6.qt6cr_process_exit_status(to_unsafe))
    end

    def read_all_standard_output : QByteArray
      QByteArray.new(Qt6.copy_and_release_bytes(LibQt6.qt6cr_process_read_all_standard_output(to_unsafe)))
    end

    def read_all_standard_error : QByteArray
      QByteArray.new(Qt6.copy_and_release_bytes(LibQt6.qt6cr_process_read_all_standard_error(to_unsafe)))
    end

    def read_channel : ProcessChannel
      ProcessChannel.from_value(LibQt6.qt6cr_process_read_channel(to_unsafe))
    end

    def read_channel=(value : ProcessChannel) : ProcessChannel
      LibQt6.qt6cr_process_set_read_channel(to_unsafe, value.value)
      value
    end

    def process_channel_mode : ProcessChannelMode
      ProcessChannelMode.from_value(LibQt6.qt6cr_process_process_channel_mode(to_unsafe))
    end

    def process_channel_mode=(value : ProcessChannelMode) : ProcessChannelMode
      LibQt6.qt6cr_process_set_process_channel_mode(to_unsafe, value.value)
      value
    end

    def input_channel_mode : ProcessInputChannelMode
      ProcessInputChannelMode.from_value(LibQt6.qt6cr_process_input_channel_mode(to_unsafe))
    end

    def input_channel_mode=(value : ProcessInputChannelMode) : ProcessInputChannelMode
      LibQt6.qt6cr_process_set_input_channel_mode(to_unsafe, value.value)
      value
    end

    def close_read_channel(channel : ProcessChannel) : self
      LibQt6.qt6cr_process_close_read_channel(to_unsafe, channel.value)
      self
    end

    def close_write_channel : self
      LibQt6.qt6cr_process_close_write_channel(to_unsafe)
      self
    end

    def set_standard_input_file(file_name : String) : self
      LibQt6.qt6cr_process_set_standard_input_file(to_unsafe, file_name.to_unsafe)
      self
    end

    def set_standard_output_file(file_name : String, mode : IODeviceOpenMode = IODeviceOpenMode::Truncate) : self
      LibQt6.qt6cr_process_set_standard_output_file(to_unsafe, file_name.to_unsafe, mode.value)
      self
    end

    def set_standard_error_file(file_name : String, mode : IODeviceOpenMode = IODeviceOpenMode::Truncate) : self
      LibQt6.qt6cr_process_set_standard_error_file(to_unsafe, file_name.to_unsafe, mode.value)
      self
    end

    def set_standard_output_process(destination : QProcess) : self
      LibQt6.qt6cr_process_set_standard_output_process(to_unsafe, destination.to_unsafe)
      self
    end

    def process_environment : QProcessEnvironment
      QProcessEnvironment.wrap(LibQt6.qt6cr_process_environment(to_unsafe), true)
    end

    def process_environment=(value : QProcessEnvironment) : QProcessEnvironment
      LibQt6.qt6cr_process_set_process_environment(to_unsafe, value.to_unsafe)
      value
    end

    def environment : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_process_environment_strings(to_unsafe))
    end

    def environment=(values : Enumerable(String)) : Array(String)
      strings = values.to_a
      QProcess.with_string_pointers(strings) do |pointers, count|
        LibQt6.qt6cr_process_set_environment_strings(to_unsafe, pointers, count)
      end
      strings
    end

    def on_started(&block : ->) : self
      @started.connect { block.call }
      self
    end

    def on_finished(&block : Int32, ProcessExitStatus ->) : self
      @finished.connect { |exit_code, exit_status| block.call(exit_code, exit_status) }
      self
    end

    def on_error_occurred(&block : ProcessError ->) : self
      @error_occurred.connect { |error| block.call(error) }
      self
    end

    def on_state_changed(&block : ProcessState ->) : self
      @state_changed.connect { |state| block.call(state) }
      self
    end

    def on_ready_read_standard_output(&block : ->) : self
      @ready_read_standard_output.connect { block.call }
      self
    end

    def on_ready_read_standard_error(&block : ->) : self
      @ready_read_standard_error.connect { block.call }
      self
    end

    def self.with_string_pointers(values : Enumerable(String), &)
      strings = values.to_a.map(&.to_s)
      pointers = strings.map(&.to_unsafe)
      pointer = pointers.empty? ? Pointer(UInt8*).null : pointers.to_unsafe
      yield pointer, pointers.size.to_i32
    end

    protected def emit_started : Nil
      @started.emit
    end

    protected def emit_finished(exit_code : Int32, exit_status : Int32) : Nil
      @finished.emit(exit_code, ProcessExitStatus.from_value(exit_status))
    end

    protected def emit_error_occurred(error : Int32) : Nil
      @error_occurred.emit(ProcessError.from_value(error))
    end

    protected def emit_state_changed(state : Int32) : Nil
      @state_changed.emit(ProcessState.from_value(state))
    end

    protected def emit_ready_read_standard_output : Nil
      @ready_read_standard_output.emit
    end

    protected def emit_ready_read_standard_error : Nil
      @ready_read_standard_error.emit
    end

    private def register_process_callbacks : Nil
      @started = Signal().new
      @finished = Signal(Int32, ProcessExitStatus).new
      @error_occurred = Signal(ProcessError).new
      @state_changed = Signal(ProcessState).new
      @ready_read_standard_output = Signal().new
      @ready_read_standard_error = Signal().new
      @process_callback_userdata = Box.box(self.as(QProcess))
      LibQt6.qt6cr_process_on_started(to_unsafe, STARTED_TRAMPOLINE, @process_callback_userdata)
      LibQt6.qt6cr_process_on_finished(to_unsafe, FINISHED_TRAMPOLINE, @process_callback_userdata)
      LibQt6.qt6cr_process_on_error_occurred(to_unsafe, ERROR_OCCURRED_TRAMPOLINE, @process_callback_userdata)
      LibQt6.qt6cr_process_on_state_changed(to_unsafe, STATE_CHANGED_TRAMPOLINE, @process_callback_userdata)
      LibQt6.qt6cr_process_on_ready_read_standard_output(to_unsafe, READY_READ_STANDARD_OUTPUT_TRAMPOLINE, @process_callback_userdata)
      LibQt6.qt6cr_process_on_ready_read_standard_error(to_unsafe, READY_READ_STANDARD_ERROR_TRAMPOLINE, @process_callback_userdata)
    end

    private STARTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(QProcess).unbox(userdata).emit_started
    end

    private FINISHED_TRAMPOLINE = ->(userdata : Void*, exit_code : Int32, exit_status : Int32) do
      Box(QProcess).unbox(userdata).emit_finished(exit_code, exit_status)
    end

    private ERROR_OCCURRED_TRAMPOLINE = ->(userdata : Void*, error : Int32) do
      Box(QProcess).unbox(userdata).emit_error_occurred(error)
    end

    private STATE_CHANGED_TRAMPOLINE = ->(userdata : Void*, state : Int32) do
      Box(QProcess).unbox(userdata).emit_state_changed(state)
    end

    private READY_READ_STANDARD_OUTPUT_TRAMPOLINE = ->(userdata : Void*) do
      Box(QProcess).unbox(userdata).emit_ready_read_standard_output
    end

    private READY_READ_STANDARD_ERROR_TRAMPOLINE = ->(userdata : Void*) do
      Box(QProcess).unbox(userdata).emit_ready_read_standard_error
    end
  end
end
