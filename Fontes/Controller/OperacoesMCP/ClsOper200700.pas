unit ClsOper200700;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, System.Classes, ClsParametros, ClsListaBloqueio,
  ClsCFCControl, ClsServidorControl, ClsCandidatoControl, ClsProva;

type
  Operacao200700 = class(TComponent)
  protected
    FUsuario: string;
    FSenha: string;
    FCodigo: string;
    FMensagem: string;
    FMensagemTipo: string;
    FRetorno: TNotifyEvent;
    FXMLRetorno: WideString;
    Operacao: MainOperacao;

    Procedure onXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure SetSenha(ParSenha: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property Usuario: String read FUsuario write SetUsuario;
    property Senha: String read FSenha write SetSenha;
    property codigo: String read FCodigo write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property MensagemTipo: String read FMensagemTipo write FMensagemTipo;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

uses ClsFuncoes;

Procedure Operacao200700.onXMLRetorno(Sender: TObject);
var
  LerXML: TXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
begin

  try
    LerXML := TXMLDocument.Create(Self);
    // Aqui emplemeta a rotina de retorno
    if (Operacao.XMLRetorno <> '') then
    begin
      try
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except
        on Erro: Exception do
        begin
          GravaArquivoLog('Operação 200700 - Retorno Padrão - ' + Erro.Message);
          LerXML.Active := False;
          LerXML.Xml.Clear;
          LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
          LerXML.Active := True;
        end;
      end;

      if LerXML.Xml.Text <> '' then
      begin
        NoRetorno := LerXML.ChildNodes.FindNode('retorno');
        if NoRetorno <> nil then
        begin
          if NoRetorno.HasAttribute('codigo') then
          begin
            if NoRetorno.HasAttribute('codigo') then
              codigo := NoRetorno.Attributes['codigo'];

            NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('texto');

            if NoRetorno.ChildNodes.FindNode('mensagem').HasAttribute('tipo') then
              MensagemTipo := NoRetorno.ChildNodes.FindNode('mensagem').Attributes['tipo']
            else
              MensagemTipo := 'I';

            if NoMensagem <> nil then
              Mensagem := NoMensagem.Text;
          end;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      GravaArquivoLog('Operação 200700 - Retorno Padrão - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  LerXML.Free;
  FRetorno(Self);

end;

procedure Operacao200700.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') then
    MontaXMLEnvio(Self);
end;

procedure Operacao200700.SetSenha(ParSenha: String);
begin
  FSenha := ParSenha;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') then
    MontaXMLEnvio(Self);
end;

Procedure Operacao200700.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: TXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLexame: IXMLNode;
  XMLaluno: IXMLNode;
  XMLalunoCPF: IXMLNode;
  XMLProgramas: IXMLNode;
  XMLPrograma: IXMLNode;
  XMLprocessos: IXMLNode;
  XMLprocessosLista: IXMLNode;
  XMLProgramaDescricao: IXMLNode;
  XMLNomeMac: IXMLNode;
  XMLMac: IXMLNode;
  XMLIP: IXMLNode;
  XmlTexto: string;
  I: Integer;
  ParMaquina: Maquina;
begin

  if (Trim(FUsuario) = '') or (Trim(FSenha) = '') then
  begin
    codigo := 'D998';
    Mensagem := 'Falta parametros para executar a consulta!';
  end;

  XMLDoc := TXMLDocument.Create(Self);
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';

  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := ParCFC.id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '200700';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLexame := XMLElementoEnvio.AddChild('exame');
  XMLexame.Text := ' ';
  XMLexame.Attributes['id'] := ParQuestionario.Id_prova;
  XMLexame.Attributes['tipo'] := ParCandidato.TipoProva;

  XMLaluno := XMLexame.AddChild('aluno');
  XMLaluno.Text := ' ';
  XMLaluno.Attributes['id'] := ParCandidato.IdCandidato;

  XMLalunoCPF := XMLaluno.AddChild('cpf');
  XMLalunoCPF.Text := ParCandidato.CPFCandidato;

  ParProcessosServicosProibidosAtivos := ProcessosServicosProibidosAtivos.Create;

  XMLProgramas := XMLexame.AddChild('programas');
  XMLProgramas.Text := ' ';
  XMLProgramas.Attributes['quantidade'] := IntToStr(ParProcessosServicosProibidosAtivos.ID.Count);

  ParMaquina := Maquina.Create;

  for I := 0 to ParProcessosServicosProibidosAtivos.ID.Count - 1 do
  begin
    XMLPrograma := XMLProgramas.AddChild('programa');
    XMLPrograma.Text := ' ';
    XMLPrograma.Attributes['id'] := ParProcessosServicosProibidosAtivos.ID[I];

    XMLProgramaDescricao := XMLPrograma.AddChild('descricao');
    XMLProgramaDescricao.Text := ParProcessosServicosProibidosAtivos.Processos[I];
  end;

  if ParShisnine.Enviar_Processos = 'S' then
  begin
    XMLprocessos := XMLexame.AddChild('processos');
    XMLprocessos.Attributes['quantidade'] := IntToStr(ParProcessosServicosProibidos.ID.Count + ParProcessosServicosProibidos.Servicos.Count);

    XMLprocessosLista := XMLprocessos.AddChild('lista');
    ParListaProcessosAtivos.Sorted := True;
    for I := 1 to ParListaProcessosAtivos.Count - 1 do
    begin
      XMLprocessosLista.Text := XMLprocessosLista.Text + Trim(ParListaProcessosAtivos[I] + ',');
    end;

    ParListaServicosAtivos.Sorted := True;
    for I := 0 to ParListaServicosAtivos.Count - 1 do
    begin
      XMLprocessosLista.Text := XMLprocessosLista.Text + Trim(ParListaServicosAtivos[I] + ',');
    end;

  end;

  XMLNomeMac := XMLexame.AddChild('maquina');
  XMLNomeMac.Text := ParMaquina.Nome;

  XMLMac := XMLexame.AddChild('mac');
  XMLMac.Text := ParMaquina.MAC;

  XMLIP := XMLexame.AddChild('ip');
  XMLIP.Text := ParMaquina.IP;

  XMLNomeMac := XMLexame.AddChild('computador');
  XMLNomeMac.Text := Parametros.Computador;

  ParMaquina.Free;

  XMLDoc.SaveToXML(XmlTexto);
  XMLDoc.Free;

  Operacao := MainOperacao.Create(Self, XMLElementoEnvio.Attributes['operacao'], '<?xml version="1.0" encoding="UTF-8"?>' + XmlTexto, onXMLRetorno);
  Operacao.consutar;

end;

end.
