unit FormUpperLimit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormGridBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, Vcl.Menus,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Mask, sMaskEdit, CxGridUnit,
  sCustomComboEdit, sToolEdit, sLabel, Vcl.Buttons, sSpeedButton, Vcl.ExtCtrls,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, DBWork,
  cxGridTableView, cxGridDBTableView, cxGrid, FormResource, MyMessageCls,
  Data.Win.ADODB, DateUtils, sDialogs, System.StrUtils, frxClass;

type
  TfrmUpperLimit = class(TfrmBase)
    btnImport: TsSpeedButton;
    actImportCSV: TAction;
    odImport: TsOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actImportCSVExecute(Sender: TObject);
  private
    { Private declarations }
    GrdLimits : TFillGridFromBase;
    procedure DataSource1DataChange(Sender: TObject; Field: Data.DB.TField);
  public
    { Public declarations }
  end;

var
  frmUpperLimit: TfrmUpperLimit;

implementation

{$R *.dfm}

procedure TfrmUpperLimit.FormCreate(Sender: TObject);
begin
  inherited;
  btnImport.SkinData.ColorTone := frmResource.BackGroundColor;
  GrdLimits := TFillGridFromBase.Create(
                                          baseGrid,[
                                                      TQryParamValue.Create(baseGridView.Tag,'pDateFrom',StartOfTheDay(DateBeg.Date),tpDate),
                                                      TQryParamValue.Create(baseGridView.Tag,'pDateTo',EndOfTheDay(DateTo.Date),tpDate)
                                                   ]
                                        );
  baseGridView.DataController.DataSource.OnDataChange := DataSource1DataChange;
end;

procedure TfrmUpperLimit.DataSource1DataChange(Sender: TObject; Field: Data.DB.TField);
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
        if baseGridView.DataController.DataSource.DataSet.FieldByName('value').AsFloat = 0 then
        begin
          ShowMyMessage('Invalid monetary amount specified');
          baseGridView.DataController.DataSource.DataSet.Cancel;
          exit;
        end;
        case ShowMyMessage('Confirm your balance replenishment ¹' + baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsString + '?',tQuestion,tBoth) of
          mrCancel :
          begin
            baseGridView.DataController.DataSource.DataSet.Cancel;
            exit;
          end;
        end;
        if not pPDB.CloseLimitIncrease(ADOQuery, baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsInteger) then
        begin
          baseGridView.DataController.DataSource.DataSet.Cancel;
          exit;
        end;
      end
      else
      begin
        case ShowMyMessage('Confirm the opening of the balance replenishment ¹' + baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsString + '?',tQuestion,tBoth) of
          mrCancel :
          begin
            baseGridView.DataController.DataSource.DataSet.Cancel;
            exit;
          end;
        end;
        if not pPDB.UnCloseLimitIncrease(ADOQuery, baseGridView.DataController.DataSource.DataSet.FieldByName('id').AsInteger) then
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

procedure TfrmUpperLimit.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(GrdLimits);
end;

procedure TfrmUpperLimit.actImportCSVExecute(Sender: TObject);
var
  LCSVFile : TStringList;
  line : string;
  value : string;
  i : Byte;
  vCustomer, vCurrecy : integer;
  vValue : Real;
  ADOQuery : TADOQuery;
begin
  if not odImport.Execute then
    Exit;
  if odImport.FileName = '' then Exit;
  LCSVFile := TStringList.Create;
  ADOQuery := pPDB.CreateQuerry;
  try
    LCSVFile.LoadFromFile(odImport.FileName);
    try
      for line in LCSVFile do
      begin
        i := 1;  vCustomer := 0; vCurrecy := 0; vValue := 0;
        for value in SplitString(line, ';') do
        begin
          case i of
            1: vCustomer := StrToInt(value);
            2: vCurrecy := StrToInt(value);
            3: vValue := StrToFloat(value);
          end;
          Inc(i);
        end;
        if (vCustomer > 0) and (vCurrecy > 0) and (vValue <> 0) then
          if not pPDB.INSERT_CLOSE_LIMIT(ADOQuery, vCustomer, vCurrecy, vValue) then Continue;
      end;
    except
      on E:Exception do
        ShowMyMessage(E.Message,tError,tOk);
    end;
    GrdLimits.RefreshGrid;
  finally
    FreeAndNil(LCSVFile);
    FreeAndNil(ADOQuery);
  end;
end;

end.
