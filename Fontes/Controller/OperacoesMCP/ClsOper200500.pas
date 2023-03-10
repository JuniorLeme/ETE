unit ClsOper200500;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsQuestionario, ClsParametros, ClsFuncoes, System.Classes,
  Datasnap.DBClient, Data.DB, Soap.XSBuiltIns, ClsServidorControl,
  ClsEnvioMCP, ClsRetornoMCP;

type
  T200500Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(id_prova, Tipo, Bloqueio: string; Foto: WideString)
      : IXMLDocument;
  end;

  T200500Retorno = class(TRetornoMCP)
    Procedure MontaRetorno(XMLDoc: IXMLDocument);
  end;

implementation

Procedure T200500Retorno.MontaRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoExame: IXMLNode;
  NoResultado: IXMLNode;
begin

  try

    Self.Retorno(XMLDoc);

    if Self.IsValid then
    begin
      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');
      NoExame := NoRetorno.ChildNodes.FindNode('exame');
      if NoExame <> nil then
      begin
        NoResultado := NoExame.ChildNodes.FindNode('resultado');
      end;
    end;

  except
    on Erro: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Opera??o 200500 - Retorno Padr?o - ' +
        Erro.Message);
      XMLDoc.Active := False;
    end;
  end;

end;

Function T200500Envio.MontaXMLEnvio(id_prova, Tipo, Bloqueio: string;
  Foto: WideString): IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  NoFoto: IXMLNode;
begin

  if Bloqueio = '' then
    Bloqueio := 'N';

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('200500', Result);

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Text := ' ';
  XMLExame.Attributes['id'] := id_prova;
  XMLExame.Attributes['tipo'] := Tipo;
  XMLExame.Attributes['bloqueio'] := Bloqueio;

  NoFoto := XMLExame.AddChild('foto');
  NoFoto.Text := Foto;

end;

end.
