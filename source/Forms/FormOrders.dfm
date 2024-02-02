inherited frmOrders: TfrmOrders
  Caption = 'frmOrders'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  inherited baseGrid: TcxGrid
    ExplicitLeft = 8
    inherited baseGridView: TcxGridDBTableView
      Tag = 3
      OnCellDblClick = baseGridViewCellDblClick
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
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 60.000000000000000000
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
        Column = 7
        Control = btnSettingTable
        Row = 0
      end
      item
        Column = 6
        Control = btnReport
        Row = 0
      end>
    inherited btnSettingTable: TsSpeedButton
      Left = 303
    end
    object btnReport: TsSpeedButton
      AlignWithMargins = True
      Left = 253
      Top = 3
      Width = 44
      Height = 44
      Action = actReport
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 12
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
  inherited ActionList1: TActionList
    inherited actSetFilter: TAction
      Hint = ''
    end
    inherited actEdit: TAction
      OnExecute = actEditExecute
    end
    object actReport: TAction
      Tag = 1
      Hint = 'Report'
      ImageIndex = 12
      OnExecute = actReportExecute
    end
  end
end
