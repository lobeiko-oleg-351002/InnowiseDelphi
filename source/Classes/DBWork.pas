unit DBWork;

interface

uses Uni,UniProvider,Vcl.Forms,DBWorkSQL, SQLServerUniProvider,
System.SysUtils,MyMessageCls,Vcl.ComCtrls,System.Classes,
cxGrid,cxGridDBTableView,sComboBox,MyDialogForm,sBitBtn,sCurrencyEdit,
Vcl.Controls,sEdit,cxCustomPivotGrid, cxPivotGrid,cxCalc,Windows,
cxDBPivotGrid,cxDBVGrid,cxVGrid,sLabel,SettingData, Data.DB,
System.Variants, cxGridCustomTableView,cxDBLookupComboBox,
cxCheckBox, sTreeView, cxCustomData, dxBar, cxBarEditItem,
cxCheckComboBox, cxButtonEdit, cxLookAndFeelPainters, FormResource,
cxTextEdit, System.Generics.Collections, Data.Win.ADODB,frxClass,
frxPrinter, frxDBSet;

type TclsCheckComboBoxItem = class
  public
    Item : TcxCheckComboBoxItem;
    id : Integer;
    constructor Create(pItem:TcxCheckComboBoxItem);
    destructor Destroy; override;
end;

type tTypeFrxParam = (tpfrxNone,tpfrxString,tpfrxInteger,tpfrxFloat,tpfrxDate);

type  TQryFrxParamValue = class
  private
    vNSQL       : SmallInt;
    vParamName  : string;
    vParamValue : Variant;
    vParamType  : tTypeFrxParam;
  public
    constructor Create(pNSQL:SmallInt;pParamName:string;pParamValue:Variant;pParamType:tTypeFrxParam);
  end;

type TclsCheckComboBox = class
  private
    ComboBox : TcxCheckComboBox;
    Qry : TADOQuery;
    procedure CreateItems;
  public
    listItems : TList;    // TclsCheckComboBoxItem
    procedure RefreshItems;
    constructor Create(pCbxComboCheck : TcxCheckComboBox; pCbxId : Integer);
    destructor Destroy; override;
end;

type
  TCheckComboBoxItem = class
  private
    item : TcxCheckComboBoxItem;
    id : string;
  public
    constructor Create(pId,pCaption:string;pItem:TcxCheckComboBoxItem);
    destructor Destroy; override;
end;

type
  TFillcxCheckComboBox = class
  private
    CheckComboBox : TcxBarEditItem;
    CheckComboBox2 : TcxCheckComboBox;
    Q : TADOQuery;
    ListItems : TList;      // TCheckComboBoxItem
    item : TcxCheckComboBoxItem;
    procedure PrevCreate(ComboBoxTag:integer;pValues:array of TQryParamValue);
  public
    function GetCheckedIds:string;
    constructor Create(pCheckComboBox:TcxBarEditItem;pValues:array of TQryParamValue); overload;
    constructor Create(pCheckComboBox:TcxCheckComboBox;pValues:array of TQryParamValue); overload;
    destructor Destroy; override;
end;

type
  TTreeItem = class
    name : string;
  private
    ImageIndex : Integer;
    SelectImageIndex : Integer;
  public
    node: TTreeNode;
    parentN : Integer;
    id : Integer;
    sqlgridid : integer;
    constructor Create(pId,pParent:Integer;pName:string;pSqlGridId,pImageIndex,pSelectImageIndex:integer);
    destructor Destroy; override;
end;

type
  TFillTreeFromBase = class
  private
    Qry : TADOQuery;
    tvDict : TsTreeView;
    procedure CreateTree(pItemDict:TTreeItem);
  public
    ListItems : TList;
    constructor Create(ptvDict : TsTreeView; ShowItemsArr : TTreeItemsId = nil);
    destructor Destroy; override;
end;

