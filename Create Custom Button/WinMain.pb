UsePNGImageDecoder()

Enumeration 
  #WinMain
  #btnCreate
  #btnCancel
  #txtTitle
  #strTitle
  #txtImage
  #imgForButton
  #btnSelect
EndEnumeration

Global OriginalImage.i
Global ButtonTitle.s,ImageName.s

Procedure SetFormTexts()
  
  SetWindowTitle(#WinMain, "Create Button")
  SetGadgetText(#btnCreate, "Create")
  SetGadgetText(#btnCancel, "Cancel")
  SetGadgetText(#txtTitle, "Button Name")
  SetGadgetText(#txtImage, "Image")
  SetGadgetText(#btnSelect, "Select")
  GadgetToolTip(#btnSelect, "Select Image")
  
EndProcedure

Procedure LoadOriginal(FileName.s)
  
  OriginalImage = LoadImage(#PB_Any, FileName)
  ResizeImage(OriginalImage, 30, 30) ;Allows for pressed effect
  SetGadgetState(#imgForButton, ImageID(OriginalImage))
  
EndProcedure

 Procedure CheckCreatePath(Directory.s)

  BackSlashs = CountString(Directory, "\")
 
  Path$ = ""
  For i = 1 To BackSlashs + 1
    Temp$ = StringField(Directory.s, i, "\")
    If StringField(Directory.s, i+1, "\") > ""
      Path$ + Temp$ + "\"
    Else
      path$ + temp$
    EndIf
    CreateDirectory(Path$)
  Next i
  
EndProcedure

Procedure WriteButtonFile()

  Define LineRead.s
  Define NewFile.s,Replacement.s
  
  NewFile = GetCurrentDirectory() + ButtonTitle + "\" + ButtonTitle + ".pbi"
  
  ;Attempt To Read File
  LineNumber = 0
  If ReadFile(0, "CustomButton.pbi")
    ;Create Empty File 
    CreateFile(1, NewFile)
    While Eof(0) = 0
      LineRead = ReadString(0)
      LineRead = ReplaceString(LineRead,"MyButton",ButtonTitle)
      LineRead = ReplaceString(LineRead,"accept.png",ImageName)      
      ;Write Line To New File
      WriteStringN(1, LineRead)
    Wend
    CloseFile(0)
    CloseFile(1) 
  Else
    
    ProcedureReturn -1
    
  EndIf  
  
EndProcedure

Procedure WriteProgrammeFile()

  Define LineRead.s
  Define NewFile.s,Replacement.s
  
  NewFile = GetCurrentDirectory() + ButtonTitle + "\WinMain.pb"
  
  ;Attempt To Read File
  LineNumber = 0
  If ReadFile(0, "MyButtonMain.pb")
    ;Create Empty File 
    CreateFile(1, NewFile)
    While Eof(0) = 0
      LineRead = ReadString(0)
      LineRead = ReplaceString(LineRead,"MyButton",ButtonTitle)
      ;Write Line To New File
      WriteStringN(1, LineRead)
    Wend
    CloseFile(0)
    CloseFile(1) 
  Else
    
    ProcedureReturn -1
    
  EndIf  
  
EndProcedure

OpenWindow(#WinMain, 0, 0, 350, 130, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
ButtonGadget(#btnCreate, 180, 90, 70, 30, "")
ButtonGadget(#btnCancel, 270, 90, 70, 30, "")
TextGadget(#txtTitle, 10, 10, 120, 20, "", #PB_Text_Right)
StringGadget(#strTitle, 140, 10, 200, 20, "")
TextGadget(#txtImage, 10, 40, 120, 20, "", #PB_Text_Right)
ImageGadget(#imgForButton, 140, 40, 32, 32, 0, #PB_Image_Border)
ButtonGadget(#btnSelect, 190, 40, 70, 30, "")
GadgetToolTip(#btnSelect, "")
  
SetFormTexts()

Define FileName.s

Repeat 
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End

    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case #btnCreate
          
          ;Create Folder For Button
          ButtonTitle = ReplaceString(GetGadgetText(#strTitle)," ","")
          CheckCreatePath(GetCurrentDirectory() + ButtonTitle)
          
          ;Copy Image To Folder
          CopyFile(FileName,GetCurrentDirectory() + ButtonTitle + "\" + GetFilePart(FileName))
          
          ;Rewrite Custom Gadget.pbi
          WriteButtonFile()
          CopyFile("Resize.pbi",GetCurrentDirectory() + ButtonTitle + "\Resize.pbi")
          WriteProgrammeFile()
          
        Case #btnCancel
          
          End
          
        Case #btnSelect
          
          FileName = OpenFileRequester("Please choose image to load", "C:\", "Images (*.png)|*.png", 0)
          If FileName
            LoadOriginal(FileName)
            ImageName = GetFilePart(FileName)

          EndIf        
          
          
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 78
; FirstLine = 90
; Folding = -
; EnableXP