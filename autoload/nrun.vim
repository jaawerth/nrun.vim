" Settable options:
"   'g:nrun_disable_which' - disables "which" fallback
"   'g:nrun_which_cmd' - sets command for "which." default is simply "which",
"   available on all (?) UNIX shells.


" trim excess whitespace
function! nrun#StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

" check for locally-installed executable before falling back to 'which'
" takes a second optional arg for "which" fallback: 0 or v:valse will disable
" the fallback entirely, a string sets the fallback command. Alternatively,
" takes a dictionary with "disable_fallback" and "fallback_cmd" keys
function! nrun#Which(cmd, ...)
	let l:fallbackCmd = 'which'
	let l:disableFallback = exists('g:nrun_disable_which') && g:nrun_disable_which

	if exists('g:nrun_which_cmd')
		let l:fallbackCmd = g:nrun_which_cmd
	endif

	" optional args.
	if a:0 >= 1
		let l:optType = type(a:1)
		if optType == 0 || optType == 6
			let l:disableFallback = a:1
		elseif optType == 1
			let l:fallbackCmd = a:1
		endif
		unlet l:optType
	endif
	let l:cwd = getcwd()
	let l:rp = fnamemodify('/', ':p')
	let l:hp = fnamemodify('~/', ':p')
	while l:cwd != l:hp && l:cwd != l:rp
		if filereadable(resolve(l:cwd . '/package.json'))
			let l:execPath = fnamemodify(l:cwd . '/node_modules/.bin/' . a:cmd, ':p')
			if executable(l:execPath)
				return l:execPath
			else
				break
			endif
		endif
		let l:cwd = resolve(l:cwd . '/..')
	endwhile
	if !l:disableFallback
		let l:execPath = nrun#StrTrim(system(l:fallbackCmd . ' ' . a:cmd))
		if executable(l:execPath)
			return l:execPath
		else
			return a:cmd . ' not found'
		endif
	else
		return a:cmd . ' not found'
	endif
endfunction

function! nrun#Exec(cmd)
	let l:exec = nrun#Which(a:cmd)
	if match(l:exec, 'not found$') != -1
		throw l:exec
	else
		return system(l:exec)
	endif
endfunction
