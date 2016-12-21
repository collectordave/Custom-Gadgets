
IncludeFile "CustomGadget.pbi"


Enumeration FormGadget
  #btnRedraw  
  #CustomGadget1
  #CustomGadget2
EndEnumeration

Global Window_0,CustomGadget3.i,CustomGadget4.i

  Window_0 = OpenWindow(#PB_Any, 0, 0, 600, 400, "", #PB_Window_SystemMenu)
  CustomGadget(#CustomGadget1,250, 40, 130, 80,0)
  CustomGadget(#CustomGadget2,100, 40, 130, 80,0)  
  CustomGadget3 = CustomGadget(#PB_Any,100, 240, 130, 80,0)
  CustomGadget4 = CustomGadget(#PB_Any,250, 240, 130, 80,#PB_Canvas_Keyboard | #PB_Canvas_DrawFocus)
  ButtonGadget(#btnRedraw, 470, 340, 70, 30, "")
  
  Repeat
    
  Event = WaitWindowEvent()
    
  Select Event
    Case #PB_Event_CloseWindow
      
      End

    Case #PB_Event_Gadget

      Select EventGadget()
          
        Case #btnRedraw

          ResizeGadget(CustomGadget3,10,200,100,#PB_Ignore)
          
        Case #CustomGadget1

          Select EventData()
              
            Case CustomGadget::#CgEvent1
              Debug "Main Gadget 0 Event 1"
              
            Case CustomGadget::#CgEvent2
              Debug "Main Gadget 0 Event 2" 
              
             Case CustomGadget::#CgEvent3
              Debug "Main Gadget 0 Event 3"              
              
          EndSelect        
          
        Case #CustomGadget2

          Select EventData()
              
            Case CustomGadget::#CgEvent1
              Debug "Main Gadget 1 Event 1"
              
            Case CustomGadget::#CgEvent2
              Debug "Main Gadget 1 Event 2" 
              
             Case CustomGadget::#CgEvent3
              Debug "Main Gadget 1 Event 3"              
              
          EndSelect          
          
        Case CustomGadget3

          Select EventData()
              
            Case CustomGadget::#CgEvent1
              Debug "Main Gadget 2 Event 1"
              
            Case CustomGadget::#CgEvent2
              Debug "Main Gadget 2 Event 2" 
              
             Case CustomGadget::#CgEvent3
              Debug "Main Gadget 2 Event 3"              
              
          EndSelect
          
         Case CustomGadget4

          Select EventData()
  
            Case CustomGadget::#CgEvent1
              Debug "Main Gadget 3 Event 1"
              
            Case CustomGadget::#CgEvent2
              Debug "Main Gadget 3 Event 2" 
              
             Case CustomGadget::#CgEvent3
              Debug "Main Gadget 3 Event 3"              
              
          EndSelect       
          
          
          
      EndSelect
  
  EndSelect
  
ForEver
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 34
; FirstLine = 21
; EnableXP