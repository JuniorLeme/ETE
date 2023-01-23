unit ClsOperacoes;

interface
  uses System.Classes, Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient,
       System.SysUtils, ClsWebService, Vcl.StdCtrls, IdHashMessageDigest,
       Vcl.Graphics, Vcl.Controls, Vcl.ComCtrls, Vcl.Forms,  Vcl.ExtCtrls,
       Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, IdHTTP, Xml.XMLDoc,
       IdTCPConnection, IdTCPClient, IdBaseComponent, IdComponent, ClsProva,
       ClsParametros, ClsStatusInternet;

type
  MainOperacao = class(TComponent)

  private
    FXmlRetornoPadrao : WideString;
    FXmlEnvio : WideString;
    FXmlRetorno : WideString;
    FControle : Boolean;

    procedure SetRetornoPadrao(XML: WideString);
    function GetRetornoPadrao(): WideString;
    function MD5(const texto:string):string;

  protected

    FRetorno : TNotifyEvent;

    SERVIDOR : array[1..6] of string;
    WSDL :     array[1..6] of string;
    URL :      array[1..6] of string;

    FTokenCodeRetorno : string;
    FTokenMensagemRetorno : string;

    HttpRio : THTTPRIO;

    const Servico = 'Operacoes.executar';
    const Porta =   'OperacoesPort';

    const ServicoFoto = 'Operacoes.foto';
    const PortaFoto   = 'OperacoesPort';

  public
    property Controle: Boolean read FControle write FControle;
    property XMLRetorno: WideString read FXMLRetorno write FXMLRetorno;
    property XMLRetornoPadrao: WideString read GetRetornoPadrao write SetRetornoPadrao;

    function consutar : Boolean;
    function Token : String;
    Constructor Create(Sender: TComponent; ParXMLEnvio : WideString; ParRetorno: TNotifyEvent); overload;
  end;

implementation
  uses ClsFuncoes, cipher;

constructor MainOperacao.Create(Sender: TComponent; ParXMLEnvio : WideString; ParRetorno: TNotifyEvent);
begin

  // inicia as variaveis
  if ParStatusInternet = nil then
    ParStatusInternet := TStatusInternet.Create;

  ParStatusInternet.Falha := 0;
  ParStatusInternet.FalhaQtde := 0;
  ParStatusInternet.FalhaDescricao := ' ';

  if ParStatusInternet = nil then
  begin
    ParStatusInternet := TStatusInternet.Create;
    ParStatusInternet.Falha      := 0;
    ParStatusInternet.FalhaQtde  := 0;
  end;

  Controle  := False;
  FRetorno  := ParRetorno;
  FxmlEnvio := ParXMLEnvio;

  // http://servidor1.eprova.com.br:8080/mcp/Operations?WSDL

  // http://servidor1.eprova.com.br:443/mcp/Operations?WSDL
  // WSDL: http://200.233.218.131:8080/mcp/Operations?WSDL
  // Teste: 200.233.218.131:8080/mcp/Operations?Tester

  // SERVIDOR[1] := 'cesio.keynet.com.br';
  // SERVIDOR[2] := 'cesio.keynet.com.br';
  // SERVIDOR[3] := 'cesio.keynet.com.br';

  SERVIDOR[1] := ParServidor.Servidor1;
  SERVIDOR[2] := ParServidor.Servidor2;
  SERVIDOR[3] := ParServidor.Servidor3;

  URL[1] := 'http://'+SERVIDOR[1]+':443/mcp/Operations';
  URL[2] := 'http://'+SERVIDOR[2]+':443/mcp/Operations';
  URL[3] := 'http://'+SERVIDOR[3]+':443/mcp/Operations';

  WSDL[1] := URL[1]+'?WSDL';
  WSDL[2] := URL[1]+'?WSDL';
  WSDL[3] := URL[1]+'?WSDL';

  SERVIDOR[4] := 'servidor1.eprova.com.br';
  SERVIDOR[5] := 'servidor2.eprova.com.br';
  SERVIDOR[6] := 'servidor3.eprova.com.br';

  URL[4] := 'http://'+SERVIDOR[1]+':443/mcp/Operations';
  URL[5] := 'http://'+SERVIDOR[2]+':443/mcp/Operations';
  URL[6] := 'http://'+SERVIDOR[3]+':443/mcp/Operations';

  WSDL[4] := URL[1]+'?WSDL';
  WSDL[5] := URL[1]+'?WSDL';
  WSDL[6] := URL[1]+'?WSDL';

  FXmlRetornoPadrao :=
    '<?xml version="1.0" encoding="Latin1"?> '+
    ' <retorno servidor="532997" usuario="0" operacao="999999" codigo="B999"> '+
    ' 	<mensagem tipo="E" id="998"> '+
    '     <texto>Servidor em manutenção. Tente mais tarde!</texto> '+
    '   </mensagem> '+
    ' </retorno>';

