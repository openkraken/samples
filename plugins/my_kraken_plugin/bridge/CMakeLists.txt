cmake_minimum_required(VERSION 3.2.0)
project(my_kraken_plugin)

set (CMAKE_MODULE_PATH /Users/andycall/work/plugin-build-tools/cmake)
find_package(kraken)

add_library(my_kraken_plugin SHARED
  .kraken-test-tools/my_kraken_plugin.cc
.kraken-test-tools/my_kraken_plugin.h
)

if ($ENV{KRAKEN_JS_ENGINE} MATCHES "jsc")
  set_target_properties(my_kraken_plugin PROPERTIES OUTPUT_NAME my_kraken_plugin_jsc)
endif()

list(APPEND BRIDGE_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(my_kraken_plugin ${BRIDGE_LINK_LIBS} kraken)
target_include_directories(my_kraken_plugin PUBLIC ${BRIDGE_INCLUDE})

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set_target_properties(my_kraken_plugin
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../macos"
        )
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Android")
  set_target_properties(my_kraken_plugin
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../android/jniLibs/${ANDROID_ABI}/"
        )
endif()
  