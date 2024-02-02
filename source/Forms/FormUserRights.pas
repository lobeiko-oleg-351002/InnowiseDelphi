unit FormUserRights;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sComboBox, sLabel, DBWork,
  Vcl.ExtCtrls, Vcl.ComCtrls, sTreeView, FormResource, Vcl.Graphics, Uni,
  System.Generics.Collections, MyMessageCls, Vcl.Menus, System.Actions,
  Vcl.ActnList, acPNG, Vcl.Buttons, sBitBtn, MyDialogForm, sCheckBox, Data.Win.ADODB;

type
  TMenuItem = class
    private
      id : Integer;
      name : string;
      parent : integer;
      FNode : TTreeNode;
      procedure SetNode(aValue : TTreeNode);
    public
      constructor Create(aId, aParent : Integer; aName : string);
      property Node : TTreeNode read FNode write SetNode;
  end;
  TMenuItemList = class(TList<TMenuItem>);

  TfrmUserRights = class(TForm)
    GridPanel1: TGridPanel;
    GridPanel2: TGridPanel;
    sLabel1: TsLabel;
    cbPosts: TsComboBox;
    GridPanel3: TGridPanel;
    GridPanel4: TGridPanel;
    sLabel2: TsLabel;
    GridPanel5: TGridPanel;
    sLabel3: TsLabel;
    tvAllMenu: TsTreeView;
    tvAccessRight: TsTreeView;
    btnDelete: TsBitBtn;
    btnCopyRight: TsBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvAccessRightDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvAccessRightDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure cbPostsChange(Sender: TObject);
    procedure actDeleteMenuItemExecute(Sender: TObject);
    procedure btnDeleteDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnDeleteDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnCopyRightClick(Sender: TObject);
  private
    { Private declarations }
    ListItemsMenu : TMenuItemList;
    ListAcceptedItemsMenu : TMenuItemList;
    frmCopyRights : TfrmMyDialog;
    cbPostsRight : TsComboBox;
    chkBoxDeleteRight : TsCheckBox;
    procedure FillTreeView(aTv:TsTreeView; aList : TMenuItemList);
    procedure CopyRights(Sender: TObject);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TMenuItem.SetNode(aValue : TTreeNode);
begin
  FNode := aValue;
end;

constructor TMenuItem.Create(aId, aParent : Integer; aName : string);
begin
  id := aId;
  name := aName;
  parent := aParent;
  FNode := nil;
end;

procedure TfrmUserRights.FillTreeView(aTv:TsTreeView; aList : TMenuItemList);
var
  Item, SubItem : TMenuItem;
begin
  aTv.Items.Clear;
  for Item in aList do
  begin
    if Item.parent = 0 then
    begin
      Item.Node := aTv.Items.AddChild(nil, Item.name);
    end
    else
    begin
      for SubItem in aList do
      if SubItem.id = Item.parent then
        Item.Node := aTv.Items.AddChild(SubItem.Node, Item.name);
    end;
  end;
end;

procedure TfrmUserRights.actDeleteMenuItemExecute(Sender: TObject);
//var
//  Item : TMenuItem;
begin
//  for Item in ListItemsMenu do
//    if Item.name = tvAccessRight.Selected.Text then
//    begin
//      ShowMyMessage(IntToStr(Item.id));
//      Break;
//    end;
end;

procedure TfrmUserRights.cbPostsChange(Sender: TObject);
var
  Q : TADOQuery;
begin
  tvAccessRight.Items.Clear;
  ListAcceptedItemsMenu.Clear;
  Q := pPDB.CreateQuerry;
  with Q do
  try
    pPDB.GetAcceptedMenuItems(Q, StrToInt(TcbObj(cbPosts.Items.Objects[cbPosts.ItemIndex]).tag));
    while not Eof do
    begin
      ListAcceptedItemsMenu.Add
        (
          TMenuItem.Create
            (
              FieldByName('menuid').AsInteger,
              FieldByName('parentid').AsInteger,
              FieldByName('name').AsString
            )
        );
      Next;
    end;
    FillTreeView(tvAccessRight, ListAcceptedItemsMenu);
    tvAccessRight.FullExpand;
  finally
    FreeAndNil(Q);
  end;
end;

procedure TfrmUserRights.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmUserRights.FormCreate(Sender: TObject);
var
  Q : TADOQuery;
