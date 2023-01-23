unit ClsOper200710;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, System.Classes, ClsParametros, ClsFuncoes, System.JSON,
  Datasnap.DSClientRest, Winapi.Windows, Winapi.ShellAPI, Vcl.Dialogs,
  Vcl.StdCtrls, ClsServidorControl, ClsCFCControl, ClsListaBloqueio,
  ClsEnvioMCP, ClsRetornoMCP;

type
  T200710Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(IDExame, TipoExame, IDAluno, CPFAluno: String)
      : IXMLDocument;
  end;

  T200710Retorno = class(TRetornoMCP)
    MensagemDetecta: TStringList;
    Procedure MontaRetorno(XMLDoc: IXMLDocument);
  end;

implementation

Procedure T200710Retorno.MontaRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoResumo: IXMLNode;

  I: Integer;
  J: Integer;
begin

  Self.Retorno(XMLDoc);

  MensagemDetecta := TStringList.Create;

  try

    if not Self.IsValid then
    begin

      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');

      ArquivoLog.GravaArquivoLog('Operação 200710 - Retorno - ' + Self.FCodigo +
        ' ' + Self.Mensagem);

      if MensagemTipo = 'R' then
      begin
        MensagemDetecta.Add(' ');
        MensagemDetecta.Add(' ');
        MensagemDetecta.Add(' ');

        MensagemDetecta.Add(Self.Mensagem);

        NoResumo := NoRetorno.ChildNodes.FindNode('mensagem')
          .ChildNodes.FindNode('resumo');

        for I := 0 to NoResumo.ChildNodes.Count - 1 do
        begin
          if NoResumo.ChildNodes.Get(I).ChildNodes.Count > 0 then
          begin
            MensagemDetecta.Add(' ');
            MensagemDetecta.Add(UpperCase(NoResumo.ChildNodes.Get(I).NodeName) +
              ' EM DESACORDO.');
            for J := 0 to NoResumo.ChildNodes.Get(I).ChildNodes.Count - 1 do
            begin
              MensagemDetecta.Add('     ' + NoResumo.ChildNodes.Get(I)
                .ChildNodes.Get(J).Text);
            end;
          end;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Operação 200710 - Retorno Padrão - ' +
        E.Message);
      XMLDoc.Active := False;
    end;
  end;

end;

