unit FormColumnsGridEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormResource, Vcl.StdCtrls, Vcl.Buttons,
  sBitBtn, sListBox, sCheckListBox, sLabel, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid;

type
  TfrmColumnsGridEdit = class(TForm)
    clbColumns: TsCheckListBox;
    btnOk: TsBitBtn;
    sLabel1: TsLabel;
    procedure FormCreate(Sender: TObject);
    procedure clbColumnsCheckChanging(Sender: TObject; AItemIndex: Integer;
      ANewState: TCheckBoxState; var ChangingAllowed: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    FGridView: TcxGridDBTableView;
    procedure SetView(aValue : TcxGridDBTableView);
  public
    { Public declarations }
    property GridView: TcxGridDBTableView write SetView;
  end;

implementation

{$R *.dfm}

procedure TfrmColumnsGridEdit.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmColumnsGridEdit.clbColumnsCheckChanging(Sender: TObject;
  AItemIndex: Integer; ANewState: TCheckBoxState; var ChangingAllowed: Boolean);
begin
  FGridView.Columns[AItemIndex].Visible := not FGridView.Columns[AItemIndex].Visible;
end;

procedure TfrmColumnsGridEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i : integer;
  str : string;
begin
  for I := 0 to FGridView.ColumnCount - 1 do
  if not FGridView.Columns[i].Visible then
    str := str + FGridView.Columns[i].Caption + ';';
  str := Copy(str, 1, Length(str) - 1);
  if str = '' then
    ConfigINIcls.DeleteValue('HIDEDFIELDS', IntToStr(FGridView.Tag))
  else
    ConfigINIcls.WriteValue('HIDEDFIELDS',IntToStr(FGridView.Tag),str);
end;

procedure TfrmColumnsGridEdit.FormCreate(Sender: TObject);
begin
  clbColumns.Color := frmResource.BackGroundColor;
  clbColumns.Font.Color := frmResource.FontColor;
end;

procedure TfrmColumnsGridEdit.SetView(aValue : TcxGridDBTableView);
var
  i : integer;
begin
  clbColumns.Items.Clear;
  FGridView := aValue;
  for I := 0 to FGridView.ColumnCount - 1 do
  begin
    clbColumns.AddItem(FGridView.Columns[i].Caption,FGridView.Columns[i]);
    clbColumns.Checked[i] := FGridView.Columns[i].Visible;
  end;
end;

end.
