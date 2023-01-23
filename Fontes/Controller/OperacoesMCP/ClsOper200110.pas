unit ClsOper200110;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  IdCoderMIME,
  System.SysUtils, clsDialogos, Vcl.Dialogs, Vcl.StdCtrls, IdHTTP,
  System.Classes,
  Vcl.Imaging.jpeg, IdGlobal, ClsServidorControl, ClsQuestionario,
  ClsParametros, ClsEnvioMCP,
  ClsRetornoMCP;

type

  T200110Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(Id_prova, Tipo: string): IXMLDocument;
  end;

  T200110Retorno = class(TRetornoMCP)
    Procedure MontaRetorno(XMLDoc: IXMLDocument);
  end;

implementation

uses ClsFuncoes;

Procedure T200110Retorno.MontaRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoExame: IXMLNode;
  NoQuestoes: IXMLNode;
  NoQuestao: IXMLNode;
  I: Integer;
  q: Integer;
begin

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

        NoQuestoes := NoExame.ChildNodes.FindNode('questoes');
        if NoQuestoes <> nil then
        begin

          for I := 0 to NoQuestoes.ChildNodes.Count - 1 do
          begin

            NoQuestao := NoQuestoes.ChildNodes.Get(I);

            for q := 1 to ParQuestionario.Perguntas.Count do
            begin

              if ParQuestionario.Perguntas.Items[q]
                .id_questoes = NoQuestao.Attributes['id'] then
                if NoQuestao.ChildNodes.FindNode('imagem') <> nil then
                  ParQuestionario.Perguntas.Items[q].PerguntaImagem :=
                    NoQuestao.ChildNodes.FindNode('imagem').Text;

            end;

          end;

        end;

      end;

    end;

  except
    on Erro: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Opera��o 200110 - Retorno Padr�o - ' +
        Erro.Message);
      XMLDoc.Active := False;
    end;
  end;

end;

function T200110Envio.MontaXMLEnvio(Id_prova, Tipo: string): IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLQuestoes: IXMLNode;
  XmlQuestao: IXMLNode;
  I: Integer;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('200110', Result);

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Text := ' ';
  XMLExame.Attributes['id'] := Id_prova;
  XMLExame.Attributes['tipo'] := Tipo;

  XMLQuestoes := XMLExame.AddChild('questoes');
  XMLQuestoes.Text := '';

  for I := 1 to ParQuestionario.Perguntas.Count do
  begin
    if ParQuestionario.Perguntas.Items[I].PerguntaImagem <> '' then
    begin
      XmlQuestao := XMLQuestoes.AddChild('questao');
      XmlQuestao.Attributes['id'] :=
        IntToStr(ParQuestionario.Perguntas.Items[I].id_questoes);
      XmlQuestao.Text := ' ';
    end;
  end;

end;

end.