type
  TDB = class(TSQLClass)
    private
      SQLServerConnection : TADOConnection;
      SQLFields : array of string;
      IP : string;
      ComputerName : string;
      DateLicense : string;
      FLogin : string;
      FPassword : string;
      FGUID : string;
    public
      constructor create;
      function OpenConnect(user,passwd:string):Boolean;
      function CreateQuerry:TADOQuery;
      function FillItemsFromDB(Items:TStrings;pSQL:string;pParams:array of string; pGetQry : Boolean = False):TADOQuery; overload;
      function FillItemsFromDB(Items:TStrings;pCbxId:Integer;pParams:array of string; pGetQry : Boolean = False):TADOQuery; overload;
      procedure FillItemsFromDB(Items:TStrings;Qry:TADOQuery); overload;
      function CheckConnection:Boolean;
      function GetStrValue(cbb:TsComboBox;objId:string):string;
      function FillCbxFromDB(pCBX:TsComboBox;pValues:array of TQryParamValue; pGetQry : Boolean = False):TADOQuery;
      procedure SetComboValue(cb:TsComboBox;str:string);
      procedure ClearObjItem(Items:TStrings);
      procedure SetActiveIP(pIP : string);
      procedure SetComputerName(pCompName : string);
      function GetActiveIP : string;
      function GetComputerName : string;
      procedure SetParamValue(pViewTag:SmallInt;var Qry:TADOQuery;pValues:array of TQryParamValue);
      property Login : string read FLogin write FLogin;
      property Password : string read FPassword write FPassword;
      property GUID : string read FGUID write FGUID;
      destructor Destroy;override;
    private
      {$REGION 'Variables and methods of create partners'}
//      procedure ClickNewCountry(Sender : TObject);
//      procedure AddNewCountry(Sender : TObject);
//      procedure cbCountryChange(Sender: TObject);
//      procedure AddPartnerDB(Sender: TObject);
//      procedure UpdatePartnerDB(Sender: TObject);
//      procedure CreateFormDataPartner(pTypeView : TTypeView;pPartnerId : integer);
      {$ENDREGION}
      {$REGION 'Variables and methods of create partners'}

      {$ENDREGION}
      function prepareSQL(SQL:string) : string;
  end;

var pPDB : TDB;

implementation

uses CxGridUnit;

constructor TQryFrxParamValue.Create(pNSQL:SmallInt;pParamName:string;pParamValue:Variant;pParamType:tTypeFrxParam);
begin
  vNSQL := pNSQL;
  vParamName := pParamName;
  vParamValue := pParamValue;
  vParamType  := pParamType;
end;

constructor TclsCheckComboBoxItem.Create(pItem:TcxCheckComboBoxItem);
begin
  Item := pItem;
  id := pItem.tag;
end;

destructor TclsCheckComboBoxItem.Destroy;
begin
  FreeAndNil(Item);
end;

procedure TclsCheckComboBox.CreateItems;
var
  Item:TcxCheckComboBoxItem;
begin
  while not Qry.Eof do
  begin
    Item := ComboBox.Properties.Items.Add;
    Item.Tag := Qry.FieldByName('id').AsInteger;
    Item.Description := Qry.FieldByName('name').AsString;
    listItems.Add(TclsCheckComboBoxItem.Create(Item));
    Qry.Next;
  end;
end;

procedure TclsCheckComboBox.RefreshItems;
begin
  while listItems.Count > 0 do
  begin
    TclsCheckComboBoxItem(listItems[0]).Destroy;
    listItems.Delete(0);
  end;
  Qry.Close;
  pPDB.OpenQuerry(Qry);
  CreateItems;
end;

constructor TclsCheckComboBox.Create(pCbxComboCheck : TcxCheckComboBox; pCbxId : Integer);
begin
  ComboBox := pCbxComboCheck;
  listItems := TList.Create;
  Qry := pPDB.CreateQuerry;
  pPDB.GetSQLComboBox(Qry,pCbxId);
  Qry.SQL.Text := Qry.FieldByName('cbxsql').AsString + ' ' + Qry.FieldByName('ordertext').AsString;
  pPDB.OpenQuerry(Qry);
  CreateItems;
end;

