VERSION 5.00
Begin VB.Form frmMain 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   ClientHeight    =   4980
   ClientLeft      =   120
   ClientTop       =   120
   ClientWidth     =   8625
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
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   Picture         =   "frmMain.frx":A3B2
   ScaleHeight     =   332
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   575
   StartUpPosition =   3  '窗口缺省
   Begin VB.Timer tmrSyncking 
      Enabled         =   0   'False
      Interval        =   3000
      Left            =   1500
      Top             =   4095
   End
   Begin VB.Timer tmrRight 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   3000
      Top             =   4095
   End
   Begin VB.Timer tmrLeft 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   2460
      Top             =   4095
   End
   Begin VB.Label StatusBar 
      Alignment       =   2  'Center
      BackColor       =   &H000080FF&
      BackStyle       =   0  'Transparent
      Caption         =   "szStatus:Lorem Ipsum"
      ForeColor       =   &H00646464&
      Height          =   270
      Left            =   15
      TabIndex        =   2
      Tag             =   "False"
      ToolTipText     =   "双击强制清空状态栏"
      Top             =   3585
      Width           =   6000
   End
   Begin VB.Image btnMin 
      Height          =   240
      Left            =   5355
      Picture         =   "frmMain.frx":56566
      Stretch         =   -1  'True
      ToolTipText     =   "最小化"
      Top             =   75
      Width           =   240
   End
   Begin VB.Image RightBlock 
      Height          =   2220
      Left            =   3105
      OLEDropMode     =   1  'Manual
      Stretch         =   -1  'True
      Top             =   1305
      Width           =   2820
   End
   Begin VB.Image LeftBlock 
      Height          =   2220
      Left            =   105
      OLEDropMode     =   1  'Manual
      Stretch         =   -1  'True
      Top             =   1305
      Width           =   2820
   End
   Begin VB.Image btnMenu 
      Height          =   270
      Left            =   270
      ToolTipText     =   "设置菜单"
      Top             =   675
      Width           =   315
   End
   Begin VB.Image btnClose 
      Height          =   240
      Left            =   5685
      Picture         =   "frmMain.frx":568A8
      Stretch         =   -1  'True
      ToolTipText     =   "退出"
      Top             =   75
      Width           =   240
   End
   Begin VB.Image btnGo 
      Height          =   285
      Left            =   5505
      Picture         =   "frmMain.frx":56BEA
      Stretch         =   -1  'True
      ToolTipText     =   "开始同步"
      Top             =   675
      Width           =   285
   End
   Begin VB.Image btnInfo 
      Height          =   240
      Left            =   105
      Picture         =   "frmMain.frx":570A0
      Stretch         =   -1  'True
      ToolTipText     =   "关于..."
      Top             =   75
      Width           =   240
   End
   Begin VB.Image TitleBar 
      Height          =   390
      Left            =   0
      Top             =   0
      Width           =   6030
   End
   Begin VB.Label lblLeft 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "拖放以指定文件夹"
      BeginProperty Font 
         Name            =   "微软雅黑"
         Size            =   10.5
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00646464&
      Height          =   300
      Left            =   150
      TabIndex        =   0
      Top             =   2940
      Width           =   2730
   End
   Begin VB.Label lblRight 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "拖放以指定文件夹"
      BeginProperty Font 
         Name            =   "微软雅黑"
         Size            =   10.5
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00646464&
      Height          =   300
      Left            =   3150
      TabIndex        =   1
      Top             =   2940
      Width           =   2730
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'// Lorem ipsum dolor sit amet 1234567890 子曰学而时习之不亦说乎
Private Declare Function SetWindowPos Lib "user32.dll" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Private Const HWND_TOPMOST As Long = -1&
Private Const HWND_TOP As Long = 0&
Private Const SWP_NOMOVE As Long = &H2&
Private Const SWP_NOSIZE As Long = &H1&

Private Const BG_IMG_WIDTH As Long = 402
Private Const BG_IMG_HEIGHT As Long = 258

Private Const CS_DROPSHADOW = &H20000
Private Const CS_NOSHADOW = &H20028
Private Declare Function GetClassLong Lib "user32" Alias "GetClassLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Const GCL_STYLE = (-26)
Private Declare Function SetClassLong Lib "user32" Alias "SetClassLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SetWindowRgn Lib "user32" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
Private Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long

