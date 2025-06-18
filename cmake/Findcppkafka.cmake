# Findcppkafka.cmake
# Finds the cppkafka library
#
# This will define the following variables:
#
#   cppkafka_FOUND        - True if the system has cppkafka
#   cppkafka_INCLUDE_DIRS - cppkafka include directory
#   cppkafka_LIBRARIES    - cppkafka libraries

find_path(cppkafka_INCLUDE_DIR
    NAMES cppkafka/cppkafka.h
    PATHS /usr/local/include
    NO_DEFAULT_PATH
)

find_library(cppkafka_LIBRARY
    NAMES cppkafka
    PATHS /usr/local/lib
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(cppkafka
    REQUIRED_VARS cppkafka_LIBRARY cppkafka_INCLUDE_DIR
)

if(cppkafka_FOUND)
    set(cppkafka_LIBRARIES ${cppkafka_LIBRARY})
    set(cppkafka_INCLUDE_DIRS ${cppkafka_INCLUDE_DIR})
endif()

mark_as_advanced(cppkafka_INCLUDE_DIR cppkafka_LIBRARY) 