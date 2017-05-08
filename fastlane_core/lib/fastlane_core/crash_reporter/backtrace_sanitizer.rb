module FastlaneCore
  class BacktraceSanitizer

    def self.sanitize(type: nil, backtrace: nil)
      if type == :user_error || type == :crash
        # If the crash is from `UI` we only want to include the stack trace
        # up to the point where the crash was initiated.
        # The two stack frames we are dropping are `method_missing` and
        # the call to `crash!` or `user_error!`.
        stack = backtrace.drop(2)
      else
        stack = backtrace
      end

      stack = remove_fastlane_gem_path(backtrace: stack)
      stack = remove_gem_home_path(backtrace: stack)
      stack = remove_home_dir_mentions(backtrace: stack)
    end

    def self.remove_fastlane_gem_path(backtrace: nil)
      fastlane_path = Gem.loaded_specs['fastlane'].full_gem_path
      backtrace.map do |frame|
        if frame.include?(fastlane_path)
          frame.gsub!(fastlane_path, '')
        end
        frame
      end
    end

    def self.remove_gem_home_path(backtrace: nil)
      backtrace.map do |frame|
        if frame.include?(ENV['GEM_HOME'])
          frame.gsub!(ENV['GEM_HOME'], 'GEM_HOME')
        end
        frame
      end
    end

    def self.remove_home_dir_mentions(backtrace: nil)
      backtrace.map do |frame|
        if frame.include?(Dir.home)
          frame.gsub!(Dir.home, '~')
        end
        frame
      end
    end

  end
end