Private Const WS_EX_LAYERED = &H80000
Private Const WS_EX_TRANSPARENT As Long = &H20&
Private Const GWL_EXSTYLE = (-20)
Private Const LWA_ALPHA = &H2
Private Const LWA_COLORKEY = &H1

Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Const HTCAPTION = 2
Private Const WM_NCLBUTTONDOWN = &HA1

Private Sub btnClose_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnClose.Picture = LoadPicture(App.Path & "\res\close-down.bmp")
End Sub

Private Sub btnClose_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnClose.Picture = LoadPicture(App.Path & "\res\close-up.bmp")
    Call btnClose_Click
End Sub

Private Sub btnGo_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call btnGo_Click
End Sub

Private Sub btnInfo_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnInfo.Picture = LoadPicture(App.Path & "\res\info-down.bmp")
    
End Sub

Private Sub btnInfo_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnInfo.Picture = LoadPicture(App.Path & "\res\info-up.bmp")
    Call btnInfo_Click
End Sub

Private Sub btnMenu_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    PopupMenu frmSupport.mnuTop, , (btnMenu.Left + btnMenu.Width / 2), (btnMenu.Top + btnMenu.Height / 2)
End Sub

Private Sub btnMin_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnMin.Picture = LoadPicture(App.Path & "\res\min-down.bmp")
End Sub

Private Sub btnMin_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    btnMin.Picture = LoadPicture(App.Path & "\res\min-up.bmp")
    frmMain.WindowState = 1
End Sub

Private Sub Form_Load()
If App.PrevInstance Then Unload frmMain: Exit Sub

    frmMain.Width = BG_IMG_WIDTH * Screen.TwipsPerPixelX
    frmMain.Height = BG_IMG_HEIGHT * Screen.TwipsPerPixelY
    frmMain.Left = (Screen.Width - frmMain.Width) / 2
    frmMain.Top = (Screen.Height - frmMain.Height) / 2
    
    ' SetWindowLong frmMain.hwnd, GWL_EXSTYLE, GetWindowLong(frmMain.hwnd, GWL_EXSTYLE) Or WS_EX_LAYERED
    ' SetLayeredWindowAttributes frmMain.hwnd, &HFF31FF, t, LWA_ALPHA Or LWA_COLORKEY
    SetWindowRgn frmMain.hWnd, CreateRoundRectRgn(0, 0, frmMain.Width / Screen.TwipsPerPixelX + 1, frmMain.Height / Screen.TwipsPerPixelY + 1, 2, 2), True
    SetClassLong frmMain.hWnd, GCL_STYLE, GetClassLong(frmMain.hWnd, GCL_STYLE) Or CS_DROPSHADOW
    ' SetWindowPos frmMain.hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE
    
    Load frmSupport
    Load frmMsg
    
    If Not LoadCfg() Then Call LoadDefaultCfg
    With frmSupport
        Select Case SyncMode
        Case EnumSyncMode.esmMutualUpdate
            .mnuUpdate_Click
        Case EnumSyncMode.esmLeftToRight
            .mnuL2R_Click
        Case EnumSyncMode.esmRightToLeft
            .mnuR2L_Click
        Case Else
            .mnuCompare_Click
        End Select
        '// .mnuRemember.Checked = Remember
        .tmrMnuClick.Enabled = False
        .mnuRemember.Tag = Remember
        .mnuRemember.Caption = IIf(Remember, "记住关闭时的设置", "不要记住关闭时的设置")
        .mnuHideTerm.Tag = HideTerm
        .mnuHideTerm.Caption = IIf(HideTerm, "隐藏Python终端窗口", "显示Python终端窗口")
    End With
    If LeftPath <> "" Then Call LeftBlock_Drop(LeftPath)
    If RightPath <> "" Then Call RightBlock_Drop(RightPath)
    SetStatus ""
    
    lpOldWndProc = Hook(frmMain.hWnd)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call SaveCfg
    Unhook frmMain.hWnd, lpOldWndProc
End Sub

Private Sub LeftBlock_Click()
    ' Call lsRGB(0, 0, 255)
    If LeftPath <> "" Then SetStatus "", True: SetStatus "双击可以导航到文件夹"
