# Zone VST Plugin

A simple VST3 distortion plugin, inspired by ZUN's Touhou soundtracks.

## Prerequisites

This project requires the VST3 SDK. Please download it from the Steinberg website. You should have a directory structure like this:

```
your_project_folder/
├── VST_SDK/
│   └── vst3sdk/
└── Zone/
    ├── src/
    └── CMakeLists.txt
```

## Build Instructions

To build this plugin, you will need to have CMake and a C++ compiler installed.

1.  Create a build directory inside the `Zone` folder:
    ```
    cd Zone
    ln -s ../VST_SDK/vst3sdk .
    mkdir build
    cd build
    rm -rf ./*
    rm -rf .cache
    ```

2.  Run CMake to generate the build files. It will automatically find the VST SDK in the parent directory.
    ```
    cmake -DCMAKE_BUILD_TYPE=Debug ..
    ```

3.  Build the plugin:
    ```
    cmake --build .
    ```

4.  The VST3 plugin bundle (`Zone.vst3`) will be created in the `build` directory (inside `build/Debug` or `build/Release` on Windows). You can then copy this bundle to your VST3 plugins folder.

    - On macOS, this is typically `~/Library/Audio/Plug-Ins/VST3`.
    - On Windows, this is typically `C:\Program Files\Common Files\VST3`.

