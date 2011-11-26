'R E A D M E
'��� ������ ������� ���������� ��������� 7zip � Blat!
'� ������ ������� ��� ����� ����������� full �����
'������ ����������� ���� � ������ -F ���� -D. F - FULL   D - differencial
Public SourceArray(100), BackupNameArray(100)  ,Destination, AmountOfCopiesMonthFullBackup , AmountOfCopiesFullBackup, AmountOfCopiesDiffBackup
Public TempDir, LogDir, SMTPServer, SenderName, AutName, Password ,CountOfSourceArray, CountOfBackupNameArray, Dir7Zip, DirBlat
Public IDOperation, NameOperation, ReturnIDGoodOperation, ReturnIDBadOperation, RecepientGood, RecepientBad 
Public flagDestination, flagLogDir, flag7ZipLogFile, DateStartOperation, CurrentAmountOfCopies, FolderForSearch
Public BackupType, ErrorArray(100), errorFlag, TmpLog(100)

errorFlag = false 	
DateStartOperation = Mid(Date, 7, 4) + "-" + Mid(Date, 4, 2) + "-" + Mid(Date, 1, 2)	'��������� � ������ ������ ������� ���� � ������ �������. ��� �������� ����� �������������� �� ���� ���� �������, ����� �� ���� �������������� �� ������� �������� ������
For z= 0 to 100 step 1							'�������� ������ � ��������
	ErrorArray(z) = "0"
Next
For z= 0 to 100 step 1
	TmpLog(z) = 0
Next

FormStartConfig()			
DefineBackupType()
Set fsoALL = CreateObject("Scripting.FileSystemObject")
Set LogFileStreamOut = fsoALL.OpenTextFile(LogDir + BackupType + "_" + DateStartOperation + ".log", 8, true, 0 )
LogFileStreamOut.WriteLine now() & " Start operation"
LogFileStreamOut.WriteLine now() & " RunBackup()"
RunBackup()
LogFileStreamOut.WriteLine now() & " DeleteOldBackup()"
DeleteOldBackup()
LogFileStreamOut.WriteLine now() & " Start send message"
LogFileStreamOut.Close
SendErrorMessage()
DelLog()

