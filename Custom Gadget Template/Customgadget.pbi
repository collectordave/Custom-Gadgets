;Resize.pbi needed to capture resize events

XIncludeFile "Resize.pbi"

DeclareModule CustomGadget
  
  ;{ ==Gadget Event Enumerations=================================
;        Name/title: Enumerations
;       Description: Part of custom gadget template
;                  : Enumeration of Custom Gagdet event constants 
;                  : Started at 100 to Avoid Using 0
;                  : as creation events etc can still be recieved
;                  : in main event loop
; ================================================================
;} 
  Enumeration 100
    #CgEvent1
    #CgEvent2
    #CgEvent3
  EndEnumeration
    
  ;Create the gadget procedure Only used by main gadget public procedure
  Declare CreateGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
  
EndDeclareModule

Module CustomGadget

  ;The Main Gadget Structure
  Structure MyGadget
    Window_ID.i
    Gadget_ID.i
  EndStructure
  Global Dim MyGadgetArray.MyGadget(0) 
  Global Currentgadget.i
  
  ;Required To Obtain Resize Events
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_Size
    #PB_EventType_Move
  EndEnumeration
   
  Procedure SetCurrentGadgetID(Gadget.i)
  ;{ ==Procedure Header Comment==============================
;        Name/title: GetgadgetID
;       Description: Part of custom gadget template
;                  : Procedure to return the MyGadgetArray() element number 
;                  : for the gadget on which the event occurred
; 
; ====================================================
;}     
    Define iLoop.i
    
    If Currentgadget <> gadget
    
      For iLoop = 0 To ArraySize(MyGadgetArray())

        If Gadget = MyGadgetArray(iLoop)\Gadget_ID

          CurrentGadget = iLoop
        
        EndIf
      
      Next iLoop 

    EndIf
  
  EndProcedure
  
  Procedure DrawGadget(Gadget.i)
  ;{ ==Procedure Header Comment==============================
  ;        Name/title: DrawGadget
  ;       Description: Part of custom gadget template
  ;                  : Procedure to draw the gadget on the canvas
  ; 
  ; ====================================================
  ;}    
    
    SetCurrentGadgetID(Gadget)
    
    
    
  EndProcedure 
     
  Procedure AddGadget(ThisWindow.i,ThisGadget.i)
 ;{ ==Procedure Header Comment==============================
;        Name/title: AddGadget
;       Description: Part of custom gadget template
;                  : Adds the Id of the newly created gadget to the gadget array
; ====================================================
;}

    MyGadgetArray(ArraySize(MyGadgetArray()))\Window_ID = ThisWindow
    MyGadgetArray(ArraySize(MyGadgetArray()))\Gadget_ID = ThisGadget
    ReDim MyGadgetArray(ArraySize(MyGadgetArray())+1)
    
  EndProcedure
  
  Procedure SendEvents(Event.i)
