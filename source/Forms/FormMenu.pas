unit FormMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormGridBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxCustomTileControl, dxTileControl,
  cxClasses, DBWork, Uni, UniProvider, MyMessageCls, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dxBar,FormResource, Vcl.ExtCtrls,
  FormDirectorys, Vcl.ComCtrls, sPageControl, System.Generics.Collections,
  FormOrders, FormUserRights,FormBalances, FormUpperLimit, Data.Win.ADODB;

type
  TMenuItemIndex = record
    GroupIdList : SmallInt;
    ItemIdList  : SmallInt;
end;

type
  TBaseFormRef = class of TfrmBase;

type
  TMenuItemCls = class
  private
    ItemMenu : TdxTileControlItem;
    vId : integer;
    vLevel : SmallInt;
    vName : string;
    vModule : string;
    vParent : Integer;
    vImageName : string;
    ListModuleForm : TList;
    procedure tcMenuItem1Click(Sender: TdxTileControlItem);
  public
    constructor Create(pId,pLevel:Integer;pName,pModule:string;pParent:Integer;pImageName:string; pMenu:TdxTileControl; pListModuleForm : TList);
    destructor Destroy;override;
end;

type
  TMenuGroupCls = class
  private
    GroupMenu : TdxTileControlGroup;
    vLevel : SmallInt;
    ListMenuItem : TList<TMenuItemCls>;   //  TMenuItemCls
    vMenu : TdxTileControl;
    tmrMessage : TTimer;
    ListModuleForm : TList;
    procedure tmrMessageTimer(Sender: TObject);
    function GetMenuItem(pId:Integer): TMenuItemCls;
  public
    constructor Create(pLevel : SmallInt; pMenu : TdxTileControl; pListModuleForm : TList);
    destructor Destroy;override;
    procedure AddItem(pId:Integer;pName,pModule:string;pParent:Integer;pImageName:string);
end;

type
  TMenuCls = class
  private
    ListModuleForm : TList;
    ListGroups : TList<TMenuGroupCls>;
  public
    constructor Create(pMenu : TdxTileControl; pListModuleForm : TList);
    destructor Destroy; override;
    procedure AddGroup(pLevel : SmallInt; pMenu : TdxTileControl);
end;

type
  TfrmMenu = class(TForm)
    tcMenu: TdxTileControl;
    pcBody: TsPageControl;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pcBodyCloseBtnClick(Sender: TComponent; TabIndex: Integer;
      var CanClose: Boolean; var Action: TacCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    Qry : TADOQuery;
    vMenu : TMenuCls;
    DictSheetMenu : TObjectDictionary<integer,TForm>;
    vIndexActiveItem : TMenuItemIndex;
    ListModuleForm : TList;
    procedure CheckStateMenu(pItemId : Smallint);
    function FindForm(AClass: TBaseFormRef; pTag : integer): TForm;
    procedure RunForm(const Index, pTag: Integer);
  public
    { Public declarations }
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.dfm}

//const
//   ListModuleForm : array[1..8] of TBaseFormRef =(
//      TfrmDirectorys,
//      TfrmWh,
//      TfrmDelivery,
//      TfrmMoveNomenclature,
//      TfrmOrders,
//      TfrmBox,
//      TfrmConsumption,
//      TfrmInventory
//
//   );

function TfrmMenu.FindForm(AClass: TBaseFormRef; pTag : integer): TForm;
var
  Index: Integer;
  tabSheet : TsTabSheet;
  menuGroup : TMenuGroupCls;
  menuItem : TMenuItemCls;
begin
  Result := nil;
  Index := 0;
  while (Index < Screen.FormCount) and (not Assigned(Result)) do
  begin
    if Screen.Forms[Index].ClassType = AClass then
      Result := Screen.Forms[Index]
    else
      Inc(Index);
  end;
  if not Assigned(Result) then
  begin
    Result := AClass.Create(Application.MainForm);
    tabSheet := TsTabSheet.Create(pcBody);
    for menuGroup in vMenu.ListGroups do
      for menuItem in menuGroup.ListMenuItem do
        if menuItem.vId = pTag then
        begin
          tabSheet.Caption := menuItem.vName;
          Break;
        end;
    with tabSheet do
    begin
      PageControl := pcBody;
      Tag := pTag;
      SkinData.CustomColor := True;
      SkinData.CustomFont := True;
      Font.Color := frmResource.FontColor;
    end;
    pcBody.ActivePage := tabSheet;
    Result.Parent := tabSheet;
    Result.Align := alClient;
    Result.AlignWithMargins := False;
    DictSheetMenu.Add(pTag, Result);
    pcBody.Show;
  end
  else
  begin
    for Index := 0 to pcBody.PageCount - 1 do
      if pcBody.Pages[index].Tag = pTag then
      begin
        pcBody.ActivePage := pcBody.Pages[index];
        Break;
      end;

  end;
