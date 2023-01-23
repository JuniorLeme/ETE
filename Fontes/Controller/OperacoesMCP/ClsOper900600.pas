unit ClsOper900600;

interface

uses
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, System.SysUtils,
  System.Classes,
  Winapi.WinInet, Soap.SOAPHTTPClient, IdHashMessageDigest, ClsWebService,
  ClsParametros,
  ClsConexaoFerramentas, ClsEnvioMCP, ClsRetornoMCP, ClsCandidatoControl,
  ClsListaProdutoID;

type

  T900600Retorno = class(TRetornoMCP)
    Procedure MontaXMLRetorno(XMLDoc: IXMLDocument);
  end;

  T900600Envio = class(TEnvioMCP)
    function MontaXMLEnvio: IXMLDocument;
    procedure HttpRioTokenBeforeExecute(const MethodName: string;
      Request: TStream);
  end;

implementation

uses ClsFuncoes;

Procedure T900600Retorno.MontaXMLRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoSistemas: IXMLNode;

  ContProduto: Integer;
  ProdutoID: TProdutoID;

begin

  // <e-prova uf="SP"> <descricao> e-CFCAnet SP </descricao> <servidor>591804 </servidor> <portas><digital>9292</digital> <foto>9393</foto> </portas> </e-prova>
  // <e-prova uf="BA"> <descricao> e-prova BA </descricao> <servidor>532997 </servidor> <portas><digital>9292</digital> <foto>9393</foto> </portas> </e-prova>
  // <e-prova uf="MG"> <descricao> e-prova MG </descricao> <servidor>872461 </servidor> <portas><digital>9292</digital> <foto>9393</foto> </portas> </e-prova>
  // <e-prova uf="SE"> <descricao> e-prova SE </descricao> <servidor>726851 </servidor> <portas><digital>9292</digital> <foto>9393</foto> </portas> </e-prova>
  // <e-prova uf="AL"> <descricao> e-prova AL </descricao> <servidor>806076 </servidor> <portas><digital>9292</digital> <foto>9393</foto> </portas> </e-prova>

  try

    Self.Retorno(XMLDoc);

    if Self.IsValid then
    begin
      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');
      NoSistemas := NoRetorno.ChildNodes.FindNode('sistemas');

      ListaProdutoID := TListaProdutoID.Create;

      for ContProduto := 0 to NoSistemas.ChildNodes.Count - 1 do
      begin

        if NoSistemas.ChildNodes.Nodes[ContProduto] <> nil then
        begin
          ProdutoID := TProdutoID.Create;
          ProdutoID.uf := NoSistemas.ChildNodes.Nodes[ContProduto]
            .Attributes['uf'];
          ProdutoID.descricao := NoSistemas.ChildNodes.Nodes[ContProduto]
            .ChildNodes.FindNode('descricao').Text;
          ProdutoID.servidor := NoSistemas.ChildNodes.Nodes[ContProduto]
            .ChildNodes.FindNode('servidor').Text;
          ProdutoID.digital :=
            StrToIntDef(NoSistemas.ChildNodes.Nodes[ContProduto]
            .ChildNodes.FindNode('portas').ChildNodes.FindNode('digital')
            .Text, 9292);
          ProdutoID.foto := StrToIntDef(NoSistemas.ChildNodes.Nodes[ContProduto]
            .ChildNodes.FindNode('portas').ChildNodes.FindNode('foto')
            .Text, 9393);

          ListaProdutoID.AddObject(ProdutoID.descricao, ProdutoID);

          // ProdutoID := nil;
        end;

      end;

      ListaProdutoID.Sort;

    end;

  except
    on e: Exception do
    begin
      if Debug then
      begin
        ArquivoLog.GravaArquivoLog('Opera��o 900600 - Retorno Padr�o - ' +
          e.Message);
        ArquivoLog.Gravar;
      end;

      XMLDoc.Active := False;
    end;
  end;

end;

procedure T900600Envio.HttpRioTokenBeforeExecute(const MethodName: string;
  Request: TStream);
var
  timeout: Integer;
begin
  timeout := 1000;

  InternetSetOption(nil, INTERNET_OPTION_CONNECT_TIMEOUT, Pointer(@timeout),
    sizeof(timeout));
  InternetSetOption(nil, INTERNET_OPTION_SEND_TIMEOUT, Pointer(@timeout),
    sizeof(timeout));
  InternetSetOption(nil, INTERNET_OPTION_RECEIVE_TIMEOUT, Pointer(@timeout),
    sizeof(timeout));
end;

function T900600Envio.MontaXMLEnvio: IXMLDocument;
var
  XMLDoc: TXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLacesso: IXMLNode;

  HttpRio: THTTPRIO;
  net: TConexao;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';

  XMLElementoEnvio.Attributes['servidor'] := '259403';
  XMLElementoEnvio.Attributes['usuario'] := '0';
  XMLElementoEnvio.Attributes['operacao'] := '900600';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  // Neste caso � para ter uma acesso
  XMLacesso := XMLElementoEnvio.AddChild('acesso');
  XMLacesso.Text := ' ';

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  HttpRio := THTTPRIO.Create(nil);

  try
    // Almenta o tempo de espera
    HttpRio.OnBeforeExecute := HttpRioTokenBeforeExecute;
    HttpRio.URL := 'http://crcxe.grupocriar.com.br:443/mcp/Operations';

    HttpRio.Service := 'Operations';
    HttpRio.Port := 'MainPort';

    Result.Xml.Text := (HttpRio as ClsWebService.Main)
      .execute('259403', XMLDoc.Xml.Text);

  except
    on e: Exception do
    begin

      Sleep(1000);
      if net.PingDNSGrupoCRIAR then
      begin
        HttpRio := THTTPRIO.Create(nil);

        // Almenta o tempo de espera
        HttpRio.OnBeforeExecute := HttpRioTokenBeforeExecute;
        HttpRio.URL := 'http://crcxe.grupocriar.com.br:443/mcp/Operations';

        HttpRio.Service := 'Operations';
        HttpRio.Port := 'MainPort';

        Result.Xml.Text := (HttpRio as ClsWebService.Main)
          .execute('259403', XMLDoc.Xml.Text);
      end
      else
      begin

        Result.Xml.Text :=
          '<?xml version="1.0" encoding="Latin1"?><retorno servidor="532997" usuario="0" operacao="000000" codigo="D997">'
          + '<mensagem tipo="S" id="997" ><texto>Verifique sua conex�o de rede e internet!</texto></mensagem></retorno>';
      end;

    end;
  end;

end;

end.
