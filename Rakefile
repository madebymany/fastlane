require "bundler/gem_tasks"

GEMS = %w(fastlane danger-device_grid)
RAILS = %w(boarding refresher enhancer)

SECONDS_PER_DAY = 60 * 60 * 24

task :yolo do

  ENV['LOGGING_PROJECT'] = 'fastlane-166414'
  begin
    raise 'SomeError'
  rescue => ex
    require 'json'
    json = {
      'eventTime': Time.now.to_datetime.rfc3339,
      'serviceContext': {
        'service': 'fastlane',
        'version': '1.0'
      },
      'message': "#{ex.message}: #{ex.backtrace.join("\n")}",
    }.to_json
    require 'faraday'

    api_key = 'AIzaSyAMACPfuI-wi4grJWEZjcPvhfV2Rhmddwo'
    connection = Faraday.new(url: "https://clouderrorreporting.googleapis.com/v1beta1/projects/fastlane-166414/events:report?key=#{api_key}")

    response = connection.post do |request|
      request.headers['Content-Type'] = 'application/json'
      request.body = json
    end
  end
end

task :rubygems_admins do
  names = ["KrauseFx", "ohayon", "asfalcone", "mpirri", "mfurtak", "taquitos"]
  (GEMS + ["krausefx-shenzhen", "commander-fastlane"]).each do |gem_name|
    names.each do |name|
      puts `gem owner #{gem_name} -a #{name}`
    end
  end
end

task :test_all do
  formatter = "--format progress"
  formatter += " -r rspec_junit_formatter --format RspecJunitFormatter -o $CIRCLE_TEST_REPORTS/rspec/fastlane-junit-results.xml" if ENV["CIRCLE_TEST_REPORTS"]
  sh "rspec --pattern ./**/*_spec.rb #{formatter}"
end

# Overwrite the default rake task
# since we use fastlane to deploy fastlane
task :push do
  sh "bundle exec fastlane release"
end

#####################################################
# @!group Helper Methods
#####################################################

def box(str)
  l = str.length + 4
  puts ''
  puts '=' * l
  puts '| ' + str + ' |'
  puts '=' * l
end

task default: :test_all
