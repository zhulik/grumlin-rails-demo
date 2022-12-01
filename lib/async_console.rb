# frozen_string_literal: true

class AsyncConsole
  extend Grumlin::Repository

  def start
    IRB::WorkSpace.prepend(Rails::Console::BacktraceCleaner)
    IRB::ExtendCommandBundle.include(Rails::ConsoleMethods)

    IRB.setup(binding.source_location[0], argv: [])
    workspace = IRB::WorkSpace.new(binding)

    run(workspace)
  end

  def inspect
    "main"
  end

  def to_s
    inspect
  end

  private

  def run(workspace)
    Async do
      IRB::Irb.new(workspace).run(IRB.conf)
    ensure
      Grumlin.close
    end
  rescue StandardError, Interrupt, Async::Stop, IRB::Abort
    retry
  end
end