function T200710Envio.MontaXMLEnvio(IDExame, TipoExame, IDAluno,
  CPFAluno: String): IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLexame: IXMLNode;
  XMLAluno: IXMLNode;
  XMLCPFAluno: IXMLNode;
  XMLComputador: IXMLNode;
  XMLMaquina: IXMLNode;
  XMLmac: IXMLNode;
  XMLip: IXMLNode;
  XMLos: IXMLNode;

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

    ParMaquina := Maquina.Create;

    if ParMacAdress = nil then
      ParMacAdress := TMacAdress.Create;

    if ParSistemaOperacional = nil then
      ParSistemaOperacional := TSistemaOperacional.Create;

    if ParListaAplicativos = nil then
      ParListaAplicativos := TListaAplicativos.Create;

    if ParListaDispositivos = nil then
      ParListaDispositivos := TListaDispositivos.Create;

    if ParListaProcessosAtivos = nil then
      ParListaProcessosAtivos := TListaProcessosAtivos.Create;

    if ParProcessosServicosProibidos = nil then
      ParProcessosServicosProibidos := ProcessosServicosProibidos.Create;

    if ParListaServicosAtivos = nil then
      ParListaServicosAtivos := TListaServicosAtivos.Create;

    Result := TXMLDocument.Create(nil);
    Result.Active := False;
    Result.Active := True;

    EnvioMCP := TEnvioMCP.GetInstance;
    XMLElementoEnvio := EnvioMCP.GetEnvioMCP('200710', Result);

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
    XMLComputador.Text := Parametros.Computador;
    XMLComputador.Attributes['identificacao'] := Trim(Parametros.Identificacao);

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
    XMLSoftwares.Attributes['quantidade'] :=
      IntToStr(ParListaAplicativos.Count);

    try
      for I := 0 to ParListaAplicativos.Count - 1 do
      begin
        XMLSoftware := XMLSoftwares.AddChild('software');
        XMLSoftware.Text := ParListaAplicativos[I];
      end;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog
          ('Verificar lista aplicativo - Operção 200710 ');
    end;

    try
      // Hardwares
      XMLHardwares := XMLexame.AddChild('hardwares');
      XMLHardwares.Attributes['quantidade'] :=
        IntToStr(ParListaDispositivos.Count);
      for I := 0 to ParListaDispositivos.Count - 1 do
      begin
        XMLHardware := XMLHardwares.AddChild('hardware');

        XMLHardware.Text := Copy(ParListaDispositivos[I],
          Pos('|', ParListaDispositivos[I]) + 1, length(ParListaDispositivos[I])
          - (Pos('|', ParListaDispositivos[I]) - 1));

        XMLHardware.Text := StringReplace(XMLHardware.Text, '&', '*',
          [rfReplaceAll, rfIgnoreCase]);
        XMLHardware.Text := StringReplace(XMLHardware.Text, '\', '#',
          [rfReplaceAll, rfIgnoreCase]);

        XMLHardware.Attributes['tipo'] := Copy(ParListaDispositivos[I], 1,
          Pos('|', ParListaDispositivos[I]) - 1);
      end;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog
          ('Verificar lista hardware - Operção 200710 ');
    end;

    try
      // Processos
      XMLProcessos := XMLexame.AddChild('processos');

      cont := 0;
      for I := 0 to ParListaProcessosAtivos.Count - 1 do
      begin

        if ParProcessosServicosProibidos.Processos.IndexOf
          (ParListaProcessosAtivos[I]) > -1 then
        begin

          XMLProcesso := XMLProcessos.AddChild('processo');
          XMLProcesso.Text := ParListaProcessosAtivos[I];

          XMLProcesso.Attributes['id'] := ParProcessosServicosProibidos.ID
            [ParProcessosServicosProibidos.Processos.IndexOf
            (ParListaProcessosAtivos[I])];

          Inc(cont);

        end;

      end;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog
          ('Verificar lista processos - Operção 200710 ');
    end;

    try
      XMLProcessos.Attributes['quantidade'] := IntToStr(cont);
      XMLListaProcesso := XMLProcessos.AddChild('lista');

      if ParListaProcessosAtivos.Count <> -1 then
      begin
        XMLListaProcesso.Text := ParListaProcessosAtivos[0];

        for I := 1 to ParListaProcessosAtivos.Count - 1 do
          XMLListaProcesso.Text := XMLListaProcesso.Text + ',' +
            ParListaProcessosAtivos[I];
      end;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog
          ('Verificar lista Processos Ativos - Operção 200710 ');
    end;

    try
      // Serviços
      XMLServicos := XMLexame.AddChild('servicos');

      cont := 0;
      for I := 0 to ParListaServicosAtivos.Count - 1 do
      begin

        for J := 0 to ParProcessosServicosProibidos.Servicos.Count - 1 do
        begin

          if UpperCase(ParProcessosServicosProibidos.Servicos[J])
            = UpperCase(Copy(ParListaServicosAtivos[I], 0,
            length(ParProcessosServicosProibidos.Servicos[J]))) Then
          begin
            XMLServico := XMLServicos.AddChild('servico');
            XMLServico.Text := ParListaServicosAtivos[I];

            XMLServico.Attributes['id'] := ParProcessosServicosProibidos.ID[J];
            Inc(cont);
          end;

        end;

      end;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog
          ('Verificar lista serviços - Operção 200710 ');
    end;

    Try
      XMLServicos.Attributes['quantidade'] := IntToStr(cont);
      XMLListaServico := XMLServicos.AddChild('lista');

      if ParListaServicosAtivos.Count <> -1 then
      begin
        XMLListaServico.Text := ParListaServicosAtivos[0];

        for I := 1 to ParListaServicosAtivos.Count - 1 do
          XMLListaServico.Text := XMLListaServico.Text + ',' +
            ParListaServicosAtivos[I];
      end;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog
          ('Verificar lista serviços ativos - Operção 200710 ');
    end;

  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Operção 200710 - ' + E.Message);
  end;

end;

end.