Sub FormStartConfig() '�������� ���� ��������� �������� � ��������
	For i= 0 to 100 step 1
		SourceArray(i) = 0
	Next
	For i = 0 to 100 step 1
		BackupNameArray(i) = 0
	Next							
	Dir7Zip = 0				
	DirBlat = 0				
	Destination = 0				
	AmountOfCopiesMonthFullBackup = 0	
	AmountOfCopiesFullBackup = 0					
	AmountOfCopiesDiffBackup = 0					
	LogDir = 0				
	TempDir = 0
	'��������� �������� �����������
	SMTPServer = 0					
	SenderName = 0				
	AutName = 0					
	Password = 0	
	'�� ���������� ������ ��������
	IDOperation = 0								
	NameOperation = 0						
	ReturnIDGoodOperation = 0					
	ReturnIDBadOperation = 0					
	RecepientGood = 0	
	RecepientBad = 0
	Dim fsoFSC
	Dim TempString '���������� ��� �������� ������� ������
	Dim CountSA '������� ��� ������� ����������
	CountSA = 0
	Dim CountBNA '������� ��� ������� ���� ��� �������
	CountBNA = 0
	Set fsoFSC = CreateObject("Scripting.FileSystemObject")
	If fsoFSC.FileExists("BackupConfig.ini") Then
		Set ConfigFileStreamIn =fsoFSC.OpenTextFile("BackupConfig.ini", 1 , false, 0 )
		Do While ConfigFileStreamIn.AtEndOfStream <> True
			TempString = ConfigFileStreamIn.ReadLine
			If Left(TempString, 1) <> "'" or Left(TempString, 1) <> "#" or Left(TempString, 1) <> ";" Then
				If Left(TempString, 7) = "Source=" Then				
					If SourceArray(CountSA) = 0 Then  
						SourceArray(CountSA) = Mid(TempString, 8)
						CountSA = CountSA+1
					End IF
				End If
				If Left(TempString, 11) = "BackupName=" Then
					If BackupNameArray(CountBNA) = 0 Then
						BackupNameArray(CountBNA) = Mid(TempString, 12)
						CountBNA = CountBNA+1
					End If
				End If
				If Left(TempString, 12) = "Destination=" Then
					If Destination = 0 Then	
						Destination = Mid(TempString, 13)
					End If
				End If
				If Left (TempString,30) = "AmountOfCopiesMonthFullBackup=" Then
					If AmountOfCopiesMonthFullBackup = 0 Then
						AmountOfCopiesMonthFullBackup = Mid (TempString, 31)
					End If
				End If
				If Left(TempString, 25) = "AmountOfCopiesFullBackup=" Then
					If AmountOfCopiesFullBackup = 0 Then
						AmountOfCopiesFullBackup = Mid(TempString, 26)
					End If
				End If	
				If Left(TempString, 25) = "AmountOfCopiesDiffBackup=" Then
					If AmountOfCopiesDiffBackup = 0 Then
						AmountOfCopiesDiffBackup = Mid(TempString, 26)
					End If
				End If
				If Left(TempString, 8) = "TempDir="	Then
					If TempDir = 0 Then
						If Mid(TempString, 9) <> "" Then
							TempDir = Mid(TempString, 9)
						Else
							TempDir = Destination
						End If
					End If	
				End If	
				If Left(TempString, 7) = "LogDir=" Then
					If LogDir = 0 Then
						If Mid(TempString, 8) <>"" Then
							LogDir = Mid(TempString, 8)
						Else
							LogDir = Destination + "LogDir\"
						End If
					End If
				End If
				
				If Left(TempString, 11) = "SMTPServer=" Then
					If SMTPServer = 0 Then
						SMTPServer = Mid(TempString, 12)
					End If
				End If
				If Left(TempString, 11) = "SenderName=" Then
					If SenderName = 0 Then
						SenderName = Mid (TempString, 12)
					End If
				End If
				If Left(TempString, 8) = "AutName=" Then
					If AutName = 0 Then
						AutName = Mid(TempString, 9)
					End If
				End If
				If Left(TempString, 9) = "Password=" Then
					If Password = 0 Then
						Password = Mid(TempString, 10)
					End If
				End If
				If Left(TempString, 14) = "RecepientGood=" Then
					If RecepientGood = 0 Then
						RecepientGood = Mid(TempString, 15)
					End If
				End If
				If Left (TempString, 13) = "RecepientBad=" Then
					If RecepientBad = 0 Then
						RecepientBad = Mid(TempString, 14)
					End If
				End If
				If Left(TempString, 8) = "Dir7Zip=" Then
					If Dir7Zip = 0 Then
						If Mid(TempString,9) <> "" Then
							Dir7Zip = Mid(TempString,9)
						Else
							Dir7Zip = "C:\Program Files\7-Zip\"
						End If
					End If
				End If
				If Left(TempString, 8) = "DirBlat=" Then
					If DirBlat = 0 Then
						If Mid(TempString,9) <> "" Then
							DirBlat = Mid(TempString,9)
						Else
							DirBlat = "C:\Program Files\Blat\"
						End If
					End If
				End If				
				If Left (TempString, 12) = "IDOperation=" Then
					If IDOperation = 0 Then
						IDOperation = Mid(TempString, 13)
					End If
				End If
				If Left (TempString, 14) = "NameOperation=" Then
					If NameOperation = 0 Then
						NameOperation = Mid(TempString, 15)
					End If
				End If
				If Left (TempString, 22) = "ReturnIDGoodOperation=" Then
					If ReturnIDGoodOperation = 0 Then
						ReturnIDGoodOperation = Mid(TempString, 23)
					End If
				End If
				If Left (TempString, 21) = "ReturnIDBadOperation=" Then
					If ReturnIDBadOperation = 0 Then
						ReturnIDBadOperation = Mid(TempString, 22)
					End If
				End If
			End If
		Loop
	CountOfSourceArray = CountSA-1
	CountOfBackupNameArray = CountBNA-1
	End If
End Sub