destructor TclsCheckComboBox.Destroy;
begin
  while listItems.Count > 0 do
  begin
    TclsCheckComboBoxItem(listItems[0]).Destroy;
    listItems.Delete(0);
  end;
  FreeAndNil(listItems);
  FreeAndNil(Qry);
end;

constructor TCheckComboBoxItem.Create(pId,pCaption:string;pItem:TcxCheckComboBoxItem);
begin
  item := pItem;
  id := pId;
  item.Description := pCaption;
end;

destructor TCheckComboBoxItem.Destroy;
begin
  FreeAndNil(item);
end;

function TFillcxCheckComboBox.GetCheckedIds:string;
var
  i : Integer;
  strch : string;
begin
  Result := '';
  if CheckComboBox <> nil  then
  begin
    if CheckComboBox.EditValue = null then Exit;
    strch := CheckComboBox.EditValue;
    for I := 0 to ListItems.Count - 1 do
    if strch[i+1] = '1' then
      Result := Result + QuotedStr(TCheckComboBoxItem(ListItems[i]).id) + ',';
  end;
  if CheckComboBox2 <> nil  then
  begin
    for I := 0 to ListItems.Count - 1 do
    if CheckComboBox2.States[i] = cbsChecked then
      Result := Result + TCheckComboBoxItem(ListItems[i]).id + ',';
  end;
  Result := Copy(Result,0,Length(Result) - 1);
end;

procedure TFillcxCheckComboBox.PrevCreate(ComboBoxTag:integer;pValues:array of TQryParamValue);
begin
  Q := pPDB.CreateQuerry;
  ListItems := TList.Create;
  with Q do
  begin
    pPDB.GetSQLComboBox(Q,ComboBoxTag);
    SQL.Text := FieldByName('cbxsql').AsString + ' ' + FieldByName('ordertext').AsString;
    Close;
    pPDB.SetParamValue(ComboBoxTag,Q,pValues);
    pPDB.OpenQuerry(Q);
  end;
end;

constructor TFillcxCheckComboBox.Create(pCheckComboBox:TcxCheckComboBox;pValues:array of TQryParamValue);
begin
  CheckComboBox2 := pCheckComboBox;
  PrevCreate(pCheckComboBox.Tag,pValues);
  with Q do
  while not Eof do
  begin
    item := pCheckComboBox.Properties.Items.Add;
    ListItems.Add(TCheckComboBoxItem.Create(FieldByName('id').AsString,FieldByName('name').AsString,item));
    Next;
  end;
end;

constructor TFillcxCheckComboBox.Create(pCheckComboBox:TcxBarEditItem;pValues:array of TQryParamValue);
begin
  CheckComboBox := pCheckComboBox;
  PrevCreate(pCheckComboBox.Tag,pValues);
  with Q do
  while not Eof do
  begin
    item := TcxCheckComboBoxProperties(pCheckComboBox.Properties).items.Add;
    ListItems.Add(TCheckComboBoxItem.Create(FieldByName('id').AsString,FieldByName('name').AsString,item));
    Next;
  end;
end;

destructor TFillcxCheckComboBox.Destroy;
begin
  FreeAndNil(Q);
  while ListItems.Count > 0 do
  begin
    TCheckComboBoxItem(ListItems.Items[0]).Destroy;
    ListItems.Delete(0);
  end;
  FreeAndNil(ListItems);
end;

constructor TDB.create;
begin
  SQLServerConnection := TADOConnection.Create(Application);
  SQLServerConnection.ConnectionString := 'Provider=SQLOLEDB.1;Database={database};Password={password};Persist Security Info=True;User ID={user};Data Source={host}';
end;

destructor TDB.Destroy;
begin
  GUID := '';
  DateLicense := '';
  SQLServerConnection.Connected := False;
  inherited Destroy;
end;

function TDB.OpenConnect(user,passwd:string):Boolean;
var
  str : string;
