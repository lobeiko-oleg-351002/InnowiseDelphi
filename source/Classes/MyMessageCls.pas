unit MyMessageCls;

interface

uses System.UITypes, Vcl.Forms, System.SysUtils;

type tMessage = (tConfirm, tQuestion, tWarning, tError);
type tMButton = (tOk, tBoth);

function ShowMyMessage(MessageStr : string; typeMsg : tMessage   = tConfirm; typeButton : tMButton = tOk; Caption : string = '') : TModalResult;

implementation

uses MyMessage;

function ShowMyMessage(MessageStr : string; typeMsg : tMessage= tConfirm; typeButton : tMButton = tOk; Caption : string = '') : TModalResult;
  begin
//    Result := mrRetry;
    frmMessage := TfrmMessage.Create(Application);
    frmMessage.FormStyle := fsStayOnTop;
    try
      frmMessage.Position := TPosition.poScreenCenter;
      frmMessage.SetProp(MessageStr, typeMsg, typeButton, Caption);
      with frmMessage do
        if ShowModal = mrOk then
          Result := mrOk
        else
          Result := mrCancel;
    finally
      FreeAndNil(frmMessage);
    end;
  end;

end.
