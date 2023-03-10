unit ClsOper200400;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, IdCoderMIME, System.Classes, ClsServidorControl,
  ClsQuestionario,
  ClsParametros, ClsCandidatoControl, ClsFuncoes, ClsEnvioMCP, ClsRetornoMCP;

type

  T200400Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(Id_prova, Tipo, Andamento, duracao: string)
      : IXMLDocument;
    Function MontaXMLEnvioSinc(argXMLSinc: string): IXMLDocument;
  end;

  T200400Retorno = class(TRetornoMCP)
    Procedure MontaRetorno(Andamento: string; XMLDoc: IXMLDocument);
  end;

implementation

uses clseProvaConst;

Procedure T200400Retorno.MontaRetorno(Andamento: string; XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoExame: IXMLNode;
  NoResultado: IXMLNode;
  NoDisciplina: IXMLNode;
  I: Integer;
  ParDisciplina: TDisciplina;
begin

  try

    Self.Retorno(XMLDoc);

    if Self.IsValid then
    begin
      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');

      // S? vai rodar essa etapa se o andamento for finalizar
      if Andamento = 'E' then
      begin
        NoExame := NoRetorno.ChildNodes.FindNode('exame');
        if NoExame <> nil then
        begin
          NoResultado := NoExame.ChildNodes.FindNode('resultado');

          if NoResultado.HasAttribute('avaliacao')  then
            ParQuestionario.Aproveitamento :=  StrToFloatDef( ReplaceStr(NoResultado.Attributes['avaliacao'], '.', ','), 0)
          else
            ParQuestionario.Aproveitamento := 0;

          ParQuestionario.TotalRespostasCorretas := 0;
          ParQuestionario.TotalRespostasErradas := 0;

          for I := 1 to NoResultado.ChildNodes.Count do
          begin
            NoDisciplina := NoResultado.ChildNodes.Get(I - 1);
            ParDisciplina := TDisciplina.Create;

            ParDisciplina.ResultadoDisciplinaPerg := StrToIntDef(NoDisciplina.Attributes['total'], 0);
            ParDisciplina.ResultadoDisciplina := NoDisciplina.ChildNodes.FindNode('descricao').Text;
            ParDisciplina.ResultadoDisciplinaCertas := StrToIntDef(NoDisciplina.ChildNodes.FindNode('certas').Text, 0);
            ParDisciplina.ResultadoDisciplinaErradas := StrToIntDef(NoDisciplina.ChildNodes.FindNode('erradas').Text, 0);
            ParQuestionario.TotalRespostasCorretas := ParQuestionario.TotalRespostasCorretas + ParDisciplina.ResultadoDisciplinaCertas;
            ParQuestionario.TotalRespostasErradas := ParQuestionario.TotalRespostasErradas + ParDisciplina.ResultadoDisciplinaErradas;

            if ParQuestionario.Disciplinas.ContainsKey(NoDisciplina.ChildNodes.FindNode('descricao').Text) then
            begin
              ParQuestionario.Disciplinas.Remove(NoDisciplina.ChildNodes.FindNode('descricao').Text);
              ParQuestionario.Disciplinas.Add(NoDisciplina.ChildNodes.FindNode('descricao').Text, ParDisciplina);
            end
            else
              ParQuestionario.Disciplinas.Add(NoDisciplina.ChildNodes.FindNode('descricao').Text, ParDisciplina);
          end;
        end;
      end;
    end;

  except
    on Erro: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Opera??o 200400 - Retorno Padr?o - ' +
        Erro.Message);
      XMLDoc.Active := False;
    end;
  end;

end;

Function T200400Envio.MontaXMLEnvio(Id_prova, Tipo, Andamento, duracao: string)
  : IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLAndamento: IXMLNode;
  XMLDuracao: IXMLNode;
  XMLQuestoes: IXMLNode;
  XmlQuestao: IXMLNode;
  XmlResposta: IXMLNode;
  XMLHash: IXMLNode;

  IdEncoderMIME: TIdEncoderMIME;
  I: Integer;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('200400', Result);

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Text := ' ';
  XMLExame.Attributes['id'] := Id_prova;
  XMLExame.Attributes['tipo'] := Tipo;

  XMLAndamento := XMLExame.AddChild('andamento');
  XMLAndamento.Attributes['tipo'] := Andamento;

  XMLDuracao := XMLAndamento.AddChild('duracao');
  XMLDuracao.Text := duracao;

  IdEncoderMIME := TIdEncoderMIME.Create(nil);

  XMLHash := XMLExame.AddChild('hash');
  XMLHash.Text := IdEncoderMIME.EncodeString(Trim(ParQuestionario.url_Hash));

  XMLQuestoes := XMLExame.AddChild('questoes');
  XMLQuestoes.Attributes['total'] := IntToStr(ParQuestionario.TotalPerguntas);
  XMLQuestoes.Text := '';

  for I := 1 to ParQuestionario.Perguntas.Count do
  begin

    if ParQuestionario.Perguntas.Items[I].RespostaEscolhida <> '' then
    begin
      XmlQuestao := XMLQuestoes.AddChild('questao');
      XmlQuestao.Attributes['id'] :=
        IntToStr(ParQuestionario.Perguntas.Items[I].id_questoes);
      XmlQuestao.Text := ' ';

      XmlResposta := XmlQuestao.AddChild('resposta');
      XmlResposta.Text := ParQuestionario.Perguntas.Items[I].RespostaEscolhida;
    end;

  end;

  Result.SaveToFile(UserProgranData + strFileEnviar + '\200400' +
    IntToStr(ParQuestionario.Id_prova) + ParCandidato.CPFCandidato + '.ep');

end;

Function T200400Envio.MontaXMLEnvioSinc(argXMLSinc: string): IXMLDocument;
begin
  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.LoadFromFile(argXMLSinc);
  Result.Active := True;
end;

end.
