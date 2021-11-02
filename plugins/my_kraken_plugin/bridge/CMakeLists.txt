cmake_minimum_required(VERSION 3.2.0)
project(my_kraken_plugin)
set(CMAKE_CXX_STANDARD 17)

add_library(kraken SHARED IMPORTED)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set_target_properties(kraken PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/kraken/lib/macos/libkraken.dylib")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "iOS")
  if(${PLATFORM} MATCHES "SIMULATOR64")
    set_target_properties(kraken PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/kraken/lib/ios/kraken_bridge.xcframework/ios-x86_64-simulator/kraken_bridge.framework/kraken_bridge")
  else()
    set_target_properties(kraken PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/kraken/lib/ios/kraken_bridge.xcframework/ios-arm64_armv7_armv7s/kraken_bridge.framework/kraken_bridge")
  endif()
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Android")
  set_target_properties(kraken PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/kraken/lib/android/jniLibs/${ANDROID_ABI}/libkraken.so")
endif()

add_library(my_kraken_plugin SHARED
  .kraken-test-tools/my_kraken_plugin.cc
.kraken-test-tools/my_kraken_plugin.h
)

list(APPEND BRIDGE_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(my_kraken_plugin ${BRIDGE_LINK_LIBS} kraken)
target_include_directories(my_kraken_plugin PUBLIC ${BRIDGE_INCLUDE})

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set_target_properties(my_kraken_plugin
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../bridge/build/macos"
        )
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Android")
  set_target_properties(my_kraken_plugin
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../bridge/build/android/${ANDROID_ABI}/"
        )
endif()

if (${CMAKE_SYSTEM_NAME} MATCHES "iOS")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "")

  set_target_properties(my_kraken_plugin PROPERTIES
          OUTPUT_NAME my_kraken_plugin
          FRAMEWORK TRUE
          FRAMEWORK_VERSION C
          MACOSX_FRAMEWORK_IDENTIFIER com.openkraken.plugins.my_kraken_plugin
          )
endif()
  