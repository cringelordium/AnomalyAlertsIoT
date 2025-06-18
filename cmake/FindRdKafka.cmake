# FindRdKafka.cmake
# Finds the RdKafka library
#
# This will define the following variables:
#
#   RdKafka_FOUND        - True if the system has RdKafka
#   RdKafka_INCLUDE_DIRS - RdKafka include directory
#   RdKafka_LIBRARIES    - RdKafka libraries
#   RdKafka_VERSION      - RdKafka version

find_path(RdKafka_INCLUDE_DIR
    NAMES librdkafka/rdkafka.h
    PATHS /usr/local/include
    NO_DEFAULT_PATH
)

find_library(RdKafka_LIBRARY
    NAMES rdkafka
    PATHS /usr/local/lib
    NO_DEFAULT_PATH
)

find_library(RdKafka++_LIBRARY
    NAMES rdkafka++
    PATHS /usr/local/lib
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RdKafka
    REQUIRED_VARS RdKafka_LIBRARY RdKafka++_LIBRARY RdKafka_INCLUDE_DIR
)

if(RdKafka_FOUND)
    set(RdKafka_LIBRARIES ${RdKafka_LIBRARY} ${RdKafka++_LIBRARY})
    set(RdKafka_INCLUDE_DIRS ${RdKafka_INCLUDE_DIR})
endif()

mark_as_advanced(RdKafka_INCLUDE_DIR RdKafka_LIBRARY RdKafka++_LIBRARY) 