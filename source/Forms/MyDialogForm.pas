unit MyDialogForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, sStatusBar, Vcl.ExtCtrls,
  sPanel, Vcl.StdCtrls, Vcl.Buttons, sBitBtn, WorkWithValueObj, sLabel,
  Vcl.Mask, sMaskEdit, sCustomComboEdit, sCurrEdit, sCurrencyEdit,sEdit,sComboBox,
  sListBox,Vcl.Grids, sToolEdit, sSpinEdit, sCheckBox;

type
  TfrmMyDialog = class(TForm)
    sStatus: TsStatusBar;
    pnlBody: TsPanel;
    btnOk: TsBitBtn;
    btnCancel: TsBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    WorkData : TWorkWithValueObj;
    FocusedObjName : string;
  public
    procedure SetDialogSize(X,Y : Integer);
    function CreateObject(className,objName,Caption:string;Left,Top,
      Width,Height:integer;UserStr:string;Enabled:string):TComponent;
    procedure SetFocus(ObjName:string); reintroduce;
    function GetValueProp(objName,ObjPropName:string) : Variant;
    procedure SetValueProp(objName,ObjPropName:string;value:variant);
    procedure KeyPress(Sender: TObject; var Key: Char); reintroduce;
    procedure ComboBoxChange(Sender: TObject);
    { Public declarations }
  end;

type
  obj = class(TControl);

var
  frmMyDialog: TfrmMyDialog;

implementation

{$R *.dfm}

procedure TfrmMyDialog.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmMyDialog.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmMyDialog.KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    SelectNext(Self.ActiveControl,True,True);
  if '.,'.Contains(Key) then
    Key := FormatSettings.DecimalSeparator;
end;

procedure TfrmMyDialog.ComboBoxChange(Sender: TObject);
begin
    SelectNext(Self.ActiveControl,True,True);
end;

function TfrmMyDialog.CreateObject(className,objName,Caption:string;Left,Top,
  Width,Height:integer;UserStr:string;Enabled:string):TComponent;
var
  control : TControl;
  lbl : TsLabelFX;
begin
  lbl := TsLabelFX.Create(Self);
  lbl.Parent := pnlBody;
  lbl.Caption := Caption;
  lbl.Left := Left;
  lbl.Top := Top;
  lbl.AutoSize := True;
  control := nil;
//  lbl.Name := 'lbl'+objName;
  if className='TsBitBtn' then
    control := TsBitBtn.Create(Self);
  if className='TsCurrencyEdit' then
  begin
    control := TsCurrencyEdit.Create(Self);
    (control as TsCurrencyEdit).OnKeyPress := KeyPress;
    (control as TsCurrencyEdit).DisplayFormat := UserStr;
  end;
  if className='TsComboBox' then
  begin
    control := TsComboBox.Create(Self);
    (control as TsComboBox).OnChange := ComboBoxChange;
    (control as TsComboBox).Text := '';
  end;
  if className='TsEdit' then
  begin
    control := TsEdit.Create(Self);
    (control as TsEdit).OnKeyPress := KeyPress;
  end;
  if className='TsCheckBox' then
  begin
    control := TsCheckBox.Create(Self);
    control.Parent := Self;
    TsCheckBox(control).Caption := Caption;
  end;
  if className='TsDateEdit' then
  begin
    control := TsDateEdit.Create(Self);
  end;
  if className='TsTimePicker' then
  begin
    control := TsTimePicker.Create(Self);
  end;
  if className='TsEditPass' then
  begin
    control := TsEdit.Create(Self);
    (control as TsEdit).PasswordChar := '*';
    (control as TsEdit).OnKeyPress := KeyPress;
  end;
  if className='TsBitBtn' then
  begin
    control := TsBitBtn.Create(Self);
  end;
  if className='TsListBox' then
  begin
    control := TsListBox.Create(Self);
    TsListBox(control).ItemHeight := 25;
  end;
  if className='TStringGrid' then
  begin
    control := TStringGrid.Create(Self);
  end;

  (control as TWinControl).TabOrder := Self.ComponentCount-3;
  if className<>'TsBitBtn' then
    lbl.Visible := true
  else
    begin
       lbl.Visible := false;
      (control as TsBitBtn).Caption := Caption;
    end;
  if className = 'TsCheckBox' then
    lbl.Visible := false;
  if control<>nil then
  begin
    control.Parent := pnlBody;
    WorkData.SetProperty(control,'Name',objName,StrVal);
    if (className<>'TsListBox') and (className<>'TStringGrid') and (className<>'TsCheckBox') then
      begin
        WorkData.SetProperty(control,'Left',lbl.Left+lbl.Width + 10,IntVal);
        WorkData.SetProperty(control,'Top',Top,IntVal);
      end
    else
      begin
        WorkData.SetProperty(control,'Left',Left,IntVal);
        WorkData.SetProperty(control,'Top',Top+lbl.Height + 3,IntVal);
      end;
    WorkData.SetProperty(control,'Width',Width,IntVal);
    WorkData.SetProperty(control,'Height',Height,IntVal);
    WorkData.SetProperty(control,'Caption',Caption,StrVal);
    WorkData.SetProperty(control,'Enabled',Enabled,BoolVal);
  end;
  if className='TsEdit' then
    (control as TsEdit).Text := '';
  Result := control;
end;

procedure TfrmMyDialog.SetDialogSize(X,Y : Integer);
begin
  Self.Width := X;
  Self.Height := Y;
  Self.Left := (Screen.Width div 2) - (Self.Width div 2);
  Self.Top := (Screen.Height div 2) - (Self.Height div 2);
  btnOk.Top := sStatus.Top - (btnOk.Height) - 10;
  btnCancel.Top := btnOk.Top;
  btnOk.Left := (Self.Width div 2)-(btnOk.Width div 2)*2-5;
  btnCancel.Left := btnOk.Left + btnOk.Width + 10;
end;

procedure TfrmMyDialog.SetFocus(ObjName:string);
begin
  FocusedObjName := ObjName;
end;

procedure TfrmMyDialog.FormShow(Sender: TObject);
var
  i:Integer;
begin
  if FocusedObjName='' then exit;
  for I := 0 to Self.ComponentCount - 1 do
    if Self.Components[i].Name=FocusedObjName then
    begin
      if (Self.Components[i] as TWinControl).Enabled then
        (Self.Components[i] as TWinControl).SetFocus;
      Break;
    end;
  btnOk.TabOrder := Self.ComponentCount -2;
  btnCancel.TabOrder := Self.ComponentCount -1;
end;

function TfrmMyDialog.GetValueProp(objName,ObjPropName:string) : Variant;
var
  i:Integer;
begin
  Result := '';
  for I := 0 to Self.ComponentCount - 1 do
    if Self.Components[i].Name=objName then
      begin
        Result := WorkData.GetPropertyValues(ObjPropName,Self.Components[i]);
        Break;
      end;
end;

procedure TfrmMyDialog.SetValueProp(objName,ObjPropName:string;value:variant);
var
  i:Integer;
begin
  for I := 0 to Self.ComponentCount - 1 do
    if Self.Components[i].Name=objName then
      begin
        WorkData.SetProperty(Self.Components[i],ObjPropName,value,StrVal);
        Break;
      end;
end;

end.