end;

function MainOperacao.Token : String;
  var
    LerXML: IXMLDocument;
begin

  HttpRio := THTTPRIO.Create(nil);

  if Trim(XMLRetorno) = '' then
  begin
    if Parametros.Servidor = 'Erro' then
    begin
      Parametros.Servidor := '1';
      HttpRio.URL := PChar(URL[1]);
    end
    else
      if (StrToIntDef(Parametros.Servidor , 1) > 0) and
         (StrToIntDef(Parametros.Servidor , 1) <= 3) then
        HttpRio.URL := PChar(URL[StrToIntDef(Parametros.Servidor,1)])
      else
      begin
        Parametros.Servidor := '1';
        HttpRio.URL := PChar(URL[1]);
      end;

    HttpRio.Service := Servico;
    HttpRio.Port    := Porta;

  end;

  try

    Result := (HttpRio as ClsWebService.Main).token(IntToStr(ParServidor.ID_Sistema), Parametros.Versao, Decifra( Parametros.Usuarios ,'AXF'), MD5(Decifra( Parametros.Senha ,'AXF')) );

    if Result <> '' then
    begin

      LerXML := NewXMLDocument;

      try
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Result;
        LerXML.Active := True;
      except on Erro : Exception do
      begin
        GravaArquivoLog(self,'Operação 100100 - Retorno Padrão - '+Erro.Message);
        LerXML.Active   := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := XMLRetornoPadrao;
        LerXML.Active := True;
      end;
      end;

      if LerXML.ChildNodes.FindNode('retorno') <> nil then
      begin

        FTokenCodeRetorno := LerXML.ChildNodes.FindNode('retorno').Attributes['codigo'];

        if FTokenCodeRetorno = 'B000' then
        begin
          Result := LerXML.ChildNodes.FindNode('retorno').ChildNodes.FindNode('token').Text;
        end
        else
        begin
          Result := '';
          FTokenMensagemRetorno := LerXML.ChildNodes.FindNode('retorno').ChildNodes.FindNode('token').Text;
        end;

      end;

    end;

  except on Erro: exception do
  begin

    // Informa a falha do web service
    ParStatusInternet.Falha := 1;
    ParStatusInternet.FalhaQtde := ParStatusInternet.FalhaQtde + 1;

    if Trim(FXMLRetorno) <> '' then
      ParStatusInternet.FalhaDescricao := FXMLRetorno
    else
      ParStatusInternet.FalhaDescricao := Erro.Message;

    GravaArquivoLog(self,Erro.Message + ' - Retorno Padrão ');

    if StrToIntDef( Parametros.Servidor ,1) >= 3 then
      Parametros.Servidor := '1'
    else
      Parametros.Servidor := IntToStr(StrToIntDef(Parametros.Servidor,1)+1);

    if PingIP('internic.net') and
      (ParQuestionario.Id_prova > 0) and
      (ParCFC.offline = 'S') then
    begin
      FXmlRetorno :=
        '<?xml version="1.0" encoding="Latin1"?>'+
        '<retorno servidor="'+IntToStr(ParServidor.ID_Sistema)+'" usuario="0" operacao="999999" codigo="D555">'+
        '<mensagem tipo="S" id="555" ><texto>Servidor em manutenção!'+
        '</texto></mensagem></retorno>';
      FTokenCodeRetorno := 'D555';
      FTokenMensagemRetorno := 'ModoOffLine'
    end
    else
      FXmlRetorno :=
        '<?xml version="1.0" encoding="Latin1"?>'+
        '<retorno servidor="'+IntToStr(ParServidor.ID_Sistema)+'" usuario="0" operacao="999999" codigo="B999">'+
        '<mensagem tipo="S" id="999" ><texto>'+Erro.Message+
        '</texto></mensagem></retorno>';

  end;
  end;