;{ ==Procedure Header Comment==============================
;        Name/title: SendEvents
;       Description: Part of custom gadget template
;                  : Used to send custom events to the main event loop
; ====================================================
;}   
    
    ;Post The Event
    PostEvent(#PB_Event_Gadget, MyGadgetArray(CurrentGadget)\Window_ID, MyGadgetArray(CurrentGadget)\Gadget_ID, #PB_Event_FirstCustomValue,Event)
    
 EndProcedure
    
  Procedure GadgetEvents()
  ;{ ==Procedure Header Comment==============================
;        Name/title: GadgetEvents
;       Description: Part of custom gadget template
;                  : Handles all events for this custom gadget
; ====================================================
;}
   
    SetCurrentGadgetID(EventGadget())
    
    ;Captures the custom event 15 which means this gadget has been resized or moved
     If EventData() = 15
      Debug "Reset"
      ;Fixed Size Gadget No resize
      If GadgetHeight(MyGadgetArray(CurrentGadget)\Gadget_ID) <> 32 Or GadgetWidth(MyGadgetArray(CurrentGadget)\Gadget_ID) <> 32
        ResizeGadget(MyGadgetArray(CurrentGadget)\Gadget_ID,#PB_Ignore,#PB_Ignore,32,32)
        DrawGadget(MyGadgetArray(CurrentGadget)\Gadget_ID)
      EndIf
    EndIf   
      
    Select EventType()
       
      Case #PB_EventType_MouseEnter
        
        ;Debug "Mouse Entered Gadget " + Str(CurrentGadget)
        
      Case #PB_EventType_MouseLeave 
        
        ;Debug "Mouse Left Gadget " + Str(CurrentGadget)       
        
      Case #PB_EventType_MouseMove 
        
        ;Debug "MouseMove On Gadget " + Str(CurrentGadget)        
        
      Case #PB_EventType_MouseWheel
        
        ;Debug "MouseWheel  On Gadget " + Str(CurrentGadget)           
        
      Case #PB_EventType_LeftButtonDown
        
        ;Debug "LeftButtonDown On Gadget " + Str(CurrentGadget)        
        
      Case #PB_EventType_LeftButtonUp
        
        ;Debug "LeftButtonUp On Gadget " + Str(CurrentGadget)        
        
      Case #PB_EventType_LeftClick 
        
        ;Debug "LeftClick On Gadget " + Str(CurrentGadget) 
        SendEvents(#CgEvent1) ;Just for testing
        
      Case #PB_EventType_LeftDoubleClick
        
        ;Debug "LeftDoubleClick On Gadget " + Str(CurrentGadget)           
        
      Case #PB_EventType_RightButtonDown
        
        ;Debug "RightButtonDown On Gadget " + Str(CurrentGadget)        
         
       Case #PB_EventType_RightButtonUp
        
        ;Debug "RightButtonUp On Gadget " + Str(CurrentGadget)        
        
      Case #PB_EventType_RightClick
        
        ;Debug "RightClick On Gadget " + Str(CurrentGadget)           
        SendEvents(#CgEvent2) ;Just for testing 
        
      Case #PB_EventType_RightDoubleClick
        
        ;Debug "RightDoubleClick On Gadget " + Str(CurrentGadget)           
        
      Case #PB_EventType_MiddleButtonDown
        
        ;Debug "MiddleButtonDown On Gadget " + Str(CurrentGadget)         
        
      Case #PB_EventType_MiddleButtonUp
        
        ;Debug "MiddleButtonUp On Gadget " + Str(CurrentGadget) 
        
      Case    #PB_EventType_Focus
        
        ;Debug "Got Focus On Gadget " + Str(CurrentGadget)   
        
      Case      #PB_EventType_LostFocus
        
        ;Debug "lost Focus On Gadget " + Str(CurrentGadget)   
        
      Case      #PB_EventType_KeyDown
        
        ;Debug "Key down On Gadget " + Str(CurrentGadget)   
        
      Case      #PB_EventType_KeyUp
        
        ;Debug "Key Up On Gadget " + Str(CurrentGadget)   
        
      Case      #PB_EventType_Input
        
        ;Debug "Input On Gadget " + Str(CurrentGadget)   + "= " +   Chr(GetGadgetAttribute(MyGadgetArray(CurrentGadget)\Gadget_ID, #PB_Canvas_Input ))     
        
    EndSelect
    
  EndProcedure
  
  Procedure CreateGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
    ;{ ==Procedure Header Comment==============================
;        Name/title: CreateGadget
;       Description: Part of custom gadget template
;                  : procedure to create the canvas used for the gadget
; ====================================================
;}  
    Define ThisWindow.i,ThisGadget.i,ThisColour.i
  
    ;Create The Canvas For The Gadget
    If Gadget = #PB_Any
      ThisGadget = CanvasGadget(#PB_Any, x,y,width,height,Flags)
    Else
      ThisGadget = Gadget
      CanvasGadget(Gadget, x,y,width,height,Flags)
    EndIf
  
    ;Bind This Gadgets Events
    BindGadgetEvent(ThisGadget, @GadgetEvents())

    ;The Window On Which It Is Created
    ThisWindow = GetActiveWindow()
    
    ;Add the window id as data to the gadget
    SetGadgetData(ThisGadget,ThisWindow)    
    
    ;Add To The Custom Gadget Array
    AddGadget(ThisWindow,ThisGadget)
    
    ;Get background colour where gadget will be drawn
    StartDrawing(WindowOutput(ThisWindow))
      ThisColour = Point(x, y)
    StopDrawing()
    
    ;Set colour of canvas to background
    StartDrawing(CanvasOutput(ThisGadget))
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0, 0, OutputWidth(), OutputHeight(), ThisColour)
    StopDrawing()     
    
    SetCurrentGadgetID(ThisGadget)
    
    ;Draw the actual gadget
    DrawGadget(CurrentGadget)
    
    ProcedureReturn ThisGadget 
    
  EndProcedure 
  
EndModule

Procedure.i CustomGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
;{ ==Procedure Header Comment==============================
;        Name/title: CustomGadget
;       Description: Part of custom gadget template
;                  : Public procedure to add this custom gadget to a window
; ====================================================
;}  
  Define ThisGadget.i
  
  ThisGadget = CustomGadget::CreateGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
  
  ProcedureReturn ThisGadget  
  
EndProcedure

; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 29
; FirstLine = 4
; Folding = VAg
; EnableXP