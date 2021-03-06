cmake_minimum_required(VERSION 2.8)

project(hefur C CXX)

enable_testing()

option(HEFUR_CONTROL_INTERFACE "enables Hefur's control interface and hefurctl" ON)

find_package(GnuTLS REQUIRED)

file(STRINGS VERSION HEFUR_VERSION)

message("hefur version: ${HEFUR_VERSION}")
message("control interface: ${HEFUR_CONTROL_INTERFACE}")

add_definitions(
  -std=c++14
  -D_GNU_SOURCE -D_LARGEFILE64_SOURCE
  -Wall -Wextra -Werror=return-type
  -DHEFUR_VERSION=\"${HEFUR_VERSION}\"
  ${GNUTLS_DEFINITIONS})

if(HEFUR_CONTROL_INTERFACE)
  add_definitions(-DHEFUR_CONTROL_INTERFACE)
endif()

include(GNUInstallDirs)

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(RT_LIB "rt")
else()
  set(RT_LIB "")
endif()

add_subdirectory(mimosa EXCLUDE_FROM_ALL)
include_directories(mimosa)
add_subdirectory(hefur)

install(
  DIRECTORY www/
  DESTINATION ${CMAKE_INSTALL_DATADIR}/hefur/www
  PATTERN bootstrap EXCLUDE
  PATTERN *.less EXCLUDE
  PATTERN update-bootstrap.sh EXCLUDE)

install(
  FILES manual/manual.html
  DESTINATION ${CMAKE_INSTALL_DOCDIR}/hefur/)
