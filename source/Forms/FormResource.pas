unit FormResource;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.Menus,
  cxEdit, cxEditRepositoryItems, cxClasses, CofigINICls, GifImg, FormWait,
  cxStyles, System.Generics.Collections, dxTileControl,dxCustomTileControl,
  sPageControl;

type
  TTypeView = (tvInset,tvEdit);

type
  TBoxSelectedData = record
    vRackN  : string;
    vLineN  : SmallInt;
    vBoxN   : SmallInt;
    vBoxId  : Integer;
  end;

type
  TField = class(TObject)
      pn        : Integer;
      pnm       : string;
      pv        : Boolean;
      pperwidth : SmallInt;
    public
      constructor create(nn:Integer;name:string;visbl:boolean;perwidth:SmallInt);
      destructor Destroy;override;
  end;

type
  TAgentData = class
    OPF : smallint;
    name : string;
    UNN : string;
    Address : string;
    AddressPost : string;
    Account : string;
    Bank : smallint;
    BIC : string;
    Phone : string;
    Fax : string;
    Mobile : string;
    Email : string;
  end;

type
  TVisibles = (tvAll,tvViews,tvBoxTask);
  TVisiblesList = class(TList<TVisibles>);

type
  TNotesOrder = class
    vViewsNote : string;
    vBoxNote : string;
  end;

type
  TMovedNomenclaure = class
    vBoxId : Integer;
    vNowId : Integer;
    vNomType : SmallInt;
    vCount : Real;
    public
      constructor Create(pBoxId,pNowId,pNomType : Integer; pCount : Real);
  end;
  TMovedNomenclaureList = TList<TMovedNomenclaure>;

type
  TcbObj = class(TObject)
    tag : string;
    constructor Create(s:string);
    destructor Destroy;override;
  end;

type tTypeParam = (tpNone,tpString,tpInteger,tpFloat,tpDate,tpTime,tpComboBox,tpCheckBox,tpButtonEdit,tpPassword);

type
  TQryParamValue = class
  private
    FTagView : SmallInt;
    FParamName : string;
    FParamValue : Variant;
    FParamType  : tTypeParam;
    FCanEditField : boolean;
    FReplace : Boolean;
  public
    property vTagView : SmallInt read FTagView write FTagView;
    property vParamName : string read FParamName write FParamName;
    property vParamValue : Variant read FParamValue write FParamValue;
    property vParamType : tTypeParam read FParamType write FParamType;
    property vCanEditField : boolean read FCanEditField write FCanEditField;
    property vReplace : boolean read FReplace write FReplace;
    constructor Create(pTagView:SmallInt;pParamName:string;pParamValue:Variant;pParamType:tTypeParam;pCanEditField:boolean = FALSE;pReplace:boolean = FALSE);
end;

type TTreeItemsId = class
  public
    ListItems : TList;
    constructor Create(pItemsIds : array of integer);
    destructor Destroy; override;
end;

type
  TMenuItems = class
//    private
      ItemsTree : TTreeItemsId;
      Item : TMenuItem;
    public
      constructor Create(pItemCaption:String;pItemTag:integer;pItemsTree:array of integer;pOnClick : TNotifyEvent);
      destructor Destroy; override;
  end;

type TEventText = class
  Caption : string;
  Msg     : string;
end;

type TClientLicences = class(TObject)
  private
    FIdLicence:string;
    FDateActivate : string;
    FDateLicence:string;
  public
    property IdLicence : string read FIdLicence write FIdLicence;
    property DateActivate : string read FDateActivate write FDateActivate;
    property DateLicence : string read FDateLicence write FDateLicence;
    constructor Create(pIdLicence:string;pDateActivate,pDaleLicence:string);
    destructor Destroy;override;
end;

type
  TclsFilterTemplateStr = class
      id : Integer;
      typeParam : smallint;
      param : string;
      value : string;
    public
      constructor Create(pId:integer;pTypeParam:smallint;pParam,pValue:string);
  end;

type TclsClient = class
    num       : SmallInt;
    clientId  : Integer;
    abonID    : Integer;
    sertID    : Integer;
  public
    constructor Create(pNum:SmallInt;pclientId,pabonID,psertID:Integer);
