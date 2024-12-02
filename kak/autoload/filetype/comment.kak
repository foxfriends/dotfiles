add-highlighter shared/comment group
add-highlighter shared/comment/   fill comment
add-highlighter shared/comment/   regex \b(TODO|NOTE)(\[(.+)\])?: 1:keyword 3:value
add-highlighter shared/comment/   regex \b(RM|FIXME|HACK)(\[(.+)\])?: 1:error 3:value

add-highlighter shared/comment/   regex \b(eslint-(disable|enable)((-next)?-line)?(?!-))\b 1:keyword
add-highlighter shared/comment/   regex (@ts(-expect-error|-ignore)(?!-))\b 1:keyword
add-highlighter shared/comment/   regex \bprettier-ignore\b 1:keyword

add-highlighter shared/doc_comment group
add-highlighter shared/doc_comment/   fill doc_comment
add-highlighter shared/doc_comment/   regex \b(TODO|NOTE)(\[(.+)\])?: 1:keyword 3:value
add-highlighter shared/doc_comment/   regex \b(RM|FIXME|HACK)(\[(.+)\])?: 1:error 3:value
