provide-module dotenv %{
    define-command dotenv-load -params 0..1 %{
        evaluate-commands %sh{
            file=${1:-.env}
            n=0
            while read p; do
                if echo "$p" | grep '[\w\d_]+=.*' -P -q ; then
                    echo "$p" | while IFS== read -r name value; do 
                        echo "declare-option str %{dotenv_${name}}"
                        echo "set-option global %{dotenv_${name}} %{${value}}"
                        n=$((n + 1))
                    done
                fi
            done < $file
            echo "echo -debug $n env variables loaded from $file"
        }
    }
}
