unit ClsOper200710;

interface
  uses
    ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
    System.SysUtils, System.Classes, ClsParametros, ClsFuncoes, System.JSON,
    Datasnap.DSClientRest, Winapi.Windows, Winapi.ShellAPI, Vcl.Dialogs,
    IdCoderMIME, Vcl.StdCtrls, ClsListaBloqueio;

type
  Operacao200710 = class abstract(TComponent)

  protected
    FIDExame: string;
    FTipoExame: string;
    FIDAluno: string;
    FCPFAluno: string;
    FIdentificacao: string;

    FCodigo: string;
    FMensagem: string;
    FMensagemTipo: string;


    FRetorno: TNotifyEvent;
    FXMLRetorno: WideString;
    Operacao: MainOperacao;

    Procedure onXMLRetorno(Sender: TObject);

  public

    MensagemBiblica: TStringList;

    property IDExame: String read FIDExame write FIDExame;
    property TipoExame: String read FTipoExame write FTipoExame;
    property IDAluno: String read FIDAluno write FIDAluno;
    property Identificacao: String read FIdentificacao write FIdentificacao;
    property CPFAluno: String read FCPFAluno write FCPFAluno;

    property codigo: String read FCodigo write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property MensagemTipo: String read FMensagemTipo write FMensagemTipo;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;

    Procedure MontaXMLEnvio(Sender: TObject);
  end;

implementation

Procedure Operacao200710.onXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  NoResumo: IXMLNode;

  I: Integer;
  indice: Integer;
  J: Integer;
