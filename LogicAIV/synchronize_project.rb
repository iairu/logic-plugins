#!/usr/bin/env ruby
require 'xcodeproj'

# This script synchronizes the Xcode project with the file system for the AIV project.
# It ensures all Swift files in the 'Shared' directory are added to the Framework and Extension targets.

project_path = 'AIV.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target_names = [
  'AIVFramework macOS', 
  'AIVExtension macOS', 
  'AIVFramework iOS', 
  'AIVExtension iOS'
]

targets = project.targets.select { |t| target_names.include?(t.name) }

if targets.empty?
  puts "Warning: No matching targets found from list: #{target_names}"
  puts "Available targets: #{project.targets.map(&:name)}"
  exit 1
end

puts "Found targets: #{targets.map(&:name).join(', ')}"

# Ensure Shared group exists
shared_group = project.main_group['Shared']
unless shared_group
  puts "Creating 'Shared' group..."
  shared_group = project.main_group.new_group('Shared', 'Shared')
end

# --- Cleanup Step ---
# Remove references to files that do not exist on disk
puts "Checking for missing files..."
shared_group.recursive_children.each do |child|
  next unless child.is_a?(Xcodeproj::Project::Object::PBXFileReference)
  
  unless File.exist?(child.real_path)
    puts "Removing missing file reference: #{child.path}"
    child.remove_from_project
    # Also remove from targets
    targets.each do |target|
      target.source_build_phase.remove_file_reference(child)
    end
  end
end
# --------------------

# Find all Swift files in Shared directory
files = Dir.glob('Shared/**/*.swift')

files.each do |file_path|
  # 1. Add file to project (creates file reference if needed)
  # We need to respect the directory structure in the project groups
  
  # split path into components, ignoring 'Shared' prefix as that matches the group
  relative_path = Pathname.new(file_path).relative_path_from(Pathname.new('Shared'))
  components = relative_path.to_s.split(File::SEPARATOR)
  filename = components.pop
  
  # Navigate/Create groups
  current_group = shared_group
  components.each do |dir|
    next_group = current_group[dir]
    unless next_group
      next_group = current_group.new_group(dir, dir)
    end
    
    # Ensure path is set if it was missing (e.g. from previous bad run)
    if next_group.path.nil? || next_group.path.empty?
        next_group.set_path(dir)
    end
    
    current_group = next_group
  end
  
  # Create file reference in the correct group
  # Xcodeproj's new_file automatically handles checking if it exists in that group
  file_ref = current_group.new_file(filename) 
  
  # 2. Add to targets
  targets.each do |target|
    # Check if file is already in compile sources
    unless target.source_build_phase.files_references.include?(file_ref)
      target.add_file_references([file_ref])
      puts "Added #{file_path} to #{target.name}"
    end
  end
end

project.save
puts "Project synchronization complete."
