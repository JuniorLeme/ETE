unit ClsOper400100;

interface
  uses ClsOperacoes,Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
       System.SysUtils, ClsParametros, System.Classes;

type
  Operacao400100 = class(TComponent)
  protected
    Fcodigo: string;
    Fmensagem: string;
    Fid_cfc: string;
    FArquivo: string;
    FServer: string;
    FStream: string;
    FTipo: string;
    Fid_prova: Integer;
    FRetorno : TNotifyEvent;
    Operacao : MainOperacao;

    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure Setid_cfc(Parid_cfc: String);
    procedure SetArquivo(ParArquivo: String);
    procedure SetStream(ParStream: String);
    procedure SetTipo(ParTipo: String);
    procedure SetId_Prova(ParId_Prova: Integer);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property codigo: String    read Fcodigo   write Fcodigo;
    property mensagem: String  read Fmensagem write Fmensagem;
    property id_cfc: String    read Fid_cfc   write Setid_cfc;
    property Tipo: String      read FTipo     write SetTipo;
    property id_prova: Integer read Fid_prova write Setid_prova;
    property Arquivo: String   read FArquivo  write SetArquivo;
    property Server: String    read FServer   write FServer;
    property Stream: String    read FStream   write SetStream;
    property Retorno : TNotifyEvent read FRetorno write FRetorno;
  end;

implementation
  uses ClsFuncoes;

Procedure Operacao400100.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  NoId_Cfc: IXMLNode;
begin
  try
    LerXML := NewXMLDocument;
    // Aqui emplemeta a rotina de retorno
    if (Trim(Operacao.XMLRetorno) <> '') then
    begin
      try
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except on Erro : Exception do
      begin
        GravaArquivoLog(self,'Operação 400100 - Retorno Padrão - '+Erro.Message);
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
      end;

      if Trim(LerXML.XML.Text) <> '' then
      begin
        NoRetorno := LerXML.ChildNodes.FindNode('retorno');
        if NoRetorno <> nil then
        begin
          if NoRetorno.HasAttribute('codigo') then
            if (NoRetorno.Attributes['codigo'] <> 'B000') or
               (NoRetorno.Attributes['codigo'] <> 'D555') then
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];

              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('texto');
              if NoMensagem <> nil then
              begin
                mensagem := NoMensagem.Text;
              end;
            end
            else
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
              NoId_Cfc := NoRetorno.ChildNodes.FindNode('id_cfc');

              if NoId_Cfc <> nil then
                id_cfc := NoId_Cfc.Text;
            end;
        end;
      end;
    end;

  except on E: Exception do
  begin
    GravaArquivoLog(self,'Operação 400100 - Retorno Padrão - '+E.Message);
    LerXML.Active := False;
    LerXML.XML.Clear;
    LerXML.XML.Text := Operacao.XMLRetornoPadrao;
    LerXML.Active := True;
  end;
  end;

  FRetorno(self);
end;

procedure Operacao400100.Setid_cfc(Parid_cfc: String);
begin
  Fid_cfc := Parid_cfc;
  if (Trim(Fid_cfc) <> '') and (Trim(FArquivo) <> '') and
     (FId_Prova <> 0) and (Trim(FTipo) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao400100.SetArquivo(ParArquivo: String);
begin
  FArquivo := ParArquivo;
  if (Trim(Fid_cfc) <> '') and (Trim(FArquivo) <> '') and
     (FId_Prova <> 0)and (Trim(FTipo) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao400100.SetStream(ParStream: String);
begin
  FStream := ParStream;
  if (Trim(Fid_cfc) <> '') and (Trim(FArquivo) <> '') and
     (FId_Prova <> 0)and (Trim(FTipo) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao400100.SetTipo(ParTipo: String);
begin
  FTipo := ParTipo;
  if (Trim(Fid_cfc) <> '') and (Trim(FTipo) <> '') and
     (Trim(FArquivo) <> '') and (FId_Prova <> 0) then
    MontaXMLEnvio(self);
end;

procedure Operacao400100.SetId_Prova(ParId_Prova: Integer);
begin
  FId_Prova := ParId_Prova;
  if (Trim(Fid_cfc) <> '') and (Trim(FTipo) <> '') and
     (Trim(FArquivo) <> '') and (FId_Prova <> 0) then
    MontaXMLEnvio(self);
end;

Procedure Operacao400100.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLmonitoramento: IXMLNode;
  XMLarquivo: IXMLNode;
  XMLserver: IXMLNode;
  XMLstream: IXMLNode;
  XMLComputador: IXMLNode;
  XmlTexto: string;
begin

  if (Trim(Fid_cfc) = '') or (Trim(FArquivo) = '') or (Trim(FTipo) = '') then
  begin
    codigo := 'B999';
    mensagem := 'Falta parametros para executar a consulta!';
  end;

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;
  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '400100';
  XMLElementoEnvio.Attributes['versao']   := GetVersaoArq;

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['id'] :=  IntToStr(id_prova);
  XMLExame.Attributes['tipo'] := Tipo;
  XMLExame.Attributes['computador'] := ParCFC.Computador;

  XMLComputador := XMLExame.AddChild('computador');
  XMLComputador.Text := ParCFC.Computador;

  XMLmonitoramento := XMLExame.AddChild('monitoramento');

  if (ParMonitoramento.Situacao = 'V') or
     (ParMonitoramento.Situacao = 'I') then
    XMLmonitoramento.Attributes['situacao'] := 0;

  if (ParMonitoramento.Situacao <> 'V') and
     (ParMonitoramento.Situacao <> 'I') then
    XMLmonitoramento.Attributes['situacao'] := 1;

  XMLarquivo := XMLmonitoramento.AddChild('arquivo');
  XMLarquivo.Text := Arquivo;

  XMLserver := XMLmonitoramento.AddChild('server');
  XMLserver.Text := Server;

  XMLstream := XMLmonitoramento.AddChild('stream');

  if Trim(Stream) = '' then
    XMLstream.Text := 'stream1.eprova.ba.grupocriar.com.br'
  else
    XMLstream.Text := Stream;

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(Self,'<?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto,onMontaXMLRetorno);
  Operacao.consutar;
end;

end.

