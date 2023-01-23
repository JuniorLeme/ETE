unit ClsOper300100;

interface

uses ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsParametros, System.Classes;

type
  Operacao300100 = class(TComponent)
  protected
    Fid_cfc: string;
    FID_Aluno: string;

    Fcodigo: string;
    Fmensagem: string;
    FFoto: WideString;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;

    Procedure onMontaXMLRetorno(Sender: TObject);
    Procedure SetID_Aluno(ID_Aluno: String);
    Procedure Setid_cfc(id_cfc: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public

    property id_cfc: String read Fid_cfc write Setid_cfc;
    property ID_Aluno: String read FID_Aluno write SetID_Aluno;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property Foto: WideString read FFoto write FFoto;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

uses ClsFuncoes;

Procedure Operacao300100.SetID_Aluno(ID_Aluno: String);
begin
  FID_Aluno := Trim(ID_Aluno);

  if (FID_Aluno <> '') and (Fid_cfc <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao300100.Setid_cfc(id_cfc: String);
begin
  Fid_cfc := Trim(id_cfc);

  if (FID_Aluno <> '') and (Fid_cfc <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao300100.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
begin

  try
    // Aqui emplemeta a rotina de retorno
    if (Trim(Operacao.XMLRetorno) <> '') then
    begin
      LerXML := NewXMLDocument;

      try
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except
        on Erro: Exception do
        begin
          GravaArquivoLog(self,'Operação 300100 - Retorno Padrão - ' + Erro.Message);
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
            codigo := NoRetorno.Attributes['codigo'];

          if codigo <> 'B000' then
          begin
            NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem')
              .ChildNodes.FindNode('texto');
            if NoMensagem <> nil then
              mensagem := NoMensagem.Text;
          end
          else
          begin
            mensagem := 'Presença registrada com sucesso!';
          end;
        end;
      end;
    end;
  except
    on Erro: Exception do
    begin

      GravaArquivoLog(self,'Operação 300100 - Retorno Padrão - ' + Erro.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(self);
end;

Procedure Operacao300100.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLID_Aluno: IXMLNode;
  NoFoto: IXMLNode;
  XmlTexto: string;
begin

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '300100';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLID_Aluno := XMLElementoEnvio.AddChild('aluno');
  XMLID_Aluno.Text := ' ';
  XMLID_Aluno.Attributes['id'] := ID_Aluno;

  NoFoto := XMLID_Aluno.AddChild('foto');
  NoFoto.Text := Foto;

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(self,
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
