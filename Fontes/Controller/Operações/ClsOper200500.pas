unit ClsOper200500;

interface
  uses
    ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
    System.SysUtils, ClsProva, ClsParametros, ClsFuncoes, System.Classes,
    Datasnap.DBClient, Data.DB, Soap.XSBuiltIns;

type
  Operacao200500 = class(TComponent)

  protected
    FUsuario: string;
    FId_prova: Integer;
    Fcodigo: string;
    Fmensagem: string;
    FTipo: string;
    Fid_cfc: string;
    FFoto: WideString;
    FBloqueio: string;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;

    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure SetTipo(ParTipo: String);
    procedure SetId_prova(ParId_prova: Integer);
    Procedure MontaXMLEnvio(Sender: TObject);
  public

    property Usuario: String read FUsuario write SetUsuario;
    property Id_prova: Integer read FId_prova write SetId_prova;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property Tipo: String read FTipo write SetTipo;
    property id_cfc: String read Fid_cfc write Fid_cfc;
    property Foto: WideString read FFoto write FFoto;
    property Bloqueio: String read FBloqueio write FBloqueio;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

Procedure Operacao200500.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  NoExame: IXMLNode;
  NoResultado: IXMLNode;
begin

  try
    LerXML := NewXMLDocument;
    // Aqui emplemeta a rotina de retorno
    try
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetorno;
      LerXML.Active := True;
    except
      on Erro: Exception do
      begin
        GravaArquivoLog(self,'Operação 200500 - Retorno Padrão - ' + Erro.Message);
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
    end;

    // Aqui emplemeta a rotina de retorno
    if (Trim(Operacao.XMLRetorno) <> '') then
    begin
      if Trim(LerXML.Xml.Text) <> '' then
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
                mensagem := NoMensagem.Text;

            end
            else
            begin

              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];

              NoExame := NoRetorno.ChildNodes.FindNode('exame');
              if NoExame <> nil then
              begin
                NoResultado := NoExame.ChildNodes.FindNode('resultado');
              end;
            end;
        end;
      end;
    end;
  except
    on Erro: Exception do
    begin
      GravaArquivoLog(self,'Operação 200500 - Retorno Padrão - ' + Erro.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(Self);

end;

procedure Operacao200500.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
end;

procedure Operacao200500.SetId_prova(ParId_prova: Integer);
begin
  FId_prova := ParId_prova;
  if (Trim(Fid_cfc) <> '') and (FId_prova <> 0) and (Trim(FTipo) <> '') then
    MontaXMLEnvio(Self);
end;

procedure Operacao200500.SetTipo(ParTipo: String);
begin
  FTipo := ParTipo;
  if (Trim(Fid_cfc) <> '') and (FId_prova <> 0) and (Trim(FTipo) <> '') then
    MontaXMLEnvio(Self);
end;

Procedure Operacao200500.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  NoFoto: IXMLNode;
  XmlTexto: WideString;
begin

  if (Trim(Fid_cfc) = '') or (FId_prova = 0) or (Trim(FTipo) = '') then
  begin
    codigo := 'B999';
    mensagem := 'Falta parametros para executar a consulta!';
  end;

  if FBloqueio = '' then
    FBloqueio := 'N';

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '200500';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Text := ' ';
  XMLExame.Attributes['id'] := Id_prova;
  XMLExame.Attributes['tipo'] := Tipo;
  XMLExame.Attributes['bloqueio'] := FBloqueio;

  NoFoto := XMLExame.AddChild('foto');
  NoFoto.Text := Foto;

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(Self,
    '<?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
