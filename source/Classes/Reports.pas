unit Reports;

interface

uses System.Classes,frxClass,Vcl.Forms,System.SysUtils,frxPrinter,SettingData,
     Data.DB, frxDBSet, System.Generics.Collections, System.DateUtils,
     DBWork, MyMessageCls, Data.Win.ADODB;

type
  tTypeFrxParam = (tpfrxNone,tpfrxString,tpfrxInteger,tpfrxFloat,tpfrxDate);

  TQryFrxParamValue = class
  private
    vNSQL       : SmallInt;
    vParamName  : string;
    vParamValue : Variant;
    vParamType  : tTypeFrxParam;
  public
    constructor Create(pNSQL:SmallInt;pParamName:string;pParamValue:Variant;pParamType:tTypeFrxParam);
  end;

  TSQLReport = class
  private
    vNSQL              : Integer;
    Qry                : TADOQuery;
    Src                : TDataSource;
    frxSrc             : TfrxDBDataset;
    linkMasterDataName : string;
    listParam          : TList<TQryFrxParamValue>;
    procedure SetParamsInFrxSQL;
  public
    constructor Create(pNSQl:integer;pSQL,pQryName,pLinkMD:string;frxReport:TfrxReport;pParamsValue:TList<TQryFrxParamValue>);
    destructor Destroy;override;
  end;

  TFillFrxReport = class
  private
    Qry : TADOQuery;
    frxReport : TfrxReport;
    vReportId : Integer;
    lstQry    : TList<TSQLReport>;
    procedure RunSQL;
  public
    procedure SetVariableValue(pVarName:string;pValue:variant);
    procedure ShowReport;
    constructor Create(pReportId:integer;pParamsValue:array of TQryFrxParamValue);
    destructor Destroy;override;
  end;

type TReport=class(TPersistent)
   private

   protected

   public
      procedure ImportReportExcel(TaskId : integer);virtual;abstract;
      constructor Create;
      destructor Destroy;override;
end;

type TMyFrxReport=class(TObject)
    frxReport:TfrxReport;
  public
    procedure SetPrinter(PrinterName:string);
    procedure LoadFromFile(fileName:string);
    procedure AddVariable(varname,value:string);
    procedure ShowReport;
    procedure PrintReport(copies:smallint);
    constructor create;
    destructor Destroy;override;
end;

TReportClass=class of TReport;

implementation

constructor TQryFrxParamValue.Create(pNSQL:SmallInt;pParamName:string;pParamValue:Variant;pParamType:tTypeFrxParam);
begin
  vNSQL := pNSQL;
  vParamName := pParamName;
  vParamValue := pParamValue;
  vParamType  := pParamType;
end;

constructor TSQLReport.Create(pNSQl:integer;pSQL,pQryName,pLinkMD:string;frxReport:TfrxReport;pParamsValue:TList<TQryFrxParamValue>);
begin
  vNSQL := pNSQl;
  Qry := pPDB.CreateQuerry;
  Qry.SQL.Text := pSQL;
  if pLinkMD <> '' then
  begin
    Src := TDataSource.Create(nil);
    frxSrc := TfrxDBDataset.Create(nil);
    frxSrc.Name := pQryName;
    frxSrc.UserName := pQryName;
    linkMasterDataName := pLinkMD;
    frxSrc.DataSet := Qry;
    frxReport.DataSets.Add(frxSrc);
  end;
  listParam := pParamsValue;
end;

destructor TSQLReport.Destroy;
begin
  FreeAndNil(Qry);
  while listParam.Count > 0 do
  begin
    TQryFrxParamValue(listParam.Items[0]).Destroy;
    listParam.Delete(0);
  end;
  FreeAndNil(listParam);
  if linkMasterDataName <> '' then
  begin
    FreeAndNil(Src);
    FreeAndNil(frxSrc);
  end;
end;

constructor TFillFrxReport.Create(pReportId:integer;pParamsValue:array of TQryFrxParamValue);
var
  i : Integer;
  lstParams : TList<TQryFrxParamValue>;
begin
  Qry := pPDB.CreateQuerry;
  frxReport := pPDB.GetFrxTemplate(Qry,pReportId);
  if frxReport = nil then
  begin
    ShowMyMessage('Could not open report template!',tError,tOk);
    FreeAndNil(Qry);
    Exit;
  end;
  lstQry := TList<TSQLReport>.Create;
  vReportId := pReportId;
  pPDB.GetSubSQLFrxReport(Qry,pReportId);
  while not Qry.eof do
  begin
    lstParams := TList<TQryFrxParamValue>.Create;
    for I := 0 to Length(pParamsValue) - 1 do
    if Qry.FieldByName('n').AsInteger = TQryFrxParamValue(pParamsValue[i]).vNSQL then
      lstParams.Add(TQryFrxParamValue(pParamsValue[i]));
    lstQry.Add(TSQLReport.Create
                (
                  Qry.FieldByName('n').AsInteger,
                  Qry.FieldByName('sqltext').AsString,
                  Qry.FieldByName('nameQry').AsString,
                  Qry.FieldByName('linkMD').AsString,
                  frxReport,
                  lstParams
                )
              );
    if Qry.FieldByName('linkMD').AsString <> '' then
      TfrxMasterData(frxReport.FindComponent(Qry.FieldByName('linkMD').AsString)).DataSet:=frxReport.DataSets.Find(Qry.FieldByName('nameQry').AsString).DataSet;
    Qry.next;
  end;
