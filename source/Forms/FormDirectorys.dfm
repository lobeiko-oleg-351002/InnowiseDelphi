inherited frmDirectorys: TfrmDirectorys
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
  ClientHeight = 911
  ClientWidth = 1232
  OnDestroy = FormDestroy
  ExplicitWidth = 1232
  ExplicitHeight = 911
  PixelsPerInch = 96
  TextHeight = 19
  object Splitter1: TSplitter [0]
    Left = 359
    Top = 85
    Height = 826
    ExplicitLeft = 288
    ExplicitTop = 232
    ExplicitHeight = 100
  end
  inherited baseGrid: TcxGrid
    Left = 365
    Width = 864
    Height = 820
    ExplicitLeft = 362
    ExplicitWidth = 870
    ExplicitHeight = 826
    inherited baseGridView: TcxGridDBTableView
      Tag = 1
      OptionsData.DeletingConfirmation = False
    end
  end
  object tvDict: TsTreeView [2]
    Tag = 1
    AlignWithMargins = True
    Left = 3
    Top = 88
    Width = 353
    Height = 820
    Align = alLeft
    BevelInner = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Calibri'
    Font.Style = []
    Images = frmResource.imgList30_30
    Indent = 33
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    OnChange = tvDictChange
    SkinData.CustomColor = True
    SkinData.CustomFont = True
  end
  inherited grdPnlButtonsTop: TGridPanel
    Width = 1232
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
        Value = 50.000000000000000000
      end>
    ExplicitWidth = 1232
    inherited btnUpdate: TsSpeedButton
      ExplicitLeft = 153
    end
    inherited btnExcel: TsSpeedButton
      ExplicitLeft = 203
    end
    inherited btnEdit: TsSpeedButton
      ExplicitWidth = 44
    end
    inherited btnDel: TsSpeedButton
      ExplicitLeft = 103
    end
    inherited btnSettingTable: TsSpeedButton
      Width = 44
      ExplicitLeft = 203
      ExplicitWidth = 54
    end
  end
  inherited grdFilterDate: TGridPanel
    Width = 1232
    TabOrder = 3
    Visible = False
    ExplicitWidth = 1232
  end
  inherited ActionList1: TActionList
    inherited actAddRow: TAction
      OnUpdate = actAddRowUpdate
    end
  end
end
