" Vim syntax file
" Language: Lustre

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword lustreKeyword node var let tel function returns const when
syn keyword lustreType type
syn keyword lustreFlowControl if then else for while assert

" Types
syn keyword lustreType bool int real

" Operators
syn match lustreOperator "\v\+"
syn match lustreOperator "\v\-"
syn match lustreOperator "\v\*"
syn match lustreOperator "\v\/"
syn match lustreOperator "\v\="
syn match lustreOperator "\v\<"
syn match lustreOperator "\v\>"
syn match lustreOperator "\v\<\="
syn match lustreOperator "\v\>\="
syn match lustreOperator "\v\-\>"
syn match lustreOperator "\v\:\:"

" Boolean operators
syn match lustreBooleanOperator "\vxor"
syn match lustreBooleanOperator "\vor"
syn match lustreBooleanOperator "\vand"
syn match lustreBooleanOperator "\vnot"
syn match lustreBoolean "\vfalse"
syn match lustreBoolean "\vtrue"

" Function calls
syn region lustreFunction start="\v\w+\(" end=")" contains=lustreType,lustreNumber,lustreBoolean,lustreBooleanOperator,lustreKeyword

" Numbers
syn match lustreNumber "\v\d\+"
syn match lustreIdentifier "\v\w\+\d*\b"

" Strings
syn region lustreString start='"' end='"'

" Comments
syn region lustreComment start="/\*" end="\*/"
syn match lustreComment "\/\/.*$"
syn match lustreComment "--.*$"

" Highlighting
hi def link lustreKeyword Keyword
hi def link lustreType Type
hi def link lustreOperator Operator
hi def link lustreBoolean Boolean
hi def link lustreBooleanOperator Boolean
hi def link lustreFunction Function
hi def link lustreNumber Number
hi def link lustreString String
hi def link lustreComment Comment
hi def link lustreIdentifier Identifier

hi lustreComment ctermfg=grey guifg=#808080
hi lustreFlowControl ctermfg=magenta guifg=#FF00FF
hi lustreBoolean ctermfg=magenta guifg=#FF00FF
hi lustreBooleanOperator ctermfg=yellow guifg=#FFA500
