if test (uname) = 'Darwin'
  function grab --description 'Grab whole file into clipboard' -a input_path
    # Courtesy of Jordan, but converted to fish
    if test -z "$input_path"
      echo "Usage: grab <file_or_directory_path>" >&2
      return 1
    end
    set input_path "$argv[1]"
    # Attempt to resolve the input path to an absolute path using realpath.
    # realpath is generally available on modern macOS.
    # It handles '.', '..', and resolves symbolic links.
    set absolute_path (realpath "$input_path")
    # Although realpath resolves the path structure, double-check if the target
    # actually exists, as osascript 'POSIX file' usually expects an existing item.
    # The '-e' test checks for the existence of a file or directory.
    if test ! -e "$absolute_path"
        echo "Error: File or directory does not exist: '$absolute_path'" >&2
        return 1
    end
    osascript \
        -e 'on run args' \
        -e 'set the clipboard to POSIX file (first item of args)' \
        -e end \
        "$absolute_path"
    return 0
  end
end
