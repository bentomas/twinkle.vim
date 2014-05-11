if exists('g:loaded_twinkle')
  finish
endif

if !exists('g:twinkle_add_mappings')
    let g:twinkle_add_mappings = 1
endif

if !exists('g:twinkle_filetype_iskeywords')
    let g:twinkle_filetype_iskeywords = {}
endif

function! s:VeryMagicEscape(str)
    "http://jeetworks.org/vim-regular-expression-special-characters-to-escape-or-not-to-escape/
    let search = escape(a:str, '@=%.^$~*+?()<>[{\|/')
    return search
endfunction

function! s:SaveIskeyword()
    let s:saved_isk = &l:iskeyword
endfunction

function! s:SetIskeywordForFileType(filetype)
    if has_key(g:twinkle_filetype_iskeywords, a:filetype)
        let &l:iskeyword = g:twinkle_filetype_iskeywords[a:filetype]
    elseif has_key(g:twinkle_filetype_iskeywords, '*')
        let &l:iskeyword = g:twinkle_filetype_iskeywords['*']
    endif
endfunction

function! s:RestoreIskeyword()
    let &l:iskeyword = s:saved_isk
endfunction

function! s:SaveYankRegisters()
    let s:saved_regQ  = getreg('"')
    let s:saved_typeQ = getregtype('"')
    let s:saved_reg0  = getreg('0')
    let s:saved_type0 = getregtype('0')
endfunction

function! s:RestoreYankRegisters()
    call setreg('"', s:saved_regQ, s:saved_typeQ)
    call setreg('0', s:saved_reg0, s:saved_type0)
endfunction

noremap <silent> <Plug>(TwinkleMagicStarNormal)
    \ :call <SID>SaveIskeyword()<CR>
    \:call <SID>SaveYankRegisters()<CR>
    \:call  <SID>SetIskeywordForFileType(&filetype)<CR>
    \:let @0 = <SID>VeryMagicEscape(expand('<cword>'))<CR>
    \:echo '/\v<'.@0.'>'<CR>
    \/\v<<C-R><C-R>0><CR>
    \:call <SID>RestoreIskeyword()<CR>
    \:call <SID>RestoreYankRegisters()<CR>

noremap <silent> <Plug>(TwinkleMagicPoundNormal)
    \ :call <SID>SaveIskeyword()<CR>
    \:call <SID>SaveYankRegisters()<CR>
    \:call  <SID>SetIskeywordForFileType(&filetype)<CR>
    \:let @0 = <SID>VeryMagicEscape(expand('<cword>'))<CR>
    \:echo '/\v'.@0<CR>
    \?\v<<C-R><C-R>0<CR>><CR>
    \:call <SID>RestoreIskeyword()<CR>
    \:call <SID>RestoreYankRegisters()<CR>

noremap <silent> <Plug>(TwinkleMagicStarVisual)
    \ :<C-U>
    \call <SID>SaveYankRegisters()<CR>
    \gvy
    \:let @0 = <SID>VeryMagicEscape(@")<CR>
    \:echo '/\v'.@0<CR>
    \/\v<C-R><C-R>0<CR>
    \gV
    \:call <SID>RestoreYankRegisters()<CR>

noremap <silent> <Plug>(TwinkleMagicPoundVisual)
    \ :<C-U>
    \call <SID>SaveYankRegisters()<CR>
    \gvy
    \:let search=<SID>VeryMagicEscape(@")
    \?\v<C-R><C-R>=search<CR><CR>
    \gV
    \:call <SID>RestoreYankRegisters()<CR>

noremap <silent> <Plug>(TwinkleMagicSearch)           /\v
noremap <silent> <Plug>(TwinkleMagicReverseSearch)    ?\v

if g:twinkle_add_mappings
    map  / <Plug>(TwinkleMagicSearch
    map  ? <Plug>(TwinkleMagicReverseSearch)

    nmap * <Plug>(TwinkleMagicStarNormal)
    nmap # <Plug>(TwinkleMagicPoundNormal)

    vmap * <Plug>(TwinkleMagicStarVisual)
    vmap # <Plug>(TwinkleMagicPoundVisual)
endif
