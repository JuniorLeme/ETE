unit FrmClntMdlBiometria;

interface

uses
  System.SysUtils, System.Classes, ClsClientRestBiometria, IPPeerClient,
  Datasnap.DSClientRest;

type
  TClientModule1 = class(TDataModule)
    DSRestConnection1: TDSRestConnection;
  private
    FInstanceOwner: Boolean;
    FoperacaoClient: TOperClientBiometria;
    function GetoperacaoClient: TOperClientBiometria;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property operacaoClient: TOperClientBiometria read GetoperacaoClient
      write FoperacaoClient;
  end;

var
  ClientModule1: TClientModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

constructor TClientModule1.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TClientModule1.Destroy;
begin
  FoperacaoClient.Free;
  inherited;
end;

function TClientModule1.GetoperacaoClient: TOperClientBiometria;
begin
  if FoperacaoClient = nil then
    FoperacaoClient := TOperClientBiometria.Create(DSRestConnection1,
      FInstanceOwner);
  Result := FoperacaoClient;
end;

end.
