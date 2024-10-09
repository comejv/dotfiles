" Y86-64 Syntax Highlighting
" Define the syntax for Y86-64 instructions, registers, comments, and numbers

" Clear existing syntax rules
syntax clear

" Highlight Y86-64 instructions
syntax keyword y86Instr addl subl andl xorl addq subq andq xorq
syntax keyword y86Instr rrmovl irmovl mrmovl rmmovl
syntax keyword y86Instr rrmovq irmovq mrmovq rmmovq
syntax keyword y86Instr jmp je jne jg jge jl jle
syntax keyword y86Instr pushl popl pushq popq halt nop

" Highlight Y86-64 registers (including 64-bit ones)
syntax keyword y86Register %eax %ecx %edx %ebx %esp %ebp %esi %edi
syntax keyword y86Register %rax %rbx %rcx %rdx %rsi %rdi %rsp %rbp

" Match numbers (both immediate values and memory offsets)
syntax match y86Number /\<\d\+\>/
syntax match y86HexNumber /\<0x[0-9A-Fa-f]\+\>/

" Highlight comments (starting with # or //)
syntax match y86Comment /#.*/ contains=@Spell
syntax match y86Comment /\/\/.*/ contains=@Spell

" Highlight assembly directives (.pos, .quad, .align)
syntax keyword y86Directive .pos .quad .align
highlight link y86Directive PreProc

" Optionally highlight labels (a word followed by a colon)
syntax match y86Label /^\s*\w\+:/ containedin=ALL
highlight link y86Label Label

" Define highlighting colors
highlight link y86Instr Keyword
highlight link y86Register Type
highlight link y86Number Number
highlight link y86HexNumber Number
highlight link y86Comment Comment
