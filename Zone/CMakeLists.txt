cmake_minimum_required(VERSION 3.15)
project(Zone)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Ensure Objective-C++ is enabled for macOS bundle targets
if(APPLE)
    enable_language(OBJCXX)
    set(CMAKE_OBJCXX_STANDARD 20)
    set(CMAKE_OBJCXX_STANDARD_REQUIRED ON)
endif()

# VST3 SDK options
set(SMTG_ADD_VST3_PLUGINS_EXAMPLES OFF CACHE BOOL "")
set(SMTG_ADD_VST3_HOSTING_SAMPLES OFF CACHE BOOL "")
set(SMTG_CREATE_BUNDLE_FOR_WINDOWS OFF CACHE BOOL "")
set(SMTG_CREATE_PLUGIN_LINK OFF CACHE BOOL "")
set(SMTG_ENABLE_AU_WRAPPER OFF CACHE BOOL "")
set(SMTG_ENABLE_AAX_WRAPPER OFF CACHE BOOL "")

# Find and add VST3 SDK
add_subdirectory(vst3sdk)

add_definitions(-DDEVELOPMENT)


# Find the VST3 SDK main target
# The VST3 SDK does not always create a Steinberg::VstSdk target.
# Instead, link to 'sdk' which is the main VST3 SDK target.
# If you want to be robust, check if Steinberg::VstSdk exists, otherwise use sdk.

# Source files
add_library(zone MODULE
    src/Processor.cpp
    src/Controller.cpp
    src/Entry.cpp
)

target_include_directories(zone PRIVATE
    src
)

# Try to link to Steinberg::VstSdk, fallback to sdk if not found
if(TARGET Steinberg::VstSdk)
    target_link_libraries(zone PRIVATE Steinberg::VstSdk)
elseif(TARGET sdk)
    target_link_libraries(zone PRIVATE sdk)
else()
    message(FATAL_ERROR "Neither Steinberg::VstSdk nor sdk target found in vst3sdk. Please check your VST3 SDK setup.")
endif()

# VST3-specific properties
set_target_properties(zone PROPERTIES
    FRAMEWORK TRUE
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_NAME "Zone"
    MACOSX_BUNDLE_EXTENSION "vst3"
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.zone.vst3"
    MACOSX_BUNDLE_ICON_FILE "Icon.icns"
    MACOSX_BUNDLE_INFO_PLIST "Info.plist"
)

# Create the VST3 bundle directory structure
add_custom_target(ZoneVST3 ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory
            "${CMAKE_BINARY_DIR}/Zone.vst3/Contents/MacOS"
    COMMAND ${CMAKE_COMMAND} -E copy
            "$<TARGET_FILE:zone>"
            "${CMAKE_BINARY_DIR}/Zone.vst3/Contents/MacOS/"
    DEPENDS zone
)