begin
  Result := false;
  Login := user;
  with SQLServerConnection do
    begin
      LoginPrompt := false;
      str := SQLServerConnection.ConnectionString;
      str := StringReplace(str, '{password}', passwd,[rfReplaceAll, rfIgnoreCase]);
      str := StringReplace(str, '{user}', user,[rfReplaceAll, rfIgnoreCase]);
      str := StringReplace(str, '{host}', SettingControl.SettingData.Host,[rfReplaceAll, rfIgnoreCase]);
      str := StringReplace(str, '{database}', SettingControl.SettingData.DbName,[rfReplaceAll, rfIgnoreCase]);
      SQLServerConnection.ConnectionString := str;
      try
        Connected := true;
        inherited Create(user,SQLServerConnection);
      except
        on E:Exception do
          begin
            ShowMyMessage(E.Message,tError,tOk);
            exit;
          end;
      end;
    end;
  Result := True;
end;

procedure TDB.SetActiveIP(pIP : string);
begin
  IP := pIP;
end;

procedure TDB.SetComputerName(pCompName : string);
begin
  ComputerName := pCompName;
end;

function TDB.GetActiveIP : string;
begin
  Result := IP;
end;

function TDB.GetComputerName : string;
begin
  Result := ComputerName;
end;

function TDB.CreateQuerry:TAdoQuery;
begin
  Result := TAdoQuery.Create(nil);
  Result.Connection := SQLServerConnection;
end;

procedure TDB.SetParamValue(pViewTag:SmallInt;var Qry:TADOQuery;pValues:array of TQryParamValue);
var
  i, j : Integer;
  int : Integer;
begin
  try
    for j := 0 to Qry.Parameters.Count -1 do
      for i := 0 to Length(pValues) - 1 do
      if UpperCase(Qry.Parameters[j].Name) = UpperCase(TQryParamValue(pValues[i]).vParamName) then
      begin
        if TQryParamValue(pValues[i]).vParamName = '' then Continue;
        if (TQryParamValue(pValues[i]).vTagView = pViewTag) and ((TQryParamValue(pValues[i]).vParamValue <> null) or (TQryParamValue(pValues[i]).vParamType = tpComboBox)) then
        if TQryParamValue(pValues[i]).vReplace then
          Qry.SQL.Text := StringReplace(Qry.SQL.Text, ':'+TQryParamValue(pValues[i]).vParamName, TQryParamValue(pValues[i]).vParamValue, [rfReplaceAll, rfIgnoreCase])
        else
        case TQryParamValue(pValues[i]).vParamType of
          tpString,tpButtonEdit,tpPassword  : Qry.Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName).Value := TQryParamValue(pValues[i]).vParamValue;
          tpInteger : Qry.Parameters[j].Value := TQryParamValue(pValues[i]).vParamValue;
          tpFloat   : Qry.Parameters[j].Value := TQryParamValue(pValues[i]).vParamValue;
          tpDate    : Qry.Parameters[j].Value := TQryParamValue(pValues[i]).vParamValue;
          tpTime    : Qry.Parameters[j].Value := TQryParamValue(pValues[i]).vParamValue;        // Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName)
          tpCheckBox :
          begin
            if TQryParamValue(pValues[i]).vParamValue = Null then
              Qry.Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName).Value := False
            else
              Qry.Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName).Value :=  TQryParamValue(pValues[i]).vParamValue;
          end;
          tpComboBox :
          begin
            if TQryParamValue(pValues[i]).vParamValue = null then
              Qry.Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName).Value := -1
            else
              if TryStrToInt(TQryParamValue(pValues[i]).vParamValue, int) then
                Qry.Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName).Value := StrToInt(TQryParamValue(pValues[i]).vParamValue)
              else
                Qry.Parameters.ParamByName(TQryParamValue(pValues[i]).vParamName).Value := TQryParamValue(pValues[i]).vParamValue;
          end;
        end;
      end;
  except
    Exit;
  end;
end;
{ TTreeItem }

