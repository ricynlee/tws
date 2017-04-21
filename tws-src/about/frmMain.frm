VERSION 5.00
Begin VB.Form frmMain 
   AutoRedraw      =   -1  'True
   BorderStyle     =   0  'None
   Caption         =   "Presentation"
   ClientHeight    =   4365
   ClientLeft      =   14610
   ClientTop       =   2730
   ClientWidth     =   6855
   ControlBox      =   0   'False
   Icon            =   "frmMain.frx":0000
   LockControls    =   -1  'True
   ScaleHeight     =   291
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   457
   ShowInTaskbar   =   0   'False
   Begin VB.Image btnClose 
      Height          =   270
      Left            =   3945
      ToolTipText     =   "¹Ø±Õ"
      Top             =   585
      Width           =   270
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const HTCAPTION As Long = 2
Private Const WM_NCLBUTTONDOWN  As Long = &HA1
Private Const WM_SYSCOMMAND As Long = &H112
Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long


Private Sub btnClose_Click()
    Form_DblClick
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    'Movability isn't recommended
    'but makes it easier to debug
    Call ReleaseCapture
    Call SendMessage(frmMain.hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&)
End Sub

Private Sub Form_DblClick()
    Unload frmMain
End Sub

Private Sub Form_Initialize()
    If App.PrevInstance Then Unload frmMain: Exit Sub
    Call InitGdiplus
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    Unload frmMain
End Sub

'// Example usage
Private Sub Form_Load()
On Error GoTo Failure
    Dim Cmd As String
    Cmd = Command$()
    Call Bind(frmMain, IIf(Cmd = "", App.Path & "\about.png", Cmd), True)
    Call SetAlpha(255)
    ' Command$()
    Exit Sub
Failure:
    Unload frmMain
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call TermGdiplus
End Sub