end;

procedure TfrmMenu.RunForm(const Index, pTag: Integer);
var
  Form: TForm;
begin
  if ListModuleForm.Count < Index then
    Exit;
  Form := FindForm(ListModuleForm[Index], pTag);
  if Assigned(Form) then
  begin
//    Form.Parent := sTabSheet1;
    Form.Show;
  end;
end;

constructor TMenuCls.Create(pMenu : TdxTileControl; pListModuleForm : TList);
begin
  ListModuleForm := pListModuleForm;
  ListGroups := TList<TMenuGroupCls>.Create;
end;

destructor TMenuCls.Destroy;
begin
  while ListGroups.Count > 0 do
  begin
    TMenuGroupCls(ListGroups.Items[0]).Destroy;
    ListGroups.Delete(0);
  end;
  FreeAndNil(ListGroups);
end;

procedure TMenuCls.AddGroup(pLevel : SmallInt; pMenu : TdxTileControl);
begin
  ListGroups.Add(TMenuGroupCls.Create(pLevel, pMenu,ListModuleForm));
end;

constructor TMenuGroupCls.Create(pLevel : SmallInt; pMenu : TdxTileControl; pListModuleForm : TList);
begin
  ListModuleForm := pListModuleForm;
  GroupMenu := pMenu.Groups.Add;
  ListMenuItem := TList<TMenuItemCls>.Create;
  vMenu := pMenu;
  vLevel := pLevel;
  tmrMessage := TTimer.Create(nil);
  tmrMessage.Interval := 2000;
  tmrMessage.OnTimer := tmrMessageTimer;
  tmrMessage.Enabled := True;
end;

destructor TMenuGroupCls.Destroy;
begin
  tmrMessage.Enabled := False;
  FreeAndNil(tmrMessage);
  while ListMenuItem.Count > 0 do
  begin
    TMenuItemCls(ListMenuItem.Items[0]).Destroy;
    ListMenuItem.Delete(0);
  end;
  FreeAndNil(ListMenuItem);
  FreeAndNil(GroupMenu);
end;

procedure TMenuGroupCls.AddItem(pId:Integer;pName,pModule:string;pParent:Integer;pImageName:string);
begin
  ListMenuItem.Add(TMenuItemCls.Create(pId,vLevel,pName,pModule,pParent,pImageName,vMenu,ListModuleForm));
  TMenuItemCls(ListMenuItem[ListMenuItem.Count - 1]).ItemMenu.Group := GroupMenu;
end;

constructor TMenuItemCls.Create(pId,pLevel:Integer;pName,pModule:string;pParent:Integer;pImageName:string; pMenu:TdxTileControl; pListModuleForm : TList);
begin
  ListModuleForm := pListModuleForm;
  ItemMenu := pMenu.Items.Add;
  ItemMenu.Tag := pId;
  ItemMenu.OnClick := tcMenuItem1Click;
  ItemMenu.Style.GradientBeginColor := frmResource.BackGroundColor;
  ItemMenu.Style.GradientEndColor := frmResource.BackGroundColor;
  vId := pId;
  vLevel := pLevel;
  vName := pName;
  vModule := pModule;
  vParent := pParent;
  vImageName := pImageName;
  ItemMenu.Text1.WordWrap := True;
  ItemMenu.Text1.Align := oaMiddleCenter;
  ItemMenu.Text1.Font.Color := clBlack;//frmResource.FontColor;
  ItemMenu.Text1.Value := pName;
end;

function TMenuGroupCls.GetMenuItem(pId:Integer): TMenuItemCls;
var
  i : Integer;
begin
  Result := nil;
  for I := 0 to ListMenuItem.Count - 1 do
    if TMenuItemCls(ListMenuItem[i]).vId = pId then
    begin
      Result := TMenuItemCls(ListMenuItem[i]);
      Break;
    end;
end;

procedure TMenuGroupCls.tmrMessageTimer(Sender: TObject);
var
  Item : TMenuItemCls;
begin
  Item := GetMenuItem(20);
  if Item = nil then exit;
end;

procedure TMenuItemCls.tcMenuItem1Click(Sender: TdxTileControlItem);
var
  frmClsName : string;
  i : Integer;
begin
  frmMenu.CheckStateMenu(TdxTileControlItem(Sender).tag);
  frmClsName := TMenuItemCls(TMenuGroupCls(frmMenu.vMenu.ListGroups[frmMenu.vIndexActiveItem.GroupIdList]).
                              ListMenuItem[frmMenu.vIndexActiveItem.ItemIdList]).vModule;
  for i := 0 to ListModuleForm.count - 1 do
    if TBaseFormRef(ListModuleForm[i]).ClassName = frmClsName then
    begin
      frmMenu.RunForm(i, TdxTileControlItem(Sender).tag);
      Break;
    end;
