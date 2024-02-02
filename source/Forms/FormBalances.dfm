inherited frmBalances: TfrmBalances
  Caption = 'frmBalances'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  inherited baseGrid: TcxGrid
    Top = 94
    Height = 519
    ExplicitTop = 94
    ExplicitHeight = 519
  end
  inherited grdPnlButtonsTop: TGridPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1000
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
      end
      item
        SizeStyle = ssAbsolute
      end
      item
        SizeStyle = ssAbsolute
      end
      item
        SizeStyle = ssAbsolute
      end
      item
        SizeStyle = ssAbsolute
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 60.000000000000000000
      end>
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 1000
    inherited btnUpdate: TsSpeedButton
      Left = 3
      Width = -6
      ExplicitLeft = 3
      ExplicitWidth = -6
    end
    inherited btnExcel: TsSpeedButton
      Left = 3
      ExplicitLeft = 3
    end
    inherited btnAdd: TsSpeedButton
      Width = -6
      ExplicitWidth = -6
    end
    inherited btnEdit: TsSpeedButton
      Left = 3
      ExplicitLeft = 3
      ExplicitWidth = -6
    end
    inherited btnDel: TsSpeedButton
      Left = 3
      Width = -6
      ExplicitLeft = 3
      ExplicitWidth = -6
    end
    inherited btnSettingTable: TsSpeedButton
      Left = 53
      ExplicitLeft = 53
    end
  end
  inherited grdFilterDate: TGridPanel
    Top = 56
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 80.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 2
        Control = lblFrom
        Row = 0
      end
      item
        Column = 3
        Control = DateBeg
        Row = 0
      end
      item
        Column = 4
        Control = lblTo
        Row = 0
      end
      item
        Column = 5
        Control = DateTo
        Row = 0
      end
      item
        Column = 6
        Control = btnFilter
        Row = 0
      end
      item
        Column = 0
        Control = sLabel1
        Row = 0
      end
      item
        Column = 1
        Control = cbAccounts
        Row = 0
      end>
    ExplicitTop = 56
    inherited lblFrom: TsLabel
      Left = 283
      Width = 94
      ExplicitLeft = 283
    end
    inherited DateBeg: TsDateEdit
      Left = 383
      ExplicitLeft = 338
    end
    inherited lblTo: TsLabel
      Left = 583
      Width = 34
      ExplicitLeft = 583
    end
    inherited DateTo: TsDateEdit
      Left = 623
      ExplicitLeft = 490
    end
    inherited btnFilter: TsSpeedButton
      Left = 823
      ExplicitLeft = 418
      ExplicitWidth = 19
    end
    object sLabel1: TsLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 74
      Height = 29
      Align = alClient
      Alignment = taCenter
      Anchors = []
      Caption = 'Account'
      Layout = tlCenter
      ExplicitWidth = 52
      ExplicitHeight = 19
    end
    object cbAccounts: TsComboBox
      Tag = 5
      AlignWithMargins = True
      Left = 83
      Top = 3
      Width = 194
      Height = 27
      Align = alClient
      Anchors = []
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      ItemIndex = -1
      TabOrder = 2
    end
  end
  inherited ActionList1: TActionList
    Left = 752
    Top = 16
  end
  inherited SaveRepDlg: TSaveDialog
    Left = 816
    Top = 24
  end
  inherited pmSettingTable: TPopupMenu
    Left = 688
    Top = 16
  end
end