end;

function MainOperacao.consutar : Boolean;
  var
    vToken: WideString;
begin

  vToken := Token ;

  if (FTokenCodeRetorno = 'B000') or (FTokenCodeRetorno = 'D555') then
  begin

    HttpRio := THTTPRIO.Create(nil);

    if Trim(XMLRetorno) = '' then
    begin
      if Parametros.Servidor = 'Erro' then
      begin
        Parametros.Servidor := '1';
        HttpRio.URL := PChar(URL[1]);
      end
      else
        if (StrToIntDef(Parametros.Servidor , 1) > 0) and
           (StrToIntDef(Parametros.Servidor , 1) <= 3) then
          HttpRio.URL := PChar(URL[StrToIntDef(Parametros.Servidor,1)])
        else
        begin
          Parametros.Servidor := '1';
          HttpRio.URL := PChar(URL[1]);
        end;

      HttpRio.Service := Servico;
      HttpRio.Port    := Porta;
    end;

    try

      if Trim(XMLRetorno) = '' then
        FXMLRetorno := (HttpRio as ClsWebService.Main).secure_execute(IntToStr(ParServidor.ID_Sistema), vToken, FXMLEnvio)

    except on Erro: exception do
    begin

      // Informa a falha do web service
      ParStatusInternet.Falha := 1;
      ParStatusInternet.FalhaQtde := ParStatusInternet.FalhaQtde + 1;

      if Trim(FXMLRetorno) <> '' then
        ParStatusInternet.FalhaDescricao := FXMLRetorno
      else
        ParStatusInternet.FalhaDescricao := Erro.Message;

      GravaArquivoLog(self,Erro.Message + ' - Retorno Padrão ');

      if StrToIntDef( Parametros.Servidor ,1) >= 3 then
        Parametros.Servidor := '1'
      else
        Parametros.Servidor := IntToStr(StrToIntDef(Parametros.Servidor,1) + 1);

      if (PingIP('internic.net')) and
        (ParQuestionario.Id_prova > 0) and
        (ParCFC.offline = 'S') then
        FXmlRetorno :=
          '<?xml version="1.0" encoding="Latin1"?>'+
          '<retorno servidor="'+IntToStr(ParServidor.ID_Sistema)+'" usuario="0" operacao="999999" codigo="D555">'+
          '<mensagem tipo="S" id="555" ><texto>Servidor em manutenção!'+
          '</texto></mensagem></retorno>'
      else
        FXmlRetorno :=
          '<?xml version="1.0" encoding="Latin1"?>'+
          '<retorno servidor="'+IntToStr(ParServidor.ID_Sistema)+'" usuario="0" operacao="999999" codigo="B999">'+
          '<mensagem tipo="S" id="999" ><texto>'+Erro.Message+
          '</texto></mensagem></retorno>';

    end;
    end;

  end
  else
  begin

    FXmlRetorno :=
      '<?xml version="1.0" encoding="Latin1"?>'+
      '<retorno servidor="532997" usuario="0" operacao="999999" codigo="'+FTokenCodeRetorno +'">'+
      '<mensagem tipo="E" id="555" ><texto>'+ FTokenMensagemRetorno +
      '</texto></mensagem></retorno>';

  end;

  FRetorno(Self);

  if FXmlRetorno <> '' then
    Result := True
  else
    Result := False;

end;

procedure MainOperacao.SetRetornoPadrao(XML: WideString);
begin
  FXmlRetornoPadrao := xml;
end;

function MainOperacao.GetRetornoPadrao(): WideString;
begin
  Result := FXmlRetornoPadrao;
end;

function MainOperacao.MD5(const texto:string):string;
var
  idmd5 : TIdHashMessageDigest5;
begin

  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := idmd5.HashStringAsHex(texto);
  finally
    idmd5.Free;
  end;

end;

end.
