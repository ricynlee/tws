VERSION 5.00
Begin VB.Form frmSupport 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   ClientHeight    =   915
   ClientLeft      =   105
   ClientTop       =   705
   ClientWidth     =   990
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   61
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   66
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '屏幕中心
   Visible         =   0   'False
   Begin VB.Timer tmrMnuClick 
      Enabled         =   0   'False
      Interval        =   60000
      Left            =   270
      Top             =   180
   End
   Begin VB.Menu mnuTop 
      Caption         =   "mnuTop"
      Begin VB.Menu mnuSyncMode 
         Caption         =   "同步方式"
         Begin VB.Menu mnuL2R 
            Caption         =   "左侧文件夹覆盖右侧文件夹"
         End
         Begin VB.Menu mnuR2L 
            Caption         =   "右侧文件夹覆盖左侧文件夹"
         End
         Begin VB.Menu mnuUpdate 
            Caption         =   "两侧文件夹相互更新"
         End
         Begin VB.Menu mnuCompare 
            Caption         =   "对比左右差异,不改动数据"
            Checked         =   -1  'True
         End
      End
      Begin VB.Menu mnuSep0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHideTerm 
         Caption         =   "隐藏Python终端窗口"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRemember 
         Caption         =   "记住关闭时的设置"
         Checked         =   -1  'True
      End
   End
End
Attribute VB_Name = "frmSupport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const CNT_DOWN_MNU_CLICK As Integer = 5 '// 菜单单击倒计时,分钟

Sub mnuCompare_Click()
    SyncMode = EnumSyncMode.esmCompareOnly
    mnuL2R.Checked = False
    mnuR2L.Checked = False
    mnuUpdate.Checked = False
    mnuCompare.Checked = True
    SetStatus "", True
    SetStatus "同步方式选择:只比对差异"
    tmrMnuClick.Tag = CNT_DOWN_MNU_CLICK
    tmrMnuClick.Enabled = True
End Sub

Private Sub mnuHideTerm_Click()
    HideTerm = Not HideTerm
    mnuHideTerm.Tag = HideTerm
    mnuHideTerm.Caption = IIf(HideTerm, "隐藏Python终端窗口", "显示Python终端窗口")
    SetStatus "", True
    SetStatus "Python终端窗口:" & IIf(HideTerm, "隐藏", "显示")
End Sub

Sub mnuL2R_Click()
    SyncMode = EnumSyncMode.esmLeftToRight
    mnuL2R.Checked = True
    mnuR2L.Checked = False
    mnuUpdate.Checked = False
    mnuCompare.Checked = False
    SetStatus "", True
    SetStatus "同步方式选择:左侧覆盖右侧"
    tmrMnuClick.Tag = CNT_DOWN_MNU_CLICK
    tmrMnuClick.Enabled = True
End Sub

Sub mnuR2L_Click()
    SyncMode = EnumSyncMode.esmRightToLeft
    mnuL2R.Checked = False
    mnuR2L.Checked = True
    mnuUpdate.Checked = False
    mnuCompare.Checked = False
    SetStatus "", True
    SetStatus "同步方式选择:右侧覆盖左侧"
    tmrMnuClick.Tag = CNT_DOWN_MNU_CLICK
    tmrMnuClick.Enabled = True
End Sub

Sub mnuUpdate_Click()
    SyncMode = EnumSyncMode.esmMutualUpdate
    mnuL2R.Checked = False
    mnuR2L.Checked = False
    mnuUpdate.Checked = True
    mnuCompare.Checked = False
    SetStatus "", True
    SetStatus "同步方式选择:相互更新"
    tmrMnuClick.Tag = CNT_DOWN_MNU_CLICK
    tmrMnuClick.Enabled = True
End Sub

Private Sub mnuRemember_Click()
    Remember = Not Remember
    mnuRemember.Tag = Remember
    mnuRemember.Caption = IIf(Remember, "记住关闭时的设置", "不要记住关闭时的设置")
    SetStatus "", True
    SetStatus "记住关闭时的设置:" & IIf(Remember, "是", "否")
End Sub

Private Sub tmrMnuClick_Timer()
    tmrMnuClick.Tag = tmrMnuClick.Tag - 1
    If tmrMnuClick.Tag = 0 Then tmrMnuClick.Enabled = False
End Sub
