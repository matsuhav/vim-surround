" surround.vim
" OriginalAuthor:	Tim Pope <https://github.com/tpope/vim-surround>
" Author:		matsuhav

" if exists("g:loaded_surround") && g:loaded_surround == 1
" 	finish
" endif
let g:loaded_surround = 1
let s:save_cpo = &cpo
set cpo&vim
silent! unlet b:surround_dict_full

" Short help
" g:loaded_surround to disable autoload
" surround dict
" g:surround_enable_default_dict to disable default maps
" g:surround_dict b:surround_dict to add surrounds
" unlet b:surround_dict_full to live changes to surrounds
" g:surround_max_subexp = 3 by default. to change max '\1's
" cmap
" g:surround_enable_default_cmap to disable default cmap
" g:surround_cmap b:surround_cmap to add cmap
" unlet b:surround_map_full to live changes to cmaps
" indent
" g:surround_enable_reindent b:surround_enable_reindent to disable reindent
" cursor
" g:surround_putcursorafter b:surround_putcursorafter to put cursor after
" mapping
" g:surround_enable_default_mappings to disable default mappings
" recommendation
" Install https://github.com/tpope/vim-surround to repeat with '.'


" '' =~# "\<C-]>"
" '\1's are replaced with '\k\+' when search()
" Shouldn't use 'literal-string'. It can't contain <CR>s
" '\n' and "\\n" matches <CR>
let s:surround_dict_default = {
		\ '  ': ' \r ',
		\ 'b': '(\r)',
		\ '(': '( \r )',
		\ ')': '(\r)',
		\ 'B': '{\r}',
		\ ' B': ' {\r}',
		\ '{': '{ \r }',
		\ '}': '{\r}',
		\ 'a': '<\r>',
		\ '<': '< \r >',
		\ '>': '<\r>',
		\ 'A': '[\r]',
		\ '[': '[ \r ]',
		\ ']': '[\r]',
		\ '''': '''\r''',
		\ '"': '"\r"',
		\ ',': ',\r,',
		\ 'p': '\n\r\n\n',
		\ '': '{\n\t\r\n}',
		\ 't': '<\1>\r</\1>',
		\ 'T': '<\1 \r</\1>',
		\ 'l': '\\begin{\1}\r\\end{\1}',
		\ '\': '\\begin{\1}\r\\end{\1}',
		\ 'f': '\1(\r)',
		\ 'F': '\1( \r )',
		\ 'Ra': '>\r<',
		\ '|': '|\r|',
		\ 's': '\\\r\\',
		\ 'd': '..\r..',
		\ ':': ':\r:',
		\ '`': '`\r`',
		\ '*': '*\r*',
		\ }

" When it has '\1's, it maps during input(),
" execute 'cnoremap ' . '>' . ' ' . ''
" execute 'silent! cunmap ' . '>'
let s:surround_cmap_default = {
		\ 't': {'>': ''},
		\ 'l': {'}': ''},
		\ '\': {'}': ''},
		\ }

let g:surround_max_subexp = 3

function! s:getchar()
	let c = getchar()
	if c =~ '^\d\+$'
		let c = nr2char(c)
	endif
	return c
endfunction

" a:leftover is used to pass leftover char after get count
" Initialize dictionary if neccesary
" Loop while there are matchs
" Return when found only match or whennever hit <CR>
" Return [is_match_found, input]
function! s:get_surround(leftover)
	if !exists('b:surround_dict_full')
		let b:surround_dict_full = {}
		if !exists('g:surround_enable_default_dict') || g:surround_enable_default_dict == 1
			call extend(b:surround_dict_full, s:surround_dict_default)
		endif
		if exists('g:surround_dict')
			call extend(b:surround_dict_full, g:surround_dict)
		endif
		if exists('b:surround_dict')
			call extend(b:surround_dict_full, b:surround_dict)
		endif
	endif
	if !exists('b:surround_map_full')
		let b:surround_map_full = {}
		if !exists('g:surround_enable_default_cmap') || g:surround_enable_default_cmap == 1
			call extend(b:surround_map_full, s:surround_cmap_default)
		endif
		if exists('g:surround_cmap')
			call extend(b:surround_map_full, g:surround_cmap)
		endif
		if exists('b:surround_cmap')
			call extend(b:surround_map_full, b:surround_cmap)
		endif
	endif
	let newchar = a:leftover
	let input = a:leftover
	if a:leftover == ''
		let newchar = s:getchar()
		let input .= newchar
	else
	endif
	let continue = 1
	while continue == 1
		let continue = 0
		for key in keys(b:surround_dict_full)
			if key =~# '^' . input . '.'
				let continue = 1
			endif
		endfor
		for key in keys(b:surround_dict_full)
			if key ==# input && continue == 0
				return [1, key]
			elseif key . '' ==# input && newchar == ''
				let s:input .= ''
				return [1, substitute(key, '$', '', '')]
			endif
		endfor
		if continue == 0 || newchar == ''
			break
		endif
		let newchar = s:getchar()
		let input .= newchar
	endwhile
	return [0, input]
endfunction

" a:accept_count is 1 when used as delete/change target
"                is 0 when used as destination
" Returns count, success_p and keysequence
function! s:getinput(accept_count)
	let l:count = ''
	let char = ''
	let s:input = ''
	if a:accept_count
		" get count part
		let char = s:getchar()
		while char =~ '\d'
			let l:count .= char
			let char = s:getchar()
		endwhile
	endif
	if l:count == ''
		let l:count = '1'
	endif
	let [success_p, key] = s:get_surround(char)
	if success_p
		return [str2nr(l:count), 1, key]
	endif
	if key =~# '[]'
		return [0, 0, '']
	elseif key =~# '$'
		return [str2nr(l:count), 0, substitute(key, '$', '', '')]
	else
		return [str2nr(l:count), 0, key]
	endif
endfunction

function! s:map(key, is_map)
	for key in keys(b:surround_map_full)
		if key !~# a:key
			continue
		endif
		for [key, value] in items(b:surround_map_full[a:key])
			if a:is_map
				execute 'cnoremap ' . key . ' ' . value
			else
				execute 'silent! cunmap ' . key
			endif
		endfor
	endfor
endfunction

" Replace every '\1's
" Returns string used for concatenation
function! s:process_dest(key, all)
	let i = 1
	let all = a:all
	while i < g:surround_max_subexp
		let startpos = match(all, '\\' . i)
		if startpos == -1
			break
		endif
		call s:map(a:key, 1)
		let input = input(strcharpart(all, 0, startpos))
		let s:input .= input . ''
		call s:map(a:key, 0)
		let all = substitute(all, '\\' . i, input, 'g')
		let i += 1
	endwhile
	return [s:pattern2string(s:extractbefore(all)), s:pattern2string(s:extractafter(all))]
endfunction

" First occurrence is '\(\k\+\)' and the other is '\1'
" Returns pattern
function! s:process_target(all)
	let i = 1
	let jb = 1
	let ja = 1
	let before = s:extractbefore(a:all)
	let after = s:extractafter(a:all)
	while i < g:surround_max_subexp
		let startposb = match(before, '\\' . i)
		let startposa = match(after, '\\' . i)
		if startposb == -1 && startposa == -1
			break
		endif
		if startposb != -1
			let before = substitute(before, '\\' . i,  '\\(\\k\\+\\)', '')
			let before = substitute(before, '\\' . i,  '\\' . jb, 'g')
			let jb += 1
		endif
		if startposa != -1
			let after = substitute(after, '\\' . i,  '\\(\\k\\+\\)', '')
			let after = substitute(after, '\\' . i,  '\\' . ja, 'g')
			let ja += 1
		endif
		let i += 1
	endwhile
	return [before, after]
endfunction

" Can't use '\1' with searchpair!
function s:process_target_nosubmatch(all)
	let i = 1
	let all = a:all
	while i < g:surround_max_subexp
		let all = substitute(all, '\\' . i,  '\\(\\k\\+\\)', 'g')
		let i += 1
	endwhile
	return [s:extractbefore(all), s:extractafter(all)]
endfunction

" is_change is true when change
" is_change is 2 when linewise
function! s:dosurround(is_change)
	" determine target
	let [l:count, success_p, targetkey] = s:getinput(1)
	let l:count *= v:count1
	if success_p
		let targetpat = b:surround_dict_full[targetkey]
		let [before, after] = s:process_target(targetpat)
	else
		let targetpat = targetkey
		let [before, after] = [targetkey, targetkey]
	endif
	if targetpat ==# ''
		return s:beep()
	endif

	call s:save()

	" mark and yank target
	let curpos = getpos('.')
	if targetkey !~# 't\|T'
		if !s:search_literally(before, 'bcW')
			return s:beep()
		endif
		let i = 1
		while i < l:count
			if !s:search_literally(before, 'bW')
				return s:beep()
			endif
			let i += 1
		endwhile
		let beforepos = getpos('.')
		call s:search_literally(before, 'ceW')
		if before ==# after
			call search('.')
		endif
		let [before, after] = s:process_target_nosubmatch(targetpat)
		call searchpair(s:literalize_pattern(before), '', s:literalize_pattern(after), 'W')
		call s:search_literally(after, 'ceW')
		let afterpos = getpos('.')

		if afterpos[1] < curpos[1] || (afterpos[1] == curpos[1] && afterpos[2] <= curpos[2])
			return s:beep()
		endif

		call setpos('.', beforepos)
		normal! v
		call setpos('.', afterpos)
		normal! y
		let keeper = getreg('"')
		let regtype = getregtype('"')
		let keeper = substitute(keeper, '^' . before, '', '')
		let keeper = substitute(keeper, after . '$', '', '')
	else
		execute 'normal! y' . l:count . 'it'
		let keeper = getreg('"')
		if targetkey ==# 'T'
			execute 'normal! y' . l:count . 'at'
			let attr = getreg('"')
			let attr = substitute(attr, '>*$', '', '')
			let attr = matchstr(attr, '<\S\+ \zs\_.\{-\}\ze>', '', '')
			let keeper = attr . '>' . keeper
		endif
		call setpos('.', curpos)
		execute 'normal! v' . l:count . 'at'
		let regtype = getregtype('"')
	endif

	" determine dest
	let newbefore = ''
	let newafter = ''
	if a:is_change
		let [s:null, success_p, destkey] = s:getinput(0)
		if success_p
			if destkey ==# 't' && targetkey ==# 'T'
				let destkey = 'T'
			endif
			let destpat = b:surround_dict_full[destkey]
			let [newbefore, newafter] = s:process_dest(destkey, destpat)
		else
			let destpat = destkey
			let [newbefore, newafter] = [destkey, destkey]
		endif
		if destpat ==# ''
			return s:beep()
		endif
		if a:is_change == 2 " linewise
			let regtype = 'V'
		endif
	endif

	" make dest
	let keeper = newbefore . keeper . newafter

	call s:put_and_restore(keeper, regtype)
	if a:is_change
		if a:is_change == 1
			silent! call repeat#set("\<Plug>ChangeSurround" . targetkey . destkey . s:input, l:count)
		else
			silent! call repeat#set("\<Plug>ChangeSurroundLinewise" . targetkey . destkey . s:input, l:count)
		endif
	else
		silent! call repeat#set("\<Plug>DeleteSurround" . targetkey, l:count)
	endif
endfunction

" a:type is setup to set opfunc
" When used as opfunc, a:type is one of the 'line', 'char' and 'block'
" it's 'visual' when called directry from vmap
function! s:opfunc(type, ...)
	if a:type ==# 'setup'
		let &opfunc = matchstr(expand('<sfile>'), '<SNR>\w\+$')
		return 'g@'
	endif
	let linewise = a:0 != 0 && a:1 == 1

	call s:save()

	" yank target
	if a:type ==# 'visual'
		let visualmode = visualmode()
		let visualkey = substitute(visualmode, '\d\+$', '', '')
		execute 'normal! `<' . visualkey . '`>y'
	else
		if a:type ==# 'line'
			let visualkey = 'V'
		elseif a:type ==# 'char'
			let visualkey = 'v'
		elseif a:type ==# 'block'
			let visualkey = ''
		endif
		execute 'normal! `[' . visualkey . '`]y'
	endif
	let keeper = getreg('"')
	let regtype = getregtype('"')

	" determine dest
	let [s:null, success_p, destkey] = s:getinput(0)
	if success_p
		if destkey ==# 'T'
			let destkey = 't'
		endif
		let destpat = b:surround_dict_full[destkey]
		let [newbefore, newafter] = s:process_dest(destkey, destpat)
	else
		let destpat = destkey
		let [newbefore, newafter] = [destkey, destkey]
	endif
	if destpat ==# ''
		return s:beep()
	endif
	let regtype = 'v'
	if linewise == 1
		let regtype = 'V'
	endif

	" make dest
	if a:type ==# 'visual' && visualkey ==# ''
		let keeper = substitute(keeper, '^', s:string2pattern(newbefore), '')
		let keeper = substitute(keeper, '\n', s:string2pattern(newafter) . '\n' . s:string2pattern(newbefore), 'g')
		let keeper = substitute(keeper, '$', s:string2pattern(newafter), '')
		let regtype = visualmode
	else
		let keeper = newbefore . keeper . newafter
	endif

	call s:put_and_restore(keeper, regtype)
	if a:type =~ '^\d\+$'
		if a:0 && a:1
			silent! call repeat#set("\<Plug>SurroundaLineLinewise".destkey.s:input,a:type)
		else
			silent! call repeat#set("\<Plug>SurroundaLine".destkey.s:input,a:type)
		endif
	else
		silent! call repeat#set("\<Plug>SurroundRepeat".destkey.s:input)
	endif
endfunction

function! s:opfuncLinewise(type, ...)
	if a:type ==# 'setup'
		let &opfunc = matchstr(expand('<sfile>'), '<SNR>\w\+$')
		return 'g@'
	endif
	call s:opfunc(a:type, 1)
endfunction

function! s:save()
	let s:save_clipboard = &clipboard
	set clipboard-=unnamed clipboard-=unnamedplus
	let s:save_reg = getreg('"')
	let s:save_regtype = getregtype('"')
	let s:saved = 1
endfunction

function! s:restore()
	if exists('s:saved') && s:saved == 1
		let &clipboard = s:save_clipboard
		call setreg('"', s:save_reg, s:save_regtype)
	endif
	let s:saved = 0
endfunction

function! s:put_and_restore(keeper, regtype)
	call setreg('"', a:keeper, a:regtype)
	normal! gvp
	call s:reindent()
	normal! `<
	if exists('b:surround_putcursorafter') ? b:surround_putcursorafter
			\ : (exists('g:surround_putcursorafter') && g:surround_putcursorafter)
		normal! `>
		call search('.')
	endif
	call s:restore()
endfunction

" helpers
function! s:extractbefore(str)
	return matchstr(a:str,'.*\ze\\r')
endfunction

function! s:extractafter(str)
	return matchstr(a:str,'\\r\zs.*')
endfunction

function! s:search_literally(pattern, flags)
	return search(s:literalize_pattern(a:pattern), a:flags)
endfunction

function! s:literalize_pattern(pattern)
	return '\V'.substitute(a:pattern, '\', '\\', 'g')
endfunction

" two backslashes to one
function! s:pattern2string(pattern)
	let pattern = substitute(a:pattern, '\\\\', '\', 'g')
	let pattern = substitute(pattern, '\\n', "\n", 'g')
	let pattern = substitute(pattern, '\\t', "\t", 'g')
	return pattern
endfunction

function! s:string2pattern(string)
	return substitute(a:string, '\\', '\\\\', 'g')
endfunction

function! s:reindent()
	if exists("b:surround_enable_reindent") ? b:surround_enable_reindent
			\ : (!exists("g:surround_enable_reindent") || g:surround_enable_reindent)
		normal! gv=
	endif
endfunction

function! s:beep()
	call s:restore()
	normal! "\<Esc>"
	return ""
endfunction


nnoremap <silent> <Plug>SurroundRepeat		.
nnoremap <silent> <Plug>DeleteSurround		:<C-U>call <SID>dosurround(0)<CR>
nnoremap <silent> <Plug>ChangeSurround		:<C-U>call <SID>dosurround(1)<CR>
nnoremap <silent> <Plug>ChangeSurroundLinewise	:<C-U>call <SID>dosurround(2)<CR>

" visual
vnoremap <silent> <Plug>VisualSurround		:<C-U>call <SID>opfunc('visual')<CR>
vnoremap <silent> <Plug>VisualSurroundLinewise	:<C-U>call <SID>opfuncLinewise('visual')<CR>

" linewise
nnoremap <expr>   <Plug>SurroundaLine		'^'.v:count1.<SID>opfunc('setup').'g_'
nnoremap <expr>   <Plug>SurroundaLineLinewise	<SID>opfuncLinewise('setup').'_'
" characterwise
nnoremap <expr>   <Plug>Surround		<SID>opfunc('setup')
nnoremap <expr>   <Plug>SurroundLinewise	<SID>opfuncLinewise('setup')

if !exists("g:surround_enable_default_mappings") || g:surround_enable_default_mappings == 0
	nmap ds   <Plug>DeleteSurround
	nmap cs   <Plug>ChangeSurround
	nmap cS   <Plug>ChangeSurroundLinewise
	nmap ys   <Plug>Surround
	nmap yS   <Plug>SurroundLinewise
	nmap yss  <Plug>SurroundaLine
	nmap ySs  <Plug>SurroundaLineLinewise
	nmap ySS  <Plug>SurroundaLineLinewise
	xmap S    <Plug>VisualSurround
	xmap gS   <Plug>VisualSurroundLinewise
	nmap ysa` ys2i`
	nmap ysa" ys2i"
	nmap ysa' ys2i'
endif

let &cpo = s:save_cpo
unlet! s:save_cpo

" vim: foldmethod=marker noexpandtab
