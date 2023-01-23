unit ClsProva;

interface
  uses System.Classes, Vcl.Graphics, System.SysUtils, System.Generics.Collections,
  IdTCPClient, IdICMPClient, ClsParametros ;

type
  TPergunta = class
    id_questoes : Integer;
    Pergunta : WideString;
    PerguntaImagem : String;
    PerguntaMateria :String;

    RespostaA : WideString;
    RespostaB : WideString;
    RespostaC : WideString;
    RespostaD : WideString;
    RespostaE : WideString;

    RespostaCorreta   : String;
    RespostaEscolhida : String;
  end;

 TDisciplina = class
    ResultadoDisciplina : WideString;
    ResultadoDisciplinaPerg : Integer;
    ResultadoDisciplinaCertas : Integer;
    ResultadoDisciplinaErradas : Integer;
 end;

  TQuestionario = Class(TObject)

  private
    FTentativas: Integer;
    FModoOnline: boolean;

    procedure SetModoOnline(val: boolean);
    function GetModoOnline(): boolean;

    procedure SetTempoDecorrido(val: Integer);
    function GetTempoDecorrido(): Integer;

    function PortTestSevidoresCRIAR(arServidor: string; ArgPort: Integer ): Boolean;
    function PingSevidoresCRIAR(arServidor: string): Boolean;
  protected
    FPerguntaNumero : Integer;
    FTempoMinimo : Integer;
    FSemResposta : String;
    FURL_Prova: WideString;
    FURL_Gabarito: WideString;
    Furl_Hash: WideString;

    // Resultado
    FId_prova : Integer;
    FTotalPerguntas : Integer;
    FTotalRespostasCorretas : Integer;
    FTotalRespostasErradas : Integer;
    FQtde_Alternativas : Integer;
    FAproveitamento : Double;
    FTempoTotal : Integer;
    FTempoDecorrido : Integer;
    FTempo : Real;

  public
    Perguntas : TDictionary<Integer,TPergunta>;
    Disciplinas : TDictionary<Integer,TDisciplina>;

    ResultadoDisciplinaCorCertas  : array[1..20] of TColor;
    ResultadoDisciplinaCorErradas : array[1..20] of TColor;

    property Id_prova: Integer read FId_prova write FId_prova;

    property TempoTotal: Integer read FTempoTotal write FTempoTotal;
    property TempoDecorrido: Integer read GetTempoDecorrido write SetTempoDecorrido;
    property TempoMinimo : Integer read FTempoMinimo write FTempoMinimo;
    property Tempo: Real read FTempo write FTempo;

    property TotalPerguntas: Integer read FTotalPerguntas write FTotalPerguntas;
    property TotalRespostasErradas: Integer  read FTotalRespostasErradas  write FTotalRespostasErradas;
    property TotalRespostasCorretas: Integer read FTotalRespostasCorretas write FTotalRespostasCorretas;
    property QtdeAlternativas: Integer read FQtde_Alternativas write FQtde_Alternativas;
    property SemResposta : String read FSemResposta write FSemResposta;
    property Aproveitamento: Double read FAproveitamento write FAproveitamento;

    property url_prova : WideString read Furl_prova write Furl_prova;
    property url_gabarito : WideString read FURL_Gabarito write FURL_Gabarito;
    property url_Hash : WideString read Furl_Hash write Furl_Hash;
    constructor Create(sender: TObject);
    property Tentativas: Integer read FTentativas;
    property ModoOnline: boolean read GetModoOnline write SetModoOnline;

  End;

var
  ParQuestionario: TQuestionario;

implementation

constructor TQuestionario.Create(sender: TObject);
begin

  Perguntas   := TDictionary<Integer, TPergunta>.Create;
  Disciplinas := TDictionary<Integer, TDisciplina>.Create;

  FPerguntaNumero := 0;
  FTempoMinimo := 0;
  FSemResposta := '';
  FURL_Prova := '';
  FURL_Gabarito := '';
  Furl_Hash := '';

  // Resultado
  FId_prova := 0;
  FTotalPerguntas := 0;
  FTotalRespostasCorretas := 0;
  FTotalRespostasErradas := 0;
  FQtde_Alternativas := 0;
  FAproveitamento := 0;
  FTempoTotal := 0;
  FTempoDecorrido := 0;
  FTempo := 0;
end;

procedure TQuestionario.SetModoOnline(val: boolean);
begin

  val := PortTestSevidoresCRIAR('iridio.keynet.com.br',443);

  if val = false then
    val := PingSevidoresCRIAR('internic.net');

  Inc(FTentativas);

end;

procedure TQuestionario.SetTempoDecorrido(val: Integer);
begin

  // Set
  FTempoDecorrido := val;

  if FModoOnline = False then
  begin
    // gravar xml



  end;

end;

function TQuestionario.GetModoOnline: boolean;
begin
  // Get
  Result := FModoOnline;
end;

function TQuestionario.GetTempoDecorrido: Integer;
begin
  // Get
  Result := FTempoDecorrido;
end;

function TQuestionario.PingSevidoresCRIAR(arServidor: string): Boolean;
var
  IdICMPClient: TIdICMPClient;
begin

  try

    IdICMPClient := TIdICMPClient.Create( nil );
    IdICMPClient.Host := arServidor;
    IdICMPClient.ReceiveTimeout := 500;
    IdICMPClient.Ping;

    Result := (IdICMPClient.ReplyStatus.BytesReceived  > 0);

  except on E: Exception do
    Result := False;
  end;

end;

function TQuestionario.PortTestSevidoresCRIAR(arServidor: string; argPort: Integer): Boolean;
  var
    intPorta : Integer;
    bCon: Boolean;
    I: Integer;
begin

  bCon := false;

  with TIdTCPClient.Create(Nil) do
  begin

    Host := arServidor;
    Port := ArgPort ;

    try

      for I := 1 to 3 do
      begin

        try

          //primeiro eu executo Connect e depois verifico se está conectado
          ConnectTimeout := 1000;
          Connect;  //um timeout de 1000 ms ou 1 s
          bCon := Connected;

        except on E: Exception do
          bCon := False;
        end;

        if bCon then
          Break
        else
          Sleep(5000);

      end;

    finally

      if bCon then
        Disconnect;

      Free;
    end;

    Result := bCon;

  end;

end;

end.
