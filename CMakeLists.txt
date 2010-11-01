INCLUDE(${QT_USE_FILE})
INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR})
# Project name. Should be the same as the project directory name and
# will become the name of the binary target.
SET( PROJECT_NAME "GambitDemo")

QT4_WRAP_UI(UI_SOURCE
  GambitUI.ui
)
QT4_WRAP_CPP(MOC_SOURCE
  GambitUI.h
)


SET(GAMBITC "${OE_LIB_DIR}/gambit/bin/gsc")
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D___LIBRARY")
#SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D___LIBRARY")
ADD_DEFINITIONS(-D___LIBRARY -w)

ADD_CUSTOM_COMMAND(
  OUTPUT  objects.cpp objects_.cpp
  DEPENDS objects.scm
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/objects.scm objects.scm
  COMMAND ${GAMBITC} -track-scheme -link -l ${GAMBIT_LIB_DIR}/_gambc objects
  COMMAND mv objects.c objects.cpp
  COMMAND cp objects_.c objects_.cpp
)

ADD_LIBRARY(objects
  objects.cpp
  objects_.cpp
)

TARGET_LINK_LIBRARIES(objects Extensions_GambitScheme)

ADD_CUSTOM_COMMAND(
  OUTPUT  simple.cpp simple_.cpp
  DEPENDS simple.scm objects_.cpp
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/simple.scm simple.scm
  COMMAND ${GAMBITC} -link -l objects_ simple.scm
  COMMAND mv simple.c simple.cpp
  COMMAND cp simple_.c simple_.cpp
)

ADD_LIBRARY(simple
  simple.cpp
  simple_.cpp
)

TARGET_LINK_LIBRARIES(simple objects)

# Project source code list
SET( PROJECT_SOURCES
  # Add all the cpp source files here
  main.cpp
  ${MOC_SOURCE}
  ${UI_SOURCE}
  GambitUI.cpp
)

# Include needed to use SDL under Mac OS X
IF(APPLE)
  SET(PROJECT_SOURCES ${PROJECT_SOURCES}  ${SDL_MAIN_FOR_MAC})
ENDIF(APPLE)

# Project executable
ADD_EXECUTABLE(${PROJECT_NAME}
  ${PROJECT_SOURCES}
)

# Project dependencies
TARGET_LINK_LIBRARIES(${PROJECT_NAME}
  # Core library dependencies
  OpenEngine_Core
  OpenEngine_Logging
  OpenEngine_Display
  OpenEngine_Devices
  OpenEngine_Scene
  # Extension dependencies
  Extensions_Qt
  Extensions_SetupHelpers  
  Extensions_Reflect
  # Scheme scripting
  simple
)
