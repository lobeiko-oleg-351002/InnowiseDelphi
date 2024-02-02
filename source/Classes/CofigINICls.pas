unit CofigINICls;

interface

uses System.SysUtils,Vcl.Forms,IniFiles;

type TCofigINICls = class
  private
    IniFile : TIniFile;
  public
    procedure WriteValue(const pSection,pValueName : string; const pValue : String);  overload;
    procedure WriteValue(const pSection,pValueName : string; const pValue : Boolean); overload;
    procedure WriteValue(const pSection,pValueName : string; const pValue : Integer); overload;
    procedure WriteValue(const pSection,pValueName : string; const pValue : TDateTime); overload;
    procedure WriteValue(const pSection,pValueName : string; const pValue : TDate); overload;
    procedure WriteValue(const pSection,pValueName : string; const pValue : Real); overload;
    procedure ReadValue(const pSection,pValueName,pDefault : string; var Value : string);overload;
    procedure ReadValue(const pSection,pValueName : string; pDefault : Boolean; var Value : boolean);overload;
    procedure ReadValue(const pSection,pValueName : string; pDefault : Integer; var Value : integer);overload;
    procedure ReadValue(const pSection,pValueName : string; pDefault : TDateTime; var Value : TDateTime);overload;
    procedure ReadValue(const pSection,pValueName : string; pDefault : TDate; var Value : TDate);overload;
    procedure ReadValue(const pSection,pValueName : string; pDefault : Real; var Value : Real);overload;
    procedure DeleteValue(const pSection,pValueName : string);
    procedure DeleteSection(const pSection : string);
    constructor Create(pFileName : string);
    destructor Destroy; override;
end;

implementation

constructor TCofigINICls.Create(pFileName : string);
begin
  IniFile:=TIniFile.Create(pFileName);
end;

destructor TCofigINICls.Destroy;
begin
  FreeAndNil(IniFile);
end;

procedure TCofigINICls.DeleteValue(const pSection,pValueName : string);
begin
  IniFile.DeleteKey(pSection, pValueName);
end;

procedure TCofigINICls.DeleteSection(const pSection : string);
begin
  IniFile.EraseSection(pSection);
end;

procedure TCofigINICls.WriteValue(const pSection,pValueName : string; const pValue : String);
begin
  IniFile.WriteString(pSection,pValueName,pValue);
end;

procedure TCofigINICls.WriteValue(const pSection,pValueName : string;const pValue : Boolean);
begin
  IniFile.WriteBool(pSection,pValueName,pValue);
end;

procedure TCofigINICls.WriteValue(const pSection,pValueName : string;const pValue : Integer);
begin
  IniFile.WriteInteger(pSection,pValueName,pValue);
end;

procedure TCofigINICls.WriteValue(const pSection,pValueName : string;const pValue : TDateTime);
begin
  IniFile.WriteDateTime(pSection,pValueName,pValue);
end;

procedure TCofigINICls.WriteValue(const pSection,pValueName : string;const pValue : TDate);
begin
  IniFile.WriteDate(pSection,pValueName,pValue);
end;

procedure TCofigINICls.WriteValue(const pSection,pValueName : string;const pValue : Real);
begin
  IniFile.WriteFloat(pSection,pValueName,pValue);
end;

procedure TCofigINICls.ReadValue(const pSection,pValueName,pDefault : string; var Value : string);
begin
  Value := IniFile.ReadString(pSection,pValueName,pDefault);
end;

procedure TCofigINICls.ReadValue(const pSection,pValueName : string; pDefault : Boolean; var Value : boolean);
begin
  Value := IniFile.ReadBool(pSection,pValueName,pDefault);
end;

procedure TCofigINICls.ReadValue(const pSection,pValueName : string; pDefault : Integer; var Value : integer);
begin
  Value := IniFile.ReadInteger(pSection,pValueName,pDefault);
end;

procedure TCofigINICls.ReadValue(const pSection,pValueName : string; pDefault : TDateTime; var Value : TDateTime);
begin
  Value := IniFile.ReadDateTime(pSection,pValueName,pDefault);
end;

procedure TCofigINICls.ReadValue(const pSection,pValueName : string; pDefault : TDate; var Value : TDate);
begin
  Value := IniFile.ReadDate(pSection,pValueName,pDefault);
end;

procedure TCofigINICls.ReadValue(const pSection,pValueName : string; pDefault : Real; var Value : Real);
begin
  Value := IniFile.ReadFloat(pSection,pValueName,pDefault);
end;

end.
