unit ClsOper200600;

interface
  uses ClsOperacoes,Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
    System.SysUtils, System.Classes, ServidorControl, ClsParametros, ClsProva;

  type
    Operacao200600 = class(TComponent)
    protected
      Fid_cfc: string;
      FComputador: string;
      FTipoProva: string;
      FCodigo: string;
      FMensagem: string;
      FRetorno : TNotifyEvent;
      Operacao: MainOperacao;

      procedure SetComputador(ParComputador: String);
      procedure SetId_cfc(Parid_cfc: String);
      procedure SetTipoProva(ParTipoProva: String);
      Procedure onMontaXMLRetorno(Sender: TObject);
      Procedure MontaXMLEnvio(Sender: TObject);
    public
      property id_cfc: String read Fid_cfc write SetId_cfc;
      property Computador: String read FComputador write SetComputador;
      property TipoProva: String read FTipoProva write SetTipoProva;
      property codigo: String read FCodigo write FCodigo;
      property mensagem: String read FMensagem write FMensagem;
      property Retorno : TNotifyEvent read FRetorno write FRetorno;
    end;

  implementation
uses ClsFuncoes;

procedure Operacao200600.SetId_cfc(Parid_cfc: String);
begin
  Fid_cfc := Parid_cfc;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200600.SetComputador(ParComputador: String);
begin
  FComputador := ParComputador;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200600.SetTipoProva(ParTipoProva: String);
begin
  FTipoProva := ParTipoProva;
  if (Trim(FComputador) <> '') and (Trim(FTipoProva) <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao200600.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: TXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
begin
  try
    LerXML := TXMLDocument.Create(self);
    // Aqui emplemeta a rotina de retorno
    try
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetorno;
      LerXML.Active := True;
    except
      on Erro: Exception do
      begin
        GravaArquivoLog('Operação 200600 - Retorno Padrão -' + Erro.Message);
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
    end;
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
            NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('texto');
            if NoMensagem <> nil then
              mensagem := NoMensagem.Text;
          end
          else
          begin
            if NoRetorno.HasAttribute('codigo') then
              codigo := NoRetorno.Attributes['codigo'];

          end;
      end;
    end;
  except
    on E: Exception do
    begin
      GravaArquivoLog('Operação 200600 - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(self);
end;

Procedure Operacao200600.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: TXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLComputador: IXMLNode;
  XmlTexto: string;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := False;
  XMLDoc.Active := True;
  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '200600';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['tipo'] := TipoProva;
  XMLExame.Attributes['id'] := ParQuestionario.Id_prova;
  XMLExame.Text := ' ';

  XMLComputador := XMLExame.AddChild('computador');
  XMLComputador.Text := Computador;

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(Self, XMLElementoEnvio.Attributes['operacao'],
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto,onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
