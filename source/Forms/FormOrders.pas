unit FormOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormGridBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, Vcl.Menus,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Mask, sMaskEdit, DBWork,
  sCustomComboEdit, sToolEdit, sLabel, Vcl.Buttons, sSpeedButton, Vcl.ExtCtrls,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, CxGridUnit,
  cxGridTableView, cxGridDBTableView, cxGrid, FormResource, MyMessageCls,
  FormOrderEdit, Data.Win.ADODB, DateUtils, frxClass, Reports;

type
  TfrmOrders = class(TfrmBase)
    btnReport: TsSpeedButton;
    actReport: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure baseGridViewCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure actReportExecute(Sender: TObject);
  private
    { Private declarations }
    GrdOrders : TFillGridFromBase;
    frmOrderEdit: TfrmOrderEdit;
    tmrTimer : TTimer;
    procedure DataSource1DataChange(Sender: TObject; Field: Data.DB.TField);
    procedure TimerAction(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmOrders: TfrmOrders;

implementation

{$R *.dfm}

procedure TfrmOrders.FormCreate(Sender: TObject);
begin
  inherited;
  btnReport.SkinData.ColorTone := frmResource.BackGroundColor;
  GrdOrders := TFillGridFromBase.Create(
                                          baseGrid,[
                                                      TQryParamValue.Create(baseGridView.Tag,'pDateFrom',StartOfTheDay(DateBeg.Date),tpDate),
                                                      TQryParamValue.Create(baseGridView.Tag,'pDateTo',EndOfTheDay(DateTo.Date),tpDate)
                                                   ]
                                        );
  baseGridView.DataController.DataSource.OnDataChange := DataSource1DataChange;
end;

procedure TfrmOrders.TimerAction(Sender: TObject);
begin
  if frmOrderEdit.CanClose then
  begin
    tmrTimer.Enabled := False;
    GrdOrders.RefreshGrid;
    FreeAndNil(frmOrderEdit);
  end;
end;

procedure TfrmOrders.actEditExecute(Sender: TObject);
begin
  inherited;
  frmOrderEdit := TfrmOrderEdit.Create(nil);
  frmOrderEdit.Prnt := Self.parent;
  frmOrderEdit.Closed := baseGridView.DataController.DataSource.DataSet.FieldByName('closed').AsBoolean;
  frmOrderEdit.OrderId := baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsInteger;
  tmrTimer := TTimer.Create(frmOrderEdit);
  tmrTimer.Interval := 50;
  tmrTimer.OnTimer := TimerAction;
  frmOrderEdit.Show;
end;

procedure TfrmOrders.actReportExecute(Sender: TObject);
var
  vReport : TFillFrxReport;
begin
  try
    vReport := TFillFrxReport.Create
                      (
                        TAction(Sender).Tag,
                        [
                          TQryFrxParamValue.Create(1,'pDateFrom',StartOfTheDay(DateBeg.Date),tpfrxDate),
                          TQryFrxParamValue.Create(1,'pDateTo',EndOfTheDay(DateTo.Date),tpfrxDate)
                        ]
                      );
    vReport.SetVariableValue('DateFrom',DateBeg.Text);
    vReport.SetVariableValue('DateTo',DateTo.Text);
    vReport.ShowReport;
  finally
    FreeAndNil(vReport);
  end;
end;


procedure TfrmOrders.baseGridViewCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  btnEdit.Click;
end;

procedure TfrmOrders.DataSource1DataChange(Sender: TObject; Field: Data.DB.TField);
var
  ADOQuery : TADOQuery;
begin
  if Field = nil then Exit;
  if Field.FieldName = 'closed' then
  begin
    ADOQuery := pPDB.CreateQuerry;
    try
      if Field.Value then
      begin
        case ShowMyMessage('Confirm close order ¹' + baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsString + '?',tQuestion,tBoth) of
          mrCancel :
          begin
            baseGridView.DataController.DataSource.DataSet.Cancel;
            exit;
          end;
        end;
        if not pPDB.OrderClose(ADOQuery,baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsInteger) then
        begin
          baseGridView.DataController.DataSource.DataSet.Cancel;
          exit;
        end;
      end
      else
      begin
        case ShowMyMessage('Confirm order opening ¹' + baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsString + '?',tQuestion,tBoth) of
          mrCancel :
          begin
            baseGridView.DataController.DataSource.DataSet.Cancel;
            exit;
          end;
        end;
        if not pPDB.OrderUnClose(ADOQuery,baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsInteger) then
        begin
          baseGridView.DataController.DataSource.DataSet.Cancel;
          exit;
        end;
      end;
    finally
      FreeAndNil(ADOQuery);
    end;
  end;
end;

procedure TfrmOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(GrdOrders);
end;

end.
