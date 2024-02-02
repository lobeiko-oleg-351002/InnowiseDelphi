unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, sPanel, Vcl.StdCtrls,
  sLabel, sGroupBox, Vcl.Mask, sMaskEdit, sCustomComboEdit, sToolEdit,
  sComboBox, Vcl.Buttons, sBitBtn, sCheckBox,SettingData, sEdit, sCurrEdit,
  sCurrencyEdit,Printers, FormResource;

type
  TfrmSettings = class(TForm)
    sPanel1: TsPanel;
    GridPanel1: TGridPanel;
    BtnSave: TsBitBtn;
    btnCancel: TsBitBtn;
    GridPanel2: TGridPanel;
    GridPanel3: TGridPanel;
    pnlDBConnect: TsPanel;
    sLabelFX3: TsLabelFX;
    sLabelFX4: TsLabelFX;
    sLabelFX5: TsLabelFX;
    edtHost: TsEdit;
    edtDBName: TsEdit;
    lblDBConnect: TsLabel;
    pnlView: TsPanel;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    lblView: TsLabel;
    DirEdit: TsDirectoryEdit;
    cbxSkinName: TsComboBox;
    tsActiveSkin: TsCheckBox;
    pnlPathUpdate: TsPanel;
    edtPort: TsCurrencyEdit;
    procedure DirEditChange(Sender: TObject);
    procedure FindFiles(dir,mask:string; var List:TStringList);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxSkinNameChange(Sender: TObject);
    procedure tsActiveSkinClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtPortKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    ListFiles : TStringList;
    DelListFiles : TStringList;
    procedure OpenFile;
    procedure SetSkinView;
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

//uses PPrint;

uses FormRegister;
{$R *.dfm}

procedure TfrmSettings.OpenFile;
begin
  SettingControl.OpenSettingFile;
  with SettingControl.SettingData do
  begin
    DirEdit.Text := SkinDirectory;
    cbxSkinName.Text := SkinName;
    tsActiveSkin.Checked := Active;
    edtHost.Text := Host;
    edtDBName.Text := DbName;
    edtPort.Text := IntToStr(Port);
  end;
end;

procedure TfrmSettings.FindFiles(dir,mask:string; var List:TStringList);
var
  F: System.SysUtils.TSearchRec;
  Path: string;
  Attr: Integer;
begin
  Path := dir + mask;
{$WARN SYMBOL_PLATFORM OFF}
  Attr := faReadOnly + faArchive;
{$WARN SYMBOL_PLATFORM ON}
  FindFirst(Path, Attr, F);
  if F.name <> '' then
  begin
    List.Add(F.name);
    while FindNext(F) = 0 do
      List.Add(F.name);
  end;
  FindClose(F);
end;

procedure TfrmSettings.SetSkinView;
begin
  pnlDBConnect.Color := frmResource.BackGroundColor;
  lblDBConnect.Color := frmResource.FontColor;
  pnlView.Color := frmResource.BackGroundColor;
  lblView.Color := frmResource.FontColor;
  pnlPathUpdate.Color := frmResource.BackGroundColor;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  ListFiles := TStringList.Create;
  DelListFiles := TStringList.Create;
  SetSkinView;
  OpenFile;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ListFiles);
  FreeAndNil(DelListFiles);
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  frmSettings.Top := Screen.Height div 2 - frmSettings.Height div 2 - 30;
  frmSettings.Left := Screen.Width div 2 - frmSettings.Width div 2;
end;

procedure TfrmSettings.tsActiveSkinClick(Sender: TObject);
begin
  if tsActiveSkin.Checked then
    frmRegister.SkinManager.Active := true
  else
    begin
      frmRegister.SkinManager.Active := False;
    end;
  frmRegister.Refresh;
  try
    self.Refresh;
  except
    ;
  end;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSettings.BtnSaveClick(Sender: TObject);
begin
  with SettingControl.SettingData do
  begin
    SkinDirectory := DirEdit.Text;
    SkinName := cbxSkinName.text;
    Active := tsActiveSkin.Checked;
    Host := edtHost.Text;
    DbName := edtDBName.Text;
    if edtPort.Text <> '' then
      Port := StrToInt(edtPort.Text)
    else
      Port := 0;
  end;
  SettingControl.SaveSettingFile;
  Close;
end;

procedure TfrmSettings.cbxSkinNameChange(Sender: TObject);
begin
  if cbxSkinName.ItemIndex <> -1 then
    begin
      frmRegister.SkinManager.SkinDirectory := DirEdit.Text;
      frmRegister.SkinManager.SkinName := cbxSkinName.Items[cbxSkinName.ItemIndex];

      frmResource.BackGroundColor := Self.Canvas.Pixels[10,10];
      frmResource.FontColor := lblDBConnect.Canvas.Pixels[11,11];
      SetSkinView;
//      DeletePostImageSkin;
    end;
end;

procedure TfrmSettings.DirEditChange(Sender: TObject);
var
  skName:string;
begin
  if cbxSkinName.Text<>'' then
    skName := cbxSkinName.Text;
  cbxSkinName.Clear;
  ListFiles.Clear;
  FindFiles(DirEdit.Text,'\*.asz',ListFiles);
  if ListFiles.Count <> 0 then
    cbxSkinName.Items := ListFiles;
  cbxSkinName.Text := skName;
end;

procedure TfrmSettings.edtPortKeyPress(Sender: TObject; var Key: Char);
begin
  if '012345670#8#9'.Contains(Key) then
//  if not (key in ['0'..'9',#8]) then
    Key := #0;
end;

end.
