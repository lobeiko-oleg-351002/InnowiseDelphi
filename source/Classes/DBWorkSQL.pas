unit DBWorkSQL;

interface

uses Uni, UniProvider, System.SysUtils, MyMessageCls, MySQLUniProvider, Vcl.Forms,
frxClass, FormResource, System.Classes, Data.DB, Data.Win.ADODB,System.Variants,
System.IOUtils;

type
  TSQLClass = class
    constructor Create(pUser:string;pMySQLConnection:TADOConnection);       // ;pUniStoredProc:TUniStoredProc
    destructor Destroy;override;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;
    function OnenProcedure(Transaction:boolean = true; ADOQuery : TADOQuery = nil) : TADOQuery;
    function OpenQuerry(var pQry : TADOQuery) : boolean;
    function ExecuteQuerry(var pQry : TADOQuery;Transaction:boolean = true) : boolean;
    function ExecuteProcedure(Transaction:boolean = true; ADOQuery : TADOQuery = nil) : boolean;
    function GetMenuQry(var pQry : TADOQuery) : boolean;
    function StartProcedure(ADOQuery:TADOQuery;pUser,pGUID,pIP,pCompName:string): boolean;
    function GetSQLGridFRomBase(var pQry : TADOQuery; pViewTag : integer) : boolean;
    function GetFieldsGridFRomBase(var pQry : TADOQuery; pViewTag : integer) : boolean;
    function GetDateTime(var pQry : TADOQuery):TDateTime;
    function GetComboBoxSQL(var pQry : TADOQuery; pViewTag : integer) : boolean;
    function GetQryTreeItems(var pQry : TADOQuery; pTagTree : smallint; TreeItemsId : TTreeItemsId = nil): boolean;
    procedure GetSQLComboBox(var pQry:TADOQuery;pCbxId:Integer);
    procedure GetAcceptedMenuItems(var pQry : TADOQuery; pPostId : integer);
    procedure GetAllMenuRights(var pQry : TADOQuery);
    procedure CopyMenuAccessItem(ADOQuery : TADOQuery;pPostFrom, pPostTo : Integer; pDeleteAllRight : boolean);
    procedure DeleteRightMenuItemVisible(ADOQuery : TADOQuery;pPostId, pMenuItemId : integer);
    procedure SaveRightMenuItemVisible(ADOQuery : TADOQuery;pPostId, pMenuItemId : integer);
    function GetVersion(pQry : TADOQuery):string;
    function GetFrxTemplate(var pQry:TADOQuery;pTemplId:integer):TfrxReport;
    procedure GetSubSQLFrxReport(var pQry:TADOQuery;pTemplId:integer);
    function CloseLimitIncrease(ADOQuery : TADOQuery;pId : integer):Boolean;
    function UnCloseLimitIncrease(ADOQuery : TADOQuery;pId : integer):Boolean;
    function SaveOrderStr(ADOQuery : TADOQuery;pId : integer):Boolean;
    procedure InsertTmpOrderStr(ADOQuery : TADOQuery;pId : integer);
    function OrderClose(ADOQuery : TADOQuery;pId : integer):Boolean;
    function OrderUnClose(ADOQuery : TADOQuery;pId : integer):Boolean;
    function INSERT_CLOSE_LIMIT(ADOQuery : TADOQuery; pCustomer, pCurrency: integer; pValue : real) : boolean;

  private
    MySQLConnection : TADOConnection;
//    UniStoredProc  : TUniStoredProc;
    function ShowSQLException(ADOQuery : TADOQuery;DefaultExeption : string):boolean;

end;

implementation

{$REGION 'Methods Execute queryes'}

procedure TSQLClass.StartTransaction;
begin
  MySQLConnection.BeginTrans;
end;

procedure TSQLClass.CommitTransaction;
begin
  MySQLConnection.CommitTrans;
end;

procedure TSQLClass.RollBackTransaction;
begin
  MySQLConnection.RollbackTrans;
end;

function TSQLClass.OpenQuerry(var pQry : TADOQuery) : boolean;
begin
  try
    pQry.Open;
    Result := True;
  except
    on E:Exception do
    begin
      Result := False;
      UnWaitCursor;
      ShowMyMessage(E.Message,tError,tOk);
      exit;
    end;
  end;
end;

function TSQLClass.ExecuteQuerry(var pQry : TAdoQuery;Transaction:boolean = true) : boolean;
begin
  Result := False;
  case Transaction of
    True:
      begin
        try
          MySQLConnection.BeginTrans;
          pQry.ExecSQL;
          if ShowSQLException(pQry, '') then
          begin
            MySQLConnection.RollbackTrans;
            exit;
          end;
          MySQLConnection.CommitTrans;
          Result := True;
        except
          on E:Exception do
          begin
            UnWaitCursor;
            ShowMyMessage(E.Message,tError,tOk);
            MySQLConnection.RollbackTrans;
            exit;
          end;
        end;
      end;
    False:
      begin
        try
          pQry.ExecSQL;
          if ShowSQLException(pQry, '') then
            exit;
          Result := True;
        except
          on E:Exception do
          begin
            UnWaitCursor;
            ShowMyMessage(E.Message,tError,tOk);
            exit;
          end;
        end;
      end;
  end;
