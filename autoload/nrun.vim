" trim excess whitespace
function nrun#StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

" check for locally-installed executable before falling back to 'which'
function nrun#Which(cmd)
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
	return nrun#StrTrim(system('which ' . a:cmd))

endfunction

function! nrun#Exec(cmd)
	let l:exec = nrun#Which(a:cmd)
	if match(l:exec, 'not found$') != -1
		throw 'No command found'
	else
		return system(l:exec)
	endif
endfunction
