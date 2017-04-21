Usage:

Private Sub Form_Initialize()
    Call InitGdiplus 
End Sub

Private Sub Form_Load()
    'Bind should be called AFTER a form is loaded
    Call Bind({Target_Form}, {PNG_Full_Path}, {Centered})
    Call SetAlpha({Alpha_Value})
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call TermGdiplus
End Sub