import os
import ycm_core

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# notes:
#   - `Settings()` is modified to use '&filetype' as supplied by vim YCM plugin config:
#       `let g:ycm_extra_conf_vim_data = ['&filetype']`
#   - vim defaults to `cpp` filetype for `.h` files
#       - need to use modeline or project-wide vimrc if `c` is wanted instead
filetype_key = '&filetype'
filetype_flags = {
  'cpp': [
    '-std=c++17',
    '-x',
    'c++',
    '-Wall',
    '-Wextra',
    '-Wold-style-cast',
    '-Wshadow',
  ],

  'c': [
    '-std=c11',
    '-x',
    'c',
    '-Wall',
    '-Wextra',
    '-Wshadow',
  ],
}


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags.
compilation_database_folder = ''

if os.path.exists( compilation_database_folder ):
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def GetCompilationInfoForFile( filename ):
  # The compilation_commands.json file generated by CMake does not have entries
  # for header files. So we do our best by asking the db for flags for a
  # corresponding source file, if any. If one exists, the flags for that file
  # should be good enough.
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        compilation_info = database.GetCompilationInfoForFile(
          replacement_file )
        if compilation_info.compiler_flags_:
          return compilation_info
    return None
  return database.GetCompilationInfoForFile( filename )


# This is the entry point; this function is called by ycmd to produce flags for
# a file.
def Settings( **kwargs ):
  flags = []
  data = kwargs['client_data']
  if filetype_key in data:
    filetype = data[filetype_key]
    if filetype in filetype_flags:
      flags = filetype_flags[filetype]

  if not database:
    return {
      'flags': flags,
      'include_paths_relative_to_dir': DirectoryOfThisScript()
    }
  filename = kwargs[ 'filename' ]
  compilation_info = GetCompilationInfoForFile( filename )
  if not compilation_info:
    return None

  # Bear in mind that compilation_info.compiler_flags_ does NOT return a
  # python list, but a "list-like" StringVec object.
  return {
    'flags': list( compilation_info.compiler_flags_ ),
    'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
  }
