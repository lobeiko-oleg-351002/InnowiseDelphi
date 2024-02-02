inherited frmOrderEdit: TfrmOrderEdit
  Caption = 'frmOrderEdit'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  inherited baseGrid: TcxGrid
    ExplicitLeft = 3
    ExplicitTop = 88
    ExplicitWidth = 1000
    ExplicitHeight = 525
    inherited baseGridView: TcxGridDBTableView
      Tag = 4
    end
  end
  inherited grdPnlButtonsTop: TGridPanel
    ColumnCollection = <
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
      end
      item
        SizeStyle = ssAbsolute
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
        Column = 7
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
        Column = 2
        Control = btnSave
        Row = 0
      end>
    inherited btnExit: TsSpeedButton
      Width = 44
      ExplicitWidth = 44
    end
    inherited btnUpdate: TsSpeedButton
      Left = 203
      ExplicitLeft = 203
    end
    inherited btnExcel: TsSpeedButton
      Left = 253
      ExplicitLeft = 253
    end
    inherited btnAdd: TsSpeedButton
      Left = 53
      ExplicitLeft = 53
    end
    inherited btnEdit: TsSpeedButton
      Left = 363
      ExplicitLeft = 363
      ExplicitWidth = -6
    end
    inherited btnDel: TsSpeedButton
      Left = 153
      ExplicitLeft = 153
    end
    inherited btnSettingTable: TsSpeedButton
      Left = 303
      ExplicitLeft = 303
    end
    object btnSave: TsSpeedButton
      AlignWithMargins = True
      Left = 103
      Top = 3
      Width = 44
      Height = 44
      Action = actSave
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      DisabledGlyphKind = [dgBlended, dgGrayed]
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 26
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
  inherited grdFilterDate: TGridPanel
    Visible = False
  end
  inherited ActionList1: TActionList
    inherited actAddRow: TAction
      OnUpdate = actAddRowUpdate
    end
    inherited actDeleteRow: TAction
      OnUpdate = actAddRowUpdate
    end
    object actSave: TAction
      Hint = 'Save'
      ImageIndex = 26
      OnExecute = actSaveExecute
      OnUpdate = actAddRowUpdate
    end
  end
end
