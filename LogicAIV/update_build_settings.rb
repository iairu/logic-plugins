#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'AIV.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target_names = ['AIVFramework macOS', 'AIVFramework iOS']
targets = project.targets.select { |t| target_names.include?(t.name) }

if targets.empty?
  puts "Warning: No matching targets found."
  exit 1
end

targets.each do |target|
  puts "Updating target: #{target.name}"
  target.build_configurations.each do |config|
    puts "  Configuration: #{config.name}"
    
    paths = config.build_settings['HEADER_SEARCH_PATHS']
    paths = [paths] if paths.is_a?(String)
    paths ||= ['$(inherited)']
    
    new_path = '$(SRCROOT)/Shared/AudioUnit/Support'
    
    unless paths.include?(new_path)
      paths << new_path
      config.build_settings['HEADER_SEARCH_PATHS'] = paths
      puts "    Added #{new_path}"
    else
      puts "    Path already exists."
    end
  end
end

project.save
puts "Build settings updated."
