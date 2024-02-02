object frmBase: TfrmBase
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'frmGridBase'
  ClientHeight = 616
  ClientWidth = 1006
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object baseGrid: TcxGrid
    AlignWithMargins = True
    Left = 3
    Top = 88
    Width = 1000
    Height = 525
    Align = alClient
    BevelInner = bvNone
    TabOrder = 0
    object baseGridView: TcxGridDBTableView
      OnDblClick = baseGridViewDblClick
      Navigator.Buttons.CustomButtons = <>
      FindPanel.InfoText = 'Enter text to search'
      FindPanel.ShowClearButton = False
      FindPanel.ShowCloseButton = False
      FindPanel.ShowFindButton = False
      OnCustomDrawCell = baseGridViewCustomDrawCell
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      FilterRow.InfoText = 'To search the table, click here...'
      FilterRow.ApplyChanges = fracDelayed
      NewItemRow.InfoText = 'Click here to add an entry'
      OptionsData.Appending = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      Styles.Background = frmResource.cxstylGridBack
      Styles.ContentEven = frmResource.cxstylGridBack
      Styles.ContentOdd = frmResource.cxstylGridBack
      Styles.FilterBox = frmResource.cxstylGridBack
      Styles.FindPanel = frmResource.cxstylGridBack
      Styles.Inactive = frmResource.cxstylGridBack
      Styles.IncSearch = frmResource.cxstylGridBack
      Styles.Selection = frmResource.cxStyleSelectedGrid
      Styles.FilterRowInfoText = frmResource.cxstylGridBack
      Styles.Group = frmResource.cxstylGridBack
      Styles.GroupByBox = frmResource.cxstylGridBack
      Styles.Header = frmResource.cxstylGridBack
      Styles.Preview = frmResource.cxstylGridBack
    end
    object baseGridLevel1: TcxGridLevel
      GridView = baseGridView
    end
  end
  object grdPnlButtonsTop: TGridPanel
    Left = 0
    Top = 0
    Width = 1006
    Height = 50
    Align = alTop
    BevelOuter = bvNone
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
        Column = 6
        Control = btnSettingTable
        Row = 0
      end>
    ParentColor = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    object btnExit: TsSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = -6
      Height = 44
      Action = actExit
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      DisabledGlyphKind = [dgBlended, dgGrayed]
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 8
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnUpdate: TsSpeedButton
      AlignWithMargins = True
      Left = 153
      Top = 3
      Width = 44
      Height = 44
      Action = actUpdate
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 9
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnExcel: TsSpeedButton
      AlignWithMargins = True
      Left = 203
      Top = 3
      Width = 44
      Height = 44
      Action = actExcel
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 10
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnAdd: TsSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 44
      Height = 44
      Action = actAddRow
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 28
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnEdit: TsSpeedButton
      AlignWithMargins = True
      Left = 53
      Top = 3
      Width = 44
      Height = 44
      Action = actEdit
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      DisabledGlyphKind = [dgBlended, dgGrayed]
      DisabledKind = [dkBlended, dkGrayed]
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 18
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnDel: TsSpeedButton
      AlignWithMargins = True
      Left = 103
      Top = 3
      Width = 44
      Height = 44
      Action = actDeleteRow
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 15
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnSettingTable: TsSpeedButton
      AlignWithMargins = True
      Left = 253
      Top = 3
      Width = 54
      Height = 44
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1090#1072#1073#1083#1080#1094#1099
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSettingTableClick
      ButtonStyle = tbsDropDown
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = clDefault
      Images = frmResource.imgList30_30
      GlyphColorTone = clGreen
      ImageIndex = 7
      Grayed = True
      ExplicitLeft = 32
      ExplicitTop = 24
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
  object grdFilterDate: TGridPanel
    Left = 0
    Top = 50
    Width = 1006
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 120.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
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
        Column = 0
        Control = lblFrom
        Row = 0
      end
      item
        Column = 1
        Control = DateBeg
        Row = 0
      end
      item
        Column = 2
        Control = lblTo
        Row = 0
      end
      item
        Column = 3
        Control = DateTo
        Row = 0
      end
      item
        Column = 4
        Control = btnFilter
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 2
    object lblFrom: TsLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 114
      Height = 29
      Align = alClient
      Alignment = taCenter
      Caption = 'Date from'
      Layout = tlCenter
      ExplicitWidth = 65
      ExplicitHeight = 19
    end
    object DateBeg: TsDateEdit
      AlignWithMargins = True
      Left = 123
      Top = 3
      Width = 194
      Height = 29
      Align = alClient
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 0
      Text = '  .  .    '
      ExplicitHeight = 27
    end
    object lblTo: TsLabel
      AlignWithMargins = True
      Left = 323
      Top = 3
      Width = 44
      Height = 29
      Align = alClient
      Alignment = taCenter
      Caption = 'to'
      Layout = tlCenter
      ExplicitWidth = 13
      ExplicitHeight = 19
    end
    object DateTo: TsDateEdit
      AlignWithMargins = True
      Left = 373
      Top = 3
      Width = 194
      Height = 29
      Align = alClient
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 1
      Text = '  .  .    '
      ExplicitHeight = 27
    end
    object btnFilter: TsSpeedButton
      AlignWithMargins = True
      Left = 573
      Top = 3
      Width = 29
      Height = 29
      Action = actSetFilter
      Align = alClient
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      Images = frmResource.imgList30_30
      ImageIndex = 29
      ExplicitLeft = 333
      ExplicitWidth = 27
      ExplicitHeight = 24
    end
  end
  object ActionList1: TActionList
    Images = frmResource.imgList30_30
    Left = 624
    Top = 104
    object actExit: TAction
      Hint = 'Exit'
      ImageIndex = 8
      OnExecute = actExitExecute
    end
    object actUpdate: TAction
      Hint = 'Update'
      ImageIndex = 9
      OnExecute = actUpdateExecute
      OnUpdate = actUpdateUpdate
    end
    object actExcel: TAction
      Hint = 'Upload to excel'
      ImageIndex = 10
      OnExecute = actExcelExecute
    end
    object actFilter: TAction
      Caption = 'Filter'
      ImageIndex = 11
      OnExecute = actFilterExecute
      OnUpdate = actFilterUpdate
    end
    object actFindPanel: TAction
      Caption = 'Search bar'
      ImageIndex = 29
      OnExecute = actFindPanelExecute
    end
    object actSetFilter: TAction
      Hint = 'Apply filter'
      ImageIndex = 29
      OnExecute = actSetFilterExecute
    end
    object actAutoWidth: TAction
      Caption = 'Auto-leveling'
      ImageIndex = 14
    end
    object actColumns: TAction
      Caption = 'Setting up table columns'
      ImageIndex = 12
      OnExecute = actColumnsExecute
    end
    object actAddRow: TAction
      Hint = 'Add a record to the table'
      ImageIndex = 28
      OnExecute = actAddRowExecute
    end
    object actDeleteRow: TAction
      Hint = 'Delete line'
      ImageIndex = 15
      OnExecute = actDeleteRowExecute
      OnUpdate = actDeleteRowUpdate
    end
    object actGroupPanel: TAction
      Caption = 'Grouping a table'
      ImageIndex = 17
      OnExecute = actGroupPanelExecute
    end
    object actEdit: TAction
      ImageIndex = 18
    end
  end
  object SaveRepDlg: TSaveDialog
    Filter = 'Excel|*.xls'
    Left = 472
    Top = 104
  end
  object pmSettingTable: TPopupMenu
    Images = frmResource.imgList30_30
    MenuAnimation = [maTopToBottom]
    OwnerDraw = True
    Left = 384
    Top = 56
    object A1: TMenuItem
      Action = actFilter
    end
    object N1: TMenuItem
      Action = actFindPanel
    end
    object N2: TMenuItem
      Action = actAutoWidth
    end
    object N3: TMenuItem
      Action = actGroupPanel
    end
    object N4: TMenuItem
      Action = actColumns
    end
  end
end
