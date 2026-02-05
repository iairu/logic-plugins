#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'AIV.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target_names = ['AIVFramework macOS', 'AIVFramework iOS']
targets = project.targets.select { |t| target_names.include?(t.name) }

targets.each do |target|
  puts "Updating target: #{target.name}"
  target.build_configurations.each do |config|
    config.build_settings.delete('SWIFT_OBJC_BRIDGING_HEADER')
    puts "  Removed SWIFT_OBJC_BRIDGING_HEADER for #{config.name}"
  end
end

project.save
puts "Build settings updated."
