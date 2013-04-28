include (CMakeParseArguments)

function (CTObjCARCSetEnabled value scope)
  cmake_parse_arguments(args "DIRECTORY" "" "TARGETS;SOURCES" ${ARGV})
  __SanitiseBoolean(value)

  if (scope STREQUAL "DIRECTORY")
    if (CMAKE_GENERATOR STREQUAL "Xcode" AND
        CMAKE_CURRENT_SOURCE_DIR STREQUAL "${CMAKE_SOURCE_DIR}")
      set (CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC ${value} PARENT_SCOPE)
    elseif (value)
      add_definitions(-fobjc-arc)
    else ()
      add_definitions(-fno-objc-arc)
    endif ()
  
  elseif (scope STREQUAL "SOURCES")
    if (value)
      CTAddCompilerFlags(SOURCES ${args_SOURCES} FLAGS -fobjc-arc)
    else ()
      CTAddCompilerFlags(SOURCES ${args_SOURCES} FLAGS -fno-objc-arc)
    endif ()      

  elseif (scope STREQUAL "TARGETS")
    if (CMAKE_GENERATOR STREQUAL "Xcode")
      set_property(TARGET ${args_TARGETS}
                   PROPERTY XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC ${value})
    elseif (value)
      CTAddCompilerFlags(TARGETS ${args_TARGETS} FLAGS -fobjc-arc)
    else ()
      CTAddCompilerFlags(TARGETS ${args_TARGETS} FLAGS -fno-objc-arc)
    endif ()
  else ()
    message(FATAL_ERROR "Invalid scope: ${scope}")
  endif ()
endfunction ()

# 0, NO, FALSE  -> NO
# ...           -> YES
function (__SanitiseBoolean variable)
  if (${${variable}})
    set (${variable} YES PARENT_SCOPE)
  else ()
    set (${variable} NO PARENT_SCOPE)
  endif ()
endfunction ()
