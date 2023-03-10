unit ClsOper200100;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsQuestionario, ClsParametros, clsDialogos, Vcl.Dialogs,
  System.Classes, Vcl.Imaging.jpeg, IdGlobal, IdHTTP, IdCoderMIME,
  ClsServidorControl, ClsCandidatoControl, ClsEnvioMCP, ClsRetornoMCP;

type
  T200100Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(TipoProva, IdCandidato, Identificacao,
      Computador: string): IXMLDocument;
  end;

  T200100Retorno = class(TRetornoMCP)
    Procedure MontaRetorno(XMLDoc: IXMLDocument);
  end;

implementation

uses ClsFuncoes;

Procedure T200100Retorno.MontaRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;

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
  strlistIDImagem: TStringList;
begin

  FreeAndNil(ParQuestionario);
  ParQuestionario := TQuestionario.Create(Self);

  ParQuestionario.Tempo := 0;

  strlistIDImagem := TStringList.Create;
  strlistIDImagem.Clear;

  try

    Self.Retorno(XMLDoc);

    if Self.IsValid then
    begin

      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');
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
            StrToIntDef(Trim(NoParametros.ChildNodes.FindNode('tempo_prova')
            .Text), 0);
          ParQuestionario.TempoDecorrido :=
            StrToIntDef(Trim(NoParametros.ChildNodes.FindNode('tempo_gasto')
            .Text), 0);

          Notempo_minimo := NoParametros.ChildNodes.FindNode('tempo_minimo');
          if Notempo_minimo <> nil then
            ParQuestionario.TempoMinimo :=
              StrToIntDef(Trim(Notempo_minimo.Text), 0);

          Nosem_resposta := NoParametros.ChildNodes.FindNode('sem_resposta');
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

            Nourl_prova := NoURLParametros.ChildNodes.FindNode('url_prova');
            if Nourl_prova <> nil then
              ParQuestionario.url_prova := ReplaceStr(Trim(Nourl_prova.Text),
                Nourl_prova.Attributes['simbolo'], '&');

            Nourl_gabarito := NoURLParametros.ChildNodes.FindNode
              ('url_gabarito');
            if Nourl_gabarito <> nil then
              ParQuestionario.url_gabarito :=
                ReplaceStr(Trim(Nourl_gabarito.Text),
                Nourl_gabarito.Attributes['simbolo'], '&');

            Nourl_Hash := NoURLParametros.ChildNodes.FindNode('url_hash');
            if Nourl_Hash <> nil then
              ParQuestionario.url_hash := ReplaceStr(Trim(Nourl_Hash.Text),
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
                  OldLink := NoQuestao.ChildNodes.FindNode('url_imagem').Text;
                  NewLink := StringReplace(OldLink, simbolo, '&',
                    [rfReplaceAll]);
                  ParPergunta.PerguntaImagem := NewLink;
                  strlistIDImagem.Add(IntToStr(ParPergunta.id_questoes));

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
                  ParPergunta.PerguntaImagem := NoQuestao.ChildNodes.FindNode
                    ('imagem').Text;
                end
                else
                  ParPergunta.PerguntaImagem := '';
              end;

              NoAlternativas := NoQuestao.ChildNodes.FindNode('alternativas');
              if NoAlternativas <> nil then
              begin

                ParPergunta.RespostaCorreta := NoAlternativas.Attributes
                  ['correta'];

                if NoAlternativas.ChildNodes.Get(0).HasAttribute('opcao') then

                  if NoAlternativas.ChildNodes.Get(0).Attributes['opcao'] = 'A'
                  then
                    ParPergunta.RespostaA :=
                      NoAlternativas.ChildNodes.Get(0).Text;

                if NoAlternativas.ChildNodes.Get(1).HasAttribute('opcao') then
                  if NoAlternativas.ChildNodes.Get(1).Attributes['opcao'] = 'B'
                  then
                    ParPergunta.RespostaB :=
                      NoAlternativas.ChildNodes.Get(1).Text;

                if NoAlternativas.ChildNodes.Get(2).HasAttribute('opcao') then
                  if NoAlternativas.ChildNodes.Get(2).Attributes['opcao'] = 'C'
                  then
                    ParPergunta.RespostaC :=
                      NoAlternativas.ChildNodes.Get(2).Text;

                if NoAlternativas.ChildNodes.Get(3).HasAttribute('opcao') then
                  if NoAlternativas.ChildNodes.Get(3).Attributes['opcao'] = 'D'
                  then
                    ParPergunta.RespostaD :=
                      NoAlternativas.ChildNodes.Get(3).Text;

                if NoAlternativas.ChildNodes.Get(4).HasAttribute('opcao') then
                  if NoAlternativas.ChildNodes.Get(4).Attributes['opcao'] = 'E'
                  then
                    ParPergunta.RespostaE :=
                      NoAlternativas.ChildNodes.Get(4).Text;
              end;

              ParPergunta.RespostaEscolhida := NoQuestao.ChildNodes.FindNode
                ('resposta').Text;

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
              XMLDoc.Active := False;
              ArquivoLog.GravaArquivoLog('Opera??o 200100 - ' + E.Message);
              DialogoMensagem
                ('O sistema e-Prova encontrou inconsist?ncia nos dados da ?ltima prova iniciada e n?o finalizada.'
                + #13 + 'Entrar em contato com o suporte!', mtWarning);
            end;
          end;
        end;

        if ParQuestionario.Perguntas.Count <> ParQuestionario.TotalPerguntas
        then
        begin

          Self.FCodigo := 'D100';
          Self.FMensagem :=
            'Falha no sorteio das quest?es. O n?mero de quest?es ? diferente de '
            + IntToStr(ParQuestionario.TotalPerguntas) + '.';

        end;

      end;

    end;

    FreeAndNil(strlistIDImagem);

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Opera??o 200100 - ' + E.Message);
      XMLDoc.Active := False;
    end;
  end;

end;

Function T200100Envio.MontaXMLEnvio(TipoProva, IdCandidato, Identificacao,
  Computador: string): IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLAluno: IXMLNode;
  XMLComputador: IXMLNode;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('200100', Result);

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['tipo'] := TipoProva;
  XMLExame.Text := ' ';

  XMLAluno := XMLExame.AddChild('aluno');
  XMLAluno.Attributes['id'] := IdCandidato;
  XMLAluno.Attributes['excecao'] := ParCandidato.Excecao;
  XMLAluno.Text := ' ';

  XMLComputador := XMLExame.AddChild('computador');
  XMLComputador.Text := Computador;
  XMLComputador.Attributes['identificacao'] := Trim(Identificacao);

end;

end.
