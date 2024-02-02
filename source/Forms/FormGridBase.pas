unit FormGridBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sEdit, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dxBar, DBWork, Vcl.Menus,
  cxButtons, System.Actions, Vcl.ActnList, FormResource, cxImage, cxBarEditItem,
  cxCheckBox, cxLabel, cxCalendar, MyMessageCls, DBWorkSQL, Uni, UniProvider,
  DateUtils, cxGridExportLink, CxGridUnit, Vcl.ExtCtrls, Vcl.Buttons,
  sSpeedButton, Vcl.Mask, sMaskEdit, sCustomComboEdit, sToolEdit, sLabel,
  FormColumnsGridEdit;

type
  TfrmBase = class(TForm)
    baseGridView: TcxGridDBTableView;
    baseGridLevel1: TcxGridLevel;
    baseGrid: TcxGrid;
    ActionList1: TActionList;
    actExit: TAction;
    actUpdate: TAction;
    actExcel: TAction;
    actFilter: TAction;
    actFindPanel: TAction;
    actSetFilter: TAction;
    actAutoWidth: TAction;
    actColumns: TAction;
    actAddRow: TAction;
    actDeleteRow: TAction;
    SaveRepDlg: TSaveDialog;
    actGroupPanel: TAction;
    actEdit: TAction;
    grdPnlButtonsTop: TGridPanel;
    btnExit: TsSpeedButton;
    btnUpdate: TsSpeedButton;
    btnExcel: TsSpeedButton;
    btnAdd: TsSpeedButton;
    btnEdit: TsSpeedButton;
    btnDel: TsSpeedButton;
    btnSettingTable: TsSpeedButton;
    pmSettingTable: TPopupMenu;
    A1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    grdFilterDate: TGridPanel;
    lblFrom: TsLabel;
    DateBeg: TsDateEdit;
    lblTo: TsLabel;
    DateTo: TsDateEdit;
    btnFilter: TsSpeedButton;
    procedure FormShow(Sender: TObject); virtual;
    procedure FormClose(Sender: TObject; var Action: TCloseAction); virtual;
    procedure actExitExecute(Sender: TObject);
    procedure baseGridViewDblClick(Sender: TObject);
    procedure actAddRowExecute(Sender: TObject); virtual;
    procedure actDeleteRowUpdate(Sender: TObject);
    procedure actDeleteRowExecute(Sender: TObject);virtual;
    procedure actUpdateExecute(Sender: TObject);
    procedure actUpdateUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actFilterUpdate(Sender: TObject);
    procedure actFindPanelExecute(Sender: TObject);
    procedure actSetFilterExecute(Sender: TObject);virtual;
    procedure actExcelExecute(Sender: TObject);
    procedure btnSettingTableClick(Sender: TObject);
    procedure actFilterExecute(Sender: TObject);
    procedure actGroupPanelExecute(Sender: TObject);
    procedure baseGridViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure actColumnsExecute(Sender: TObject);
  private
    { Private declarations }
    FIsDeleted : Boolean;
    frmColumnsGridEdit: TfrmColumnsGridEdit;
  public
    { Public declarations }
    GridClass : TFillGridFromBase;
    property IsDeleted : Boolean read FIsDeleted write FIsDeleted;
  end;

implementation

{$R *.dfm}

procedure TfrmBase.actAddRowExecute(Sender: TObject);
begin
  baseGridView.NewItemRow.Visible := not baseGridView.NewItemRow.Visible;
end;

procedure TfrmBase.actColumnsExecute(Sender: TObject);
begin
  if not Assigned(ActiveView) then exit;
  frmColumnsGridEdit := TfrmColumnsGridEdit.Create(nil);
  try
    frmColumnsGridEdit.GridView := ActiveView.View;
    frmColumnsGridEdit.ShowModal;
  finally
    FreeAndNil(frmColumnsGridEdit);
  end;