Sub DefineBackupType() '��������� ���������� ���� � ������� ������� ������. ���� -d, �� ����������� ���� �����, � ���� -f �� ���������, ������� �� � ���� ������ monthbackup
	BackupType = 0
	If WScript.Arguments(0) = "-F" or WScript.Arguments(0) = "-f" Then
		If AmountOfCopiesMonthFullBackup <> "" Then
			Dim ArrayOfMonthBackup(100), FolerForSearch, fc, f,countDBT, fso
			For n= 0 to 100 step 1
				ArrayOfMonthBackup(n) = 0
			Next
			rem ���� ��� ����� � ����� ������������ � BackupNameArray(0)-MonthFull � ���������� ���� � ������ ��� ����������� ���������
			countDBT = 0
			Set fso = CreateObject("Scripting.FileSystemObject")
			Set FolderForSearch = fso.GetFolder(Destination)
			Set fc = FolderForSearch.Files
			For Each f in fc
				If BackupNameArray(0) + "-" + "MonthFull" + "-" = Left (f.name, Len(BackupNameArray(0)+"-MonthFull-")) Then
					ArrayOfMonthBackup(countDBT) = f.DateLastModified
					countDBT=countDBT+1					
				End If				
			Next
			If ArrayOfMonthBackup(0) = 0 Then			'���� �� ���� ����������� ����� �� ���������, ������ ������� �������� ����� ��������
				BackupType = "MonthFull"
				CurrentAmountOfCopies = AmountOfCopiesMonthFullBackup
			Else										'����� ���� ��������� �������� �����
				rem ��������� ���������� ���� �� ��������(����� ������� - ������ ������� �������)
				t=true
				Do While t=true
					t=false
					For n= 0 to countDBT step 1
						If ArrayOfMonthBackup(n)<ArrayOfMonthBackup(n+1) Then
							temp=ArrayOfMonthBackup(n)
							ArrayOfMonthBackup(n) = ArrayOfMonthBackup(n+1)
							ArrayOfMonthBackup(n+1) = temp
							t=true
						End If
					Next
				Loop
				If Mid(ArrayOfMonthBackup(0), 4, 2) = Mid(Date, 4, 2) Then	'���� � ���� ������ ��� ������ ����������� �����, �� ������� ����� ����� ������� ������
					BackupType = "Full"
					CurrentAmountOfCopies = AmountOfCopiesFullBackup
				End If
				If Mid(ArrayOfMonthBackup(0), 4, 2) <> Mid(Date, 4, 2) Then	'����� ������� ����� ����� �������� ��������
					BackupType = "MonthFull"
					CurrentAmountOfCopies = AmountOfCopiesMonthFullBackup
				End If
			End If	
		Else
			BackupType = "Full"
			CurrentAmountOfCopies = AmountOfCopiesFullBackup
		End If
	End If
	If Wscript.Arguments(0) = "-D" or WScript.Arguments(0) = "-d" Then	'���� ���� -d �� ������� ����� - ����������������
		BackupType = "Diff"	
		CurrentAmountOfCopies = AmountOfCopiesDiffBackup
	End If
End Sub