end;

type
  TclsTemplateItem = class
      idTempl : Integer;
      nameTempl : string;
      general : Boolean;
      params : TList;      // TclsFilterTemplateStr
    public
      constructor Create(pIdTempl:integer;pNameTempl:string;pGeneral:Boolean);
      destructor Destroy; override;
  end;

type
  TfrmResource = class(TForm)
    imgList30_30: TImageList;
    cxEditRep: TcxEditRepository;
    cxEditRepPassword: TcxEditRepositoryTextItem;
    cxStyleRepository1: TcxStyleRepository;
    cxstylClientLicenceGrid: TcxStyle;
    cxstylGridBack: TcxStyle;
    cxStyleSelectedGrid: TcxStyle;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SetColorGrid;
  private
    { Private declarations }
  public
    { Public declarations }
    BackGroundColor : Integer;
    FontColor : Integer;
//    clsLicence : TDllLicenceKey;
  end;

type
  TGifWait = class
    private
      Gif: TGifImage;
    public
      function GetGif : TGifImage;
      constructor Create(pFileName : string);
      destructor Destroy; override;
  end;

type tTypeUpack = (tuRolls,tuPlate);

type
  TRoll = class(TObject)
    mItem   : TdxTileControlItem;
    mFrame: TdxTileControlItemFrame;
    Rolln   : SmallInt;
    PrRolln : SmallInt;
    Rollid  : Integer;
    Product : integer;
    Brutto  : Real;
    Sleeve  : Real;
    KolLbl  : Integer;
    Creator : string;
    DateCreate : TDateTime;
    pallet  : SmallInt;
    crNum   : Integer;
    vType   : tTypeUpack;
    constructor create(vRolln,vPrRolln:SmallInt;vRollid,vProduct,vKolLbl:Integer;
                vBrutto,vSleeve:Real;vCreator:string;vDateCreate:TDateTime;vPallet:Smallint;vcrNum:integer;pType:tTypeUpack);
    destructor Destroy;override;
end;

  TOrder=record
    NOrder  : Integer;
    OrderType : Integer;
    name    : string;
    partner : string;
    typeupack : tTypeUpack;
  end;

var
  frmResource: TfrmResource;
  ConfigINIcls : TCofigINICls;
  ClsWaitGif : TGifWait;
  Order : TOrder;

const Version = '1.0.0';


procedure WaitCursor;
procedure SetTextWaitCursor(pText : string);
procedure UnWaitCursor;

implementation

{$R *.dfm}

constructor TRoll.create(vRolln,vPrRolln:SmallInt;vRollid,vProduct,vKolLbl:Integer;
            vBrutto,vSleeve:Real;vCreator:string;vDateCreate:TDateTime;vPallet:Smallint;vcrNum:integer;pType:tTypeUpack);
begin
  Rolln := vRolln;
  PrRolln := vPrRolln;
  Rollid := vRollid;
  Product := vProduct;
  Brutto := vBrutto;
  Sleeve := vSleeve;
  KolLbl := vKolLbl;
  Creator := vCreator;
  DateCreate := vDateCreate;
  pallet := VPallet;
  crNum := vcrNum;
  vType := pType;
end;

destructor TRoll.Destroy;
begin
  inherited Destroy;
end;

constructor TMovedNomenclaure.Create(pBoxId,pNowId,pNomType : Integer; pCount : Real);
begin
  vBoxId := pBoxId;
  vNowId := pNowId;
  vNomType := pNomType;
  vCount := pCount;
end;

procedure WaitCursor;
begin
  if frmWait = nil then
    frmWait := TfrmWait.Create(Application);
  frmWait.Show;
end;

procedure UnWaitCursor;
begin
  if frmWait <> nil then
    frmWait.Hide;
end;

procedure SetTextWaitCursor(pText : string);
begin
  frmWait.lblText.Caption := pText;
end;


{$region 'Methods TClientLicenses'}
constructor TClientLicences.Create(pIdLicence:string;pDateActivate,pDaleLicence:string);
begin
  IdLicence := pIdLicence;
  DateActivate := pDateActivate;
  DateLicence := pDaleLicence;
end;

destructor TClientLicences.Destroy;
begin