end;

function TSQLClass.OnenProcedure(Transaction:boolean = true; ADOQuery : TADOQuery = nil) : TADOQuery;
begin
  Result := nil;
  case Transaction of
    true:
          begin
            try
              MySQLConnection.BeginTrans;
              ADOQuery.Open;
              if ShowSQLException(ADOQuery, '') then
              begin
                MySQLConnection.RollbackTrans;
                exit;
              end;
              MySQLConnection.CommitTrans;
              Result := ADOQuery;
            except
              on E:Exception do
              begin
                UnWaitCursor;
                ShowSQLException(ADOQuery, E.Message);
                MySQLConnection.RollbackTrans;
                exit;
              end;
            end;
          end;
    false:
         begin
            try
              ADOQuery.Open;
              if ShowSQLException(ADOQuery, '') then
                exit;
              Result := ADOQuery;
            except
              on E:Exception do
              begin
                UnWaitCursor;
                ShowSQLException(ADOQuery, E.Message);
                exit;
              end;
            end;
         end;
  end;
end;

function TSQLClass.ExecuteProcedure(Transaction:boolean = true; ADOQuery : TADOQuery = nil) : boolean;
begin
  Result := False;
  try
    case Transaction of
      true:
            begin
              try
                MySQLConnection.BeginTrans;
                ADOQuery.ExecSQL;
                if ShowSQLException(ADOQuery, '') then
                begin
                  MySQLConnection.RollbackTrans;
                  exit;
                end;
                MySQLConnection.CommitTrans;
                Result := True;
              except
                on E:Exception do
                begin
                  UnWaitCursor;
                  Result := False;
                  ShowSQLException(ADOQuery, E.Message);
                  MySQLConnection.RollbackTrans;
                  exit;
                end;
              end;
            end;
      false:
           begin
              try
                ADOQuery.ExecSQL;
                if ShowSQLException(ADOQuery, '') then
                  exit;
                Result := True;
              except
                on E:Exception do
                begin
                  UnWaitCursor;
                  Result := False;
                  ShowSQLException(ADOQuery, E.Message);
                  exit;
                end;
              end;
           end;
    end;
  except
    case Transaction of
      True : MySQLConnection.RollbackTrans;
    end;
    Result := False;
  end;
end;
{$ENDREGION}

function TSQLClass.ShowSQLException(ADOQuery : TADOQuery;DefaultExeption : string):boolean;
begin
  Result := False;
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.Get_Error :vError output');
    ADOQuery.ExecSQL;
//    ExecuteProcedure(False, ADOQuery);
    if VarToStr(Parameters.ParamByName('vError').Value) <> '' then
    begin
      ShowMyMessage(Parameters.ParamByName('vError').Value,tError,tOk);
      Result := True;
    end
    else
      if DefaultExeption <> '' then
      begin
        ShowMyMessage(DefaultExeption,tError,tOk);
        Result := True;
      end;
  end;
end;

constructor TSQLClass.Create(pUser:string;pMySQLConnection:TADOConnection);                             // ;pUniStoredProc:TUniStoredProc
begin
  MySQLConnection := pMySQLConnection;
//  UniStoredProc := pUniStoredProc;
end;

destructor TSQLClass.Destroy;
begin
//  FreeAndNil(UniStoredProc);
end;

function TSQLClass.StartProcedure(ADOQuery:TADOQuery;pUser,pGUID,pIP,pCompName:string): boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.StartProcedure :pUser');
    Parameters.ParamByName('pUser').Value := pUser;
    Result := ExecuteProcedure(False, ADOQuery);
  end;
end;

function TSQLClass.GetComboBoxSQL(var pQry : TADOQuery; pViewTag : integer) : boolean;
begin
  with pQry do
  begin
    SQL.Text := 'SELECT cbxsql,ordertext FROM dbo.s_cbxsql WHERE id = :pCBId';
    Parameters.ParamByName('pCBId').Value := pViewTag;
    Result := OpenQuerry(pQry);
  end;
end;

function TSQLClass.GetMenuQry(var pQry : TADOQuery): boolean;
begin
  with pQry do
  begin
    SQL.Add('SELECT m.id,RTRIM(m.name) as name,RTRIM(m.modules) as modules,m.parentid,m.imagename,m.level');
    SQL.Add('FROM dbo.s_menu m, dbo.v_sd_personals_active vspa, dbo.access a');
    SQL.Add('WHERE vspa.login = dbo.getuser() AND a.groupuserid = vspa.postid AND m.id=a.menuid');
    SQL.Add('ORDER BY m.level,m.name');
    Result := OpenQuerry(pQry);
  end;
