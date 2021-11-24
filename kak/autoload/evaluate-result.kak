declare-option -hidden str evaluate_result_cmd terminal-popup

define-command evaluate-result -params 1 %{
    evaluate-commands %{
        %opt{evaluate_result_cmd} "%val{config}/scripts/evaluate-result" "%val{session}" "%val{client}" "%arg{1}"
    }
}
