module FastlaneCore
  class BacktraceSanitizer

    def self.sanitize(type: nil, backtrace: nil)
      if type == :user_error || type == :crash
        # If the crash is from `UI` we only want to include the stack trace
        # up to the point where the crash was initiated.
        # The two stack frames we are dropping are `method_missing` and
        # the call to `crash!` or `user_error!`.
        backtrace.drop(2)
      else
        backtrace
      end
    end

  end
end