end;

procedure TfrmBase.actDeleteRowExecute(Sender: TObject);
begin
  IsDeleted := False;
  case ShowMyMessage('Delete the selected entry?',tQuestion,tBoth) of
    mrCancel : Exit;
  end;
  if not ActiveView.DeleteRow then Exit;
  IsDeleted := True;
end;

procedure TfrmBase.actDeleteRowUpdate(Sender: TObject);
var
  vColumn : TcxGridDBColumn;
  i,ARowIndex:Integer;
  ARowInfo:TcxRowInfo;
  EnableValue : Boolean;
begin
  try
    EnableValue := False;
    if ActiveView = nil then
    begin
      actDeleteRow.Enabled := False;
      Exit;
    end;
    if ActiveView.View <> nil then
    begin
      try
        if not Assigned(ActiveView.View.DataController) then
        begin
          actDeleteRow.Enabled := False;
          Exit;
        end;
        if not Assigned(ActiveView.View.DataController.DataSet) then
        begin
          actDeleteRow.Enabled := False;
          Exit;
        end;
      except
        exit;
      end;
      EnableValue := (ActiveView.View.DataController.DataSet.RecordCount > 0) and (ActiveView.View.Controller.SelectedRowCount > 0);
      vColumn := ActiveView.View.GetColumnByFieldName('closed');
      if vColumn = nil then
      begin
        actDeleteRow.Enabled := EnableValue;
        exit;
      end;
      for i := 0 to ActiveView.View.dataController.GetSelectedCount - 1 do
      begin
        ARowIndex := ActiveView.View.dataController.GetSelectedRowIndex(i);
        ARowInfo  := ActiveView.View.dataController.GetRowInfo(ARowIndex);
        EnableValue := not ActiveView.View.dataController.Values[ARowInfo.RecordIndex,vColumn.Index];
      end;
    end;
    actDeleteRow.Enabled := EnableValue;
  except
    ShowMyMessage('actDeleteRowUpdate',tError,tOk);
  end;
end;

procedure TfrmBase.actExcelExecute(Sender: TObject);
var
  filename : string;
begin
  if SaveRepDlg.Execute then
  begin
    if (ofExtensionDifferent in SaveRepDlg.Options) then
    begin
      filename:=ChangeFileExt(SaveRepDlg.FileName,SaveRepDlg.DefaultExt);
    end
    else
      filename:=SaveRepDlg.FileName;
    ExportGridToExcel(filename, baseGrid);
  end;
end;

procedure TfrmBase.actExitExecute(Sender: TObject);
begin
  case ShowMyMessage('Close the form without saving changes?', tQuestion, tBoth) of
    mrCancel : Exit;
  end;
  Close;
end;

procedure TfrmBase.actFilterExecute(Sender: TObject);
begin
  if Assigned(ActiveView) then
  begin
    actFilter.Checked := not actFilter.Checked;
    ActiveView.View.FilterRow.Visible := actFilter.Checked;
  end;
end;

procedure TfrmBase.actFilterUpdate(Sender: TObject);
begin
//  if ActiveView <> nil then
//    actFilter.Enabled := True
//  else
//    actFilter.Enabled := False;
end;

procedure TfrmBase.actFindPanelExecute(Sender: TObject);
begin
  if Assigned(ActiveView) then
  begin
    actFindPanel.Checked := not actFindPanel.Checked;
    if actFindPanel.Checked then
      ActiveView.View.FindPanel.DisplayMode := fpdmAlways
    else
      ActiveView.View.FindPanel.DisplayMode := fpdmNever;
  end;
end;

procedure TfrmBase.actGroupPanelExecute(Sender: TObject);
begin
  if Assigned(ActiveView) then
  begin
    actGroupPanel.Checked := not actGroupPanel.Checked;
    if actGroupPanel.Checked then
      ActiveView.View.OptionsView.GroupByBox := True
    else
      ActiveView.View.OptionsView.GroupByBox := False;
  end;
