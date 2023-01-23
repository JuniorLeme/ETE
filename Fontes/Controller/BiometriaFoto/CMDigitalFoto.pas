unit CMDigitalFoto;

interface

uses
  System.SysUtils, System.Classes, ClsDigitalFoto, IPPeerClient, Datasnap.DSClientRest ;

type
  TClientModule2 = class(TDataModule)
    DSRestConnection1: TDSRestConnection;
  private
    FInstanceOwner: Boolean;
    FoperacaoClient: operacaoClient;
    function GetoperacaoClient: operacaoClient;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property operacaoClient: operacaoClient read GetoperacaoClient write FoperacaoClient;

end;

var
  ClientModule2: TClientModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TClientModule2.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TClientModule2.Destroy;
begin
  FoperacaoClient.Free;
  inherited;
end;

function TClientModule2.GetoperacaoClient: operacaoClient;
begin
  if FoperacaoClient = nil then
    FoperacaoClient:= operacaoClient.Create(DSRestConnection1, FInstanceOwner);
  Result := FoperacaoClient;
end;

end.
