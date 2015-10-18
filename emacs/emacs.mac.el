;; set apple key as modifier
(setq mac-command-modifier 'meta)

;; make delete key delete forward on Mac OS X
(if (and (equal system-type 'darwin) window-system)
    (normal-erase-is-backspace-mode 1))

;; use same path as login shell on Mac OS X
(if (and (equal system-type 'darwin) window-system)
    (let ((path-from-shell 
	   (replace-regexp-in-string "[[:space:]\n]*$" "" 
				     (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
      (setenv "PATH" path-from-shell)
      (setq exec-path (split-string path-from-shell path-separator))))