'��������� ��������� ��� ���� Source ��������������� ��������� �������������, �.� ����� ���������� ��������� - �� ���������� ������
Sub RunBackup()		'� ����������� �� ���� ,������ 7��� ����������� � ������� �����������
	Dim WshShell, CountRB, fso
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set WshShell = WScript.CreateObject("WScript.Shell")
	CountRB = CountOfSourceArray
	WshShell.CurrentDirectory = TempDir
	Cmd = "cmd.exe /C"
	Program7Zip = Chr(34) + Dir7Zip + "7z.exe" + Chr(34)
	LogFileStreamOut.WriteLine now() & " Operation Backup start, Type=" & BackupType
	If BackupType = "Full" or BackupType = "MonthFull" Then
		For i = 0 to CountRB step 1			
			ArchiveName = BackupNameArray(i) + "-" + BackupType + "-"
			CommandLine7Zip = (Cmd + " " + Chr(34) + Program7Zip + " a -t7z -ssw -mx9 -r0 -w" + Chr(34) + TempDir + Chr(34) + " " + Chr(34) + Destination + ArchiveName + DateStartOperation + ".7z" + Chr(34) + " " + Chr(34) + SourceArray(i) + Chr(34)    + " >> " + Chr(34) + LogDir + "7ZIP" + ArchiveName + DateStartOperation + ".log" + Chr(34) + Chr(34) )			
			LogFileStreamOut.WriteLine now() & " Backup " & SourceArray(i) & " to " & Destination & ArchiveName & DateStartOperation & ".7z" & " started"
			WshShell.Run CommandLine7Zip, 0, true
			Anylize7ZipLog(ArchiveName)
			LogFileStreamOut.WriteLine now() & " Backup " & SourceArray(i) & " to " & Destination & ArchiveName & DateStartOperation & ".7z" & " finished"
			Set backupFile = fso.GetFile(Destination + ArchiveName + DateStartOperation + ".7z")
			sizeBackupFile = backupFile.Size
			LogFileStreamOut.WriteLine now() & " #analitics# " & IDOperation & " #backupsize# " & ArchiveName & DateStartOperation & ".7z " & sizeBackupFile & " bytes"
		Next
	End If
	If BackupType = "Diff" Then
		Set FolderForSearch = fso.GetFolder( Destination )
		Set fc = FolderForSearch.Files
		Dim TempArray(100)
		For i = 0 to CountRB step 1
			ArchiveName = BackupNameArray(i) + "-" + BackupType + "-"			
			For b = 0 to 100 step 1
				TempArray(b)="0"
			Next
			rem ���� ��� ����� � ����� ������������ � BackupName � ���������� ���� � ������ ��� ����������� ���������
			x=0
			For Each f in fc
				If BackupNameArray(i) + "-" + "Full" + "-" = Left (f.name, Len(BackupNameArray(i) + "-" + "Full" + "-")) or BackupNameArray(i) + "-" + "MonthFull" + "-" = Left (f.name, Len(BackupNameArray(i) + "-" + "MonthFull" + "-")) Then
					TempArray(x) = f.DateLastModified					
					x=x+1					
				End If							
			Next
			t=true
			Do While t=true
				t=false
				For n= 0 to x-2	step 1
					If TempArray(n)<TempArray(n+1) Then
						temp=TempArray(n)
						TempArray(n) = TempArray(n+1)
						TempArray(n+1) = temp
						t=true
					End If
				Next
			Loop
			Dim LastFullBackup
			For Each f in fc
				If BackupNameArray(i) + "-" + "Full" + "-" = Left (f.name, Len(BackupNameArray(i) + "-" + "Full" + "-")) or BackupNameArray(i) + "-" + "MonthFull" + "-" = Left (f.name, Len(BackupNameArray(i) + "-" + "MonthFull" + "-")) Then				
					If f.DateLastModified = TempArray(0) Then
						LastFullBackup =f.Name
					End If
				End If
			Next
			CommandLine7Zip = (Cmd + " " + Chr(34) + Program7Zip + " u " + Chr(34) + Destination + LastFullBackup + Chr(34) + " -w" + Chr(34) + TempDir + Chr(34) + " -u- -up0q3r2x2y2z0w2!" + Chr(34) + Destination + ArchiveName + DateStartOperation + ".7z"  + Chr(34) + " -t7z -ssw -mx9 -r0" + " " + Chr(34) + SourceArray(i) + Chr(34) + " >> " + Chr(34) + LogDir + "7ZIP" + ArchiveName + DateStartOperation + ".log" + Chr(34) + Chr(34) )
			LogFileStreamOut.WriteLine now() & " Backup " & SourceArray(i) & " to " & Destination & ArchiveName & DateStartOperation & ".7z" & " started"
			WshShell.Run CommandLine7Zip, 0, true
			Anylize7ZipLog(ArchiveName)
			LogFileStreamOut.WriteLine now() & " Backup " & SourceArray(i) & " to " & Destination & ArchiveName & DateStartOperation & ".7z" & " finished"
			Set backupFile = fso.GetFile(Destination + ArchiveName + DateStartOperation + ".7z")
			sizeBackupFile = backupFile.Size
			LogFileStreamOut.WriteLine now() & " #analitics# " & IDOperation & " #backupsize# " & ArchiveName & DateStartOperation & ".7z " & sizeBackupFile & " bytes"
		Next
	End If
End Sub


'������������� ����� ����� ��� ������� ������ � ��������� �� �� ���������� ������ ���� ��� ������ ����������
Sub Anylize7ZipLog(ArchiveName)
	Dim fso, logFileStreamIn, LogFileIn, GarbageMessage, CountA7ZL
	GarbageMessage = "Compressing "
	OKMessage = "Everything is Ok"
	Set fso = CreateObject("Scripting.FileSystemObject")
		OKflag = false
		Set LogFileStreamIn =fso.OpenTextFile(LogDir + "7ZIP" + ArchiveName + DateStartOperation + ".log",  1 , false, 0  )
		Set LogFileIn =fso.GetFile(LogDir + "7ZIP" + ArchiveName + DateStartOperation + ".log")		
		Do While LogFileStreamIn.AtEndOfStream <> True
			TempLine = LogFileStreamIn.ReadLine
			If GarbageMessage <> Left(TempLine, Len(GarbageMessage)) And TempLine <> "" Then
				LogFileStreamOut.WriteLine TempLine
			End If 			
			If OKMessage = Left(TempLine, Len(OKMessage)) Then
				OKflag = true
			End If
		Loop
		If OKflag = false Then
			errorFlag = true
			LogFileStreamOut.WriteLine now() & " Error: 7-Zip process completed with errors"
		End If
		LogFileStreamIn.Close
		LogFileIn.Delete
End Sub


