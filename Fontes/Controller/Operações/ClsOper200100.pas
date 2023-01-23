unit ClsOper200100;

interface

uses ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsProva, ClsParametros, clsDialogos, Vcl.Dialogs,
  System.Classes;

type
  Operacao200100 = class(TComponent)
  protected
    Fid_cfc: string;
    FComputador: string;
    FTipoProva: string;
    FCodigo: string;
    FMensagem: string;
    FIdCandidato: string;
    FIdentificacao: string;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;

    procedure SetComputador(ParComputador: String);
    procedure SetId_cfc(Parid_cfc: String);
    procedure SetTipoProva(ParTipoProva: String);
    procedure SetIdCandidato(ParIdCandidato: String);
    Procedure onMontaXMLRetorno(Sender: TObject);
    Procedure CarregarProva(LerXML: IXMLDocument);
    Procedure MontaXMLEnvio(Sender: TObject);
  public

    property id_cfc: String read Fid_cfc write SetId_cfc;
    property IdCandidato: String read FIdCandidato write SetIdCandidato;
    property Computador: String read FComputador write SetComputador;
    property Identificacao: String read FIdentificacao write FIdentificacao;
    property TipoProva: String read FTipoProva write SetTipoProva;
    property codigo: String read FCodigo write FCodigo;
    property mensagem: String read FMensagem write FMensagem;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

uses ClsFuncoes;