begin
  tvAllMenu.Color := frmResource.BackGroundColor;
  tvAllMenu.Font.Color := frmResource.FontColor;
  tvAccessRight.Color := frmResource.BackGroundColor;
  tvAccessRight.Font.Color := frmResource.FontColor;
  cbPosts.Color := frmResource.BackGroundColor;
  cbPosts.Font.Color := frmResource.FontColor;
  btnDelete.SkinData.ColorTone := frmResource.BackGroundColor;
  btnCopyRight.SkinData.ColorTone := frmResource.BackGroundColor;
  pPDB.FillItemsFromDB(cbPosts.Items, cbPosts.Tag, [], False);
  ListItemsMenu := TMenuItemList.Create;
  ListAcceptedItemsMenu := TMenuItemList.Create;
  Q := pPDB.CreateQuerry;
  try
    pPDB.GetAllMenuRights(Q);
    while not Q.Eof do
    begin
      ListItemsMenu.Add
        (
          TMenuItem.Create
            (
              Q.FieldByName('id').AsInteger,
              Q.FieldByName('parentid').AsInteger,
              Q.FieldByName('name').AsString
            )
        );
      Q.Next;
    end;
    FillTreeView(tvAllMenu, ListItemsMenu);
  finally
    FreeAndNil(Q);
  end;
end;

procedure TfrmUserRights.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ListItemsMenu);
  FreeAndNil(ListAcceptedItemsMenu);
end;

procedure TfrmUserRights.CopyRights(Sender: TObject);
var
  ADOQuery : TADOQuery;
begin
  if cbPostsRight.ItemIndex = -1 then
  begin
    ShowMyMessage('Rights group not specified!', tError, tOk);
    Exit;
  end;
  ADOQuery := pPDB.CreateQuerry;
  try
    pPDB.CopyMenuAccessItem
      (
        ADOQuery,
        StrToInt(TcbObj(cbPostsRight.Items.Objects[cbPostsRight.ItemIndex]).tag),
        StrToInt(TcbObj(cbPosts.Items.Objects[cbPosts.ItemIndex]).tag),
        chkBoxDeleteRight.Checked
      );
  finally
    FreeAndNil(ADOQuery);
  end;
  frmCopyRights.ModalResult := mrOk;
end;

procedure TfrmUserRights.btnCopyRightClick(Sender: TObject);
begin
  if cbPosts.ItemIndex = -1 then exit;
  frmCopyRights := TfrmMyDialog.Create(nil);
  try
    with frmCopyRights do
    begin
      SetDialogSize(400,250);
      cbPostsRight := TsComboBox(CreateObject('TsComboBox','cbPosts','Post',10,20,250,33,'','True'));
      cbPostsRight.Text := '';
      cbPostsRight.Tag := cbPosts.Tag;
      pPDB.FillItemsFromDB(cbPostsRight.Items, cbPostsRight.Tag, [], False);
      chkBoxDeleteRight := TsCheckBox(CreateObject('TsCheckBox','chkDeleteRight','Remove existing accesses',10,50,0,33,'','True'));
      btnOk.OnClick := CopyRights;
      ShowModal;
      if ModalResult = mrOk then
        cbPostsChange(nil);
    end;
  finally
    FreeAndNil(frmCopyRights);
  end;
end;

procedure TfrmUserRights.btnDeleteDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Item : TMenuItem;
  ADOQuery : TADOQuery;
begin
  ADOQuery := pPDB.CreateQuerry;
  try
    for Item in ListAcceptedItemsMenu do
      if Item.name = TsTreeView(Source).Selected.Text then
      begin
        pPDB.DeleteRightMenuItemVisible(ADOQuery,StrToInt(TcbObj(cbPosts.Items.Objects[cbPosts.ItemIndex]).tag), Item.id);
        cbPostsChange(nil);
        Break;
      end;
  finally
    FreeAndNil(ADOQuery);
  end;
end;

procedure TfrmUserRights.btnDeleteDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source is TsTreeView then
  begin
    if TsTreeView(Source).Name = 'tvAccessRight' then
    begin
      Accept := True;
    end;
  end;
end;

procedure TfrmUserRights.tvAccessRightDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Item : TMenuItem;
  ADOQuery : TADOQuery;
begin
  if cbPosts.ItemIndex = -1 then
  begin
    ShowMyMessage('Position not selected!', tError, tOk);
    exit;
  end;
  ADOQuery := pPDB.CreateQuerry;
  try
    for Item in ListItemsMenu do
      if Item.name = TsTreeView(Source).Selected.Text then
      begin
        pPDB.SaveRightMenuItemVisible(ADOQuery,StrToInt(TcbObj(cbPosts.Items.Objects[cbPosts.ItemIndex]).tag), Item.id);
        Break;
      end;
  finally
    FreeAndNil(ADOQuery);
  end;
  cbPostsChange(nil);
end;

procedure TfrmUserRights.tvAccessRightDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source is TsTreeView then
    Accept := True
  else
    Accept := False;
end;

end.