end;

destructor TMenuItemCls.Destroy;
begin
  FreeAndNil(ItemMenu);
end;

procedure TfrmMenu.CheckStateMenu(pItemId : Smallint);
var
  i,j : SmallInt;
begin
  tcMenu.BeginUpdate;
  try
    vIndexActiveItem.GroupIdList := -1;
    vIndexActiveItem.ItemIdList := -1;
    for i := 0 to vMenu.ListGroups.Count - 1 do
    begin
      for j := 0 to TMenuGroupCls(vMenu.ListGroups[i]).ListMenuItem.Count - 1 do
        if TMenuItemCls(TMenuGroupCls(vMenu.ListGroups[i]).ListMenuItem[j]).vId = pItemId then
        begin
          vIndexActiveItem.GroupIdList := i;
          vIndexActiveItem.ItemIdList := j;
          Break;
        end;
      if (vIndexActiveItem.GroupIdList <> -1) and (vIndexActiveItem.ItemIdList <> -1) then
        Break;
    end;
    if TMenuItemCls(TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList]).ListMenuItem[vIndexActiveItem.ItemIdList]).vModule <> '' then
    begin
      Exit;
    end;
    for i := 1 to vMenu.ListGroups.Count - 1 do
      TMenuGroupCls(vMenu.ListGroups[i]).GroupMenu.Visible := False;
    for i := 1 to vIndexActiveItem.GroupIdList + 1 do
      TMenuGroupCls(vMenu.ListGroups[i]).GroupMenu.Visible := True;
    for i := 0 to TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList + 1]).ListMenuItem.Count -1 do
      if TMenuItemCls(TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList + 1]).ListMenuItem[i]).vParent <> pItemId then
        TMenuItemCls(TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList + 1]).ListMenuItem[i]).ItemMenu.Visible := False
      else
        TMenuItemCls(TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList + 1]).ListMenuItem[i]).ItemMenu.Visible := True;
     TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList + 1]).GroupMenu.Caption.Text :=
          TMenuItemCls(TMenuGroupCls(vMenu.ListGroups[vIndexActiveItem.GroupIdList]).ListMenuItem[vIndexActiveItem.ItemIdList]).ItemMenu.Text1.Value;
  finally
    tcMenu.EndUpdate;
  end;
end;

procedure TfrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  case ShowMyMessage('Shut down and close the program?', tQuestion, tBoth) of
    mrCancel : Exit;
  end;
  CanClose := True;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
var
  lvlTag : Byte;
begin

  ListModuleForm := TList.Create;
  ListModuleForm.Add(TfrmDirectorys);
  ListModuleForm.Add(TfrmUserRights);
  ListModuleForm.Add(TfrmBalances);
  ListModuleForm.Add(TfrmUpperLimit);
  ListModuleForm.Add(TfrmOrders);

  WindowState := wsMaximized;
  DictSheetMenu := TObjectDictionary<Integer,TForm>.Create([doOwnsValues]);
  vMenu := TMenuCls.Create(TfrmMenu(self).tcMenu, ListModuleForm);
  Qry := pPDB.CreateQuerry;
  with Qry do
  begin
    pPDB.GetMenuQry(Qry);
    lvlTag := 0;
    while not eof do
    begin
      if lvlTag <> FieldByName('level').AsInteger then
      begin
        lvlTag := FieldByName('level').AsInteger;
        vMenu.AddGroup(lvlTag, tcMenu);
        TMenuGroupCls(vMenu.ListGroups[vMenu.ListGroups.Count - 1]).GroupMenu.Visible := False;
      end;
      TMenuGroupCls(vMenu.ListGroups[vMenu.ListGroups.Count - 1]).AddItem(FieldByName('id').AsInteger,FieldByName('name').AsString,FieldByName('modules').AsString,
                                                                          FieldByName('parentid').AsInteger,FieldByName('imagename').AsString);
      Next;
    end;
    if vMenu.ListGroups.Count > 0 then
      TMenuGroupCls(vMenu.ListGroups[0]).GroupMenu.Visible := True;
  end;
end;

procedure TfrmMenu.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Qry);
  vMenu.Destroy;
  DictSheetMenu.Clear;
  FreeAndNil(DictSheetMenu);
  FreeAndNil(ListModuleForm);
end;

procedure TfrmMenu.pcBodyCloseBtnClick(Sender: TComponent; TabIndex: Integer;
  var CanClose: Boolean; var Action: TacCloseAction);
var
  TabSheet : TsTabSheet;
  i : integer;
begin
  TabSheet := pcBody.Pages[TabIndex];
  for I := 0 to TabSheet.ControlCount - 1 do
  begin
    DictSheetMenu.Remove(TabSheet.Tag);
    Break;
  end;
  if pcBody.PageCount = 1 then
    pcBody.Hide;
end;

end.
