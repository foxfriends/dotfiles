# Detection
# ‾‾‾‾‾‾‾‾‾
# NOTE: there is no detection, as this language is included by JavaScript/TypeScript. It
# makes no sense on its own.

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=(javascript|typescript|html) %{
    require-module jsdoc
}

provide-module jsdoc %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾
add-highlighter shared/jsdoc regions
add-highlighter shared/jsdoc/block          default-region group

add-highlighter shared/jsdoc/block/         ref comment
add-highlighter shared/jsdoc/block/         regex  (@abstract|@virtual)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@access)\b\h+(package|private|protected|public) 1:keyword 2:keyword
add-highlighter shared/jsdoc/block/         regex  (@package|@private|@protected|@public)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@alias)\b\h+(\S+) 1:keyword 2:variable
add-highlighter shared/jsdoc/block/         regex  (@async)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@author)\b\h+(.+)\h+(<(.*)>)?$ 1:keyword 2:string 4:meta
add-highlighter shared/jsdoc/block/         regex  (@augments|@extends)\b\h+(\S+)$ 1:keyword 2:type
add-highlighter shared/jsdoc/block/         regex  (@borrows)\b\h+(\S+)\h+(as)\h+(\S+) 1:keyword 2:variable 3:keyword 4:variable
add-highlighter shared/jsdoc/block/         regex  (@callback)\b\h+(\S+) 1:keyword 2:type
add-highlighter shared/jsdoc/block/         regex  (@class|@constructor)\b(\h+(\S+))? 1:keyword 3:type
add-highlighter shared/jsdoc/block/         regex  (@classdesc)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@const|@constant)\b(\h+\{([^}]+)\})?(\h+(\S+))? 1:keyword 3:type 5:variable
add-highlighter shared/jsdoc/block/         regex  (@constructs)\b(\h+(\S+))? 1:keyword 3:type
add-highlighter shared/jsdoc/block/         regex  (@copyright)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@default|@defaultvalue)\b(\h+(\S+)) 1:keyword 2:value
add-highlighter shared/jsdoc/block/         regex  (@deprecated)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@desc|@description)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@enum)\b(\h+\{([^}]+)\})? 1:keyword 3:type
add-highlighter shared/jsdoc/block/         regex  (@event)\b\h+([^\s#]+)#(([^\s:]+):)(\S+) 1:keyword 2:type 4:variable 5:string
add-highlighter shared/jsdoc/block/         regex  (@example)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@external|@host)\b\h+(\S+) 1:keyword 2:variable
add-highlighter shared/jsdoc/block/         regex  (@file|@overview|@fileoverview)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@emits|@fires)\b\h+([^\s#]+)#(([^\s:]+):)(\S+) 1:keyword 2:type 4:variable 5:string
add-highlighter shared/jsdoc/block/         regex  (@func|@function|@method)\b(\h+(\S+))? 1:keyword 3:function
add-highlighter shared/jsdoc/block/         regex  (@generator)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@global)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@hideconstructor)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@ignore)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@implements)\b(\h+\{([^}]+)\})? 1:keyword 3:type
add-highlighter shared/jsdoc/block/         regex  (@inheritdoc)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@inner)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@instance)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@interface)\b(\h+(\S+)) 1:keyword 3:type
add-highlighter shared/jsdoc/block/         regex  (@kind)\b(class|constant|event|external|file|function|member|mixin|module|namespace|typedef) 1:keyword 2:keyword
add-highlighter shared/jsdoc/block/         regex  (@lends)\b(\h+(\S+)) 1:keyword 3:type
add-highlighter shared/jsdoc/block/         regex  (@license)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@listens)\b\h+([^\s#]+)#(([^\s:]+):)(\S+) 1:keyword 2:type 4:variable 5:string
add-highlighter shared/jsdoc/block/         regex  (@member|@var)\b(\h+\{([^}]+)\})?(\h+([A-Za-z_$][A-Za-z_$0-9]*))? 1:keyword 3:type 5:variable
add-highlighter shared/jsdoc/block/         regex  (@memberof!?)\b(\h+\S+)? 1:keyword 2:variable
add-highlighter shared/jsdoc/block/         regex  (@namespace)\b(\h+\{([^}]+)\})?(\h+([A-Za-z_$][A-Za-z_$0-9]*))? 1:keyword 3:type 5:type
add-highlighter shared/jsdoc/block/         regex  (@override)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@param|@arg|@argument)\b(\h+\{([^}]+)\})?\h+(([A-Za-z_$][A-Za-z_$0-9.]*)|\[([A-Za-z_$][A-Za-z_$0-9.\[\]]*)(\b\h*=\h*([^\]]*))?\]) 1:keyword 2:type 5:variable 6:variable 8:value
add-highlighter shared/jsdoc/block/         regex  (@prop|@property)\b(\h+\{[^}]+\})?\h+([A-Za-z_$][A-Za-z_$0-9]*) 1:keyword 2:type 3:variable
add-highlighter shared/jsdoc/block/         regex  (@readonly)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@requires)\b\h+(\S+) 1:keyword 2:string
add-highlighter shared/jsdoc/block/         regex  (@return|@returns)\b(\h+\{[^}]+\})? 1:keyword 2:type
add-highlighter shared/jsdoc/block/         regex  (@see)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@since)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@static)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@summary)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@this)\b\h+(\S+) 1:keyword 2:variable
add-highlighter shared/jsdoc/block/         regex  (@throws)\b(\h+\{[^}]+\})? 1:keyword 2:type
add-highlighter shared/jsdoc/block/         regex  (@todo)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@tutorial)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@type)\b\h+(\{([^}]+)\}) 1:keyword 2:type
add-highlighter shared/jsdoc/block/         regex  (@typedef)\b(\h+\{[^}]+\})?\h+([A-Za-z_$][A-Za-z_$0-9]*) 1:keyword 2:type 3:type
add-highlighter shared/jsdoc/block/         regex  (@variation)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@version)\b 1:keyword
add-highlighter shared/jsdoc/block/         regex  (@yield|@yields)\b(\h+\{[^}]+\})? 1:keyword 2:type

add-highlighter shared/jsdoc/block/         regex  \{(@link)\b\h+([^}]+)\} 1:keyword 3:meta
add-highlighter shared/jsdoc/block/         regex  \{(@tutorial)\b\h+([^}]+)\} 1:keyword 3:meta

§