End Sub

Private Sub LeftBlock_DblClick()
    Call LeftBlock_DoubleClick
End Sub

Private Sub LeftBlock_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    On Error GoTo Skipped
    Call LeftBlock_Drop(Data.Files(1))
    Exit Sub
Skipped:
    Call LeftBlock_Drop("")
End Sub

Private Sub RightBlock_Click()
    ' Call rsRGB(0, 0, 255)
    If RightPath <> "" Then SetStatus "", True: SetStatus "双击可以导航到文件夹"
End Sub

Private Sub RightBlock_DblClick()
    Call RightBlock_DoubleClick
End Sub

Private Sub RightBlock_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    On Error GoTo Skipped
    Call RightBlock_Drop(Data.Files(1))
    Exit Sub
Skipped:
    Call RightBlock_Drop("")
End Sub

Private Sub StatusBar_DblClick()
    StatusBar.Caption = "" '// 强制清除
    StatusBar.Tag = False
End Sub

Private Sub TitleBar_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    SendMessage frmMain.hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&
End Sub

Private Sub tmrLeft_Timer()
    Static Status As Integer, Cnt As Integer
    Static eR As Byte, eG As Byte, eB As Byte '// End & stEp
    Dim R As Byte, G As Byte, B As Byte
    Dim Ratio As Double
    Const Duration As Integer = 1000
    If Status = 0 Then '// 初始化
        ' eR = leftIndicator.FillColor And &HFF&
        ' eG = CByte((leftIndicator.FillColor And &HFF00&) / &H100)
        ' eB = CByte((leftIndicator.FillColor And &HFF0000) / &H10000)
        eR = &H64 'lblLeft.ForeColor And &HFF&
        eG = &H64  'CByte((lblLeft.ForeColor And &HFF00&) / &H100)
        eB = &H64  'CByte((lblLeft.ForeColor And &HFF0000) / &H10000)
        Status = 1
        Cnt = -tmrLeft.Interval
    ElseIf Status = 1 Then '// 正常工作
        Cnt = Cnt + tmrLeft.Interval
        Ratio = IIf(Cnt / Duration < 1, Cnt / Duration, 1)
        R = (eR - lsR) * Ratio + lsR
        G = (eG - lsG) * Ratio + lsG
        B = (eB - lsB) * Ratio + lsB
        ' leftIndicator.FillColor = RGB(R, G, b)
        lblLeft.ForeColor = RGB(R, G, B)
        If Cnt >= Duration Then
            Status = 0
            tmrLeft.Enabled = False
        End If
    End If

End Sub

Private Sub tmrRight_Timer()
    Static Status As Integer, Cnt As Integer
    Static eR As Byte, eG As Byte, eB As Byte '// End & stEp
    Dim R As Byte, G As Byte, B As Byte
    Dim Ratio As Double
    Const Duration As Integer = 1000
    If Status = 0 Then '// 初始化
        ' eR = rightIndicator.FillColor And &HFF&
        ' eG = CByte((rightIndicator.FillColor And &HFF00&) / &H100)
        ' eB = CByte((rightIndicator.FillColor And &HFF0000) / &H10000)
        eR = &H64  'lblRight.ForeColor And &HFF&
        eG = &H64  'CByte((lblRight.ForeColor And &HFF00&) / &H100)
        eB = &H64  'CByte((lblRight.ForeColor And &HFF0000) / &H10000)
        Status = 1
        Cnt = -tmrRight.Interval
    ElseIf Status = 1 Then '// 正常工作
        Cnt = Cnt + tmrRight.Interval
        Ratio = IIf(Cnt / Duration < 1, Cnt / Duration, 1)
        R = (eR - rsR) * Ratio + rsR
        G = (eG - rsG) * Ratio + rsG
        B = (eB - rsB) * Ratio + rsB
        ' rightIndicator.FillColor = RGB(R, G, b)
        lblRight.ForeColor = RGB(R, G, B)
        If Cnt >= Duration Then
            Status = 0
            tmrRight.Enabled = False
        End If
    End If

End Sub

Private Sub tmrSyncking_Timer()
    Call lsRGB(0, 0, 255)
    Call rsRGB(0, 0, 255)
End Sub
