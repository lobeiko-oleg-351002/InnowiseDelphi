unit FormDirectorys;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormGridBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxImage,
  cxCheckBox, cxLabel, cxCalendar, System.Actions, Vcl.ActnList, dxBar,
  cxBarEditItem, cxClasses, cxGridLevel, cxGridCustomView,DBWork,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  Vcl.ComCtrls, cxContainer, cxTreeView, cxSplitter, Vcl.ExtCtrls, sTreeView,
  FormResource, Uni, UniProvider, MyMessageCls, CxGridUnit, Vcl.Buttons,
  sSpeedButton, Vcl.Menus, Vcl.StdCtrls, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sToolEdit, sLabel;

type
  TfrmDirectorys = class(TfrmBase)
    tvDict: TsTreeView;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction); override;
    procedure tvDictChange(Sender: TObject; Node: TTreeNode);
    procedure actAddRowUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    { Private declarations }
    TreeDict : TFillTreeFromBase;
    ActiveId  : Integer;
    itemsid : TTreeItemsId;
    FCanClose : Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; pItemsId : TTreeItemsId); reintroduce;
    property CanClose : Boolean read FCanClose write FCanClose;
  end;

var
  frmDirectorys: TfrmDirectorys;

implementation

{$R *.dfm}

procedure TfrmDirectorys.actAddRowUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := ActiveId <> 0;
end;

procedure TfrmDirectorys.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfrmDirectorys.FormDestroy(Sender: TObject);
begin
  inherited;
  tvDict.OnChange := nil;
  FreeAndNil(TreeDict);
  tvDict.Items.Clear;
end;

procedure TfrmDirectorys.actExitExecute(Sender: TObject);
begin
  CanClose := True;
end;

constructor TfrmDirectorys.Create(AOwner: TComponent; pItemsId : TTreeItemsId);
var
  i : integer;
begin
  itemsid := pItemsId;
  inherited create(AOwner);
  TreeDict := TFillTreeFromBase.Create(tvDict,itemsid);
  tvDict.FullExpand;
  for I := 0 to TreeDict.ListItems.Count - 1 do
  begin
    if TTreeItem(TreeDict.ListItems[i]).parentN <> 0 then
    begin
      tvDictChange(tvDict,TTreeItem(TreeDict.ListItems[i]).node);
      TTreeItem(TreeDict.ListItems[i]).node.Selected := True;
      Break;
    end;
  end;
  grdPnlButtonsTop.ColumnCollection[0].Value := 50;
end;

procedure TfrmDirectorys.FormCreate(Sender: TObject);
begin
  inherited;
  CanClose := False;
  if itemsid = nil then
    TreeDict := TFillTreeFromBase.Create(tvDict);
  tvDict.Color := frmResource.BackGroundColor;
  tvDict.Font.Color := clBlack;//frmResource.FontColor;
  Splitter1.Color := frmResource.BackGroundColor;
end;

procedure TfrmDirectorys.tvDictChange(Sender: TObject; Node: TTreeNode);
var
  i : Integer;
begin
  for I := 0 to TreeDict.ListItems.Count - 1 do
//  if TTreeItem(TreeDict.ListItems[i]).node = Node then
  if TTreeItem(TreeDict.ListItems[i]).name = Node.text then
    if TTreeItem(TreeDict.ListItems[i]).parentN <> 0 then
    begin
      if ActiveId = TTreeItem(TreeDict.ListItems[i]).id then Exit;
      ActiveId := TTreeItem(TreeDict.ListItems[i]).id;
      if GridClass <> nil then
        FreeAndNil(GridClass);
      baseGridView.Tag := TTreeItem(TreeDict.ListItems[i]).sqlgridid;
      baseGrid.Parent := Self;
      GridClass := TFillGridFromBase.create(baseGrid,[]);
      Break;
    end
    else
    begin
      if GridClass <> nil then
        FreeAndNil(GridClass);
      ActiveId := 0;
      ActiveView := nil;
    end;
end;

end.