end;

function TSQLClass.GetSQLGridFRomBase(var pQry : TADOQuery; pViewTag : integer): boolean;
begin
  with pQry do
  begin
    SQL.Text := 'SELECT sqltext,ordertext,sqlinsert,sqlupdate,sqldelete FROM dbo.s_gridsql WHERE id=:pGridId';
    Parameters.ParamByName('pGridId').Value := pViewTag;
    Result := OpenQuerry(pQry);
  end;
end;

function TSQLClass.GetFieldsGridFRomBase(var pQry : TADOQuery; pViewTag : integer): boolean;
begin
  with pQry do
  begin
    SQL.Text := 'SELECT nn,RTRIM(name) as name,vsfield,edfield,perwidth,RTRIM(fieldname) as fieldname,RTRIM(fieldtype) AS fieldtype,RTRIM(paramname) as paramname,cbxsqlid FROM dbo.s_gridfields WHERE id=:pGridId ORDER BY nn';
    Parameters.ParamByName('pGridId').Value := pViewTag;
    Result := OpenQuerry(pQry);
  end;
end;

function TSQLClass.GetQryTreeItems(var pQry : TADOQuery; pTagTree : smallint; TreeItemsId : TTreeItemsId = nil): boolean;
var
  i : integer;
  SQLItems : string;
begin
  if TreeItemsId <> nil then
  begin
    SQLItems := ' and iditem in (';
    for I := 0 to TreeItemsId.ListItems.Count - 1 do
      SQLItems := SQLItems + TcbObj(TreeItemsId.ListItems[i]).tag + ',';
    SQLItems := Copy(SQLItems,1,Length(SQLItems)-1) + ')';
    pQry.SQL.Text := 'SELECT iditem,name,parent,gridsqlid,imageindex,selectimageindex FROM dbo.s_tree_items WHERE idTree=:pId' + SQLItems + ' ORDER BY ordernum';
  end
  else
    pQry.SQL.Text := 'SELECT iditem,name,parent,gridsqlid,imageindex,selectimageindex FROM dbo.s_tree_items WHERE idTree=:pId ORDER BY ordernum';
  with pQry do
  begin
    Parameters.ParamByName('pId').Value := pTagTree;
    Result := OpenQuerry(pQry);
  end;
end;

procedure TSQLClass.GetSQLComboBox(var pQry:TADOQuery;pCbxId:Integer);
begin
  with pQry do
  begin
    SQL.Text := 'SELECT cbxsql,ordertext FROM dbo.s_cbxsql WHERE id=:pID';
    Parameters.ParamByName('pID').Value := pCbxId;
    OpenQuerry(pQry);
  end;
end;

function TSQLClass.GetDateTime(var pQry : TADOQuery):TDateTime;
begin
  with pQry do
  begin
    SQL.Text := 'SELECT GETDATE() as datetime';
    OpenQuerry(pQry);
    Result := pQry.FieldByName('datetime').AsDateTime;
  end;
end;

procedure TSQLClass.GetAcceptedMenuItems(var pQry : TADOQuery; pPostId : integer);
begin
  with pQry do
  begin
    SQL.Add('SELECT a.menuid, m.name, m.parentid FROM dbo.access a, dbo.s_menu m ');
    SQL.Add('WHERE a.groupuserid = :pPostId AND m.id=a.menuid ORDER BY m.parentid,m.name ');
    Prepared;
    Parameters.ParamByName('pPostId').Value := pPostId;
    OpenQuerry(pQry);
  end;
end;

procedure TSQLClass.GetAllMenuRights(var pQry : TADOQuery);
begin
  with pQry do
  begin
    SQL.Text := 'SELECT id,name,parentid,level FROM dbo.s_menu ORDER BY parentid,name';
    OpenQuerry(pQry);
  end;
end;

procedure TSQLClass.CopyMenuAccessItem(ADOQuery : TADOQuery;pPostFrom, pPostTo : Integer; pDeleteAllRight : boolean);
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_access_menu_copy :pPostFrom,:pPostTo,:pDeleteRight');
    Parameters.ParamByName('pPostFrom').Value := pPostFrom;
    Parameters.ParamByName('pPostTo').Value := pPostTo;
    Parameters.ParamByName('pDeleteRight').Value := pDeleteAllRight;
    Prepared;
    if not ExecuteProcedure(True, ADOQuery) then Exit;
  end;
end;

