unit ClsMonitoramentoRTSPControl;

interface

uses System.Classes;

type

  TMonitoramentoFluxoRTSP = class(TObject)
  private
    FCam: String;
    FFluxo: Double;
    FDescricaoMonitoramentoRTSP: String;
    FDescricaoFluxo: String;
    FStatus_ServidorMCP: Integer;
    FStatus: String;
    procedure SetCam(val: String);
  public
    property Cam: String read FCam write SetCam;
    property Fluxo: Double read FFluxo write FFluxo;
    property DescricaoFluxo: String read FDescricaoFluxo write FDescricaoFluxo;
    property Status_ServidorMCP: Integer read FStatus_ServidorMCP
      write FStatus_ServidorMCP;
    property Status: String read FStatus write FStatus;
    property DescricaoMonitoramentoRTSP: String read FDescricaoMonitoramentoRTSP
      write FDescricaoMonitoramentoRTSP;
  end;

  TMonitoramentoRTSP = class(TObject)
  private
    FEndereco_Servidor: String;
    FVerificar_Servidor: String;
    FIniciar_Gravacao: String;
    Ffinalizar_Gravacao: String;
    FPorta_Servidor: Integer;
    FVerificar_Fluxo: String;
    FVerificar_Cameras: String;
    FCamera: String;

    procedure SetEndereco_Servidor(val: String);
    procedure SetVerificar_Servidor(val: String);
    procedure SetIniciar_Gravacao(val: String);
    procedure Setfinalizar_Gravacao(val: String);
    procedure SetPorta_Servidor(val: Integer);
    procedure SetVerificar_Fluxo(val: String);
    procedure SetVerificar_Cameras(val: String);
  public
    property Endereco_Servidor: String read FEndereco_Servidor
      write SetEndereco_Servidor;
    property Verificar_Servidor: String read FVerificar_Servidor
      write SetVerificar_Servidor;
    property Iniciar_Gravacao: String read FIniciar_Gravacao
      write SetIniciar_Gravacao;
    property finalizar_Gravacao: String read Ffinalizar_Gravacao
      write Setfinalizar_Gravacao;
    property Porta_Servidor: Integer read FPorta_Servidor
      write SetPorta_Servidor;
    property Verificar_Fluxo: String read FVerificar_Fluxo
      write SetVerificar_Fluxo;
    property Verificar_Cameras: String read FVerificar_Cameras
      write SetVerificar_Cameras;
    property Camera: String read FCamera write FCamera;

    destructor Destroy; override;
  end;

var
  ParMonitoramentoRTSP: TMonitoramentoRTSP;
  ParMonitoramentoFluxoRTSP: TMonitoramentoFluxoRTSP;
  ParListaMonitoramentoRTSP: TStringList;

implementation

procedure TMonitoramentoRTSP.SetEndereco_Servidor(val: String);
begin
  FEndereco_Servidor := val;
end;

procedure TMonitoramentoRTSP.SetVerificar_Servidor(val: String);
begin
  FVerificar_Servidor := val;
end;

procedure TMonitoramentoRTSP.SetIniciar_Gravacao(val: String);
begin
  FIniciar_Gravacao := val;
end;

procedure TMonitoramentoRTSP.Setfinalizar_Gravacao(val: String);
begin
  Ffinalizar_Gravacao := val;
end;

procedure TMonitoramentoRTSP.SetPorta_Servidor(val: Integer);
begin
  FPorta_Servidor := val;
end;

destructor TMonitoramentoRTSP.Destroy;
begin
  inherited Destroy;
end;

procedure TMonitoramentoFluxoRTSP.SetCam(val: String);
begin
  FCam := val;
end;

procedure TMonitoramentoRTSP.SetVerificar_Fluxo(val: String);
begin
  FVerificar_Fluxo := val;
end;

procedure TMonitoramentoRTSP.SetVerificar_Cameras(val: String);
begin
  FVerificar_Cameras := val;
end;

end.
