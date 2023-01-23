unit ClsProvaOffLine;

interface
  uses System.Classes, Vcl.Graphics, System.SysUtils, System.Generics.Collections,
  IdTCPClient, IdICMPClient, ClsParametros ;

type
  TPerguntaOffLine = class
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

  TDisciplinaOffLine = class
    ResultadoDisciplina : WideString;
    ResultadoDisciplinaPerg : Integer;
    ResultadoDisciplinaCertas : Integer;
    ResultadoDisciplinaErradas : Integer;
 end;

  TQuestionarioOffLine = Class(TObject)
  private
    FTentativas: Integer;
    FModoOnline: boolean;
    procedure SetModoOnline(val: boolean);
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
    Perguntas: TDictionary<Integer, TPerguntaOffLine>;
    Disciplinas: TDictionary<Integer, TDisciplinaOffLine>;
    ResultadoDisciplinaCorCertas  : array[1..20] of TColor;
    ResultadoDisciplinaCorErradas : array[1..20] of TColor;

    property Id_prova: Integer read FId_prova write FId_prova;

    property TempoTotal: Integer read FTempoTotal write FTempoTotal;
    property TempoDecorrido: Integer read FTempoDecorrido write FTempoDecorrido;
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
    property ModoOnline: boolean read FModoOnline write SetModoOnline;

  End;

var
  ParQuestionarioOffLine: TQuestionarioOffLine;

implementation

constructor TQuestionarioOffLine.Create(sender: TObject);
begin

  Perguntas   := TDictionary<Integer, TPerguntaOffLine>.Create;
  Disciplinas := TDictionary<Integer, TDisciplinaOffLine>.Create;

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

procedure TQuestionarioOffLine.SetModoOnline(val: boolean);
begin

  val := PortTestSevidoresCRIAR('iridio.keynet.com.br',443);

  if val = false then
    val := PingSevidoresCRIAR('internic.net');

  Inc(FTentativas);

end;

function TQuestionarioOffLine.PingSevidoresCRIAR(arServidor: string): boolean;
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

function TQuestionarioOffLine.PortTestSevidoresCRIAR(arServidor: string;
  ArgPort: Integer): boolean;
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
