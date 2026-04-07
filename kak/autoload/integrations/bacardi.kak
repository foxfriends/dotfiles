provide-module bacardi %{
    require-module detection
    check-cmd bacardi
    check-cmd rg

    declare-option range-specs bacardi_cbid_ranges
    add-highlighter global/parallel_design_ids replace-ranges bacardi_cbid_ranges

    define-command bacardi-detect %{
        evaluate-commands %sh{
            rg 'CB-\d+' "$kak_buffile" --vimgrep | perl -e '
                use utf8;
                $flags = $ENV{"kak_timestamp"};
                foreach $line (<STDIN>) {
                    if ($line =~ /[^:]+:(\d+):(\d+):(.*)/) {
                        $line = $1;
                        $col = $2;
                        $line_body = $3;
                        $line_body = substr($line_body, $2 - 1);
                        $line_body =~ /^(CB-(?:\d+))/;
                        $cbid = $1;
                        $len = length($cbid);
                        $basename = `bacardi $cbid`;
                        if (${^CHILD_ERROR_NATIVE} == 0) {
                            $flags .= " $line.$col+$len|\{Default\}$cbid\{overlay\}($basename)\{Default\}";
                        }
                    }
                }
                print "set-option buffer bacardi_cbid_ranges $flags"
            '
        }
    }

    hook global BufWritePost .* "bacardi-detect"
    hook global BufCreate .* "bacardi-detect"
}

hook -group bacardi global KakBegin .* %{
    require-module bacardi
}