constructor TTreeItem.Create(pId,pParent:Integer;pName:string;pSqlGridId,pImageIndex,pSelectImageIndex:integer);
begin
  id := pId;
  parentN := pParent;
  name := pName;
  ImageIndex := pImageIndex;
  SelectImageIndex := pSelectImageIndex;
  sqlgridid := pSqlGridId;
end;

destructor TTreeItem.Destroy;
begin

end;

{ TFillTreeFromBase }

procedure TFillTreeFromBase.CreateTree(pItemDict:TTreeItem);
var
  i:Integer;
begin
  if ListItems.Count = 0 then
    exit;
  if pItemDict = nil then
  begin
    for i := 0 to ListItems.Count - 1 do
      if TTreeItem(ListItems[i]).parentN = 0 then
      begin
        TTreeItem(ListItems[i]).node := tvDict.Items.AddChild(nil,TTreeItem(ListItems[i]).name);
        TTreeItem(ListItems[i]).node.ImageIndex := TTreeItem(ListItems[i]).ImageIndex;
        TTreeItem(ListItems[i]).node.SelectedIndex := TTreeItem(ListItems[i]).SelectImageIndex;
        CreateTree(TTreeItem(ListItems[i]));
      end;
  end
  else
  begin
    for i := 0 to ListItems.Count - 1 do
      if TTreeItem(ListItems[i]).parentN = pItemDict.id then
      begin
         TTreeItem(ListItems[i]).node := tvDict.Items.AddChild(TTreeItem(pItemDict).node,TTreeItem(ListItems[i]).name);
         TTreeItem(ListItems[i]).node.ImageIndex := TTreeItem(ListItems[i]).ImageIndex;
         TTreeItem(ListItems[i]).node.SelectedIndex := TTreeItem(ListItems[i]).SelectImageIndex;
         CreateTree(TTreeItem(ListItems[i]));
      end;
  end;
end;

constructor TFillTreeFromBase.Create(ptvDict : TsTreeView; ShowItemsArr : TTreeItemsId = nil);
begin
  tvDict := ptvDict;
  Qry := pPDB.CreateQuerry;
  ListItems := TList.Create;
  pPDB.GetQryTreeItems(Qry, ptvDict.Tag, ShowItemsArr);     //
  with Qry do
  begin
    while not eof do
    begin
      ListItems.Add(TTreeItem.Create(FieldByName('iditem').AsInteger,FieldByName('parent').AsInteger,FieldByName('name').AsString,
                  FieldByName('gridsqlid').AsInteger,FieldByName('imageindex').AsInteger,FieldByName('selectimageindex').AsInteger));
      Next;
    end;
    tvDict.Items.BeginUpdate;
    try
      CreateTree(nil);
    finally
      tvDict.Items.EndUpdate;
    end;
  end;

end;

destructor TFillTreeFromBase.Destroy;
begin
  FreeAndNil(Qry);
  while ListItems.Count > 0 do
  begin
    TTreeItem(ListItems[0]).Destroy;
    ListItems.Delete(0);
  end;
  FreeAndNil(ListItems);
end;

function TDB.GetStrValue(cbb:TsComboBox;objId:string):string;
var
  i:Integer;
begin
  for I := 0 to cbb.Items.Count - 1 do
    if objId=TcbObj(cbb.Items.Objects[i]).tag then
      begin
        Result := cbb.Items[i];
        Exit;
      end;
end;

function TDB.CheckConnection:Boolean;
begin
  Result := False;
  if SQLServerConnection.Connected then
    Result := True;
end;

function TDB.FillCbxFromDB(pCBX:TsComboBox;pValues:array of TQryParamValue; pGetQry : Boolean = False):TADOQuery;
var
  Q:TADOQuery;
begin
  Result := nil;
  pCBX.Items.Clear;
  Q := pPDB.CreateQuerry;
  with Q do
  try
    pPDB.GetSQLComboBox(Q,pCBX.Tag);
    SQL.Text := FieldByName('cbxsql').AsString + ' ' + FieldByName('ordertext').AsString;
    Close;
    pPDB.SetParamValue(pCBX.Tag,Q,pValues);
    pPDB.OpenQuerry(Q);
    while not Eof do
    begin
      pCBX.Items.AddObject(Q.FieldByName('name').AsString,TcbObj.Create(Q.FieldByName('id').AsString));
      Next;
    end;
  finally
    if not pGetQry then
      FreeAndNil(Q)
    else
      Result := Q;
  end;