procedure Operacao200100.SetId_cfc(Parid_cfc: String);
begin
  Fid_cfc := Parid_cfc;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') and
    (Trim(FIdCandidato) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200100.SetComputador(ParComputador: String);
begin
  FComputador := ParComputador;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') and
    (Trim(FIdCandidato) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200100.SetIdCandidato(ParIdCandidato: String);
begin
  FIdCandidato := ParIdCandidato;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') and
    (Trim(FIdCandidato) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200100.SetTipoProva(ParTipoProva: String);
begin

  FTipoProva := ParTipoProva;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') and
    (Trim(FIdCandidato) <> '') then
    MontaXMLEnvio(self);

end;

Procedure Operacao200100.CarregarProva(LerXML: IXMLDocument) ;
var

  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;

  NoExame: IXMLNode;
  NoParametros: IXMLNode;
  Notempo_minimo: IXMLNode;
  Nosem_resposta: IXMLNode;
  Noavanco: IXMLNode;
  NoURLParametros: IXMLNode;
  Nourl_prova: IXMLNode;
  Nourl_gabarito: IXMLNode;
  Nourl_Hash: IXMLNode;
  NoQuestoes: IXMLNode;
  NoQuestao: IXMLNode;
  NoURL_Imagem: IXMLNode;
  NoImagem: IXMLNode;
  NoAlternativas: IXMLNode;

  simbolo: string;
  OldLink: string;
  NewLink: string;

  I: Integer;

  ParPergunta: TPergunta;

begin

  if ParQuestionario.Perguntas.Count <> 0 then
  begin
    ParQuestionario.Free;
    ParQuestionario := TQuestionario.Create(nil);
  end;

  try

    if Trim(LerXML.Xml.Text) <> '' then
    begin
      NoRetorno := LerXML.ChildNodes.FindNode('retorno');
      if NoRetorno <> nil then
      begin
        if NoRetorno.HasAttribute('codigo') then
          if NoRetorno.Attributes['codigo'] <> 'B000' then
          begin
            if NoRetorno.HasAttribute('codigo') then
              codigo := NoRetorno.Attributes['codigo'];

            NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem')
              .ChildNodes.FindNode('texto');
            if NoMensagem <> nil then
              mensagem := NoMensagem.Text;
          end
          else
          begin
            if NoRetorno.HasAttribute('codigo') then
              codigo := NoRetorno.Attributes['codigo'];

            NoExame := NoRetorno.ChildNodes.FindNode('exame');
            if NoExame <> nil then
            begin

              ParQuestionario.id_prova := NoExame.Attributes['id'];

              NoParametros := NoExame.ChildNodes.FindNode('parametros');
              if NoParametros <> nil then
              begin
                ParQuestionario.TempoTotal :=
                  StrToIntDef
                  (Trim(NoParametros.ChildNodes.FindNode('tempo_prova')
                  .Text), 0);
                ParQuestionario.TempoDecorrido :=
                  StrToIntDef
                  (Trim(NoParametros.ChildNodes.FindNode('tempo_gasto')
                  .Text), 0);

                Notempo_minimo := NoParametros.ChildNodes.FindNode
                  ('tempo_minimo');
                if Notempo_minimo <> nil then
                  ParQuestionario.TempoMinimo :=
                    StrToIntDef(Trim(Notempo_minimo.Text), 0);

                Nosem_resposta := NoParametros.ChildNodes.FindNode
                  ('sem_resposta');
                if Nosem_resposta <> nil then
                  ParQuestionario.SemResposta := Trim(Nosem_resposta.Text);

                Noavanco := NoParametros.ChildNodes.FindNode('avanco');
                if Noavanco <> nil then
                  ParServidor.AvancoAutomatico := Trim(Noavanco.Text)
                else
                  ParServidor.AvancoAutomatico := 'S';

                NoURLParametros := NoParametros.ChildNodes.FindNode('url');
                if NoURLParametros <> nil then
                begin
                  Nourl_prova := NoURLParametros.ChildNodes.FindNode
                    ('url_prova');
                  if Nourl_prova <> nil then
                    ParQuestionario.url_prova :=
                      ReplaceStr(Trim(Nourl_prova.Text),
                      Nourl_prova.Attributes['simbolo'], '&');

                  Nourl_gabarito := NoURLParametros.ChildNodes.FindNode
                    ('url_gabarito');
                  if Nourl_gabarito <> nil then
                    ParQuestionario.url_gabarito :=
                      ReplaceStr(Trim(Nourl_gabarito.Text),
                      Nourl_gabarito.Attributes['simbolo'], '&');

                  Nourl_Hash := NoURLParametros.ChildNodes.FindNode('url_hash');
                  if Nourl_Hash <> nil then
                    ParQuestionario.url_hash :=
                      ReplaceStr(Trim(Nourl_Hash.Text),
                      Nourl_Hash.Attributes['simbolo'], '&');

                end;
              end;

              NoQuestoes := NoExame.ChildNodes.FindNode('questoes');
              if NoQuestoes <> nil then
              begin
                ParQuestionario.TotalPerguntas :=
                  StrToIntDef(Trim(NoQuestoes.Attributes['total']), 0);
                ParQuestionario.QtdeAlternativas :=
                  StrToIntDef(Trim(NoQuestoes.Attributes['alternativas']), 0);
              end;

              for I := 0 to NoQuestoes.ChildNodes.Count - 1 do
              // ParQuestionario.TotalPerguntas do
              begin
                try
                  NoQuestao := NoQuestoes.ChildNodes.Get(I);
                  if NoQuestao <> nil then
                  begin

                    ParPergunta := TPergunta.Create;

                    ParPergunta.id_questoes :=
                      StrToIntDef(Trim(NoQuestao.Attributes['id']), 0);
                    ParPergunta.Pergunta := NoQuestao.ChildNodes.FindNode
                      ('pergunta').Text;
                    ParPergunta.PerguntaMateria := NoQuestao.ChildNodes.FindNode
                      ('disciplina').Text;

                    NoURL_Imagem := NoQuestao.ChildNodes.FindNode('url_imagem');
                    NoImagem := NoQuestao.ChildNodes.FindNode('imagem');

                    if NoURL_Imagem <> nil then
                    begin
                      if NoQuestao.ChildNodes.FindNode('url_imagem')
                        .AttributeNodes.Count <> 0 then
                      begin
                        simbolo := NoQuestao.ChildNodes.FindNode('url_imagem')
                          .Attributes['simbolo'];
                        OldLink := NoQuestao.ChildNodes.FindNode
                          ('url_imagem').Text;
                        NewLink := StringReplace(OldLink, simbolo, '&',
                          [rfReplaceAll]);
                        ParPergunta.PerguntaImagem := NewLink;
                      end
                      else
                      begin
                        ParPergunta.PerguntaImagem := '';
                      end;
                    end
                    else
                    begin
                      if NoURL_Imagem <> nil then
                      begin
                        ParPergunta.PerguntaImagem :=
                          NoQuestao.ChildNodes.FindNode('imagem').Text;
                      end
                      else
                        ParPergunta.PerguntaImagem := '';
                    end;

                    NoAlternativas := NoQuestao.ChildNodes.FindNode
                      ('alternativas');
                    if NoAlternativas <> nil then
                    begin
                      ParPergunta.RespostaCorreta := NoAlternativas.Attributes
                        ['correta'];

                      if NoAlternativas.ChildNodes.Get(0).HasAttribute('opcao')
                      then
                        if NoAlternativas.ChildNodes.Get(0).Attributes['opcao']
                          = 'A' then
                          ParPergunta.RespostaA :=
                            NoAlternativas.ChildNodes.Get(0).Text;

                      if NoAlternativas.ChildNodes.Get(1).HasAttribute('opcao')
                      then
                        if NoAlternativas.ChildNodes.Get(1).Attributes['opcao']
                          = 'B' then
                          ParPergunta.RespostaB :=
                            NoAlternativas.ChildNodes.Get(1).Text;

                      if NoAlternativas.ChildNodes.Get(2).HasAttribute('opcao')
                      then
                        if NoAlternativas.ChildNodes.Get(2).Attributes['opcao']
                          = 'C' then
                          ParPergunta.RespostaC :=
                            NoAlternativas.ChildNodes.Get(2).Text;

                      if NoAlternativas.ChildNodes.Get(3).HasAttribute('opcao')
                      then
                        if NoAlternativas.ChildNodes.Get(3).Attributes['opcao']
                          = 'D' then
                          ParPergunta.RespostaD :=
                            NoAlternativas.ChildNodes.Get(3).Text;

                      if NoAlternativas.ChildNodes.Get(4).HasAttribute('opcao')
                      then
                        if NoAlternativas.ChildNodes.Get(4).Attributes['opcao']
                          = 'E' then
                          ParPergunta.RespostaE :=
                            NoAlternativas.ChildNodes.Get(4).Text;
                    end;

                    ParPergunta.RespostaEscolhida :=
                      NoQuestao.ChildNodes.FindNode('resposta').Text;

                    if Trim(ParPergunta.RespostaEscolhida) <> '' then
                    begin
                      if Trim(ParPergunta.RespostaEscolhida) <>
                        Trim(ParPergunta.RespostaCorreta) then
                        ParQuestionario.TotalRespostasErradas :=
                          ParQuestionario.TotalRespostasErradas + 1
                      else
                        ParQuestionario.TotalRespostasCorretas :=
                          ParQuestionario.TotalRespostasCorretas + 1;
                    end;
                    ParQuestionario.Perguntas.Add
                      (StrToIntDef(Trim(NoQuestao.Attributes['ordem']), 1),
                      ParPergunta);
                  end;
                except
                  on E: Exception do
                  begin
                    LerXML.Active := False;
                    LerXML.Xml.Clear;
                    LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
                    LerXML.Active := True;
                    GravaArquivoLog(self, 'Operação 200100 - ' + E.Message);
                    DialogoMensagem
                      ('O sistema e-Prova encontrou inconsistência nos dados da última prova iniciada e não finalizada.'
                      + #13 + 'Entar em contato com o suporte!', mtWarning);
                  end;
                end;
              end;
            end;
          end;
      end;
    end;

  except on E: Exception do
    begin
      GravaArquivoLog(self, 'Operação 200100 - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

end;

Procedure Operacao200100.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
begin

  if ParQuestionario.Perguntas.Count <> 0 then
  begin
    ParQuestionario.Free;
    ParQuestionario := TQuestionario.Create(nil);
  end;

  try
    LerXML := NewXMLDocument;
    // Aqui emplemeta a rotina de retorno
    try
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetorno;
      LerXML.Active := True;
    except on Erro: Exception do
      begin
        GravaArquivoLog(self, 'Operação 200100 - Retorno Padrão -' + Erro.Message);
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
    end;

    CarregarProva(LerXML);

  except on E: Exception do
    begin
      GravaArquivoLog(self, 'Operação 200100 - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(self);
end;

Procedure Operacao200100.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLAluno: IXMLNode;
  XMLComputador: IXMLNode;
  XmlTexto: string;
begin

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';

  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '200100';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['tipo'] := TipoProva;
  XMLExame.Text := ' ';

  XMLAluno := XMLExame.AddChild('aluno');
  XMLAluno.Attributes['id'] := IdCandidato;
  XMLAluno.Attributes['excecao'] := ParCandidato.Excecao;
  XMLAluno.Text := ' ';

  XMLComputador := XMLExame.AddChild('computador');
  XMLComputador.Text := Computador;
  XMLComputador.Attributes['identificacao'] := Trim(FIdentificacao);

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(self,
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
