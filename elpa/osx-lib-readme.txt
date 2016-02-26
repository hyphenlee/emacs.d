Provides functions for:
  1. Running Apple Script / osascript
  2. Play beep
     (setq ring-bell-function #'osx-lib-do-beep)
  3. Notification functions
     (osx-lib-notify2 "Emacs" "Text Editor")
  4. Copying to/from clipboard
  5. Show the current file in Finder. Works with dired.
  6. VPN Connect/Disconnect
     (defun work-vpn-connect ()
       "Connect to Work VPN."
       (interactive)
       (osx-lib-vpn-connect "WorkVPN" "VPN_Password"))
  7. Use speech
     (osx-lib-say "Emacs")
