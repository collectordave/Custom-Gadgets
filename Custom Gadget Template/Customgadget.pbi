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
  ;All Variables Used By The Gadget should Be Declared In This Structure
  ;Variables Declared Out Of The Structure are not guaranteed
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
    
  Procedure IDGadget( GadgetID )
 ;{ ==Procedure Header Comment==============================
;        Name/title: IDGadget
;       Description: Part of custom gadget template
;                  : Required to capture resize events of the gadget canvas
; 
; ====================================================
;}    
     
     
     CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetProp_( GadgetID, "PB_GadgetID") - 1
       
      CompilerCase #PB_OS_Linux
        g_object_get_data_( GadgetID, "PB_GadgetID") - 1
       
    CompilerEndSelect
  EndProcedure 
    
    CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      Procedure Resize_CallBack(GadgetID, Msg, wParam, lParam)
;{ ==Procedure Header Comment==============================
;        Name/title: Resize_CallBack
;       Description: Part of custom gadget template
;                  : Required to capture resize events of the gadget canvas
;                  : when running on windows
; ====================================================
;}           
        Protected *Func = GetProp_( GadgetID, "Resize_Event_CallBack")
       
        Protected *Gadget = IDGadget( GadgetID )
       
        Protected *Window = GetActiveWindow() ; GetProp_( GadgetID, "PB_WindowID") - 1
       
        Select Msg
          Case #WM_SIZE : PostEvent( #PB_Event_Gadget, *Window, *Gadget , #PB_EventType_Size )
          Case #WM_MOVE : PostEvent( #PB_Event_Gadget, *Window, *Gadget , #PB_EventType_Move )
          Default
           
            ProcedureReturn CallWindowProc_(*Func, GadgetID, Msg, wParam, lParam)
        EndSelect
       
       
      EndProcedure
     
    CompilerCase #PB_OS_Linux
      ProcedureC Resize_CallBack( *Event.GdkEventAny, *Handle )
  ;{ ==Procedure Header Comment==============================
;        Name/title: Resize_CallBack
;       Description: Part of custom gadget template
;                  : Required to capture resize events of the gadget canvas
;                  : when running on Linux
; ====================================================
;}       
        Protected *Widget.GtkWidget = gtk_get_event_widget_(*Event)
        ;Debug gdk_event_get_screen_ (*event)
       
        If *Widget
          Debug PeekS( gtk_widget_get_name_( (*Widget)), -1, #PB_UTF8 ) + " " + Str(g_object_get_data_(*Widget, "PB_GadgetID") - 1)
        EndIf
       
        If *Widget And *Widget = g_object_get_data_(*Widget, "Resize_Event_CallBack")
          Select *Event\type
            Case #GDK_2BUTTON_PRESS
            Case #GDK_BUTTON_PRESS
            Case #GDK_BUTTON_RELEASE
            Case #GDK_ENTER_NOTIFY
            Case #GDK_LEAVE_NOTIFY
            Case #GDK_MOTION_NOTIFY
            Case #GDK_SCROLL
              Protected *scroll.GdkEventScroll = *Event
              Select *scroll\state
                Case #GDK_SCROLL_UP
                  Debug "scrollUP"
                Case #GDK_SCROLL_DOWN
                  Debug "scrollDown"
              EndSelect
             
            Case #GDK_KEY_PRESS
            Case #GDK_KEY_RELEASE
            Case #GDK_FOCUS_CHANGE
            Case #GDK_CONFIGURE
            Case #GDK_DESTROY
            Case #GDK_DELETE
            Case #GDK_EXPOSE
            Case #GDK_UNMAP
             
              gdk_event_handler_set_( 0, 0, 0 )
            Default
             
              gtk_main_do_event_( *Event )
          EndSelect
        Else
          gtk_main_do_event_( *Event )
        EndIf
      EndProcedure
     
  CompilerEndSelect
    
  Procedure SetIDGadget( Gadget )
 ;{ ==Procedure Header Comment==============================
;        Name/title: SetIDGadget
;       Description: Part of custom gadget template
;                  : Required to capture resize events of the gadget canvas
; ====================================================
;}    
    CompilerSelect #PB_Compiler_OS
        
      CompilerCase #PB_OS_Windows
        If GetProp_( GadgetID( Gadget ), "PB_GadgetID" ) = 0
          ProcedureReturn SetProp_( GadgetID( Gadget ), "PB_GadgetID", Gadget + (1))
        EndIf
       
      CompilerCase #PB_OS_Linux
        If g_object_get_data_( GadgetID( Gadget ), "PB_GadgetID" ) = 0
          ProcedureReturn g_object_set_data_( GadgetID( Gadget ), "PB_GadgetID", Gadget + (1))
        EndIf
       
    CompilerEndSelect
    
  EndProcedure
    
  Procedure ResizeGadgetEvents(Gadget)
    
    Protected GadgetID, GadgetID1, GadgetID2, GadgetID3, GadgetID4
   
    If IsGadget( Gadget ) 
      SetIDGadget( Gadget )
      GadgetID = GadgetID( Gadget )
     
      CompilerSelect #PB_Compiler_OS
          
        CompilerCase #PB_OS_Linux
          g_object_set_data_( GadgetID, "PB_GadgetID", Gadget + 1 )
          g_object_set_data_( GadgetID, "Resize_Event_CallBack", GadgetID )
          gdk_event_handler_set_( @Resize_CallBack(), GadgetID, 0 )
         
        CompilerCase #PB_OS_Windows
          If GadgetID  And GetProp_( GadgetID,  "Resize_Event_CallBack") = #False
            SetProp_( GadgetID, "Resize_Event_CallBack", SetWindowLong_(GadgetID, #GWL_WNDPROC, @Resize_CallBack()))
          EndIf
         
      CompilerEndSelect
      
    EndIf
    
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
        
      Case #PB_EventType_Size
        
        ;Debug "ReSize On Gadget " + Str(CurrentGadget)          
        DrawGadget(EventGadget()) ;If Needed after a resize event
        SendEvents(#CgEvent3) ;Just for testing
        
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
    Define ThisWindow.i,ThisGadget.i
  
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
    ThisWindow = UseGadgetList(0)
    
    ;Add To The Custom Gadget Array
    AddGadget(ThisWindow,ThisGadget)
    
    SetCurrentGadgetID(ThisGadget)
    
    ;Add Resize Event
    ResizeGadgetEvents( ThisGadget )
    
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
; CursorPosition = 343
; FirstLine = 83
; Folding = 0EEV0
; EnableXP