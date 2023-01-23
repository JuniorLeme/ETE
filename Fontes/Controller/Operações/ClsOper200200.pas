unit ClsOper200200;

interface
uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsParametros, ClsProva, System.Classes;

type
  Operacao200200 = class(TComponent)
  protected
    FUsuario: string;
    Fid_prova: Integer;
    Ftipo: string;
    Fcodigo: string;
    Fmensagem: string;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;

    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure Setid_prova(Parid_prova: Integer);
    procedure Settipo(Partipo: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property Usuario: String read FUsuario write SetUsuario;
    property id_prova: Integer read Fid_prova write Setid_prova;
    property tipo: String read Ftipo write Settipo;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

uses ClsFuncoes;

procedure Operacao200200.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Fid_prova <> 0) and (Trim(Ftipo) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200200.Setid_prova(Parid_prova: Integer);
begin
  Fid_prova := Parid_prova;
  if (Fid_prova <> 0) and (Trim(Ftipo) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao200200.Settipo(Partipo: String);
begin
  Ftipo := Partipo;
  if (Fid_prova <> 0) and (Trim(Ftipo) <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao200200.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  Nocfclive: IXMLNode;
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
        GravaArquivoLog(self, 'Operação 200200 - Retorno Padrão - ' +
          Erro.Message);
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

              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem')
                .ChildNodes.FindNode('texto');
              if NoMensagem <> nil then
                mensagem := NoMensagem.Text;
            end
            else
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];

              Nocfclive := NoRetorno.ChildNodes.FindNode('cfclive');
              if Nocfclive <> nil then
              begin

                ParMonitoramento.cfcliveSituacao :=
                  StrToIntDef(Nocfclive.Attributes['situacao'], 0);
                ParMonitoramento.cfcliveTipo := Nocfclive.Attributes['tipo'];

                if Nocfclive.ChildNodes.FindNode('dica') <> nil then
                  ParMonitoramento.cfcliveHint := Nocfclive.ChildNodes.FindNode
                    ('dica').Text;

                if Nocfclive.ChildNodes.FindNode('mensagem') <> nil then
                  ParMonitoramento.cfcliveMensagem :=
                    Nocfclive.ChildNodes.FindNode('mensagem').Text;

              end
              else
              begin
                ParMonitoramento.cfcliveSituacao := 0;
              end;
            end;
        end;
      end;
    end;

    GravaArquivoLog(self, 'Operação 200200 - Código: ' + self.codigo +
      ' Descrição: ' + self.mensagem);

  except
    on Erro: Exception do
    begin
      GravaArquivoLog(self, 'Operação 200200 - Retorno Padrão - ' +
        Erro.Message);

      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(self);
end;

Procedure Operacao200200.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XmlTexto: string;
begin

  if (Trim(FUsuario) = '') or (Trim(Ftipo) = '') then
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
  XMLElementoEnvio.Attributes['usuario'] := Usuario;
  XMLElementoEnvio.Attributes['operacao'] := '200200';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['id'] := IntToStr(id_prova);
  XMLExame.Attributes['tipo'] := tipo;

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(self,
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
