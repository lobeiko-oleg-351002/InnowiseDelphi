unit SettingData;

interface

uses System.SysUtils,Vcl.Forms, FormResource;

type
  TSettingData=record
    Host          : string;
    DbName        : string;
    Port          : Integer;
    SkinDirectory : string;
    TemplDir      : string;
    TimeOut       : real;
    ImageDirectory : string;
    WCom          : string;
    SkinName      : string;
    Active        : Boolean;
    PrinterName   : string;
    PrinterName2  : string;
    ArchivePath   : string;
    DirUpdate : string;
    LastLogin : string;
  end;

type
  TSettings = class(TObject)
    private

    public
      SettingData : TSettingData;
      procedure SaveSettingFile;
      procedure OpenSettingFile;
  end;

var SettingControl : TSettings;
    login : string;
    vers : string = '1.1.8';

implementation

procedure TSettings.SaveSettingFile;
begin
  with ConfigINIcls do
  begin
    WriteValue('PATH','Skins',SettingControl.SettingData.SkinDirectory);
    WriteValue('PATH','Archive',SettingControl.SettingData.ArchivePath);
    WriteValue('PATH','Template',SettingControl.SettingData.TemplDir);
    WriteValue('PATH','DirUpdate',SettingControl.SettingData.DirUpdate);
    WriteValue('SKIN','Name',SettingControl.SettingData.SkinName);
    WriteValue('SKIN','Active',SettingControl.SettingData.Active);
    WriteValue('PATH','Images',SettingControl.SettingData.ImageDirectory);
    WriteValue('DATABASE','Host',SettingControl.SettingData.Host);
    WriteValue('DATABASE','Name',SettingControl.SettingData.DbName);
    WriteValue('DATABASE','Port',SettingControl.SettingData.Port);
    WriteValue('LOGIN','LASTLOGIN',SettingControl.SettingData.LastLogin);
  end;
end;

procedure TSettings.OpenSettingFile;
begin
  with ConfigINIcls do
  begin
    ReadValue('PATH','Images','',SettingControl.SettingData.ImageDirectory);
    ReadValue('PATH','Skins','',SettingControl.SettingData.SkinDirectory);
    ReadValue('PATH','Archive','',SettingControl.SettingData.ArchivePath);
    ReadValue('PATH','Template','',SettingControl.SettingData.TemplDir);
    ReadValue('PATH','DirUpdate','',SettingControl.SettingData.DirUpdate);
    ReadValue('SKIN','Name','',SettingControl.SettingData.SkinName);
    if SettingControl.SettingData.SkinName='Android OS.asz' then
    begin
      SettingControl.SettingData.SkinName := 'Black Box.asz';
      DeleteFile(SettingControl.SettingData.SkinDirectory + '\Android OS.asz');
    end;
    ReadValue('SKIN','Active',false,SettingControl.SettingData.Active);
    ReadValue('DATABASE','Host','',SettingControl.SettingData.Host);
    ReadValue('DATABASE','Name','',SettingControl.SettingData.DbName);
    ReadValue('DATABASE','Port',0,SettingControl.SettingData.Port);
    ReadValue('LOGIN','LASTLOGIN','',SettingControl.SettingData.LastLogin);
  end;
end;

end.