end;

function TDB.FillItemsFromDB(Items:TStrings;pCbxId:Integer;pParams:array of string; pGetQry : Boolean = False):TAdoQuery;
var
  Q:TADOQuery;
  sqlstr : string;
begin
  Items.Clear;
  Q:=pPDB.CreateQuerry;
  try
    with Q do
    begin
      SQL.Add('SELECT cbxsql,ordertext FROM s_cbxsql WHERE id=:pId');
      Prepared;
      Parameters.ParamByName('pId').Value := pCbxId;
      Open;
      sqlstr := FieldByName('cbxsql').AsString + ' ' + FieldByName('ordertext').AsString;
    end;
  finally
    FreeAndNil(Q);
    Result := pPDB.FillItemsFromDB(Items,sqlstr,pParams,pGetQry);
  end;
end;

procedure TDB.FillItemsFromDB(Items:TStrings;Qry:TADOQuery);
begin
  Items.Clear;
  with Qry do
  begin
    First;
    while not Eof do
    begin
      Items.AddObject(FieldByName('name').AsString,TcbObj.Create(FieldByName('id').AsString));
      Next;
    end;
  end;
end;

function TDB.FillItemsFromDB(Items:TStrings;pSQL:string;pParams:array of string; pGetQry : Boolean = False):TADOQuery;
var
  Q:TADOQuery;
  i:Integer;
begin
  Result := nil;
  Items.Clear;
  SetLength(SQLFields,0);
  FreeAndNil(SQLFields);
  prepareSQL(pSQL);
  Q:=pPDB.CreateQuerry;
  try
    with Q do
    begin
      SQL.Add(pSQL);
      if Length(SQLFields) > 0 then
        Prepared;
      for i := 0 to Length(SQLFields) - 1 do
        Parameters.ParamByName(SQLFields[i]).Value := pParams[i];
      pPDB.OpenQuerry(Q);
      while not Eof do
      begin
        Items.AddObject(FieldByName('name').AsString,TcbObj.Create(FieldByName('id').AsString));
        Next;
      end;
    end;
  finally
    SetLength(SQLFields,0);
    FreeAndNil(SQLFields);
    if not pGetQry then
      FreeAndNil(Q)
    else
      Result := Q;
  end;
end;

procedure TDB.ClearObjItem(Items:TStrings);
var
   i:integer;
begin
  for I := 0 to Items.Count - 1 do
    (items.Objects[i] as TcbObj).Free;
  items.Clear;
end;

procedure TDB.SetComboValue(cb:TsComboBox;str:string);
var
  i:Integer;
begin
  for I := 0 to cb.Items.Count -1 do
    if TcbObj(cb.Items.Objects[i]).tag = str then
      begin
        cb.ItemIndex := i;
        Break;
      end;
end;

function TDB.prepareSQL(SQL:string) : string;
var
  position : Integer;
  i:Integer;
begin
  position := AnsiPos(':',SQL);
  if position = 0 then
    begin
      Result := SQL;
      Exit;
    end;
  for i := position to Length(SQL)-1 do
    if (SQL[i] = ' ') or (i=Length(SQL)-1) or (SQL[i] = ',') then
      begin
        SetLength(SQLFields,Length(SQLFields)+1);
        if i<>Length(SQL)-1 then
          begin
            SQLFields[Length(SQLFields)-1] := Copy(SQL,position+1,(i-1)-position);
            Delete(SQL,position,(i)-position);
          end
        else
          begin
            SQLFields[Length(SQLFields)-1] := Copy(SQL,position+1,Length(SQL));
            Delete(SQL,position,Length(SQL));
          end;
        break;
      end;
  Result := prepareSQL(SQL);
end;

end.

