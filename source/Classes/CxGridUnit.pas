unit CxGridUnit;

interface

uses DBWork, Uni, Data.DB, cxGrid, cxGridDBTableView, cxCustomPivotGrid, cxPivotGrid,
     System.Classes, cxGridCustomTableView, Vcl.Controls, System.Generics.Collections,
     System.SysUtils, cxCustomData, System.Variants, FormResource, MyMessageCls,
     cxCheckBox, cxDBLookupComboBox, cxEdit, cxTextEdit, Data.Win.ADODB;

type
  TFillCBXDBField = class
  private
    QLcbx   : TAdoQuery;
    SrcLcbx : TDataSource;
    tag : Integer;
  public
    procedure RefreshCBX(pValues:array of TQryParamValue);
    constructor Create(pTag:integer;pColumn : TcxGridDBColumn;pValues:array of TQryParamValue);
    destructor Destroy;override;
  end;

  TFieldData = class
  private
    column          : TcxGridDBColumn;
    nn              : SmallInt;
    name            : string;
    vsField         : Boolean;
    edField         : Boolean;
    perWidth        : Real;
    fieldName       : string;
    fieldType       : tTypeParam;
    paramName       : string;
    cbxsqlid        : Integer;
    CBXDBFieldData  : TFillCBXDBField;
  public
    constructor Create(pNn:SmallInt;pName,pFieldName,pParamName:string;pVsField,pEdField:Boolean;pPerWidth:Real;pCbxSqlId:integer;pfieldType:tTypeParam;pView:TcxGridDBTableView);
    destructor Destroy;override;
  end;

  TLinkDataGrid = class(TObject)
  private
    Src         : TDataSource;
    Qry         : TADOQuery;
    SQLDefText  : string;
    SQLText     : string;
    SqlConcat   : string;
    SqlReplace  : string;
    SQLOrder    : string;
    SQLInsert    : string;
    SQLUpdate   : string;
    SQLDelete   : string;
    ListFields  : TList<TFieldData>;
    NeedSave    : Boolean;
    HideNewRowBeforeAdded : Boolean;
    FView : TcxGridDBTableView;
    HidedFields: TArray<String>;
    function GetTag : string;
    procedure baseGridViewKeyPress(Sender: TObject; var Key: Char);
    procedure baseGridViewEditValueChanged(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure baseGridViewCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  public
    property View : TcxGridDBTableView read FView write FView;
    property Tag : string read GetTag ;
    procedure dsBeforePost(DataSet: TDataSet);
    function DeleteRow : boolean;
    procedure Refresh;
    procedure ChangeParametersAndReopen(pValues : array of TQryParamValue);
    procedure SetNeedSave(pNeedSave : boolean);
    constructor Create(pView : TcxGridDBTableView);
    destructor Destroy; override;
  end;

  TFillGridFromBase = class(TObject)
  private
    ListViewsFromGrid : TObjectDictionary<String, TLinkDataGrid>;
    vView : TLinkDataGrid;
    vGrid  : TcxGrid;
  public
    procedure RefreshGrid;
    procedure ClearGrid;
    function GetDataController(pViewTag : Integer) : TDataSource;
    procedure ChangeParametersAndReopen(pValues : array of TQryParamValue); overload;
    procedure ChangeParametersAndReopen(pTagView : Integer; pValues : array of TQryParamValue); overload;
    procedure SqlConcat(pView:TcxGridDBTableView;pSubSQL:string);
    procedure ClearSqlConcat(pView:TcxGridDBTableView);
    procedure ReplaseSqlSubStr(pView:TcxGridDBTableView;pBefore,pAfter:string);
    procedure ClearReplaseSqlSubStr(pView:TcxGridDBTableView);
    procedure SetValueParamByName(pView:TcxGridDBTableView; pValues : array of TQryParamValue);
    procedure SetHideNewRowBeforeAdded(pState : boolean);
    procedure ApplyWithOutEnterKey;
    constructor Create(pGrid : tCxGrid; pValues : array of TQryParamValue);
    destructor Destroy;override;
end;

var
  ActiveView  : TLinkDataGrid;

implementation

constructor TFillGridFromBase.Create(pGrid : tCxGrid; pValues : array of TQryParamValue);
var
  i, j : SmallInt;
begin
  ActiveView := nil;
  ListViewsFromGrid := TObjectDictionary<String, TLinkDataGrid>.Create([doOwnsValues]);
  vGrid := pGrid;
  for i := 0 to pGrid.ViewCount - 1 do
  if pGrid.Views[i].Tag > 0 then
  begin
    vView := TLinkDataGrid.Create(TcxGridDBTableView(pGrid.Views[i]));
    ActiveView := vView;
    if vView.ListFields.Count = 0 then Continue;
    ListViewsFromGrid.Add(vView.Tag,vView);
    with vView do
    begin
      SQLDefText := vView.Qry.SQL.Text;
      pPDB.SetParamValue(vView.View.Tag,vView.Qry,pValues);
      vView.View.NewItemRow.InfoText := 'Click here to add an entry';
      if not pPDB.OpenQuerry(vView.Qry) then
      begin
        ListViewsFromGrid.Free;
        exit;
      end;
      if vView.ListFields.Count <> vView.Qry.Fields.Count then
      begin
        ShowMyMessage('The number of columns in the query and in the table does not match!',tError,tOk);
        ListViewsFromGrid.Free;
        exit;
      end;
      for j := 0 to vView.Qry.Fields.Count - 1 do
      begin
        with TFieldData(vView.ListFields[j]).column do
        begin
          DataBinding.FieldName := vView.Qry.Fields[j].FieldName;
          Visible := TFieldData(vView.ListFields[j]).vsField;
          Options.Editing := TFieldData(vView.ListFields[j]).edField;
          Caption := TFieldData(vView.ListFields[j]).name;
          HeaderAlignmentHorz:=taCenter;
          Width := Round((pGrid.Width * TFieldData(vView.ListFields[j]).perWidth/100))-1;
          if TFieldData(vView.ListFields[j]).fieldType = tpComboBox then
          begin
            Tag := TFieldData(vView.ListFields[j]).cbxsqlid;
            TFieldData(vView.ListFields[j]).CBXDBFieldData := TFillCBXDBField.Create(vView.View.tag,TFieldData(vView.ListFields[j]).column,pValues);
          end;
          if TFieldData(vView.ListFields[j]).fieldType = tpCheckBox then
            TFieldData(vView.ListFields[j]).column.PropertiesClass:=TcxCheckBoxProperties;
          if TFieldData(vView.ListFields[j]).fieldType = tpDate then
            TFieldData(vView.ListFields[j]).column.PropertiesClassName:='TcxDateEditProperties';
          if TFieldData(vView.ListFields[j]).fieldType = tpTime then
            TFieldData(vView.ListFields[j]).column.PropertiesClassName:= 'TcxTimeEditProperties';
          if TFieldData(vView.ListFields[j]).fieldType = tpButtonEdit then
            TFieldData(vView.ListFields[j]).column.PropertiesClassName:='TcxButtonEditProperties';
          if TFieldData(vView.ListFields[j]).fieldType = tpPassword then
          begin
            TFieldData(vView.ListFields[j]).column.PropertiesClassName:='TcxTextEditProperties';
//            TcxTextEditProperties(TFieldData(vView.ListFields[j]).column).PasswordChar := '*';//eemPassword;
          end;


        end;
      end;
    end;
  end;
end;

destructor TFillGridFromBase.Destroy;
begin
  FreeAndNil(ListViewsFromGrid);
  vView := nil;
end;

procedure TFillGridFromBase.SqlConcat(pView:TcxGridDBTableView;pSubSQL:string);
begin
  ListViewsFromGrid.TryGetValue(IntToStr(pView.Tag),vView);
  if not Assigned(vView) then exit;
  vView.SqlConcat := pSubSQL;
end;

function TFillGridFromBase.GetDataController(pViewTag : Integer) : TDataSource;
begin
  Result := nil;
  ListViewsFromGrid.TryGetValue(IntToStr(pViewTag),vView);
  if Assigned(vView) then
    Result := vView.Src;
end;

procedure TFillGridFromBase.SetValueParamByName(pView:TcxGridDBTableView; pValues : array of TQryParamValue);
var
  j : Integer;
begin
  ListViewsFromGrid.TryGetValue(IntToStr(pView.Tag),vView);
  if not Assigned(vView) then exit;
  for j := 0 to Length(pValues) - 1 do
    if TQryParamValue(pValues[j]).vTagView = vView.View.Tag then
    case TQryParamValue(pValues[j]).vParamType of
      tpString,tpPassword : vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
      tpInteger : vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
      tpFloat : vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
      tpDate :
      begin
        try
          vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
        except
          vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
        end;
      end;
      tpTime : vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
      tpCheckBox : vView.Qry.Parameters.ParamByName(TQryParamValue(pValues[j]).vParamName).Value := TQryParamValue(pValues[j]).vParamValue;
    end;
end;

procedure TFillGridFromBase.ClearSqlConcat(pView:TcxGridDBTableView);
begin
  ListViewsFromGrid.TryGetValue(IntToStr(pView.Tag),vView);
  if not Assigned(vView) then exit;
  vView.SqlConcat := '';
end;

procedure TFillGridFromBase.ClearReplaseSqlSubStr(pView:TcxGridDBTableView);
begin
  ListViewsFromGrid.TryGetValue(IntToStr(pView.Tag),vView);
  if not Assigned(vView) then exit;
  vView.SqlReplace := '';
end;

procedure TFillGridFromBase.ClearGrid;
var
  i : SmallInt;
begin
  for i := 0 to vGrid.ViewCount - 1 do
  begin
    ListViewsFromGrid.TryGetValue(IntToStr(vGrid.Views[i].Tag),vView);
    if not Assigned(vView) then Continue;
    vView.Qry.Close;
  end;
end;

procedure TFillGridFromBase.SetHideNewRowBeforeAdded(pState : boolean);
begin
  vView.HideNewRowBeforeAdded := pState;
end;

procedure TFillGridFromBase.ApplyWithOutEnterKey;
begin
  vView.NeedSave := True;
end;

procedure TFillGridFromBase.ReplaseSqlSubStr(pView:TcxGridDBTableView;pBefore,pAfter:string);
begin
  ListViewsFromGrid.TryGetValue(IntToStr(pView.Tag),vView);
  if not Assigned(vView) then Exit;
  vView.SqlReplace := vView.SQLText;
  vView.SqlReplace := StringReplace(vView.SqlReplace, pBefore, pAfter,[rfReplaceAll, rfIgnoreCase]);
end;

procedure TFillGridFromBase.ChangeParametersAndReopen(pTagView : Integer;pValues : array of TQryParamValue);
var
  FieldPointer : Pointer;
begin
  ListViewsFromGrid.TryGetValue(IntToStr(pTagView),vView);
  if not Assigned(vView) then exit;
  for FieldPointer in vView.ListFields do
    if TFieldData(FieldPointer).fieldType = tpComboBox then
      TFieldData(FieldPointer).CBXDBFieldData.RefreshCBX(pValues);
  if vView.SQLDefText <> '' then
    vView.Qry.SQL.Text := vView.SQLDefText
  else
    vView.SQLDefText := vView.Qry.SQL.Text;
    vView.Qry.Close;
    try
      if vView.SqlReplace = '' then
        vView.Qry.SQL.Text := vView.SQLText + ' ' + vView.SqlConcat + ' ' + vView.SQLOrder
      else
        vView.Qry.SQL.Text := vView.SqlReplace + ' ' + vView.SqlConcat + ' ' + vView.SQLOrder;
      pPDB.SetParamValue(vView.View.Tag,vView.Qry,pValues);
      pPDB.OpenQuerry(vView.Qry);
    except
      on E:Exception do
      begin
        ShowMyMessage(E.Message,tError,tOk);
        exit;
      end;
    end;
end;

procedure TFillGridFromBase.ChangeParametersAndReopen(pValues : array of TQryParamValue);
var
  i, j : SmallInt;
begin
  for i := 0 to vGrid.ViewCount - 1 do
  begin
    ListViewsFromGrid.TryGetValue(IntToStr(vGrid.Views[i].Tag),vView);
    if not Assigned(vView) then Continue;
    for j := 0 to vView.ListFields.Count - 1 do
    if TFieldData(vView.ListFields[j]).fieldType = tpComboBox then
    begin
      TFieldData(vView.ListFields[j]).CBXDBFieldData.RefreshCBX(pValues);
    end;
    if vView.SQLDefText <> '' then
      vView.Qry.SQL.Text := vView.SQLDefText
    else
      vView.SQLDefText := vView.Qry.SQL.Text;
    try
      vView.Qry.Close;
      try
        if vView.SqlReplace = '' then
          vView.Qry.SQL.Text := vView.SQLText + ' ' + vView.SqlConcat + ' ' + vView.SQLOrder
        else
          vView.Qry.SQL.Text := vView.SqlReplace + ' ' + vView.SqlConcat + ' ' + vView.SQLOrder;
        pPDB.SetParamValue(vView.View.Tag,vView.Qry,pValues);
        pPDB.OpenQuerry(vView.Qry);
      except
        on E:Exception do
        begin
          ShowMyMessage(E.Message,tError,tOk);
          exit;
        end;
      end;
    finally

    end;
  end;
end;

procedure TFillGridFromBase.RefreshGrid;
var
  i : SmallInt;
  ARowIndex: Integer;
begin
  for i := 0 to vGrid.ViewCount - 1 do
  begin
    ListViewsFromGrid.TryGetValue(IntToStr(vGrid.Views[i].Tag),vView);
    if not Assigned(vView) then Continue;
    ARowIndex := vView.View.DataController.GetRowIndexByRecordIndex(vView.View.DataController.FocusedRecordIndex, True);
    vView.SQLDefText := vView.Qry.SQL.Text;
    try
      vView.Qry.Close;
      try
        if vView.SqlReplace = '' then
          vView.Qry.SQL.Text := vView.SQLText + ' ' + vView.SqlConcat + ' ' + vView.SQLOrder
        else
          vView.Qry.SQL.Text := vView.SqlReplace + ' ' + vView.SqlConcat + ' ' + vView.SQLOrder;
        pPDB.OpenQuerry(vView.Qry);

        while ARowIndex > 0 do
        begin
          vView.View.DataController.DataSource.DataSet.Next;
          Dec(ARowIndex);
        end;
        if vView.View.DataController.FocusedRecordIndex > -1 then
          vView.View.ViewData.Rows[vView.View.DataController.FocusedRecordIndex].Expand(False);
      except
        on E:Exception do
        begin
          ShowMyMessage(E.Message,tError,tOk);
          exit;
        end;
      end;
    finally

    end;
  end;
end;

function TLinkDataGrid.GetTag : string;
begin
  Result := IntToStr(View.Tag);
end;

function TLinkDataGrid.DeleteRow : boolean;
var
  Q : TAdoQuery;
begin
  Result := False;
  Q := pPDB.CreateQuerry;
  with Q do
  try
    SQL.Text := Self.SQLDelete;

    Parameters.ParamByName('pId').Value := View.DataController.DataSource.DataSet.FieldByName('id').AsInteger;
    if not pPDB.ExecuteQuerry(Q) then Exit;
    Qry.Close;
    Qry.Open;
    Result := True;
  finally
    FreeAndNil(Q);
  end;
end;

procedure TLinkDataGrid.Refresh;
begin
  Qry.Close;
  Qry.Open;
end;

procedure TLinkDataGrid.SetNeedSave(pNeedSave : boolean);
begin
  NeedSave := pNeedSave;
end;

procedure TLinkDataGrid.ChangeParametersAndReopen(pValues : array of TQryParamValue);
begin
  pPDB.SetParamValue(View.Tag,Qry,pValues);
  Qry.Close;
  try
    SQLDefText := Qry.SQL.Text;
    try
      if SqlReplace = '' then
        Qry.SQL.Text := SQLText + ' ' + SqlConcat + ' ' + SQLOrder
      else
        Qry.SQL.Text := SqlReplace + ' ' + SqlConcat + ' ' + SQLOrder;
      pPDB.SetParamValue(View.Tag,Qry,pValues);
      pPDB.OpenQuerry(Qry);
    finally
//      Qry.SQL.Text := SQLDefText;
    end;
  except
    on E:Exception do
    begin
      ShowMyMessage(E.Message,tError,tOk);
      exit;
    end;
  end;
end;

procedure TLinkDataGrid.baseGridViewCellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  vColumn : TcxGridDBColumn;
  i,ARowIndex:Integer;
  ARowInfo:TcxRowInfo;
  vReadOnly : Boolean;
begin
  ActiveView := Self;
  vColumn := TcxGridDBTableView(Sender).GetColumnByFieldName('closed');
  if vColumn = nil then exit;
  vReadOnly := False;
  for i := 0 to TcxCustomGridTableView(Sender).dataController.GetSelectedCount - 1 do
  begin
    ARowIndex := TcxCustomGridTableView(Sender).dataController.GetSelectedRowIndex(i);
    ARowInfo  := TcxCustomGridTableView(Sender).dataController.GetRowInfo(ARowIndex);
    vReadOnly := TcxCustomGridTableView(Sender).dataController.Values[ARowInfo.RecordIndex,vColumn.Index];
  end;
  for i := 0 to ActiveView.ListFields.Count - 1 do
  begin
    if vReadOnly and TFieldData(ActiveView.ListFields[i]).edField and (TFieldData(ActiveView.ListFields[i]).fieldName <> 'closed') then
      TFieldData(ActiveView.ListFields[i]).column.Options.Editing := False;
    if not vReadOnly and TFieldData(ActiveView.ListFields[i]).edField then
      TFieldData(ActiveView.ListFields[i]).column.Options.Editing := True;
  end;
end;

constructor TLinkDataGrid.Create(pView : TcxGridDBTableView);
var typePar : tTypeParam;
var
  HidedFieldsString : string;
  vsField : Boolean;
  i : integer;
begin
  Qry := pPDB.CreateQuerry;
  if not pPDB.GetSQLGridFRomBase(Qry, pView.Tag) then Exit;
  View := pView;
  ConfigINIcls.ReadValue('HIDEDFIELDS',IntToStr(pView.Tag),'',HidedFieldsString);
  HidedFields := HidedFieldsString.Split([';']);
  View.OnCellClick := baseGridViewCellClick;
  ListFields := TList<TFieldData>.Create;
  SQLText := Qry.FieldByName('sqltext').AsString;
  SQLOrder := Qry.FieldByName('ordertext').AsString;
  SQLInsert := Qry.FieldByName('sqlinsert').AsString;
  SQLUpdate := Qry.FieldByName('sqlupdate').AsString;
  SQLDelete := Qry.FieldByName('sqldelete').AsString;
  if not pPDB.GetFieldsGridFRomBase(Qry, pView.Tag) then exit;
  while not Qry.Eof do
  begin
    typePar := tpNone;
    if Qry.FieldByName('fieldtype').AsString = '' then
      typePar := tpNone;
    if Qry.FieldByName('fieldtype').AsString = 'tpString' then
      typePar := tpString;
    if Qry.FieldByName('fieldtype').AsString = 'tpInteger' then
      typePar := tpInteger;
    if Qry.FieldByName('fieldtype').AsString = 'tpFloat' then
      typePar := tpFloat;
    if Qry.FieldByName('fieldtype').AsString = 'tpDate' then
      typePar := tpDate;
    if Qry.FieldByName('fieldtype').AsString = 'tpTime' then
      typePar := tpTime;
    if Qry.FieldByName('fieldtype').AsString = 'tpComboBox' then
      typePar := tpComboBox;
    if Qry.FieldByName('fieldtype').AsString = 'tpCheckBox' then
      typePar := tpCheckBox;
    if Qry.FieldByName('fieldtype').AsString = 'tpButtonEdit' then
      typePar := tpButtonEdit;
    if Qry.FieldByName('fieldtype').AsString = 'tpPassword' then
      typePar := tpPassword;
    vsField := Qry.FieldByName('vsfield').AsBoolean;
    for I := 0 to Length(HidedFields) - 1 do
    if HidedFields[i] = Qry.FieldByName('name').AsString then
    begin
      vsField := False;
      Break;
    end;
    ListFields.Add(TFieldData.Create(Qry.FieldByName('nn').AsInteger,Qry.FieldByName('name').AsString,Qry.FieldByName('fieldname').AsString,Qry.FieldByName('paramname').AsString,
                                     vsField,Qry.FieldByName('edfield').AsBoolean,Qry.FieldByName('perwidth').AsFloat,Qry.FieldByName('cbxsqlid').AsInteger,typePar,pView));
    Qry.Next;
  end;
  Qry.Close;
  if SqlReplace = '' then
    Qry.SQL.Text := SQLText + ' ' + SqlConcat + ' ' + SQLOrder
  else
    Qry.SQL.Text := SqlReplace + ' ' + SqlConcat + ' ' + SQLOrder;
  Src := TDataSource.Create(nil);
  Src.DataSet := Qry;
  pView.DataController.DataSource := Src;
  pView.DataController.DataSet.BeforePost := dsBeforePost;
  pView.OnKeyPress := baseGridViewKeyPress;
  pView.OnEditValueChanged := baseGridViewEditValueChanged;
end;

procedure TLinkDataGrid.baseGridViewEditValueChanged(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  if View.DataController.MasterKeyFieldNames <> '' then
    View.DataController.Post
  else
    View.DataController.PostEditingData;
  dsBeforePost(View.DataController.DataSet);
end;

procedure TLinkDataGrid.baseGridViewKeyPress(Sender: TObject; var Key: Char);
begin
  NeedSave := False;
  if Key= #13 then
  begin
    NeedSave := True;
    dsBeforePost(Src.DataSet);
  end;
end;

procedure TLinkDataGrid.dsBeforePost(DataSet: TDataSet);
var
  QryPrivate : TADOQuery;
  i:Integer;
  arrParam : array of TQryParamValue;
  ARowIndex: Integer;
begin
  QryPrivate := pPDB.CreateQuerry;
  ARowIndex := -1;
  try
    for I := 0 to ListFields.Count - 1 do
      if TFieldData(ListFields[i]).fieldName <> '' then
      begin
        SetLength(arrParam,length(arrParam)+1);
        arrParam[length(arrParam)-1] := TQryParamValue.Create(View.Tag,TFieldData(ListFields[i]).paramName,           // View.DataController.DataSet.FieldByName(TFieldData(ListFields[i]).fieldName).AsVariant
                                        View.DataController.DataSet.FieldValues[TFieldData(ListFields[i]).fieldName],TFieldData(ListFields[i]).fieldType,TFieldData(ListFields[i]).edField);
      end;
    for I := 0 to Length(arrParam) - 1 do
    if (arrParam[i].vCanEditField) and (arrParam[i].vParamValue = Null) and (arrParam[i].vParamType <> tpDate) then
    if not NeedSave then
      Exit;
    NeedSave := False;
    if View.DataController <> nil then
      ARowIndex := View.DataController.GetRowIndexByRecordIndex(View.DataController.FocusedRecordIndex, True);
    if VarToStr(View.DataController.DataSet.FieldValues['id']) = '' then
      QryPrivate.SQL.Text := SQLInsert
    else
      QryPrivate.SQL.Text := SQLUpdate;
    pPDB.SetParamValue(View.Tag,QryPrivate,arrParam);
//    QryPrivate.Parameters := Qry.Parameters;
    if QryPrivate.SQL.Text = '' then exit;
    if not pPDB.ExecuteQuerry(QryPrivate) then
    begin
      View.DataController.DataSet.Cancel;
      exit;
    end;
    View.DataController.DataSet.Cancel;
    Self.Qry.Close;
    if pPDB.CheckConnection then
      pPDB.OpenQuerry(Self.Qry);
    if True then
    for I := 0 to ListFields.Count - 1 do
      if TFieldData(ListFields[i]).CBXDBFieldData <> nil then
        TFieldData(ListFields[i]).CBXDBFieldData.RefreshCBX(arrParam);
    if HideNewRowBeforeAdded then
      View.NewItemRow.Visible := False;
  finally
    while ARowIndex > 0 do
    begin
      View.DataController.DataSource.DataSet.Next;
      Dec(ARowIndex);
    end;
    while Length(arrParam) > 0 do
    begin
      TQryParamValue(arrParam[Length(arrParam)-1]).Destroy;
      SetLength(arrParam,Length(arrParam)-1);
    end;
    FreeAndNil(QryPrivate);
  end;
end;

destructor TLinkDataGrid.Destroy;
begin
  if not Assigned(Qry) then Exit;
  Qry.Close;
  FreeAndNil(Qry);
  FreeAndNil(Src);
  while ListFields.Count > 0 do
  begin
    TFieldData(ListFields[0]).Destroy;
    ListFields.Delete(0);
  end;
  FreeAndNil(ListFields);
  SetLength(HidedFields, 0);
end;

constructor TFieldData.Create(pNn:SmallInt;pName,pFieldName,pParamName:string;pVsField,pEdField:Boolean;pPerWidth:Real;pCbxSqlId:integer;pfieldType:tTypeParam;pView:TcxGridDBTableView);
begin
  nn := pNn;
  name := pName;
  vsField := pVsField;
  edField := pEdField;
  perWidth := pPerWidth;
  column := pView.CreateColumn;
  column.Styles.Content := frmResource.cxstylGridBack;
  fieldName := pFieldName;
  fieldType := pfieldType;
  paramName := pParamName;
  cbxsqlid := pCbxSqlId;
end;

destructor TFieldData.Destroy;
begin
  if CBXDBFieldData <> nil then
    FreeAndNil(CBXDBFieldData);
  FreeAndNil(column);
end;

constructor TFillCBXDBField.Create(pTag:integer;pColumn : TcxGridDBColumn;pValues:array of TQryParamValue);
begin
  tag := pTag;
  QLcbx := pPDB.CreateQuerry;
  SrcLcbx := TDataSource.Create(nil);
  pColumn.PropertiesClassName:='TcxLookupComboBoxProperties';
  if not pPDB.GetComboBoxSQL(QLcbx,pColumn.Tag) then Exit;
  with QLcbx do
  begin
    SQL.Text := FieldByName('cbxsql').AsString + ' ' + FieldByName('ordertext').AsString;
    Close;
    pPDB.SetParamValue(tag,QLcbx,pValues);
    pPDB.OpenQuerry(QLcbx);
  end;
  SrcLcbx.DataSet := QLcbx;
  with TcxLookupComboBoxProperties(pColumn.Properties) do
  begin
    ListSource := SrcLcbx;
    KeyFieldNames:='id';
    ListFieldNames:='name';
    ListOptions.ShowHeader:=False;
  end;
end;

destructor TFillCBXDBField.Destroy;
begin
  FreeAndNil(QLcbx);
  FreeAndNil(SrcLcbx);
end;

procedure TFillCBXDBField.RefreshCBX(pValues:array of TQryParamValue);
begin
  QLcbx.Close;
  pPDB.SetParamValue(tag,QLcbx,pValues);
  QLcbx.Open;
end;

end.