end;

procedure TfrmBase.actSetFilterExecute(Sender: TObject);
begin
  if ActiveView = nil then Exit;
  ActiveView.View := baseGridView;
  ActiveView.ChangeParametersAndReopen
            (
              [
                TQryParamValue.Create(ActiveView.View.Tag,'pDateFrom',StartOfTheDay(DateBeg.Date),tpDate,False),
                TQryParamValue.Create(ActiveView.View.Tag,'pDateTo',EndOfTheDay(DateTo.Date),tpDate,False)
              ]
            );
end;

procedure TfrmBase.actUpdateExecute(Sender: TObject);
var
  ARowIndex: Integer;
begin
  try
    if ActiveView <> nil then
    begin
      ActiveView.View.BeginUpdate();
      try
        if ActiveView.View.DataController = nil then Exit;
          ARowIndex := ActiveView.View.DataController.GetRowIndexByRecordIndex(ActiveView.View.DataController.FocusedRecordIndex, True);
        ActiveView.Refresh;
        while ARowIndex > 0 do
        begin
          ActiveView.View.DataController.DataSource.DataSet.Next;
          Dec(ARowIndex);
        end;
      finally
        ActiveView.View.EndUpdate;
      end;
    end;
  except
    ShowMyMessage('actUpdateExecute',tError,tOk);
  end;
end;

procedure TfrmBase.actUpdateUpdate(Sender: TObject);
begin
  try
    if ActiveView = nil then
    begin
      actUpdate.Enabled := False;
      Exit;
    end;
    actUpdate.Enabled := True;
  except
    ShowMyMessage('actUpdateUpdate',tError,tOk);
  end;
end;

procedure TfrmBase.baseGridViewCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
begin
//  ACanvas.Canvas.Font.Color := frmResource.FontColor;
end;

procedure TfrmBase.baseGridViewDblClick(Sender: TObject);
begin
//  ShowMyMessage(IntToStr(baseGridView.Tag),tConfirm,tOk);
end;

procedure TfrmBase.btnSettingTableClick(Sender: TObject);
var
  foo : TPoint;
begin
  GetCursorPos(foo);
  pmSettingTable.Popup(foo.X, foo.Y);
end;

procedure TfrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if GridClass <> nil then
    FreeAndNil(GridClass);
  Action := caFree;
end;

procedure TfrmBase.FormCreate(Sender: TObject);
var
  vDateFrom : TDate;
  vDateTo : TDate;
  vYear,vMonth,vDay : Word;
begin
  btnExit.SkinData.ColorTone := frmResource.BackGroundColor;
  btnUpdate.SkinData.ColorTone := frmResource.BackGroundColor;
  btnExcel.SkinData.ColorTone := frmResource.BackGroundColor;
  btnAdd.SkinData.ColorTone := frmResource.BackGroundColor;
  btnEdit.SkinData.ColorTone := frmResource.BackGroundColor;
  btnDel.SkinData.ColorTone := frmResource.BackGroundColor;
  btnSettingTable.SkinData.ColorTone := frmResource.BackGroundColor;
  btnFilter.SkinData.ColorTone := frmResource.BackGroundColor;
  grdPnlButtonsTop.Color := frmResource.BackGroundColor;

  vDateFrom := Now();
  DecodeDate(vDateFrom, vYear, vMonth, vDay);
  vDateFrom := IncDay(vDateFrom,-vDay+1);
  vDateTo := IncMonth(vDateFrom,1);
  vDateTo := IncDay(vDateTo,-1);
  DateBeg.Date := vDateFrom;
  DateTo.Date := vDateTo;
//  chbEnableFilter.EditValue := False;
//  chbEnableFindPanel.EditValue := False;
//  cxbrdtmEnableGroupPanel.EditValue := False;
end;

procedure TfrmBase.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

end.