end;

destructor TFillFrxReport.Destroy;
begin
  FreeAndNil(Qry);
  frxReport.Clear;
  FreeAndNil(frxReport);
  while lstQry.Count > 0 do
  begin
    TSQLReport(lstQry.Items[0]).Destroy;
    lstQry.Delete(0);
  end;
  FreeAndNil(lstQry);
end;

procedure TFillFrxReport.RunSQL;
var
  i : Integer;
begin
  for i := 0 to lstQry.Count - 1 do
  begin
    TSQLReport(lstQry.Items[i]).SetParamsInFrxSQL;
    pPDB.OpenQuerry(TSQLReport(lstQry.Items[i]).Qry);
  end;
end;

procedure TFillFrxReport.SetVariableValue(pVarName:string;pValue:variant);
begin
  frxReport.Variables[pVarName] := QuotedStr(pValue);
end;

procedure TFillFrxReport.ShowReport;
begin
  RunSQL;
  frxReport.PrepareReport();
  frxReport.ShowReport();
end;

procedure TSQLReport.SetParamsInFrxSQL;
var
  i : Integer;
function PadL(cVal: string; nWide: integer; cChr: char): string;
var
  i1, nStart: integer;
begin
  if length(cVal) < nWide then
  begin
    nStart:=length(cVal);
    for i1:=nStart to nWide-1 do
      cVal:=cChr+cVal;
  end;
  Result:=cVal;
end;
begin
  Qry.Prepared;
  for i := 0 to listParam.Count - 1 do
  case TQryFrxParamValue(listParam.Items[i]).vParamType of
    tpfrxString:
      Qry.SQL.Text := StringReplace(Qry.SQL.Text,':'+TQryFrxParamValue(listParam.Items[i]).vParamName,QuotedStr(TQryFrxParamValue(listParam.Items[i]).vParamValue),[rfReplaceAll, rfIgnoreCase]);
    tpfrxInteger:Qry.Parameters.ParamByName(TQryFrxParamValue(listParam.Items[i]).vParamName).Value := TQryFrxParamValue(listParam.Items[i]).vParamValue;
    tpfrxFloat:Qry.Parameters.ParamByName(TQryFrxParamValue(listParam.Items[i]).vParamName).Value := TQryFrxParamValue(listParam.Items[i]).vParamValue;
    tpfrxDate:
      Qry.SQL.Text := StringReplace(Qry.SQL.Text,':'+TQryFrxParamValue(listParam.Items[i]).vParamName,
                      QuotedStr(IntToStr(YearOf(TQryFrxParamValue(listParam.Items[i]).vParamValue))+'-'+
                      PadL(IntToStr(MonthOf(TQryFrxParamValue(listParam.Items[i]).vParamValue)),2,'0')+'-'+
                      PadL(IntToStr(DayOf(TQryFrxParamValue(listParam.Items[i]).vParamValue)),2,'0')),[rfReplaceAll, rfIgnoreCase]);
  end;
end;


constructor TReport.Create;
begin
  inherited create;
end;

destructor TReport.Destroy;
begin
  inherited Destroy;
end;

constructor TMyFrxReport.Create;
begin
  inherited create;
  frxReport := TfrxReport.Create(Application);
end;

destructor TMyFrxReport.Destroy;
begin
  inherited Destroy;
  FreeAndNil(frxReport);
end;

procedure TMyFrxReport.SetPrinter(PrinterName : string);
begin
  frxReport.PrintOptions.Printer := PrinterName;
  frxReport.SelectPrinter;
end;

procedure TMyFrxReport.LoadFromFile(fileName:string);
begin
  frxReport.LoadFromFile(fileName);
end;

procedure TMyFrxReport.AddVariable(varname,value:string);
var
  obj: TfrxMemoView;
begin
  obj := TfrxMemoView(frxReport.FindObject(varname));
  if obj <> nil then
   obj.Memo.Text := value;
end;

procedure TMyFrxReport.ShowReport;
begin
  frxReport.PrepareReport(true);
  frxReport.ShowReport();
end;

procedure TMyFrxReport.PrintReport(copies:smallint);
begin
  frxReport.PrepareReport(true);
  with frxReport.PrintOptions do
  begin
    ShowDialog:=false;
    Copies:=copies;
  end;
  if SettingControl.SettingData.PrinterName <> '' then
    frxReport.Print
  else
    frxReport.ShowReport();
end;

end.
