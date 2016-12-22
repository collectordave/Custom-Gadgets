UsePNGImageDecoder()

IncludeFile "MyButton.pbi"

Global Window_0,MyButtonState.i

Enumeration
  #winmain
  #MyButton
  #btnEnable
EndEnumeration

OpenWindow(#winmain, 0, 0, 600, 400, "My Button Test", #PB_Window_SystemMenu)
ButtonGadget(#btnEnable, 390, 130, 80, 30, "Change State")
MyButton(#MyButton,40,40,32,32,0)

MyButtonState = #True ;Disabled

Repeat
  Select WaitWindowEvent()
  
    Case #PB_Event_CloseWindow
      End
   
    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()
        Case #MyButton
          Select EventData()
            Case MyButton::#ButtonClick
              Debug "Button Clicked"
           EndSelect   
         Case #btnEnable
           iLoop = iLoop + 10
           ResizeGadget(#MyButton,100,100,iLoop,100)
           If MyButtonState = #True
             MyButtonState = #False
             DisableMyButton(#MyButton,#False)
           Else
             MyButtonState = #True
             DisableMyButton(#MyButton,#True)  
           EndIf
           
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 2
; FirstLine = 21
; EnableXP