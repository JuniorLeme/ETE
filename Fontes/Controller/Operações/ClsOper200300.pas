unit ClsOper200300;

interface
uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsParametros, ClsProva, System.Classes;

type
  Operacao200300 = class(TComponent)
  protected
    FUsuario: string;
    Fid_prova: Integer;
    FTipo: string;
    FAndamento: string;
    FTempo: Integer;
    Fcodigo: string;
    Fmensagem: string;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;

    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure Setid_prova(Parid_prova: Integer);
    procedure SetTipo(ParTipo: String);
    procedure SetAndamento(ParAndamento: String);
    procedure SetTempo(ParTempo: Integer);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property Usuario: String read FUsuario write SetUsuario;
    property id_prova: Integer read Fid_prova write Setid_prova;
    property Tipo: String read FTipo write SetTipo;
    property Andamento: String read FAndamento write SetAndamento;
    property Tempo: Integer read FTempo write SetTempo;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  published
  end;

implementation

uses ClsFuncoes;

Procedure Operacao200300.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
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
        GravaArquivoLog(self, 'Operação 200300 - Retorno Padrão - ' +
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
            end;
        end;
      end;
    end;
  except
    on Erro: Exception do
    begin
      GravaArquivoLog(self,'Operação 200300 - Retorno Padrão - ' + Erro.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(self);
end;

procedure Operacao200300.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Trim(FUsuario) <> '') and (Trim(FTipo) <> '') and (Trim(FAndamento) <> '')
    and (Fid_prova <> 0) then
    MontaXMLEnvio(self);
end;

procedure Operacao200300.Setid_prova(Parid_prova: Integer);
begin
  Fid_prova := Parid_prova;
  if (Trim(FUsuario) <> '') and (Trim(FTipo) <> '') and (Trim(FAndamento) <> '')
    and (Fid_prova <> 0) then
    MontaXMLEnvio(self);
end;

procedure Operacao200300.SetTipo(ParTipo: String);
begin
  FTipo := ParTipo;
  if (Trim(FUsuario) <> '') and (Trim(FTipo) <> '') and (Trim(FAndamento) <> '')
    and (Fid_prova <> 0) then
    MontaXMLEnvio(self);
end;

procedure Operacao200300.SetAndamento(ParAndamento: String);
begin
  FAndamento := ParAndamento;
  if (Trim(FUsuario) <> '') and (Trim(FTipo) <> '') and (Trim(FAndamento) <> '')
    and (Fid_prova <> 0) then
    MontaXMLEnvio(self);
end;

procedure Operacao200300.SetTempo(ParTempo: Integer);
begin
  FTempo := ParTempo;
  if (Trim(FUsuario) <> '') and (Trim(FTipo) <> '') and (Trim(FAndamento) <> '')
    and (Fid_prova <> 0) then
    MontaXMLEnvio(self);
end;

Procedure Operacao200300.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLAndamento: IXMLNode;
  XMLTempo: IXMLNode;
  XmlTexto: string;
begin

  if (Trim(FUsuario) = '') or (Trim(FTipo) = '') or (Trim(FAndamento) = '') then
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
  XMLElementoEnvio.Attributes['operacao'] := '200300';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Attributes['id'] := IntToStr(id_prova);
  XMLExame.Attributes['tipo'] := Tipo;

  XMLAndamento := XMLExame.AddChild('andamento');
  XMLAndamento.Attributes['tipo'] := Andamento;
  XMLAndamento.Text := ' ';

  XMLTempo := XMLAndamento.AddChild('duracao');
  XMLTempo.Text := IntToStr(Tempo);

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(self,
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
