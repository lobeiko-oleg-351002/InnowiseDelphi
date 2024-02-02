unit FormWait;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sLabel, GifImg,
  Vcl.ExtCtrls, acImage, sMemo;

type
  TfrmWait = class(TForm)
    imgWait: TsImage;
    lblText: TsLabel;
    tmr: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ActivateTimer;
    procedure DeactivateTimer;
  end;

var
  frmWait: TfrmWait;

implementation

uses FormResource;

{$R *.dfm}

procedure TfrmWait.FormCreate(Sender: TObject);
begin
  TransparentColor := True;
  TransparentColorValue := Self.Color;
  imgWait.Picture.Assign(ClsWaitGif.GetGif);
  tmr.Enabled := True;
end;

procedure TfrmWait.FormHide(Sender: TObject);
begin
  tmr.Enabled := False;
end;

procedure TfrmWait.FormShow(Sender: TObject);
begin
  tmr.Enabled := True;
end;

procedure TfrmWait.tmrTimer(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TfrmWait.ActivateTimer;
begin
  tmr.Enabled := True;
end;

procedure TfrmWait.DeactivateTimer;
begin
  tmr.Enabled := False;
end;

end.