end;
{$endregion}

constructor TGifWait.Create(pFileName : string);
begin
  Gif := TGifImage.Create;
  Gif.LoadFromFile(pFileName);
  Gif.Animate := True;
  Gif.AnimateLoop := glEnabled;
end;

destructor TGifWait.Destroy;
begin
  FreeAndNil(Gif);
end;

function TGifWait.GetGif : TGifImage;
begin
  Result := Gif;
end;

constructor TMenuItems.Create(pItemCaption:String;pItemTag:integer;pItemsTree:array of integer; pOnClick : TNotifyEvent);
begin
  Item := TMenuItem.Create(nil);
  Item.Caption := pItemCaption;
  Item.Tag := pItemTag;
  Item.OnClick := pOnClick;
  ItemsTree := TTreeItemsId.Create(pItemsTree);
end;

destructor TMenuItems.Destroy;
begin
  FreeAndNil(ItemsTree);
  FreeAndNil(Item);
end;

constructor TclsClient.Create(pNum:SmallInt;pclientId,pabonID,psertID:Integer);
begin
  num := pNum;
  clientId := pclientId;
  abonID := pabonID;
  sertID := psertID;
end;

constructor TcbObj.Create(s:string);
begin
  tag := s;
end;

destructor TcbObj.Destroy;
begin

end;

constructor TTreeItemsId.Create(pItemsIds : array of integer);
var
  i : Integer;
begin
  ListItems := TList.Create;
  for I := 0 to Length(pItemsIds) - 1 do
    ListItems.Add(TcbObj.Create(IntToStr(pItemsIds[i])));
end;

destructor TTreeItemsId.Destroy;
begin
  while ListItems.Count > 0 do
  begin
    TcbObj(ListItems[0]).Destroy;
    ListItems.Delete(0);
  end;
  FreeAndNil(ListItems);
end;

constructor TclsFilterTemplateStr.Create(pId:integer;pTypeParam:smallint;pParam,pValue:string);
begin
  id := pId;
  typeParam := pTypeParam;
  param := pParam;
  value := pValue;
end;

constructor TclsTemplateItem.Create(pIdTempl:integer;pNameTempl:string;pGeneral:Boolean);
begin
  idTempl := pIdTempl;
  nameTempl := pNameTempl;
  general := pGeneral;
  params := TList.Create;
end;

destructor TclsTemplateItem.Destroy;
begin
  while params.Count > 0 do
  begin
    TclsFilterTemplateStr(params[0]).Destroy;
    params.Delete(0);
  end;
  FreeAndNil(params);
end;

procedure TfrmResource.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmResource.SetColorGrid;
begin
  cxstylGridBack.Font.Color := FontColor;
  cxstylGridBack.Color := BackGroundColor;

  cxStyleSelectedGrid.Font.Color := FontColor;
  cxStyleSelectedGrid.TextColor := FontColor;
  cxStyleSelectedGrid.Color := BackGroundColor;;
end;

procedure TfrmResource.FormCreate(Sender: TObject);
begin
  ClsWaitGif := TGifWait.Create(ExtractFilePath(Application.ExeName)+'\files\'+'WAIT.gif');

//  clsLicence := TDllLicenceKey.Create('Licence.dll');
end;

procedure TfrmResource.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ClsWaitGif);
//  FreeAndNil(clsLicence);
end;

constructor TQryParamValue.Create(pTagView:SmallInt;pParamName:string;pParamValue:Variant;pParamType:tTypeParam;pCanEditField:boolean = FALSE;pReplace:boolean = FALSE);
begin
  vTagView := pTagView;
  vParamName := pParamName;
  vParamValue := pParamValue;
  vParamType := pParamType;
  vCanEditField := pCanEditField;
  vReplace := pReplace;
  case pParamType of
    tpCheckBox:
    begin
      if vParamValue = Null then
        vParamValue := False;
    end;
  end;
end;

constructor TField.create(nn:Integer;name:string;visbl:boolean;perwidth:SmallInt);
begin
   inherited create;
   pn := nn;
   pnm := name;
   pv := visbl;
   pperwidth := perwidth;
end;

destructor TField.Destroy;
begin
   inherited Destroy;
end;

end.
