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
   StartUpPosition =   2  '��Ļ����
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
         Caption         =   "ͬ����ʽ"
         Begin VB.Menu mnuL2R 
            Caption         =   "����ļ��и����Ҳ��ļ���"
         End
         Begin VB.Menu mnuR2L 
            Caption         =   "�Ҳ��ļ��и�������ļ���"
         End
         Begin VB.Menu mnuUpdate 
            Caption         =   "�����ļ����໥����"
         End
         Begin VB.Menu mnuCompare 
            Caption         =   "�Ա����Ҳ���,���Ķ�����"
            Checked         =   -1  'True
         End
      End
      Begin VB.Menu mnuSep0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHideTerm 
         Caption         =   "����Python�ն˴���"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRemember 
         Caption         =   "��ס�ر�ʱ������"
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

Private Const CNT_DOWN_MNU_CLICK As Integer = 5 '// �˵���������ʱ,����

Sub mnuCompare_Click()
    SyncMode = EnumSyncMode.esmCompareOnly
    mnuL2R.Checked = False
    mnuR2L.Checked = False
    mnuUpdate.Checked = False
    mnuCompare.Checked = True
    SetStatus "", True
    SetStatus "ͬ����ʽѡ��:ֻ�ȶԲ���"
    tmrMnuClick.Tag = CNT_DOWN_MNU_CLICK
    tmrMnuClick.Enabled = True
End Sub

Private Sub mnuHideTerm_Click()
    HideTerm = Not HideTerm
    mnuHideTerm.Tag = HideTerm
    mnuHideTerm.Caption = IIf(HideTerm, "����Python�ն˴���", "��ʾPython�ն˴���")
    SetStatus "", True
    SetStatus "Python�ն˴���:" & IIf(HideTerm, "����", "��ʾ")
End Sub

Sub mnuL2R_Click()
    SyncMode = EnumSyncMode.esmLeftToRight
    mnuL2R.Checked = True
    mnuR2L.Checked = False
    mnuUpdate.Checked = False
    mnuCompare.Checked = False
    SetStatus "", True
    SetStatus "ͬ����ʽѡ��:��า���Ҳ�"
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
    SetStatus "ͬ����ʽѡ��:�Ҳา�����"
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
    SetStatus "ͬ����ʽѡ��:�໥����"
    tmrMnuClick.Tag = CNT_DOWN_MNU_CLICK
    tmrMnuClick.Enabled = True
End Sub

Private Sub mnuRemember_Click()
    Remember = Not Remember
    mnuRemember.Tag = Remember
    mnuRemember.Caption = IIf(Remember, "��ס�ر�ʱ������", "��Ҫ��ס�ر�ʱ������")
    SetStatus "", True
    SetStatus "��ס�ر�ʱ������:" & IIf(Remember, "��", "��")
End Sub

Private Sub tmrMnuClick_Timer()
    tmrMnuClick.Tag = tmrMnuClick.Tag - 1
    If tmrMnuClick.Tag = 0 Then tmrMnuClick.Enabled = False
End Sub
