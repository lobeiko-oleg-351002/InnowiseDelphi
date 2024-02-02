unit WorkWithValueObj;

interface

uses System.SysUtils, Winapi.Windows,StdCtrls,System.TypInfo,Classes;

type
  TTypeProp = (StrVal,IntVal,BoolVal);

type
  TWorkWithValueObj = class(TObject)
    private
      function GetProperty(AControl:TObject;AProperty:string): PPropInfo;
    public
      function GetPropertyValues(PropName : string; TObj : TObject) : string;
      procedure SetProperty(Sender: TObject; PropName:string;Value:variant;TypeProp:TTypeProp);
  end;

implementation

function TWorkWithValueObj.GetPropertyValues(PropName : string; TObj : TObject) : string;
var
  propInfo: pPropInfo;
  ClassProp: tObject;
begin
  Result := '';
  propinfo := getPropInfo(TObj, PropName, []);
  case propinfo^.proptype^.Kind of
    tkInteger:
      Result := intToStr(GetOrdProp(TObj, PropInfo));
    tkChar:
      Result := char(GetOrdProp(TObj, PropInfo));
    tkEnumeration:
      if PropInfo^.PropType^ = TypeInfo(boolean) then
        Result := GetEnumProp(TObj, PropInfo)
      else
        Result := GetEnumProp(TObj, PropInfo);
    tkFloat:
      if PropInfo^.PropType^ = TypeInfo(TDateTime) then
        Result := DateTimeToStr(GetFloatProp(TObj, PropInfo))
      else
        if PropInfo^.PropType^ = TypeInfo(TTime) then
          Result := TimeToStr(GetFloatProp(TObj, PropInfo))
        else
          if PropInfo^.PropType^ = TypeInfo(TDate) then
            Result := DateToStr(GetFloatProp(TObj, PropInfo))
          else
            Result := FloatToStr(GetFloatProp(TObj, PropInfo));
    tkUString:
      Result := GetStrProp(TObj, PropInfo);
    tkLString:
      Result := GetStrProp(TObj, PropInfo);
    tkWString:
      Result := GetStrProp(TObj, PropInfo);
    tkSet:
      Result := GetSetProp(TObj, PropInfo);
    tkInt64:
      Result := intToStr(GetInt64Prop(TObj, PropInfo));
    tkClass:
      begin
        ClassProp := GetObjectProp(TObj, PropName);
        result := tPersistent(ClassProp).ClassName;
      end;
  end;
end;

function TWorkWithValueObj.GetProperty(AControl:TObject;AProperty:string):PPropInfo;
var
  i: Integer;
  props: PPropList;
  typeData: PTypeData;
begin
  Result := nil;
  if (AControl = nil) or (AControl.ClassInfo = nil) then
    Exit;
  typeData := GetTypeData(AControl.ClassInfo);
  if (typeData = nil) or (typeData^.PropCount = 0) then
    Exit;
  GetMem(props, typeData^.PropCount * SizeOf(Pointer));
  try
    GetPropInfos(AControl.ClassInfo, props);
    for i := 0 to typeData^.PropCount - 1 do
    begin
      with Props^[i]^ do
        if (String(Name) = AProperty) then
          begin
            result := Props^[i];
            Exit;
          end;
    end;
  finally
    FreeMem(props);
  end;
end;

procedure TWorkWithValueObj.SetProperty(Sender:TObject;PropName:string;Value:variant;TypeProp:TTypeProp);
var
  propInfo: PPropInfo;
begin
  PropInfo := GetProperty(Sender,PropName);
  if PropInfo = nil then
    Exit;
  case TypeProp of
    IntVal: SetOrdProp(Sender,PropName,Value);
    StrVal: SetStrProp(Sender,PropName,Value);
    BoolVal: SetEnumProp(Sender,PropName,Value);
  end;

end;

end.
