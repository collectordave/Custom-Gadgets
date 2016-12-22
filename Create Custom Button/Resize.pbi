Procedure _ResizeGadget(Gadget, x, y, Width, Height)
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas 
        Window = GetGadgetData(Gadget)  
        If IsWindow(Window)   
          ResizeGadget(Gadget, x, y, Width, Height)
          PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_Event_FirstCustomValue, 15)
        EndIf        
    EndIf
  EndIf
  
EndProcedure

Macro ResizeGadget(Gadget, x, y, Width, Height)
  _ResizeGadget(Gadget, x, y, Width, Height)
EndMacro
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP