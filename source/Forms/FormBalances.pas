unit FormBalances;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormGridBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, Vcl.Menus,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Mask, sMaskEdit,
  sCustomComboEdit, sToolEdit, sLabel, Vcl.Buttons, sSpeedButton, Vcl.ExtCtrls,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, DBWork,
  cxGridTableView, cxGridDBTableView, cxGrid, sComboBox, FormResource,
  CxGridUnit, DateUtils;

type
  TfrmBalances = class(TfrmBase)
    sLabel1: TsLabel;
    cbAccounts: TsComboBox;
    procedure FormShow(Sender: TObject); override;
    procedure FormCreate(Sender: TObject);
    procedure actSetFilterExecute(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    GrdBallance : TFillGridFromBase;
  public
    { Public declarations }
  end;

var
  frmBalances: TfrmBalances;

implementation

{$R *.dfm}

procedure TfrmBalances.actSetFilterExecute(Sender: TObject);
begin
  if cbAccounts.ItemIndex = -1 then Exit;
  if StrToInt(TcbObj(cbAccounts.Items.Objects[cbAccounts.ItemIndex]).tag) <> baseGridView.Tag then
  begin
    if (GrdBallance <> nil) then FreeAndNil(GrdBallance);
  end;
  baseGridView.Tag := StrToInt(TcbObj(cbAccounts.Items.Objects[cbAccounts.ItemIndex]).tag);
  if Assigned(GrdBallance) then
    GrdBallance.ChangeParametersAndReopen
      (
        [
          TQryParamValue.Create(baseGridView.Tag,'pDateFrom',StartOfTheDay(DateBeg.Date),tpDate),
          TQryParamValue.Create(baseGridView.Tag,'pDateTo',EndOfTheDay(DateTo.Date),tpDate)
        ]
      )
  else
    GrdBallance := TFillGridFromBase.Create
      (
        baseGrid,
        [
          TQryParamValue.Create(baseGridView.Tag,'pDateFrom',StartOfTheDay(DateBeg.Date),tpDate),
          TQryParamValue.Create(baseGridView.Tag,'pDateTo',EndOfTheDay(DateTo.Date),tpDate)
        ]
      );
end;

procedure TfrmBalances.FormCreate(Sender: TObject);
begin
  inherited;
  pPDB.FillItemsFromDB(cbAccounts.Items, cbAccounts.Tag, []);
end;

procedure TfrmBalances.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(GrdBallance) then
    FreeAndNil(GrdBallance);
end;

procedure TfrmBalances.FormShow(Sender: TObject);
begin
  cbAccounts.Color := frmResource.BackGroundColor;
  cbAccounts.Font.Color := frmResource.FontColor;
end;

end.