procedure TSQLClass.DeleteRightMenuItemVisible(ADOQuery : TADOQuery;pPostId, pMenuItemId : integer);
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pd_access_menu :pPostId,:pMenuItemId');
    Parameters.ParamByName('pPostId').Value := pPostId;
    Parameters.ParamByName('pMenuItemId').Value := pMenuItemId;
    Prepared;
    if not ExecuteProcedure(True, ADOQuery) then Exit;
  end;
end;

procedure TSQLClass.SaveRightMenuItemVisible(ADOQuery : TADOQuery;pPostId, pMenuItemId : integer);
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_access_menu :pPostID,:pItemID');
    Parameters.ParamByName('pPostID').Value := pPostId;
    Parameters.ParamByName('pItemID').Value := pMenuItemId;
    Prepared;
    if not ExecuteProcedure(True, ADOQuery) then Exit;
  end;
end;

function TSQLClass.GetVersion(pQry : TAdoQuery):string;
begin
  with pQry do
  begin
    SQL.Add('SELECT RTRIM(vers) as vers,GETDATE()s FROM dbo.version');
    OpenQuerry(pQry);
    Result := FieldByName('vers').AsString;
  end;
end;

function TSQLClass.CloseLimitIncrease(ADOQuery : TADOQuery;pId : integer):Boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_limit_transaction_close :pTransactID');
    Parameters.ParamByName('pTransactID').Value := pId;
    Prepared;
    Result := ExecuteProcedure(True, ADOQuery);
  end;
end;

function TSQLClass.UnCloseLimitIncrease(ADOQuery : TADOQuery;pId : integer):Boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_limit_transaction_unclose :pTransactID');
    Parameters.ParamByName('pTransactID').Value := pId;
    Prepared;
    Result := ExecuteProcedure(True, ADOQuery);
  end;
end;

function TSQLClass.SaveOrderStr(ADOQuery : TADOQuery;pId : integer):Boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_order_save :pOrderId');
    Parameters.ParamByName('pOrderId').Value := pId;
    Prepared;
    Result := ExecuteProcedure(True, ADOQuery);
  end;
end;

procedure TSQLClass.InsertTmpOrderStr(ADOQuery : TADOQuery;pId : integer);
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pi_order_str_tmp :pOrderId');
    Parameters.ParamByName('pOrderId').Value := pId;
    Prepared;
    ExecuteProcedure(False, ADOQuery);
  end;
end;

function TSQLClass.OrderClose(ADOQuery : TADOQuery;pId : integer):Boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_order_close :pOrderId');
    Parameters.ParamByName('pOrderId').Value := pId;
    Prepared;
    Result := ExecuteProcedure(True, ADOQuery);
  end;
end;

function TSQLClass.OrderUnClose(ADOQuery : TADOQuery;pId : integer):Boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.pu_order_unclose :pOrderId');
    Parameters.ParamByName('pOrderId').Value := pId;
    Prepared;
    Result := ExecuteProcedure(True, ADOQuery);
  end;
end;

function TSQLClass.GetFrxTemplate(var pQry:TADOQuery;pTemplId:integer):TfrxReport;
var
  LFileName: string;
begin
  with pQry do
  begin
    SQL.Text := 'SELECT filetemplate FROM s_frxReports WHERE id = :pId';
    Prepared;
    Parameters.ParamByName('pId').Value := pTemplId;
    OpenQuerry(pQry);
    Result := TfrxReport.Create(nil);
    Result.PrintOptions.ShowDialog:=false;
    LFileName := TPath.Combine(TPath.GetLibraryPath, FieldByName('filetemplate').AsString);
    if TFile.Exists(LFileName) then
      Result.LoadFromFile(LFileName)
    else
      FreeAndNil(Result);
  end;
end;

procedure TSQLClass.GetSubSQLFrxReport(var pQry:TADOQuery;pTemplId:integer);
begin
  with pQry do
  begin
    SQL.Text := 'SELECT n,sqltext,description,linkMD,nameQry FROM s_frxReportsSQL WHERE idreport=:pId ORDER BY n';
    Prepared;
    Parameters.ParamByName('pId').Value := pTemplId;
    OpenQuerry(pQry);
  end;
end;

function TSQLClass.INSERT_CLOSE_LIMIT(ADOQuery : TADOQuery; pCustomer, pCurrency: integer; pValue : real) : boolean;
begin
  with ADOQuery do
  begin
    SQL.Clear;
    SQL.Add('EXEC dbo.INSERT_AND_CLOSE_LIMIT :pCustomer,:pCurrency,:pValue');
    Parameters.ParamByName('pCustomer').Value := pCustomer;
    Parameters.ParamByName('pCurrency').Value := pCurrency;
    Parameters.ParamByName('pValue').Value := pValue;
    Prepared;
    Result := ExecuteProcedure(True, ADOQuery);
  end;
end;

end.