Sub DeleteOldBackup()		'��������� �������� ������ �������
	If errorFlag = false Then
		LogFileStreamOut.WriteLine now() & " errorFlag = false. There are no errors, and thus start the deletion of old backup."
		Dim ArrayOfOldBackup(100), fso,fc,f,i
		CountDOB = CountOfSourceArray
		Set fso = CreateObject("Scripting.FileSystemObject")
		Set FolderForSearch = fso.GetFolder( Destination )
		Set fc = FolderForSearch.Files
		For i = 0 to CountDOB step 1
			For n= 0 to 100 step 1
				ArrayOfOldBackup(n) = 0
			Next
			rem ���� ��� ����� � ����� ������������ � BackupName � ���������� ���� � ������ ��� ����������� ���������
			x=0
			For Each f in fc
				If BackupNameArray(i) + "-" + BackupType + "-" = Left (f.name, Len(BackupNameArray(i) + "-" + BackupType + "-")) Then
					ArrayOfOldBackup(x) = f.DateLastModified
					x=x+1					
				End If				
			Next
			rem ��������� ���������� ���� �� ��������(����� ������� - ������ ������� �������
			t=true
			Do While t=true
				t=false
				For n= 0 to x step 1
					If ArrayOfOldBackup(n)<ArrayOfOldBackup(n+1) Then
						temp=ArrayOfOldBackup(n)
						ArrayOfOldBackup(n) = ArrayOfOldBackup(n+1)
						ArrayOfOldBackup(n+1) = temp
						t=true
					End If
				Next
			Loop
			rem ������� ����� �������, ��������� CurrentAmountOfCopies ��������� �����
			Copies = CurrentAmountOfCopies+1
			For n=0 to x step 1
				Copies=Copies-1
				If Copies=0 Then
					'������� ���� � ����� ����������� �� �������� �������
					For Each f in fc
						If BackupNameArray(i) + "-" + BackupType + "-" = Left (f.name, Len(BackupNameArray(i) + "-" + BackupType + "-")) Then
							If f.DateLastModified = ArrayOfOldBackup(n) Then
								LogFileStreamOut.WriteLine  now() & " DELETE backup file " & Destination & f.Name
								f.Delete
							End If
						End If
					Next	
				End If
			Next
		Next
	Else
		LogFileStreamOut.Writeline now() & " errorFlag = true. There are errors, and thus miss the deletion of old backup."	
	End If
End Sub
		
Sub SendErrorMessage()	'� ����������� �� �������� ���������� errorFlag ���������� ������ ��������� �� ������ �����
	Set WshShell = WScript.CreateObject("WScript.Shell")
	WshShell.Exec "C:\BackupScript\stunnel\stunnel.exe"
	If AutName = "" Then
		AutNameCommand = ""
		PasswordCommand = ""
	Else
		AutNameCommand = " -u " +  Chr(34) +  AutName +  Chr(34)
		PasswordCommand = " -pw " +  Chr(34) +  Password + Chr(34)
	End If
	If errorFlag = false Then
		CurrentRecepient = RecepientGood
		CurrentReturnID = ReturnIDGoodOperation
	End If
	If errorFlag = true Then
		CurrentRecepient = RecepientBad
		CurrentReturnID = ReturnIDBadOperation
	End If
	CommandLineBlat =  Chr(34) + DirBlat + "blat.exe" +  Chr(34) +  " " + " -subject " + Chr(34) + NameOperation + Chr(34) + " -body " + Chr(34) + NameOperation + Chr(34) + " -attach " + Chr(34) + LogDir + BackupType + "_" + DateStartOperation + ".log" + Chr(34) + " -to " +  Chr(34) +  CurrentRecepient +  Chr(34) +  " -server " +  Chr(34) +  SMTPServer +  Chr(34) +  " -f " +  Chr(34) +  SenderName +  Chr(34) +  AutNameCommand +  PasswordCommand + " -log " +Chr(34) + LogDir + "blat-" + DateStartOperation + ".log" + Chr(34)
	WshShell.Run CommandLineBlat, 0, true
	WshShell.Exec "C:\BackupScript\stunnel\stunnel.exe -exit"
End Sub


 Sub DelLog()
	If errorFlag = false Then
		Set fsoDL = CreateObject("Scripting.FileSystemObject")
		Set LogFileOut =fsoDL.GetFile(LogDir + BackupType + "_" + DateStartOperation + ".log")
		Set LogFileBlat =fsoDL.GetFile(LogDir + "blat-" + DateStartOperation + ".log")
		LogFileOut.Delete
		LogFileBlat.Delete
	End If
 End Sub