object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 382
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 24
  object sPanel1: TsPanel
    Left = 0
    Top = 333
    Width = 603
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 453
    object GridPanel1: TGridPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 597
      Height = 43
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = BtnSave
          Row = 0
        end
        item
          Column = 1
          Control = btnCancel
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      object BtnSave: TsBitBtn
        AlignWithMargins = True
        Left = 152
        Top = 3
        Width = 143
        Height = 37
        Align = alRight
        Caption = 'OK'
        TabOrder = 0
        OnClick = BtnSaveClick
        ImageIndex = 5
        Images = frmResource.imgList30_30
      end
      object btnCancel: TsBitBtn
        AlignWithMargins = True
        Left = 301
        Top = 3
        Width = 146
        Height = 37
        Align = alLeft
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
        ImageIndex = 2
        Images = frmResource.imgList30_30
      end
    end
  end
  object GridPanel2: TGridPanel
    Left = 0
    Top = 0
    Width = 603
    Height = 333
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 1
    ExplicitHeight = 453
  end
  object GridPanel3: TGridPanel
    Left = 0
    Top = 0
    Width = 603
    Height = 333
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlDBConnect
        Row = 0
      end
      item
        Column = 0
        Control = pnlView
        Row = 1
      end
      item
        Column = 0
        Control = pnlPathUpdate
        Row = 3
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 160.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 150.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 130.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 2
    ExplicitHeight = 453
    object pnlDBConnect: TsPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 597
      Height = 154
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 603
      ExplicitHeight = 155
      object sLabelFX3: TsLabelFX
        Left = 11
        Top = 43
        Width = 46
        Height = 32
        Caption = 'Host'
        Angle = 0
        Shadow.OffsetKeeper.LeftTop = -3
        Shadow.OffsetKeeper.RightBottom = 5
      end
      object sLabelFX4: TsLabelFX
        Left = 11
        Top = 81
        Width = 85
        Height = 32
        Caption = 'Name DB'
        Angle = 0
        Shadow.OffsetKeeper.LeftTop = -3
        Shadow.OffsetKeeper.RightBottom = 5
      end
      object sLabelFX5: TsLabelFX
        Left = 11
        Top = 118
        Width = 43
        Height = 32
        Caption = 'Port'
        Angle = 0
        Shadow.OffsetKeeper.LeftTop = -3
        Shadow.OffsetKeeper.RightBottom = 5
      end
      object lblDBConnect: TsLabel
        Left = 12
        Top = 8
        Width = 206
        Height = 29
        Caption = 'Connect to Database'
        ParentFont = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Calibri'
        Font.Style = []
      end
      object edtHost: TsEdit
        Left = 193
        Top = 43
        Width = 224
        Height = 32
        TabOrder = 0
        SkinData.SkinSection = 'EDIT'
        BoundLabel.ParentFont = False
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -13
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
      end
      object edtDBName: TsEdit
        Left = 193
        Top = 81
        Width = 224
        Height = 32
        TabOrder = 1
        SkinData.SkinSection = 'EDIT'
        BoundLabel.ParentFont = False
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -13
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
      end
      object edtPort: TsCurrencyEdit
        Left = 193
        Top = 118
        Width = 80
        Height = 32
        TabOrder = 2
        DecimalPlaces = 0
        DisplayFormat = '### ### ##0;-### ### ##0;0'
      end
    end
    object pnlView: TsPanel
      AlignWithMargins = True
      Left = 3
      Top = 163
      Width = 597
      Height = 144
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 0
      ExplicitTop = 155
      ExplicitWidth = 603
      ExplicitHeight = 150
      object sLabelFX1: TsLabelFX
        Left = 11
        Top = 42
        Width = 187
        Height = 32
        Caption = 'Path to the skins files'
        Angle = 0
        Shadow.OffsetKeeper.LeftTop = -3
        Shadow.OffsetKeeper.RightBottom = 5
      end
      object sLabelFX2: TsLabelFX
        Left = 11
        Top = 80
        Width = 96
        Height = 32
        Caption = 'Active skin'
        Angle = 0
        Shadow.OffsetKeeper.LeftTop = -3
        Shadow.OffsetKeeper.RightBottom = 5
      end
      object lblView: TsLabel
        Left = 12
        Top = 6
        Width = 119
        Height = 29
        Caption = 'Appearance'
        ParentFont = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Calibri'
        Font.Style = []
      end
      object DirEdit: TsDirectoryEdit
        Left = 193
        Top = 44
        Width = 363
        Height = 30
        AutoSize = False
        MaxLength = 255
        TabOrder = 0
        Text = ''
        OnChange = DirEditChange
        CheckOnExit = True
        BoundLabel.ParentFont = False
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -13
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        SkinData.SkinSection = 'EDIT'
        HideSelection = False
        AcceptFiles = True
        Root = 'rfDesktop'
      end
      object cbxSkinName: TsComboBox
        Left = 193
        Top = 80
        Width = 363
        Height = 32
        BoundLabel.ParentFont = False
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -13
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        SkinData.SkinSection = 'COMBOBOX'
        ItemIndex = -1
        TabOrder = 1
        OnChange = cbxSkinNameChange
      end
      object tsActiveSkin: TsCheckBox
        Left = 12
        Top = 118
        Width = 123
        Height = 28
        Caption = 'Enable skin'
        TabOrder = 2
        OnClick = tsActiveSkinClick
        SkinData.SkinSection = 'CHECKBOX'
      end
    end
    object pnlPathUpdate: TsPanel
      Left = 0
      Top = 440
      Width = 603
      Height = 5
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitTop = 435
      ExplicitHeight = 18
    end
  end
end
