XIncludeFile "Resize.pbi"

DeclareModule MyButton
  
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
    #ButtonClick
  EndEnumeration
  
  Enumeration btnImages
    #Original
  EndEnumeration
  
  ;Create the gadget procedures Only used by main gadget public procedure
  ;Should not be called directly
  Declare CreateGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
  Declare SetState(Gadget.i,State.i)
  
EndDeclareModule

Module MyButton

  ;The Main Gadget Structure
  Structure MyGadget
    Window_ID.i
    Gadget_ID.i
    State.i
    Colour.i
  EndStructure
  Global Dim MyGadgetArray.MyGadget(0) 
  Global Currentgadget.i

  Procedure SetCurrentGadgetID(Gadget.i)
  ;{ ==Procedure Header Comment==============================
;        Name/title: GetgadgetID
;       Description: Procedure to return the MyGadgetArray() element number 
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
  ;       Description: Procedure to draw the gadget on the canvas 
  ; ====================================================
  ;}    
    
  SetCurrentGadgetID(Gadget)
    
  If IsImage(#Original)
    Result = CreateImage(#PB_Any, 32, 32, 32)
    If Result
      StartDrawing(ImageOutput(Result))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0, 0, OutputWidth(), OutputHeight(), MyGadgetArray(Currentgadget)\Colour)       
     
        Select MyGadgetArray(Currentgadget)\State
          Case 1 ;Normal
             DrawAlphaImage(ImageID(#Original), 1, 1, 180)         
          Case 2 ;Hover
            DrawAlphaImage(ImageID(#Original), 1, 1, 255)       
          Case 3 ;Pressed
            DrawAlphaImage(ImageID(#Original), 2, 2, 255)         
          Case 4 ;Disabled
            DrawAlphaImage(ImageID(#Original), 1, 1, 100)          
          Default ;Normal
            DrawAlphaImage(ImageID(#Original),1,1)        
      EndSelect
              
      StopDrawing()
      
      ;Draw the image on the canvas
      StartDrawing(CanvasOutput(MyGadgetArray(Currentgadget)\Gadget_ID))
        DrawingMode(#PB_2DDrawing_AllChannels)   
        DrawAlphaImage(ImageID(Result), 0, 0) 
      StopDrawing()

    EndIf
  EndIf

  EndProcedure 
  
  Procedure SetState(Gadget.i,State.i)
    
    SetCurrentGadgetID(Gadget)
    
    If State = #True
      MyGadgetArray(Currentgadget)\State = 4
    Else
      MyGadgetArray(Currentgadget)\State = 1
    EndIf
    DrawGadget(Gadget)
    
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
    
    If EventData() = 15
      ;Fixed Size Gadget No resize
      If GadgetHeight(MyGadgetArray(CurrentGadget)\Gadget_ID) <> 32 Or GadgetWidth(MyGadgetArray(CurrentGadget)\Gadget_ID) <> 32
        ResizeGadget(MyGadgetArray(CurrentGadget)\Gadget_ID,#PB_Ignore,#PB_Ignore,32,32)
        DrawGadget(MyGadgetArray(CurrentGadget)\Gadget_ID)
      EndIf
    EndIf
   
    If MyGadgetArray(CurrentGadget)\State <> 4  
      
      Select EventType()
       
      Case #PB_EventType_MouseEnter

        MyGadgetArray(Currentgadget)\State = 2 ;Hover
        DrawGadget(MyGadgetArray(CurrentGadget)\Gadget_ID)
        
      Case #PB_EventType_MouseLeave 
      
        MyGadgetArray(Currentgadget)\State = 1 ;Normal
        DrawGadget(MyGadgetArray(CurrentGadget)\Gadget_ID) 
        
      Case #PB_EventType_LeftButtonDown
       
        MyGadgetArray(Currentgadget)\State = 3 ;Pressed
        DrawGadget(MyGadgetArray(CurrentGadget)\Gadget_ID)  
        
      Case #PB_EventType_LeftButtonUp
       
        MyGadgetArray(Currentgadget)\State = 1 ;Normal 
        DrawGadget(MyGadgetArray(CurrentGadget)\Gadget_ID)
        
      Case #PB_EventType_LeftClick 

        SendEvents(#ButtonClick) 
        
    EndSelect
    
  EndIf
  
  EndProcedure
  
  Procedure CreateGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
    ;{ ==Procedure Header Comment==============================
;        Name/title: CreateGadget
;       Description: Procedure to create the canvas used for the gadget
; ====================================================
;}  
    Define ThisWindow.i,ThisGadget.i,ThisColour.i
      
    ;ThisWindow = GetActiveWindow() ;Window on which the gadget is created
    
    ;minimum height\Width for the button
    If Height <> 32
      Height = 32
    EndIf
    If Width <> 32
      Width = 32
    EndIf
    
    ;Create The Canvas For The Gadget
    If Gadget = #PB_Any
      ThisGadget = CanvasGadget(#PB_Any, x,y,width,height,Flags)
    Else
      ThisGadget = Gadget
      CanvasGadget(Gadget, x,y,width,height,Flags)
    EndIf

    ;Bind This Gadgets Events
    BindGadgetEvent(ThisGadget, @GadgetEvents(),#PB_All )
    
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
    
    MyGadgetArray(Currentgadget)\Colour = ThisColour
    MyGadgetArray(Currentgadget)\State = 4 ;Initial State Disabled
    
    ;Image for this button
    CatchImage(#Original, ?MyButtonImage)
    ResizeImage(#Original, 30, 30)
    
    ;Draw the actual gadget
    DrawGadget(CurrentGadget)
    
    ProcedureReturn ThisGadget 
    
  EndProcedure 
  
  DataSection
  MyButtonImage: 
    IncludeBinary "accept.png" ;This buttons main image
  EndDataSection  
  
EndModule

Procedure.i MyButton(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
;{ ==Procedure Header Comment==============================
;        Name/title: CustomGadget
;       Description: Part of custom gadget template
;                  : Public procedure to add this custom gadget to a window
; ====================================================
;}  
  Define ThisGadget.i
  
  ThisGadget = MyButton::CreateGadget(Gadget.i, x.i,y.i,width.i,height.i,Flags.i)
  
  ProcedureReturn ThisGadget  
  
EndProcedure

Procedure DisableMyButton(Gadget.i,State.i)
  
  MyButton::SetState(Gadget.i,State.i)
  
EndProcedure


; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 252
; FirstLine = 161
; Folding = NAN-
; EnableXP