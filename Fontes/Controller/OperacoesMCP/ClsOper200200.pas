unit ClsOper200200;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils,
  ClsServidorControl, ClsParametros, ClsMonitoramentoRTSPControl,
  System.Classes, clsDVRFerramentas,
  ClsEnvioMCP, ClsRetornoMCP;

type
  T200200Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(id_prova, Tipo: string): IXMLDocument;
  end;

  T200200Retorno = class(TRetornoMCP)
    Procedure MontaRetorno(XMLDoc: IXMLDocument);
  end;

implementation

uses ClsFuncoes;

Procedure T200200Retorno.MontaRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  Nocfclive: IXMLNode;
begin

  try

    Self.Retorno(XMLDoc);
    if Self.IsValid then
    begin
      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');

      if NoRetorno.HasAttribute('codigo') then
        codigo := NoRetorno.Attributes['codigo'];

      if NoRetorno.ChildNodes.FindNode('status_monitoramento') <> nil then
      begin
        ParMonitoramentoFluxoRTSP.Status_ServidorMCP :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode
          ('status_monitoramento').Text, 1);
        ArquivoLog.GravaArquivoLog('Opera��o 200200 - Status monitoramento: ' +
          NoRetorno.ChildNodes.FindNode('status_monitoramento').Text);
      end
      else
        ParMonitoramentoFluxoRTSP.Status_ServidorMCP := 1;

      Nocfclive := NoRetorno.ChildNodes.FindNode('cfclive');
      if Nocfclive <> nil then
      begin
        DVRFerramentas.cfcliveSituacao :=
          StrToIntDef(Nocfclive.Attributes['situacao'], 0);
        DVRFerramentas.cfcliveTipo := Nocfclive.Attributes['tipo'];

        if Nocfclive.ChildNodes.FindNode('dica') <> nil then
          DVRFerramentas.cfcliveHint := Nocfclive.ChildNodes.FindNode
            ('dica').Text;

        if Nocfclive.ChildNodes.FindNode('mensagem') <> nil then
          DVRFerramentas.cfcliveMensagem := Nocfclive.ChildNodes.FindNode
            ('mensagem').Text;
      end
      else
      begin
        if DVRFerramentas <> nil then
          DVRFerramentas.cfcliveSituacao := 0;
      end;

    end;

    ArquivoLog.GravaArquivoLog('Opera��o 200200 - C�digo: ' + Self.codigo);

  except
    on Erro: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Opera��o 200200 - Retorno Padr�o - ' +
        Erro.Message);

      XMLDoc.Active := False;
    end;
  end;

end;

Function T200200Envio.MontaXMLEnvio(id_prova, Tipo: string): IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('200200', Result);

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['id'] := id_prova;
  XMLExame.Attributes['tipo'] := Tipo;

end;

end.
