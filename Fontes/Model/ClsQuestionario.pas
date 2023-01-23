unit ClsQuestionario;

interface

uses System.Classes, Vcl.Graphics, System.SysUtils, System.Generics.Collections;

type
  TPergunta = class
    id_questoes: Integer;
    Pergunta: WideString;
    PerguntaImagem: String;
    PerguntaMateria: String;

    RespostaA: WideString;
    RespostaB: WideString;
    RespostaC: WideString;
    RespostaD: WideString;
    RespostaE: WideString;

    RespostaCorreta: String;
    RespostaEscolhida: String;
  end;

  TDisciplina = class
    ResultadoDisciplina: WideString;
    ResultadoDisciplinaPerg: Integer;
    ResultadoDisciplinaCertas: Integer;
    ResultadoDisciplinaErradas: Integer;
  end;

  TQuestionario = Class(TObject)

  protected
    FPerguntaNumero: Integer;
    FTempoMinimo: Integer;
    FSemResposta: String;
    FURL_Prova: WideString;
    FURL_Gabarito: WideString;
    Furl_Hash: WideString;

    // Resultado
    FId_prova: Integer;
    FTotalPerguntas: Integer;
    FTotalRespostasCorretas: Integer;
    FTotalRespostasErradas: Integer;
    FQtde_Alternativas: Integer;
    FAproveitamento: Double;
    FTempoTotal: Integer;
    FTempoDecorrido: Integer;
    FTempo: Real;

  public
    // TObjectList<TMdlUsuario>;
    Perguntas: TDictionary<Integer, TPergunta>;
    Disciplinas: TDictionary<String, TDisciplina>;

    ResultadoDisciplinaCorCertas: array [1 .. 20] of TColor;
    ResultadoDisciplinaCorErradas: array [1 .. 20] of TColor;

    property Id_prova: Integer read FId_prova write FId_prova;

    property TempoTotal: Integer read FTempoTotal write FTempoTotal;
    property TempoDecorrido: Integer read FTempoDecorrido write FTempoDecorrido;
    property TempoMinimo: Integer read FTempoMinimo write FTempoMinimo;
    property Tempo: Real read FTempo write FTempo;

    property TotalPerguntas: Integer read FTotalPerguntas write FTotalPerguntas;
    property TotalRespostasErradas: Integer read FTotalRespostasErradas
      write FTotalRespostasErradas;
    property TotalRespostasCorretas: Integer read FTotalRespostasCorretas
      write FTotalRespostasCorretas;
    property QtdeAlternativas: Integer read FQtde_Alternativas
      write FQtde_Alternativas;
    property SemResposta: String read FSemResposta write FSemResposta;
    property Aproveitamento: Double read FAproveitamento write FAproveitamento;

    property url_prova: WideString read FURL_Prova write FURL_Prova;
    property url_gabarito: WideString read FURL_Gabarito write FURL_Gabarito;
    property url_Hash: WideString read Furl_Hash write Furl_Hash;

    constructor Create(sender: TObject);

  End;

var
  ParQuestionario: TQuestionario;

implementation

constructor TQuestionario.Create(sender: TObject);
begin

  Perguntas := TDictionary<Integer, TPergunta>.Create;
  Disciplinas := TDictionary<String, TDisciplina>.Create;

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

end.
