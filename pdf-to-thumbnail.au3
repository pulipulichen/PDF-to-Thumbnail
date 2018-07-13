#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#pragma compile(Icon, 'icon.ico')

$imagemagick_cmd = IniRead ( @ScriptDir & "\config.ini", "config", "IMAGEMAGICK_CMD", "1" )
$imagemagick_format = IniRead ( @ScriptDir & "\config.ini", "config", "IMAGEMAGICK_FORMAT", "png" )
$fixed_filename = IniRead ( @ScriptDir & "\config.ini", "config", "FIXED_FILENAME", "" )
$do_recycle = IniRead ( @ScriptDir & "\config.ini", "config", "DO_RECYCLE", "false" )
; convert.exe paper.pdf paper.jpg

For $i = 1 To $CmdLine[0]
    IF FileExists($CmdLine[$i]) and StringInStr(FileGetAttrib($CmdLine[$i]),"D") Then
        $filesList = _FileListToArray($CmdLine[$i])
        For $j = 1 To $filesList[0]
		    $f = $CmdLine[$i] & '\' & $filesList[$j]
			FileCopy($f, $f & ".tmp")
			FileRecycle($f & ".tmp")
			$cmd = '"' & @ScriptDir & '\image_magick\convert.exe" "' & $f & '" ' & $imagemagick_cmd & ' "' & $f & '"'
            RunWait($cmd , @ScriptDir, @SW_HIDE)
        Next
	 Else
		$f = $CmdLine[$i]
		Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
		Local $aPathSplit = _PathSplit($f, $sDrive, $sDir, $sFileName, $sExtension)
		  IF $do_recycle == "true" Then
			  FileCopy($f, $f & ".tmp")
			  FileRecycle($f & ".tmp")
			  $cmd = '"' & @ScriptDir & '\image_magick\convert.exe" "' & $f & '[0]" ' & $imagemagick_cmd & ' "' & $f & '"'
			  ;MsgBox($MB_SYSTEMMODAL, "msg", $cmd)
		  ElseIf $fixed_filename <> "" Then
			  $cmd = '"' & @ScriptDir & '\image_magick\convert.exe" "' & $f & '[0]" ' & $imagemagick_cmd & ' "' & $sDir & $fixed_filename & '.' & $imagemagick_format &'"'
		  Else
			  $cmd = '"' & @ScriptDir & '\image_magick\convert.exe" "' & $f & '[0]" ' & $imagemagick_cmd & ' "' & $f & '.' & $imagemagick_format &'"'
		   EndIf
		   ;MsgBox($MB_SYSTEMMODAL, "msg", $cmd)
		  RunWait($cmd , @ScriptDir, @SW_HIDE)
    EndIf
Next