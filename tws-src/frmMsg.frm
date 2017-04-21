VERSION 5.00
Begin VB.Form frmMsg 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   ClientHeight    =   3705
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6120
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "微软雅黑"
      Size            =   9
      Charset         =   134
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "frmMsg.frx":0000
   ScaleHeight     =   247
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   408
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '所有者中心
   Begin VB.Label lblFalse 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "否"
      BeginProperty Font 
         Name            =   "微软雅黑"
         Size            =   9
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   2340
      TabIndex        =   3
      Top             =   2280
      Width           =   1965
   End
   Begin VB.Label lblTrue 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "是"
      BeginProperty Font 
         Name            =   "微软雅黑"
         Size            =   9
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   180
      TabIndex        =   2
      Top             =   2280
      Width           =   1965
   End
   Begin VB.Label msgMajor 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "中文 Lorem ipsum 中文"
      BeginProperty Font 
         Name            =   "微软雅黑"
         Size            =   12
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   180
      TabIndex        =   1
      Top             =   420
      Width           =   4125
   End
   Begin VB.Label msgMinor 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   $"frmMsg.frx":2801C
      ForeColor       =   &H80000008&
      Height          =   810
      Left            =   180
      TabIndex        =   0
      Top             =   1245
      Width           =   4125
      WordWrap        =   -1  'True
   End
   Begin VB.Image btnFalse 
      Height          =   375
      Left            =   2340
      Top             =   2205
      Width           =   1965
   End
   Begin VB.Image btnTrue 
      Height          =   375
      Left            =   180
      Top             =   2205
      Width           =   1965
   End
End
Attribute VB_Name = "frmMsg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const BG_IMG_WIDTH As Long = 300
Private Const BG_IMG_HEIGHT As Long = 182

Private Sub btnTrue_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnTrue.Picture = LoadPicture(App.Path & "\res\msg-btn-down.bmp")
End Sub

Private Sub btnTrue_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnTrue.Picture = LoadPicture(App.Path & "\res\msg-btn-up.bmp")
    frmMsg.Tag = True
    frmMsg.Hide
End Sub

Private Sub btnFalse_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnFalse.Picture = LoadPicture(App.Path & "\res\msg-btn-down.bmp")
End Sub

Private Sub btnFalse_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnFalse.Picture = LoadPicture(App.Path & "\res\msg-btn-up.bmp")
    frmMsg.Tag = False
    frmMsg.Hide
End Sub

Private Sub Form_Initialize()
    frmMsg.Width = BG_IMG_WIDTH * Screen.TwipsPerPixelX
    frmMsg.Height = BG_IMG_HEIGHT * Screen.TwipsPerPixelY
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Or KeyAscii = 32 Then ' 回车,空格
        Call btnTrue_MouseUp(0, 0, 0, 0)
    ElseIf KeyAscii = 27 Then ' Esc
        Call btnFalse_MouseUp(0, 0, 0, 0)
    End If
End Sub

Private Sub lblTrue_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call btnTrue_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub lblTrue_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call btnTrue_MouseUp(Button, Shift, 0, 0)
End Sub

Private Sub lblFalse_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call btnFalse_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub lblFalse_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call btnFalse_MouseUp(Button, Shift, 0, 0)
End Sub


