inherited frmUpperLimit: TfrmUpperLimit
  Caption = 'UpperLimit'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  inherited baseGrid: TcxGrid
    inherited baseGridView: TcxGridDBTableView
      Tag = 2
    end
  end
  inherited grdPnlButtonsTop: TGridPanel
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
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
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 60.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 300.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = btnExit
        Row = 0
      end
      item
        Column = 4
        Control = btnUpdate
        Row = 0
      end
      item
        Column = 5
        Control = btnExcel
        Row = 0
      end
      item
        Column = 1
        Control = btnAdd
        Row = 0
      end
      item
        Column = 2
        Control = btnEdit
        Row = 0
      end
      item
        Column = 3
        Control = btnDel
        Row = 0
      end
      item
        Column = 6
        Control = btnSettingTable
        Row = 0
      end
      item
        Column = 7
        Control = btnImport
        Row = 0
      end>
    inherited btnUpdate: TsSpeedButton
      Left = 103
    end
    inherited btnExcel: TsSpeedButton
      Left = 153
    end
    inherited btnEdit: TsSpeedButton
      Width = -6
    end
    inherited btnDel: TsSpeedButton
      Left = 53
    end
    inherited btnSettingTable: TsSpeedButton
      Left = 203
    end
    object btnImport: TsSpeedButton
      AlignWithMargins = True
      Left = 263
      Top = 3
      Width = 294
      Height = 44
      Action = actImportCSV
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
  inherited ActionList1: TActionList
    object actImportCSV: TAction
      Caption = 'Import from CSV'
      Hint = 'Import from CSV'
      OnExecute = actImportCSVExecute
    end
  end
  object odImport: TsOpenDialog
    Filter = 'CSV File *.csv|*.csv'
    Left = 624
    Top = 8
  end
end
