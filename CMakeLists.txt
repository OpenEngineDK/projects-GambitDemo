# Project name. Should be the same as the project directory name and
# will become the name of the binary target.
SET( PROJECT_NAME "GambitDemo")

# GAMBIT_ADD_LIBRARY(myscheme main.scm)

ADD_LIBRARY(mycfoo
  mycfoo.h
  mycfoo.cpp
)

SET(GAMBITC "${OE_LIB_DIR}/gambit/bin/gsc")

ADD_CUSTOM_COMMAND(
  OUTPUT  objects.cpp objects_.cpp
  DEPENDS objects.scm
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/objects.scm objects.scm
  COMMAND ${GAMBITC} -l ${GAMBIT_LIB_DIR}/_gambc -link objects.scm
  COMMAND ${GAMBITC} -l ${GAMBIT_LIB_DIR}/_gambc -c objects.scm
  COMMAND cp objects.c objects.cpp
  COMMAND cp objects_.c objects_.cpp
  COMMENT "compiling scheme code"
)

ADD_CUSTOM_COMMAND(
  OUTPUT  simple.cpp simple_.cpp
  DEPENDS simple.scm
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/simple.scm simple.scm
  COMMAND ${GAMBITC} -l ${GAMBIT_LIB_DIR}/_gambc -link simple.scm
  COMMAND ${GAMBITC} -l ${GAMBIT_LIB_DIR}/_gambc -c simple.scm
  COMMAND mv simple.c simple.cpp
  COMMAND mv simple_.c simple_.cpp
  COMMENT "compiling scheme code"
)

# ADD_CUSTOM_TARGET(Simple
# #  OUTPUT  simple
#   DEPENDS simple.scm
#   COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/simple.scm simple.scm
# #  COMMAND gsc -link simple.scm
#   COMMAND gsc -exe simple.scm
# )
# #ADD_EXECUTABLE(simple)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D___LIBRARY")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D___LIBRARY")

ADD_LIBRARY(gambits
  objects.cpp
  objects_.cpp
)

ADD_LIBRARY(simple
  simple.cpp
  simple_.cpp
)

ADD_DEPENDENCIES(simple gambits)
TARGET_LINK_LIBRARIES(simple gambits)

# Project source code list
SET( PROJECT_SOURCES
  # Add all the cpp source files here
  main.cpp
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
  Extensions_GambitScheme
#  myscheme
  simple
)
