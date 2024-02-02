program Test;

uses
  Vcl.Forms,
  FormRegister in 'Forms\FormRegister.pas' {frmRegister},
  Settings in 'Forms\Settings.pas' {frmSettings},
  SettingData in 'Classes\SettingData.pas',
  FormResource in 'Forms\FormResource.pas' {frmResource},
  CofigINICls in 'Classes\CofigINICls.pas',
  FormWait in 'Forms\FormWait.pas' {frmWait},
  DBWork in 'Classes\DBWork.pas',
  DBWorkSQL in 'Classes\DBWorkSQL.pas',
  MyMessageCls in 'Classes\MyMessageCls.pas',
  MyMessage in 'Forms\MyMessage.pas' {frmMessage},
  MyDialogForm in 'Forms\MyDialogForm.pas' {frmMyDialog},
  WorkWithValueObj in 'Classes\WorkWithValueObj.pas',
  CxGridUnit in 'Classes\CxGridUnit.pas',
  FormMenu in 'Forms\FormMenu.pas' {frmMenu},
  FormGridBase in 'Forms\FormGridBase.pas' {frmBase},
  FormColumnsGridEdit in 'Forms\FormColumnsGridEdit.pas' {frmColumnsGridEdit},
  FormDirectorys in 'Forms\FormDirectorys.pas' {frmDirectorys},
  FormUserRights in 'Forms\FormUserRights.pas' {frmUserRights},
  FormBalances in 'Forms\FormBalances.pas' {frmBalances},
  FormUpperLimit in 'Forms\FormUpperLimit.pas' {frmUpperLimit},
  FormOrders in 'Forms\FormOrders.pas' {frmOrders},
  FormOrderEdit in 'Forms\FormOrderEdit.pas' {frmOrderEdit},
  Reports in 'Classes\Reports.pas';

{frmUpperLimit}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmResource, frmResource);
  Application.Run;
end.
