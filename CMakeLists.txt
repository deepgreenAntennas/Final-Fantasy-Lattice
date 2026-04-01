cmake_minimum_required(VERSION 3.16)
project(MainLatticeProject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

# 1. Target Name is MainLattice
add_executable(MainLattice main.cpp)

# 2. iPhone 13 Specific Settings
set_target_properties(MainLattice PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.NathanFox.MainLattice"
    MACOSX_BUNDLE_BUNDLE_NAME "MainLattice"
    
    XCODE_ATTRIBUTE_SWIFT_VERSION "5.0"
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "15.0" # iPhone 13 shipped with iOS 15
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "D5QS7UXDVT"
    XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Automatic"
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1" # 1 = iPhone
)

# 3. Link your SDL2 iOS library
target_link_libraries(MainLattice PRIVATE 
    "${CMAKE_CURRENT_SOURCE_DIR}/SDL_Build/SDL2-2.30.11/build_ios/Release-iphoneos/libSDL2.a"
     "-framework UIKit"
    "-framework Foundation"
    "-framework CoreGraphics"
    "-framework QuartzCore"
    "-framework Metal"
    "-framework AudioToolbox"
    "-framework AVFoundation"
    "-framework CoreAudio"
    "-framework CoreMotion"
    "-framework GameController"
)