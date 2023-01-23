unit ClsOper100400;

interface
  uses ClsOperacoes,Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
       System.SysUtils, ServidorControl, ClsParametros, System.Classes;

type
  Operacao100400 = class(TComponent)
  protected
    FUsuario: string;
    FSenha: string;
    FComputador: string;
    Fcodigo: string;
    Fmensagem: string;
    Fnome_fantasia: string;
    Fid_cfc: string;
    FRetorno : TNotifyEvent;
    Operacao : MainOperacao;
    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure SetSenha(ParSenha: String);
    procedure SetComputador(ParComputador: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property Usuario: String read FUsuario write SetUsuario;
    property Senha: String read FSenha write SetSenha;
    property Computador: String read FComputador write SetComputador;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property nome_fantasia: String read Fnome_fantasia write Fnome_fantasia;
    property id_cfc: String read Fid_cfc write Fid_cfc;
    property Retorno : TNotifyEvent read FRetorno write FRetorno;
  end;

implementation
  uses ClsFuncoes;

Procedure Operacao100400.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: TXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
begin
  try
    LerXML := TXMLDocument.Create(Self);
    if (Operacao.XMLRetorno <> '') then
    begin
      try
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except on E: Exception do
      begin
        GravaArquivoLog(' Operação 100400 - Retorno Padrão - '+ e.Message);
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
      end;

      // Aqui emplemeta a rotina de retorno
      if Trim(LerXML.XML.Text) <> '' then
      begin
        NoRetorno := LerXML.ChildNodes.FindNode('retorno');
        if NoRetorno <> nil then
        begin
          if NoRetorno.HasAttribute('codigo') then
            if NoRetorno.Attributes['codigo'] <> 'B000' then
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
              //NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem');
              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('texto');
              if NoMensagem <> nil then
                mensagem := NoMensagem.Text;
            end else begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
            end;
        end;
      end;
    end;
  except on E: Exception do
  begin
    GravaArquivoLog(' Operação 100400 - Retorno Padrão - '+ e.Message);
    LerXML.Active := False;
    LerXML.XML.Clear;
    LerXML.XML.Text := Operacao.XMLRetornoPadrao;
    LerXML.Active := True;
  end;
  end;

  FRetorno(self);
end;

procedure Operacao100400.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') and (Trim(FComputador) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao100400.SetSenha(ParSenha: String);
begin
  FSenha := ParSenha;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') and (Trim(FComputador) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao100400.SetComputador(ParComputador: String);
begin
  FComputador := ParComputador;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') and (Trim(FComputador) <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao100400.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: TXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLUsuario: IXMLNode;
  XMLSenha: IXMLNode;
  XMLComputador: IXMLNode;
  XmlTexto: string;
begin

  if (Trim(FUsuario) = '') or (Trim(FSenha) = '') or (Trim(FComputador) = '')
  then
  begin
    codigo := 'D998';
    mensagem := 'Falta parametros para executar a consulta!';
  end;

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := False;
  XMLDoc.Active := True;
  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := '0';
  XMLElementoEnvio.Attributes['operacao'] := '100400';
  XMLElementoEnvio.Attributes['versao']   := GetVersaoArq;
  XMLUsuario := XMLElementoEnvio.AddChild('usuario');
  XMLUsuario.Text := Usuario;
  XMLSenha := XMLElementoEnvio.AddChild('senha');
  XMLSenha.Text := Senha;
  XMLComputador := XMLElementoEnvio.AddChild('computador');
  XMLComputador.Text := Computador;
  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(Self, XMLElementoEnvio.Attributes['operacao'],
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto,onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
