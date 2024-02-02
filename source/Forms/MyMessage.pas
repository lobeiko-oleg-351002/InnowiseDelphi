unit MyMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, acImage, Vcl.StdCtrls,
  Vcl.Buttons, sBitBtn, acPNG, sMemo, MyMessageCls, FormResource;

type
  TfrmMessage = class(TForm)
    img: TsImage;
    mmoMessage: TsMemo;
    imgQuestion: TsImage;
    imgWarning: TsImage;
    imgError: TsImage;
    imgConfirm: TsImage;
    btnOk: TsBitBtn;
    btnCancel: TsBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetProp(MessageStr : string; typeMsg : tMessage; typeButton : tMButton; Caption : string);
  end;

var
  frmMessage: TfrmMessage;

implementation

{$R *.dfm}

procedure TfrmMessage.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmMessage.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmMessage.FormShow(Sender: TObject);
begin
  mmoMessage.Color := frmResource.BackGroundColor;
  mmoMessage.Font.Color := clBlack;//frmResource.FontColor;
  btnOk.SetFocus;
end;

procedure TfrmMessage.SetProp(MessageStr : string; typeMsg : tMessage; typeButton : tMButton; Caption : string);
  begin
    mmoMessage.Lines.Text := MessageStr;
    case typeMsg of
      tConfirm :
        begin
          frmMessage.Caption := 'Done';
          img.Picture.Bitmap.Assign(imgConfirm.Picture.Bitmap);
        end;
      tQuestion :
        begin
          frmMessage.Caption := 'Confirmation';
          img.Picture.Bitmap.Assign(imgQuestion.Picture.Bitmap);
        end;
      tError :
        begin
          frmMessage.Caption := 'Error';
          img.Picture.Bitmap.Assign(imgError.Picture.Bitmap);
        end;
      tWarning :
        begin
          frmMessage.Caption := 'Warning';
          img.Picture.Bitmap.Assign(imgWarning.Picture.Bitmap);
        end;
    end;
    case typeButton of
      tOk :
        begin
          btnCancel.Visible := false;
          btnOk.Left := Round(mmoMessage.Left + (mmoMessage.Width / 2) - (btnOk.Width / 2));
        end;
    end;
    if Caption <> '' then
      frmMessage.Caption := Caption;
  end;

end.
