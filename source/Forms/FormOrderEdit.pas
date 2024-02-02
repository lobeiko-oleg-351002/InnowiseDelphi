unit FormOrderEdit;

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
  Data.Win.ADODB;

type
  TfrmOrderEdit = class(TfrmBase)
    btnSave: TsSpeedButton;
    actSave: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actAddRowUpdate(Sender: TObject);
  private
    { Private declarations }
    FParent : TWinControl;
    FCanClose : Boolean;
    GrdServices : TFillGridFromBase;
    FOrderId : Integer;
    FClosed : Boolean;
    procedure SetOrderId(aValue : integer);
    procedure SetPrnt(aValue : TWinControl);
  public
    { Public declarations }
    property Prnt : TWinControl read FParent write SetPrnt;
    property CanClose : Boolean read FCanClose write FCanClose;
    property OrderId : Integer read FOrderId write SetOrderId;
    property Closed : Boolean read FClosed write FClosed;
  end;

implementation

{$R *.dfm}

procedure TfrmOrderEdit.SetOrderId(aValue : integer);
var
  ADOQuery : TADOQuery;
begin
  ADOQuery := pPDB.CreateQuerry;
  try
    FOrderId := aValue;
    pPDB.InsertTmpOrderStr(ADOQuery,aValue);
    GrdServices := TFillGridFromBase.Create(baseGrid,[]);
  finally
    FreeAndNil(ADOQuery);
  end;
end;

procedure TfrmOrderEdit.actAddRowUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not Closed;
  baseGridView.GetColumnByFieldName('serviceid').Options.Editing := not Closed;
  baseGridView.GetColumnByFieldName('currencyid').Options.Editing := not Closed;
  baseGridView.GetColumnByFieldName('cost').Options.Editing := not Closed;
end;

procedure TfrmOrderEdit.actSaveExecute(Sender: TObject);
var
  ADOQuery : TADOQuery;
begin
  inherited;
  case ShowMyMessage('Save changes and exit?', tQuestion, tBoth) of
    mrCancel : exit;
  end;
  ADOQuery := pPDB.CreateQuerry;
  try
    if not pPDB.SaveOrderStr(ADOQuery, OrderId) then exit;
    CanClose := True;
  finally
    FreeAndNil(ADOQuery);
  end;
end;

procedure TfrmOrderEdit.FormCreate(Sender: TObject);
begin
  inherited;
  FCanClose := False;
  btnSave.SkinData.ColorTone := frmResource.BackGroundColor;
end;

procedure TfrmOrderEdit.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(GrdServices);
end;

procedure TfrmOrderEdit.SetPrnt(aValue : TWinControl);
begin
  Self.Parent := aValue.Parent;
end;

end.
