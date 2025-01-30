# Detection
# ---------
hook global BufCreate .*\.(ll)$ %{
    set-option buffer filetype llvm
}

hook global WinSetOption filetype=llvm %{
    require-module llvm

    hook window InsertChar \n -group llvm-indent llvm-indent-on-new-line
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window llvm-.+ }
}

hook -group llvm-highlight global WinSetOption filetype=llvm %{
    add-highlighter window/llvm ref llvm
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/llvm }
}


provide-module llvm %{
    add-highlighter shared/llvm regions
    add-highlighter shared/llvm/code default-region group
    add-highlighter shared/llvm/string          region '[c]?"' (?<!\\)(\\\\)*"        fill string
    add-highlighter shared/llvm/quoted_global   region '@"' (?<!\\)(\\\\)*"        fill meta
    add-highlighter shared/llvm/quoted_register region '%"' (?<!\\)(\\\\)*"        fill variable
    add-highlighter shared/llvm/comment         region ';'       '$'              ref comment

    add-highlighter shared/llvm/code/ regex (0[xX][0-9a-fA-F]+|\b[0-9]+)\b 0:value
    add-highlighter shared/llvm/code/ regex ^\h*([A-Za-z0-9_.\-]+): 0:meta
    add-highlighter shared/llvm/code/ regex \b(i[1-9][0-9]*|ptr|label|void|token|metadata)\b 1:type
    add-highlighter shared/llvm/code/ regex "(<)(\d+) (x) (.*)(>)" 1:keyword 3:keyword 5:keyword
    add-highlighter shared/llvm/code/ regex "(\[)(\d+) (x) (.*)(\])" 1:keyword 3:keyword 5:keyword
    add-highlighter shared/llvm/code/ regex "([!]dbg)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "([!]\d+)\b" 1:value
    add-highlighter shared/llvm/code/ regex "\b(zeroinitializer|null)\b" 1:value

    add-highlighter shared/llvm/code/ regex "\b(target datalayout|target triple|source_filename)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(global|constant|define|declare|type|attributes)\b" 1:keyword

    add-highlighter shared/llvm/code/ regex "\b(private|internal|available_externally|linkonce|weak|common|appending|extern_weak|linkonce_odr|weak_odr|external)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(ccc|fastcc|coldcc|ghccc|cc 11|anyregcc|preserve_mostcc|preserve_allcc|preserve_nonecc|cxx_fast_tlscc|tailcc|swiftcc|swifttailcc|cfguard_checkcc|cc \d+)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(default|hidden|protected)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(dllimport|dllexport)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(localdynamic|initialexec|localexec)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(dso_preemptable|dso_local)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(unnamed_addr|local_unnamed_addr)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(section|partition|comdat|align|code_model|no_sanitize_address|no_sanitize_hwaddress|sanitize_address_dyninit|sanitize_memtag|gc|prefix|prologue)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(zeroext|signext|noext|inreg|byval|byref|preallocated|inalloca|sret|elementtype|align|noalias|captures|nofree|nest|returned|nonnull|dereferenceable|derferenceable_or_null|swiftself|swiftasync|swifterror|immarg|noundef|nofpclass|alignstack|allocalign|allocptr|readnone|readonly|writeonly|writable|initializes|dead_on_unwind|range)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(nocallback|nosync|nounwind|speculatable|willreturn|memory|noinline|optnone|uwtable|allocsize|noreturn)\b" 1:keyword

    add-highlighter shared/llvm/code/ regex "\b(ret|br|switch|indirectbr|invoke|callbr|resume|catchswitch|catchret|cleanupret|unreachable|fneg|add|fadd|sub|fsub|mul|fmul|udiv|sdiv|fdiv|urem|srem|frem|shl|lshr|ashr|and|or|xor|extractelement|insertelement|shufflevector|extractvalue|insertvalue|alloca|load|store|fence|cmpxchg|atomicrmw|getelementptr|trunc|zext|sext|fptrunc|fpext|fptoui|fptosi|uitofp|sitofp|ptrtoint|inttoptr|bitcast|addrspacecast|to|icmp|fcmp|phi|select|freeze|call|va_arg|landingpad|catchpad|cleanuppad)\b" 1:function
    add-highlighter shared/llvm/code/ regex "\b(inbounds|nusw|nuw|inrange)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(tail|musttail|notail)\b" 1:keyword
    add-highlighter shared/llvm/code/ regex "\b(eq|ne|ugt|uge|ult|ule|sgt|sge|slt|sle)\b" 1:function

    add-highlighter shared/llvm/code/ regex "([!](DICompileUnit|DILocation|DILocalVariable|DISubroutineType|DISubprogram|DILexicalBlock|DIExpression|DICompositeType|DIDerivedType|DISubrange|DIGlobalVariableExpression|DIGlobalVariable|DIFile|DIBasicType|DIEnumerator))\b" 1:meta
    add-highlighter shared/llvm/code/ regex "\b(distinct)\b" 1:keyword

    add-highlighter shared/llvm/code/ regex (%[a-zA-Z0-9_.]+)\b 1:variable
    add-highlighter shared/llvm/code/ regex (#\d+)\b 1:variable
    add-highlighter shared/llvm/code/ regex (@[a-zA-Z0-9_.]+)\b 1:meta

    define-command -hidden llvm-trim-indent %{
        evaluate-commands -draft -itersel %{
            execute-keys x
            # remove trailing white spaces
            try %{ execute-keys -draft s \h+$ <ret> d }
        }
    }

    define-command -hidden llvm-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : llvm-trim-indent <ret> }
            # indent after label
            try %[ execute-keys -draft k x <a-k> :$ <ret> j <a-gt> ]
        >
    ~
}
