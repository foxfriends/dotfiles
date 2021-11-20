# Detection

hook global BufCreate .*[.](pest) %{
    set-option buffer filetype pest
}

# Initialization

hook global WinSetOption filetype=pest %[
    require-module pest
]

hook -group pest-highlight global WinSetOption filetype=pest %{
    add-highlighter window/pest ref pest
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/pest }
}

provide-module pest %§

# Highlighters

add-highlighter shared/pest         regions
add-highlighter shared/pest/rules          default-region           group
add-highlighter shared/pest/rule           region [{]\K   (?=[}])   regions
add-highlighter shared/pest/comment        region '//'    '$'       ref comment


add-highlighter shared/pest/rules/   regex \b(\w+)\b  1:variable
add-highlighter shared/pest/rules/   regex \b(WHITESPACE|COMMENT)\b  1:type
add-highlighter shared/pest/rules/   regex [@$_!]?[{]  0:keyword
add-highlighter shared/pest/rules/   regex [}]        0:keyword

add-highlighter shared/pest/rule/base      default-region                       group
add-highlighter shared/pest/rule/string    region %{(?<!')"} (?<!\\)(\\\\)*"    fill string

add-highlighter shared/pest/rule/base/   regex ('([^'\\]|\\'|\\\\|\\u\{[0-9a-fA-F]{1,4}\})') 1:value
add-highlighter shared/pest/rule/base/   regex ([.|+*!&{}()?@~]) 1:keyword
add-highlighter shared/pest/rule/base/   regex \b(PEEK|POP|PUSH)\b 1:function
add-highlighter shared/pest/rule/base/   regex \b(WHITESPACE|COMMENT)\b 1:type
add-highlighter shared/pest/rule/base/   regex \b(ANY|SOI|EOI)\b 1:keyword
add-highlighter shared/pest/rule/base/   regex \b(ASCII_DIGIT|ASCII_NONZERO_DIGIT|ASCII_BIN_DIGIT_ASCII_HEX_DIGIT|ASCII_ALPHA_LOWER|ASCII_ALPHA_UPPER|ASCII_ALPHA|ASCII_ALPHANUMERIC|NEWLINE)\b 1:meta
add-highlighter shared/pest/rule/base/   regex \b(LETTER|CASED_LETTER|UPPERCASE_LETTER|LOWERCASE_LETTER|TITLECASE_LETTER|MODIFIER_LETTER|OTHER_LETTER|MARK|NONSPACING_MARK|SPACING_MARK|ENCLOSING_MARK|NUMBER|DECIMAL_NUMBER|LETTER_NUMBER|OTHER_NUMBER|PUNCTUATION|CONNECTOR_PUNCTUATION|DASH_PUNCTUATION|OPEN_PUNCTUATION|CLOSE_PUNCTUATION|INITIAL_PUNCTUATION|FINAL_PUNCTUATION|OTHER_PUNCTUATION|SYMBOL|MATH_SYMBOL|CURRENCY_SYMBOL|MODIFIER_SYMBOL|OTHER_SYMBOL|SEPARATOR|SPACE_SEPARATOR|LINE_SEPARATOR|PARAGRAPH_SEPARATOR|OTHER|CONTROL|FORMAT|SURROGATE|PRIVATE_USE|UNASSIGNED)\b 1:meta
add-highlighter shared/pest/rule/base/   regex \b(ALPHABETIC|BIDI_CONTROL|CASE_IGNORABLE|CASED|CHANGES_WHEN_CASEFOLDED|CHANGES_WHEN_CASEMAPPED|CHANGES_WHEN_LOWERCASED|CHANGES_WHEN_TITLECASED|CHANGES_WHEN_UPPERCASED|DASH|DEFAULT_IGNORABLE_CODE_POINT|DEPRECATED|DIACRITIC|EXTENDER|GRAPHEME_BASE|GRAPHEME_EXTEND|GRAPHEME_LINK|HEX_DIGIT|HYPHEN|IDS_BINARY_OPERATOR|IDS_TRINARY_OPERATOR|ID_CONTINUE|ID_START|IDEOGRAPHIC|JOIN_CONTROL|LOGICAL_ORDER_EXCEPTION|LOWERCASE|MATH|NONCHARACTER_CODE_POINT|OTHER_ALPHABETIC|OTHER_DEFAULT_IGNORABLE_CODE_POINT|OTHER_GRAPHEME_EXTEND|OTHER_ID_CONTINUE|OTHER_ID_START|OTHER_LOWERCASE|OTHER_MATH|OTHER_UPPERCASE|PATTERN_SYNTAX|PATTERN_WHITE_SPACE|PREPENDED_CONCATENATION_MARK|QUOTATION_MARK|RADICAL|REGIONAL_INDICATOR|SENTENCE_TERMINAL|SOFT_DOTTED|TERMINAL_PUNCTUATION|UNIFIED_IDEOGRAPH|UPPERCASE|VARIATION_SELECTOR|WHITE_SPACE|XID_CONTINUE|XID_START)\b 1:meta


§
