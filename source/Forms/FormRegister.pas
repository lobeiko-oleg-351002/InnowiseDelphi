unit FormRegister;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, System.ImageList,
  Vcl.ImgList, Vcl.StdCtrls, Vcl.Buttons, sBitBtn, sLabel, Data.Win.ADODB,
  Vcl.ExtCtrls, Settings, SettingData, DBWork, MyMessageCls, FormMenu, DBWorkSQL,
  FormResource, Uni, WinSock, VCLTee.TeCanvas, cxGraphics, Winapi.ShellAPI,
  cxControls, Vcl.ComCtrls, sComboBoxes, sPanel, CofigINICls, sEdit, acPNG,
  SQLServerUniProvider, Data.DB, DBAccess;

type
  TfrmRegister = class(TForm)
    Image1: TImage;
    btnViewPass: TsBitBtn;
    btnAddUser: TsBitBtn;
    btnSetting: TsBitBtn;
    btnOk: TsBitBtn;
    btnCancel: TsBitBtn;
    SkinManager: TsSkinManager;
    edtLogin: TsEdit;
    edtPassword: TsEdit;
    lblLogin: TsLabel;
    sLabel2: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure btnSettingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnViewPassClick(Sender: TObject);
    procedure edtLoginKeyPress(Sender: TObject; var Key: Char);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure edtLoginClick(Sender: TObject);
  private
    { Private declarations }
    function GetLocalIP: pAnsiChar;
  public
    { Public declarations }
  end;

var
  frmRegister: TfrmRegister;

implementation

{$R *.dfm}

function TfrmRegister.GetLocalIP: pAnsiChar;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then
  begin
    if GetHostName(@Buf, 128) = 0 then
      begin
        P := GetHostByName(@Buf);
        if P <> nil then
          Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
      end;
    WSACleanup;
  end;
end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

procedure TfrmRegister.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRegister.btnOkClick(Sender: TObject);
var
  Q : TADOQuery;
begin
  frmResource.BackGroundColor := Self.Canvas.Pixels[150,10];
  frmResource.FontColor := lblLogin.Canvas.Pixels[11,11];
  frmResource.SetColorGrid;
  pPDB := TDB.create;
  try
    if not pPDB.OpenConnect(edtLogin.Text,edtPassword.Text) then
    begin
      ShowMyMessage('Cannot open connect!',tError,tOk);
      edtPassword.SetFocus;
      edtPassword.SelectAll;
      Exit;
    end;
    pPDB.Password := edtPassword.Text;
    pPDB.SetActiveIP(String(GetLocalIP));
    pPDB.SetComputerName(GetComputerNetName);
    Q := pPDB.CreateQuerry;
    try
      if pPDB.GetVersion(Q) <> Version then
      begin
        ShowMyMessage('New version of the program is available! The update will be performed!',tWarning,tOK);
        CopyFile(pchar(SettingControl.SettingData.DirUpdate+'\Updater.exe'), 'Updater.exe', False);
        ShellExecute(Handle,'open',pchar('Updater.exe'),
          pchar(ExtractFilePath((Application.ExeName))+';'+SettingControl.SettingData.DirUpdate+'\' + '|'
            +ExtractFileName(Application.ExeName)),nil,SW_HIDE);
        Close;
        exit;
      end;
      if not pPDB.StartProcedure(Q,edtLogin.Text,pPDB.GUID,pPDB.GetActiveIP,pPDB.GetComputerName) then
      begin
        ShowMyMessage('Failed to initialize the program!!',tError,tOk);
        Close;
      end;
    finally
      FreeAndNil(Q);
    end;
    SettingControl.SettingData.LastLogin := edtLogin.Text;
    SettingControl.SaveSettingFile;
    frmMenu := TfrmMenu.Create(Application);
    try
      frmMenu.ShowModal;
    finally
      FreeAndNil(frmMenu);
      Close;
    end;
  finally
    FreeAndNil(pPDB);
  end;
end;

procedure TfrmRegister.btnSettingClick(Sender: TObject);
begin
  frmResource.BackGroundColor := Self.Canvas.Pixels[150,10];
  frmResource.FontColor := lblLogin.Canvas.Pixels[11,11];
  frmSettings := TfrmSettings.Create(nil);
  with frmSettings do
  try
    ShowModal;
  finally
    FreeAndNil(frmSettings);
  end;
end;

procedure TfrmRegister.btnViewPassClick(Sender: TObject);
begin
  if btnViewPass.ImageIndex = 1 then
  begin
    btnViewPass.ImageIndex := 0;
    edtPassword.PasswordChar := #0;
  end
  else
  begin
    btnViewPass.ImageIndex := 1;
    edtPassword.PasswordChar := '*';
  end;
end;

procedure TfrmRegister.edtLoginClick(Sender: TObject);
begin
  (Sender as TsEdit).SelectAll;
end;

procedure TfrmRegister.edtLoginKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (edtLogin.Text <> '') then
  begin
    edtPassword.SetFocus;
    edtLogin.SelectAll;
  end;
end;

procedure TfrmRegister.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (edtPassword.Text <> '') then
  begin
    btnOk.SetFocus;
  end;
end;

procedure TfrmRegister.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRegister.FormCreate(Sender: TObject);
begin
  ConfigINIcls := TCofigINICls.Create(ExtractFilePath(Application.ExeName)+'configure.ini');
  SettingControl := TSettings.Create;
  SettingControl.OpenSettingFile;
  SkinManager.SkinDirectory := SettingControl.SettingData.SkinDirectory;
  SkinManager.SkinName := SettingControl.SettingData.SkinName;
  SkinManager.Active := SettingControl.SettingData.Active;
end;

procedure TfrmRegister.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ConfigINIcls);
end;

procedure TfrmRegister.FormShow(Sender: TObject);
begin
  frmRegister.Top := Screen.Height div 2 - frmRegister.Height div 2 - 30;
  frmRegister.Left := Screen.Width div 2 - frmRegister.Width div 2;
  edtLogin.Text := SettingControl.SettingData.LastLogin;
  if edtLogin.Text <> '' then
  begin
    edtPassword.SetFocus;
  end
  else
    edtLogin.SetFocus;
end;

end.
