# Project name. Should be the same as the project directory name and
# will become the name of the binary target.
SET( PROJECT_NAME "GambitDemo")

# GAMBIT_ADD_LIBRARY(myscheme main.scm)

ADD_LIBRARY(mycfoo
  mycfoo.h
  mycfoo.cpp
)

ADD_CUSTOM_COMMAND(
  OUTPUT simple.c simple_.c # myscheme.c myscheme_.c
  DEPENDS simple.scm # myscheme.scm
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/simple.scm simple.scm
  COMMAND gsc -link simple.scm # myscheme.scm #-cc-options "-I${CMAKE_CURRENT_SOURCE_DIR}"
  COMMAND gsc -c simple.scm # myscheme.scm #-cc-options "-I${CMAKE_CURRENT_SOURCE_DIR}"
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

ADD_LIBRARY(simple
  simple.c
  simple_.c
)

ADD_LIBRARY(myscheme
  # generated
  myscheme.c
  myscheme_.c
)

TARGET_LINK_LIBRARIES(myscheme mycfoo)

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
