IncludeFile "OnOffButton.pbi"

Global Window_0,btnOnOff01

Enumeration
  #MainWindow
  #OnOff1
  #OnOff2
  #btnResize
EndEnumeration


OpenWindow(#MainWindow, 0, 0, 600, 400, "", #PB_Window_SystemMenu)
OnOffButton(#OnOff1,10,10,90,25)
SetOnOffButtonState(#OnOff1,#True)
OnOffButton(#OnOff2,200,100,90,25)
ButtonGadget(#btnResize,100,100,70,25,"Click")

Repeat
   
  Select WaitWindowEvent()
         
    Case #PB_Event_CloseWindow
      End
         
    Case #PB_Event_Gadget
      Select EventGadget()
           
        Case #btnResize
           
          ResizeGadget(#OnOff2,200,145,#PB_Ignore,#PB_Ignore)
          
        Case #OnOff1

          Select EventData()
              
             Case OnOffButton::#StateIsOn
               Debug "Button 1 Is On"
              
             Case OnOffButton::#StateIsOff
               Debug "Button 1 Is Off" 
              
           EndSelect
          
         Case #OnOff2

           Select EventData()
              
             Case OnOffButton::#StateIsOn
               Debug "Button 2 Is On"
              
             Case OnOffButton::#StateIsOff
               Debug "Button 2 Is Off" 
              
           EndSelect         
       EndSelect
      
    EndSelect
   
  ForEver
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 14
; FirstLine = 32
; EnableXP