# Commands used to detect support for other commands

provide-module detection %{
    define-command check-cmd -params 1 %{
        evaluate-commands %sh{
            command -v "$1" > /dev/null 2>&1 || echo "fail $1: command not found"
        }
    }

    define-command check-file -params 1 %{
        evaluate-commands %sh{
            test -f "$1" || echo "fail $1: file not found"
        }
    }

    define-command load-first -params .. %{
        evaluate-commands %sh{
            if [ $# -gt 0 ]; then
                echo "try %{"
                while [ $# -gt 0 ]; do
                    echo "  require-module ${1}"
                    echo "  echo -debug ${1} loaded"
                    echo "} catch %{ "
                    shift
                done
                echo "}"
            fi
        }
    }

    define-command load-all -params .. %{
        evaluate-commands %sh{
            while [ $# -gt 0 ]; do
                echo "try %{"
                echo "  echo -debug ${1}"
                echo "  require-module ${1}"
                echo "  echo -debug ${1} loaded"
                echo "} catch %{ echo -debug %val{error} }"
                shift
            done
        }
    }

    define-command find-in-parent -params 2 %{
        evaluate-commands %sh{
            target="$1"
            here="$2"
            while [ "$here" != '/' -a "$here" != '.' ]; do
                if [ -f "$here/$target" ]; then
                    return
                fi
                here=$(dirname "$here")
            done
            echo "fail ${target}: file not found in this directory or any parent"
        }
    }
}
