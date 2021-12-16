add-highlighter shared/comment group
add-highlighter shared/comment/   fill comment
add-highlighter shared/comment/   regex \b(TODO|NOTE|HACK)(\[(.+)\])?: 1:keyword 3:value
add-highlighter shared/comment/   regex \b(RM)(\[(.+)\])?: 1:error 3:value

add-highlighter shared/doc_comment group
add-highlighter shared/doc_comment/   fill doc_comment
add-highlighter shared/doc_comment/   regex \b(TODO|NOTE|HACK)(\[(.+)\])?: 1:keyword 3:value
add-highlighter shared/doc_comment/   regex \b(RM)(\[(.+)\])?: 1:error 3:value
