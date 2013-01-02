# url.txt should contain the URL load in Chrome in full screen.

do shell script "open '/Applications/Google Chrome.app' " & readFile("/url.txt")
tell application "Google Chrome" to activate
tell application "System Events"
	keystroke "f" using {command down, shift down}
end tell

# All this just to read a file; no backticks in AppleScript.
on readFile(unixPath)
	set foo to (open for access (POSIX file unixPath))
	# "class utf8" should be enclosed in Guillemets, which ironically are not represented in UTF-8 in the AppleScript Editor. Type them with Option-Backslash and Option-Shift-Backslash respectively.
	set txt to (read foo for (get eof foo) as Çclass utf8È)
	close access foo
	return txt
end readFile
