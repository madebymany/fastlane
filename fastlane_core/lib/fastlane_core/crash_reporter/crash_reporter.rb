require 'faraday'
require 'json'

module FastlaneCore
  class CrashReporter
    STACKDRIVER_API_KEY = 'AIzaSyAMACPfuI-wi4grJWEZjcPvhfV2Rhmddwo'

    TYPES = {
      user_error: '[USER_ERROR]',
      crash: '[FASTLANE_CRASH]',
      connection_failure: '[CONNECTION_FAILURE]',
      system: '[SYSTEM_ERROR]',
      option_parser: '[OPTION_PARSER]',
      invalid_command: '[INVALID_COMMAND]'
    }

    def self.enabled?
      true
    end


    def self.report_crash(type: nil, exception: nil)
      return unless enabled?
      backtrace = BacktraceSanitizer.sanitize(type: type, backtrace: exception.backtrace)
      send_report(message: "#{TYPES[type]}", backtrace: backtrace)
    end

    def self.send_report(message: nil, backtrace: nil)
      json = {
        'eventTime': Time.now.to_datetime.rfc3339,
        'serviceContext': {
          'service': 'fastlane',
          'version': Fastlane::VERSION
        },
        'message': "#{message}: #{backtrace.join("\n")}",
      }.to_json

      connection = Faraday.new(url: "https://clouderrorreporting.googleapis.com/v1beta1/projects/fastlane-166414/events:report?key=#{STACKDRIVER_API_KEY}")

      connection.post do |request|
        request.headers['Content-Type'] = 'application/json'
        request.body = json
      end
    end
  end
end