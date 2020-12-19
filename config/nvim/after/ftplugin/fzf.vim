" Use Agi to ignore file names and match only the content
command! -bang -nargs=* Agi call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
