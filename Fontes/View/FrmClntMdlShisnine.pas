unit FrmClntMdlShisnine;

interface

uses
  System.SysUtils, System.Classes, ClsClientRestShisnine, IPPeerClient,
  Datasnap.DSClientRest;

type
  TClientModule2 = class(TDataModule)
    DSRestConnection1: TDSRestConnection;
  private
    FInstanceOwner: Boolean;
    FOperacoesClient: TOperClientShisnine;
    function GetOperacoesClient: TOperClientShisnine;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property OperacoesClient: TOperClientShisnine read GetOperacoesClient write FOperacoesClient;

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
  FOperacoesClient.Free;
  inherited;
end;

function TClientModule2.GetOperacoesClient: TOperClientShisnine;
begin
  if FOperacoesClient = nil then
    FOperacoesClient:= TOperClientShisnine.Create(DSRestConnection1, FInstanceOwner);
  Result := FOperacoesClient;
end;

end.
