unit ClsToken;

interface

uses
  System.Classes, System.SysUtils, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom,
  Vcl.Forms,
  Vcl.Controls, Xml.XMLDoc, IdHashMessageDigest, Soap.Rio, Soap.SOAPHTTPClient,
  IdHTTP,
  IdTCPConnection, IdTCPClient, IdICMPClient, Winapi.Windows, Winapi.WinInet,
  Vcl.Dialogs,
  IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME, ClsConexaoFerramentas,
  ClsCFCControl,
  ClsServidorControl, ClsWebService, ClsRetornoToken, ClsFuncoes, ClsParametros;

type
  TToken = class
  private

  protected
    FCodigo: string;
    FToken: string;
    FMensagem: string;

    procedure HttpRioTokenBeforeExecute(const MethodName: string;
      Request: TStream);
  public
    function GetTokenMCP(Fusuario, Fsenha: String; Aviso: String = '')
      : IXMLDocument;
  end;

implementation

uses FrmAvisoConexao;

{ TToken }
procedure TToken.HttpRioTokenBeforeExecute(const MethodName: string;
  Request: TStream);
var
  timeout: integer;
begin

  timeout := 100000;

  InternetSetOption(nil, INTERNET_OPTION_CONNECT_TIMEOUT, Pointer(@timeout),
    sizeof(timeout));
  InternetSetOption(nil, INTERNET_OPTION_SEND_TIMEOUT, Pointer(@timeout),
    sizeof(timeout));
  InternetSetOption(nil, INTERNET_OPTION_RECEIVE_TIMEOUT, Pointer(@timeout),
    sizeof(timeout));

end;

function TToken.GetTokenMCP(Fusuario, Fsenha: String; Aviso: String = '')
  : IXMLDocument;
var
  HttpToken: THTTPRIO;
  idmd5: TIdHashMessageDigest5;
  net: TConexao;
  ListaLinks: TStringList;
  IndiceDoServidor: integer;
  IndiceDoLink: integer;
  strUsuario: String;

  Frm_Aviso: TFrm_AvisoConexao;
begin

  Result := TXMLDocument.Create(nil);

  if Now >= retToken.Exp then
  begin

    if Debug then
      ArquivoLog.GravaArquivoLog('Novo Token');

    idmd5 := TIdHashMessageDigest5.Create;
    HttpToken := THTTPRIO.Create(nil);
    ListaLinks := TStringList.Create;

    // Almenta o tempo de espera
    HttpToken.OnBeforeExecute := HttpRioTokenBeforeExecute;

    if Debug then
      ArquivoLog.GravaArquivoLog('Link Token');

    IndiceDoServidor := Random(Parametros.ListaServidores.Count - 1);
    ListaLinks.Text := (Parametros.ListaServidores.Objects[IndiceDoServidor]
      as TStringList).Text;
    IndiceDoLink := Random(ListaLinks.Count - 1);
    HttpToken.URL := ListaLinks[IndiceDoLink];

    HttpToken.Service := 'Operations';
    HttpToken.Port := 'MainPort';

    if (Parametros.ProxyURL <> '') and (Parametros.ProxyUsername <> '') and
      (Parametros.ProxyPassword <> '') then
    begin
      HttpToken.HTTPWebNode.Proxy := Parametros.ProxyURL;
      HttpToken.HTTPWebNode.Username := 'levi@grupocriar';
      HttpToken.HTTPWebNode.Password := Parametros.ProxyPassword;
    end;

    // Foi Feito desta forma porque a procedure do Cleiber n�o l� a tabela de operadores
    if ParServidor.ID_Sistema = 872461 then
      strUsuario := 'admin@' + Parametros.Usuario
    else
      strUsuario := Parametros.Usuario;

    try
      if Debug then
        ArquivoLog.GravaArquivoLog('Token: ' + IntToStr(ParServidor.ID_Sistema)
          + Parametros.Versao + strUsuario + idmd5.HashStringAsHex
          (Parametros.Senha));

      repeat

        if Debug then
          ArquivoLog.GravaArquivoLog('Ping Token ');

        if net.PingDNSGrupoCRIAR then
        begin

          if Debug then
            ArquivoLog.GravaArquivoLog('Ping Token valido ');

          Result.Xml.Text := (HttpToken as ClsWebService.Main)
            .Token(IntToStr(ParServidor.ID_Sistema), Parametros.Versao,
            strUsuario, idmd5.HashStringAsHex(Parametros.Senha));

        end
        else
        begin

          if Debug then
            ArquivoLog.GravaArquivoLog('Ping Token falhou ');

          if Parametros.AguardarAviso then
          begin
            Result.Xml.Text :=
              '<?xml version="1.0" encoding="Latin1"?><retorno servidor="' +
              IntToStr(ParServidor.ID_Sistema) +
              '" usuario="0" operacao="000000' +
              '" codigo="D998"><mensagem tipo="E" id="998"><texto>A Prova est� pausada, pois n�o h� conex�o com a Internet. Verifique sua conex�o.</texto></mensagem></retorno>';
          end
          else
          begin
            Parametros.AguardarAviso := True;
            Frm_Aviso := TFrm_AvisoConexao.Create(nil);

            if Trim(Aviso) = '' then
              Aviso := 'Verifique sua conex�o e tente novamente.';

            Frm_Aviso.Label1.Caption := Aviso;

            if Frm_Aviso.ShowModal = mrYes then
            begin

            end
            else
            begin
              Result.Xml.Text :=
                '<?xml version="1.0" encoding="Latin1"?><retorno servidor="' +
                IntToStr(ParServidor.ID_Sistema) +
                '" usuario="0" operacao="000000' +
                '" codigo="D998"><mensagem tipo="E" id="998"><texto>A Prova est� pausada, pois n�o h� conex�o com a Internet. Verifique sua conex�o.</texto></mensagem></retorno>';
            end;

            Frm_Aviso.Free;

          end;

        end;

      until (Parametros.NumeroAviso < 6);

    except
      on E: Exception do
      begin
        ArquivoLog.GravaArquivoLog('Token: ' + E.Message);
      end;

    end;

  end
  else
  begin
    Result.Xml.Text := retToken.XMLHash;
  end;

  if Result.Xml.Text = '' then
  begin
    Result.Xml.Text :=
      '<?xml version="1.0" encoding="Latin1"?><retorno servidor="' +
      IntToStr(ParServidor.ID_Sistema) + '" usuario="0" operacao="000000' +
      '" codigo="D998"><mensagem tipo="E" id="998"><texto>Token vazio</texto></mensagem></retorno>';
  end;

end;

end.
