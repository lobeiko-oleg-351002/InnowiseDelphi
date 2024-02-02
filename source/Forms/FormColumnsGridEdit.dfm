object frmColumnsGridEdit: TfrmColumnsGridEdit
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Setting up table columns'
  ClientHeight = 449
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object sLabel1: TsLabel
    Left = 8
    Top = 7
    Width = 168
    Height = 19
    Caption = 'Visibility of table columns'
  end
  object clbColumns: TsCheckListBox
    Left = 8
    Top = 32
    Width = 281
    Height = 353
    BevelInner = bvNone
    BorderStyle = bsSingle
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Calibri'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    SkinData.CustomColor = True
    SkinData.CustomFont = True
    OnCheckChanging = clbColumnsCheckChanging
  end
  object btnOk: TsBitBtn
    Left = 96
    Top = 408
    Width = 105
    Height = 33
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnOkClick
  end
end