begin

  MensagemBiblica := TStringList.Create;

  try
    LerXML := NewXMLDocument;

    // Aqui emplemeta a rotina de retorno
    if (Operacao.XMLRetorno <> '') then
    begin
      try
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except on Erro: Exception do
        begin
          GravaArquivoLog(self,'Operação 200710 - Retorno Padrão - ' + Erro.Message);
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

            if MensagemTipo = 'R' then
            begin
              MensagemBiblica.Add(' ');
              MensagemBiblica.Add(' ');
              MensagemBiblica.Add(' ');

              MensagemBiblica.Add(NoMensagem.Text);

              NoResumo := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('resumo');

              for I := 0 to NoResumo.ChildNodes.Count-1 do
              begin
                if NoResumo.ChildNodes.Get(I).ChildNodes.Count > 0 then
                begin
                  MensagemBiblica.Add(' ');
                  MensagemBiblica.Add(UpperCase(NoResumo.ChildNodes.Get(I).NodeName) + ' EM DESACORDO.');
                  for J := 0 to NoResumo.ChildNodes.Get(I).ChildNodes.Count -1 do
                  begin
                    MensagemBiblica.Add('     ' + NoResumo.ChildNodes.Get(I).ChildNodes.Get(J).Text);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      GravaArquivoLog(self,'Operação 200710 - Retorno Padrão - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(Self);

end;

Procedure Operacao200710.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLexame: IXMLNode;
  XMLAluno: IXMLNode;
  XMLCPFAluno: IXMLNode;
  XMLComputador: IXMLNode;
  XMLMaquina: IXMLNode;
  XMLmac: IXMLNode;
  XMLip: IXMLNode;
  XMLos: IXMLNode;

  XmlTexto: string;
  ParMaquina: Maquina;

  XMLSoftwares: IXMLNode;
  XMLSoftware: IXMLNode;

  XMLHardwares: IXMLNode;
  XMLHardware: IXMLNode;

  XMLProcessos: IXMLNode;
  XMLProcesso: IXMLNode;
  XMLListaProcesso: IXMLNode;

  XMLServicos: IXMLNode;
  XMLServico: IXMLNode;
  XMLListaServico: IXMLNode;
  cont, I, J: Integer;

begin

  try

    FIdentificacao := Parametros.Identificacao;

    ParMaquina := Maquina.Create;

    XMLDoc := NewXMLDocument;
    XMLDoc.Active := False;
    XMLDoc.Active := True;
    XMLElementoEnvio := XMLDoc.AddChild('envio');
    XMLElementoEnvio.Text := ' ';
    XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
    XMLElementoEnvio.Attributes['usuario'] := ParCFC.id_cfc;
    XMLElementoEnvio.Attributes['operacao'] := '200710';
    XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

    XMLexame := XMLElementoEnvio.AddChild('exame');
    XMLexame.Text := ' ';
    XMLexame.Attributes['id'] := Trim(IDExame);
    XMLexame.Attributes['tipo'] := Trim(TipoExame);
    XMLexame.Attributes['resumo'] := 'S';

    XMLAluno := XMLexame.AddChild('aluno');
    XMLAluno.Text := ' ';
    XMLAluno.Attributes['id'] := Trim(IDAluno);

    XMLCPFAluno := XMLAluno.AddChild('cpf');
    XMLCPFAluno.Text := Trim(CPFAluno);

    XMLComputador := XMLexame.AddChild('computador');
    XMLComputador.Text := ParCFC.Computador;
    XMLComputador.Attributes['identificacao'] := Trim(FIdentificacao);

    XMLMaquina := XMLComputador.AddChild('maquina');
    XMLMaquina.Text := ParMaquina.Nome;

    XMLmac := XMLComputador.AddChild('mac');
    if ParMacAdress.Count > 0 then
      XMLmac.Text := ParMacAdress[0]
    else
      XMLmac.Text := '00:00:00:00:00:00:00';

    XMLip := XMLComputador.AddChild('ip');
    XMLip.Text := ParMaquina.IP;

    XMLos := XMLComputador.AddChild('so');
    if ParSistemaOperacional.Count > 0 then
      XMLos.Text := ParSistemaOperacional[0]
    else
      XMLos.Text := 'Windows';

    // Softwares
    XMLSoftwares := XMLexame.AddChild('softwares');
    XMLSoftwares.Attributes['quantidade'] := IntToStr(ParListaAplicativos.Count);

    for I := 0 to ParListaAplicativos.Count - 1 do
    begin
      XMLSoftware := XMLSoftwares.AddChild('software');
      XMLSoftware.Text := ParListaAplicativos[I];
    end;

    // Hardwares
    XMLHardwares := XMLexame.AddChild('hardwares');
    XMLHardwares.Attributes['quantidade'] := IntToStr(ParListaDispositivos.Count);

    for I := 0 to ParListaDispositivos.Count - 1 do
    begin
      XMLHardware := XMLHardwares.AddChild('hardware');

      XMLHardware.Text :=
      Copy(ParListaDispositivos[I],
        Pos('|',ParListaDispositivos[I])+1 ,
        length(ParListaDispositivos[I]) - (Pos('|',ParListaDispositivos[I])-1));

      XMLHardware.Text := StringReplace(XMLHardware.Text, '&','*', [rfReplaceAll, rfIgnoreCase]);
      XMLHardware.Text := StringReplace(XMLHardware.Text, '\','#', [rfReplaceAll, rfIgnoreCase]);

      XMLHardware.Attributes['tipo'] := Copy(ParListaDispositivos[I], 1, Pos('|',ParListaDispositivos[I])-1);
    end;

    // Processos
    XMLProcessos := XMLexame.AddChild('processos');

    cont := 0;
    for I := 0 to ParListaProcessosAtivos.Count - 1 do
    begin
      if ParProcessosServicosProibidos.Processos.IndexOf(ParListaProcessosAtivos[I]) > -1 then
      begin

        XMLProcesso := XMLProcessos.AddChild('processo');
        XMLProcesso.Text := ParListaProcessosAtivos[I];

        XMLProcesso.Attributes['id'] :=
          ParProcessosServicosProibidos.ID[
            ParProcessosServicosProibidos.Processos.IndexOf(ParListaProcessosAtivos[I])];

        Inc(cont);
      end;
    end;

    XMLProcessos.Attributes['quantidade'] := IntToStr(cont);
    XMLListaProcesso := XMLProcessos.AddChild('lista');

    if ParListaProcessosAtivos.Count > 0 then
    begin
      XMLListaProcesso.Text := ParListaProcessosAtivos[0];

      for I := 1 to ParListaProcessosAtivos.Count -1 do
        XMLListaProcesso.Text := XMLListaProcesso.Text + ','+ ParListaProcessosAtivos[I];
    end;

    // Serviços
    XMLServicos := XMLexame.AddChild('servicos');

    cont := 0;
    for I := 0 to ParListaServicosAtivos.Count - 1 do
    begin

      for J := 0 to ParProcessosServicosProibidos.Servicos.Count -1  do
      begin

        if UpperCase(ParProcessosServicosProibidos.Servicos[J]) =
            UpperCase(
              Copy(ParListaServicosAtivos[I], 0,
                length(ParProcessosServicosProibidos.Servicos[J]))) Then
        begin
          XMLServico := XMLServicos.AddChild('servico');
          XMLServico.Text := ParListaServicosAtivos[I];

          XMLServico.Attributes['id'] := ParProcessosServicosProibidos.ID[J];
          Inc(cont);
        end;

      end;

    end;

    XMLServicos.Attributes['quantidade'] := IntToStr(cont);
    XMLListaServico := XMLServicos.AddChild('lista');

    if ParListaServicosAtivos.Count > 0 then
    begin
      XMLListaServico.Text := ParListaServicosAtivos[0];

      for I := 1 to ParListaServicosAtivos.Count -1 do
        XMLListaServico.Text := XMLListaServico.Text +','+ ParListaServicosAtivos[I];
    end;

    XMLDoc.SaveToXML(XmlTexto);
//    XMLDoc.SaveToFile(ExtractFilePath(ParamStr(0))+'Env200710.xml');
//    XMLDoc.Free;

    Operacao := MainOperacao.Create(Self, '<?xml version="1.0" encoding="UTF-8"?>' + XmlTexto, onXMLRetorno);
    Operacao.consutar;

  except on E: Exception do
    GravaArquivoLog(self,'Operção 200710 - '+E.Message );
  end;

end;


end.
