unit ClsOper100700;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, System.Classes, ClsCFCControl, ClsParametros, ClsDetecta,
  ClsServidorControl, ClsListaBloqueio, ClsEnvioMCP, ClsRetornoMCP;

type

  T100700Envio = class(TEnvioMCP)
    Function MontaXMLEnvio: IXMLDocument;
  end;

  T100700Retorno = class(TRetornoMCP)
    Procedure MontarRetorno(XMLDoc: IXMLDocument);
  end;

implementation

uses ClsFuncoes;

Procedure T100700Retorno.MontarRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  I: Integer;
begin

  try

    Self.Retorno(XMLDoc);

    if Self.IsValid then
    begin
      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');

      ParProcessosServicosProibidos := ProcessosServicosProibidos.Create;

      ParDetecta.Enviar_Processos := NoRetorno.ChildNodes.FindNode('programas')
        .Attributes['enviar_processos'];

      for I := 0 to NoRetorno.ChildNodes.FindNode('programas')
        .ChildNodes.Count - 1 do
      begin
        ParProcessosServicosProibidos.ID.Add
          (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
          .Attributes['id']);

        ParProcessosServicosProibidos.Processos.Add
          (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
          .ChildNodes.FindNode('executavel').Text);

        ParProcessosServicosProibidos.Janelas.Add
          (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
          .ChildNodes.FindNode('janela').Text);

        ParProcessosServicosProibidos.Servicos.Add
          (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
          .ChildNodes.FindNode('servico').Text);
      end;

      if NoRetorno.ChildNodes.FindNode('hardwares') <> nil then
      begin
        ParListaDispositivos.Quantidades :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode('softwares_ignorados')
          .Attributes['quantidade'], 0);

        if NoRetorno.ChildNodes.FindNode('softwares_ignorados')
          .HasAttribute('ativo') then
          ParListaDispositivos.Ativo :=
            (NoRetorno.ChildNodes.FindNode('softwares_ignorados').Attributes
            ['ativo'] = 'S');

        ParListaDispositivos.Classe.Clear;
        for I := 0 to NoRetorno.ChildNodes.FindNode('hardwares')
          .ChildNodes.Count - 1 do
          ParListaDispositivos.Classe.Add
            (NoRetorno.ChildNodes.FindNode('hardwares').ChildNodes.Get(I).Text);
      end;

      if NoRetorno.ChildNodes.FindNode('softwares_ignorados') <> nil then
      begin

        ParListaAplicativos.Quantidades :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode('softwares_ignorados')
          .Attributes['quantidade'], 0);

        if NoRetorno.ChildNodes.FindNode('softwares_ignorados')
          .HasAttribute('ativo') then
          ParListaAplicativos.Ativo :=
            (NoRetorno.ChildNodes.FindNode('softwares_ignorados').Attributes
            ['ativo'] = 'S');

        if NoRetorno.ChildNodes.FindNode('softwares_ignorados')
          .HasAttribute('classe') then
          ParListaAplicativos.Classe.Add
            (NoRetorno.ChildNodes.FindNode('softwares_ignorados').Attributes
            ['classe']);

        ParListaAplicativos.ListaSoftwaresIgnodos.Clear;
        for I := 0 to NoRetorno.ChildNodes.FindNode('softwares_ignorados')
          .ChildNodes.Count - 1 do
          ParListaAplicativos.ListaSoftwaresIgnodos.Add
            (NoRetorno.ChildNodes.FindNode('softwares_ignorados')
            .ChildNodes.Get(I).Text);
      end;

      if NoRetorno.ChildNodes.FindNode('processos') <> nil then
      begin
        ParListaProcessosAtivos.Quantidades :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode('processos').Attributes
          ['quantidade'], 0);

        if NoRetorno.ChildNodes.FindNode('processos').HasAttribute('ativo') then
          ParListaProcessosAtivos.Ativo :=
            (NoRetorno.ChildNodes.FindNode('processos').Attributes
            ['ativo'] = 'S');

        for I := 0 to NoRetorno.ChildNodes.FindNode('processos')
          .ChildNodes.Count - 1 do
          ParListaProcessosAtivos.Classe.Add
            (NoRetorno.ChildNodes.FindNode('processos').ChildNodes.Get(I).Text);
      end;

      if NoRetorno.ChildNodes.FindNode('servicos') <> nil then
      begin
        ParListaServicosAtivos.Quantidades :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode('servicos').Attributes
          ['quantidade'], 0);

        if NoRetorno.ChildNodes.FindNode('servicos').HasAttribute('ativo') then
          ParListaServicosAtivos.Ativo :=
            (NoRetorno.ChildNodes.FindNode('servicos').Attributes
            ['ativo'] = 'S');

        for I := 0 to NoRetorno.ChildNodes.FindNode('servicos')
          .ChildNodes.Count - 1 do
          ParListaServicosAtivos.Classe.Add
            (NoRetorno.ChildNodes.FindNode('servicos').ChildNodes.Get(I).Text);
      end;

      if NoRetorno.ChildNodes.FindNode('mac_adress') <> nil then
      begin
        ParMacAdress.Quantidades :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode('mac_adress').Attributes
          ['quantidade'], 0);

        if NoRetorno.ChildNodes.FindNode('mac_adress').HasAttribute('ativo')
        then
          ParMacAdress.Ativo := (NoRetorno.ChildNodes.FindNode('mac_adress')
            .Attributes['ativo'] = 'S');

        ParMacAdress.Classe.Clear;
        for I := 0 to NoRetorno.ChildNodes.FindNode('mac_adress')
          .ChildNodes.Count - 1 do
          ParMacAdress.Classe.Add(NoRetorno.ChildNodes.FindNode('mac_adress')
            .ChildNodes.Get(I).Text);
      end;

      if NoRetorno.ChildNodes.FindNode('so') <> nil then
      begin
        ParSistemaOperacional.Quantidades :=
          StrToIntDef(NoRetorno.ChildNodes.FindNode('so').Attributes
          ['quantidade'], 0);

        if NoRetorno.ChildNodes.FindNode('so').HasAttribute('ativo') then
          ParSistemaOperacional.Ativo :=
            (NoRetorno.ChildNodes.FindNode('so').Attributes['ativo'] = 'S');

        ParSistemaOperacional.Classe.Clear;
        for I := 0 to NoRetorno.ChildNodes.FindNode('so')
          .ChildNodes.Count - 1 do
          ParSistemaOperacional.Classe.Add(NoRetorno.ChildNodes.FindNode('so')
            .ChildNodes.Get(I).Text);
      end;
    end;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Operação 100700 - Retorno Padrão - ' +
        E.Message);
      XMLDoc.Active := False;
    end;
  end;

end;

function T100700Envio.MontaXMLEnvio: IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLacesso: IXMLNode;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('100700', Result);

  XMLacesso := XMLElementoEnvio.AddChild('acesso');
  XMLacesso.Text := ' ';

end;

end.
