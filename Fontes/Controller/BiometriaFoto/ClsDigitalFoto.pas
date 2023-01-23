unit ClsDigitalFoto;

interface

uses
  System.Classes, System.JSON, System.SysUtils, IdTCPConnection, IdTCPClient,
  IdHTTP,
  IPPeerClient, Data.Bind.Components, IdBaseComponent, IdComponent,
  Data.Bind.ObjectScope,
  REST.Client, Datasnap.DSClientRest, Soap.SOAPHTTPTrans, ClsDetecta,
  ClsServidorControl,
  ClsCFCControl, ClsQuestionario, ClsCandidatoControl, ClsToken, ClsFuncoes,
  ClsRetornoToken, ClsParametros;

Function LRPad(Str: String; Size: Integer; Pad: char; LorR: char): string;

Type

  TDigitalRest = Class
    local_busca: string;
    Function conect(): TJSONObject;
  End;

  TFotoRest = Class
    local_busca: string;
    Function conect(): TJSONObject;
  End;

  TretornoRest = class
    Codigo: string;
    Mensagem: string;
    Foto: WideString;
    function isValid: Boolean;
    Procedure MontaRetorno(ArgJso: TJSONObject);
  end;

implementation

uses ClsDigitalFotoExame;
{ TDigital }

Function TDigitalRest.conect(): TJSONObject;
var
  TokenEnv: TToken;
  IdHTTP1: TIdHTTP;
  StrToken: string;

  EnvioBiometriaFoto: TJSONObject;
  JsonStreamEnvio: TStringStream;
  JsonStreamRetorno: TStringStream;
  StrRetorno: WideString;

  Porta: string;
begin
  Result := nil;

  Porta := '9292';

  if Parametros.TipoBiometria = 'XE' then
    Porta := '9191';

  // local_busca: 1, // Servidor biometrica Bahia (1) - Servidor biometrica CRIAR (2) - API CFCANet (3)
  if Trim(Parametros.Scanners) = '' then
    Parametros.Scanners := '1111';

  local_busca := '2';

  if ParCFC.UF = 'BA' then
    local_busca := '1';

  if ParCFC.UF = 'SP' then
    local_busca := '3';

  TokenEnv := TToken.Create;

  if retToken = nil then
    retToken := TRetToken.Create;

  StrToken := retToken.GetToken(TokenEnv.GetTokenMCP(Parametros.Usuario,
    Parametros.Senha));

  if retToken.isValid then
  begin

    EnvioBiometriaFoto := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes('{' + '"sistema": [{' + '"program_server": "' +
      IntToStr(ParServidor.ID_Sistema) + '", ' + '"program_version": "' +
      Parametros.Versao + '", ' + '"user": "' + Parametros.Usuario + '", ' +
      '"token": "' + StrToken + '", ' + '"show_message": "N" }], ' +
      '"biometria": [{' + '"device": "' + Parametros.Scanners +
      '", "tipo_biometria": "1", ' + '"tentativas": "3", ' +
      '"quantidade": "10", ' + '"qtde_minima": "10", ' + '"com_foto": "N", ' +
      '"dedo_vivo": "S" }], ' + '"foto": [{' + '"tipo_foto": "0", ' +
      '"quantidade": "1", ' + '"transmitir": "N" }], ' + '"assinatura":[{}], ' +
      '"pessoa": [{' + '"tipo_inscricao": "1", ' + '"inscricao": "' +
      ParCandidato.CPFCandidato + '", ' + '"nome": "' +
      ParCandidato.NomeCandidato + '", ' + '"tipo_pessoa": "C", ' +
      '"area_ciretran": "' + ParCFC.Cod_Ciretran + '", ' + '"registro": "' +
      ParCandidato.RENACHCandidato + '", ' + '"local_exame": "1", ' +
      '"local_busca": "' + local_busca + '", ' + '"municipio": "' +
      ParCandidato.Municipio_Candidato + '", ' + '"excecao": "0", ' +
      '"tipoTela": "E", ' + '"flag": "3", ' + '"param1": "1" }]}'), 0)
      as TJSONObject;

    // 'http://127.0.0.1:9292/grupocriar/servidor/operacao/biometria_foto';
    IdHTTP1 := TIdHTTP.Create(nil);
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication := false;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.Charset := 'UTF-8';

    JsonStreamEnvio := TStringStream.Create('', TEncoding.UTF8);
    JsonStreamEnvio.WriteString(EnvioBiometriaFoto.ToJSON);
    JsonStreamRetorno := TStringStream.Create('', TEncoding.UTF8);

    try
      // IdHTTP.Get(URL, JsonStreamRetorno);
      IdHTTP1.Post('http://127.0.0.1:' + Porta +
        '/grupocriar/servidor/operacao/biometria_foto', JsonStreamEnvio,
        JsonStreamRetorno);
      JsonStreamRetorno.Position := 0;
      StrRetorno := JsonStreamRetorno.ReadString(JsonStreamRetorno.Size);
      Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StrRetorno),
        0) as TJSONObject;

    except
      on E: EIdHTTPProtocolException do
      begin

        Result := TJSONObject.ParseJSONValue
          (TEncoding.UTF8.GetBytes
          ('{"result":[{"resultado":[{"foto1":"","foto2":"","foto3":"","codigo":"D998","mensagem":"Biometria n�o est� funcionando corretamente!","program_server":"'
          + IntToStr(ParServidor.ID_Sistema) + '","user":"' + Parametros.Usuario
          + '"}]}]}'), 0) as TJSONObject;

        ArquivoLog.GravaArquivoLog('Identifica��o Biometria Prova HTTP:// - ' +
          E.Message);
        ArquivoLog.GravaArquivoLog('http://127.0.0.1:' + Porta +
          '/grupocriar/servidor/operacao/biometria_foto - {' +
          JsonStreamEnvio.DataString + '} - {' +
          JsonStreamRetorno.DataString + '}');
        ArquivoLog.Gravar;
      end;

      on E: Exception do
      begin

        Result := TJSONObject.ParseJSONValue
          (TEncoding.UTF8.GetBytes
          ('{"result":[{"resultado":[{"foto1":"","foto2":"","foto3":"","codigo":"D998","mensagem":"Biometria n�o est� funcionando corretamente!","program_server":"'
          + IntToStr(ParServidor.ID_Sistema) + '","user":"' + Parametros.Usuario
          + '"}]}]}'), 0) as TJSONObject;

        ArquivoLog.GravaArquivoLog('Identifica��o Biometria Prova HTTP:// - ' +
          E.Message);
        ArquivoLog.GravaArquivoLog('http://127.0.0.1:' + Porta +
          '/grupocriar/servidor/operacao/biometria_foto - {' +
          JsonStreamEnvio.DataString + '} - {' +
          JsonStreamRetorno.DataString + '}');
        ArquivoLog.Gravar;
      end;

    end;

  end;

end;

function TretornoRest.isValid: Boolean;
begin

  ArquivoLog.GravaArquivoLog('Biometria/Foto - retorno: ' + Codigo + ' ' +
    Mensagem);

  if Codigo = 'B000' then
    Result := True
  else
    Result := false;

  if Mensagem = '' then
    Mensagem := Codigo + ' Falta de argumento na captura!';

end;

{ TFoto }

Function TFotoRest.conect(): TJSONObject;
var
  TokenEnv: TToken;
  IdHTTP1: TIdHTTP;
  StrToken: string;

  EnvioBiometriaFoto: TJSONObject;
  JsonStreamEnvio: TStringStream;
  JsonStreamRetorno: TStringStream;
  StrRetorno: string;
  Porta: string;
begin
  Result := nil;

  Porta := '9393';

  if Parametros.TipoBiometria = 'XE' then
    Porta := '9191';

  TokenEnv := TToken.Create;

  if retToken = nil then
    retToken := TRetToken.Create;

  StrToken := retToken.GetToken(TokenEnv.GetTokenMCP(Parametros.Usuario,
    Parametros.Senha));

  local_busca := '2';

  if ParCFC.UF = 'BA' then
    local_busca := '1';

  if ParCFC.UF = 'SP' then
    local_busca := '3';

  if retToken.isValid then
  begin
    EnvioBiometriaFoto := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes('{' + '"sistema": [{' + '"program_server": "' +
      IntToStr(ParServidor.ID_Sistema) + '", ' + '"program_version": "' +
      Parametros.Versao + '", ' + '"user": "' + Parametros.Usuario + '", ' +
      '"token": "' + StrToken + '", ' + '"show_message": "N" }], ' +
      '"biometria": [{' + '"tipo_biometria": "4", ' + '"tentativas": "3", ' +
      '"quantidade": "10", ' + '"qtde_minima": "10", ' + '"com_foto": "S", ' +
      '"dedo_vivo": "S" }], ' + '"foto": [{' + '"tipo_foto": "1", ' +
      '"quantidade": "1", ' + '"transmitir": "S" }], ' + '"assinatura":[{' +
      '"tipo_coletor": "stu-530",' + '"transmitir":"N"}], ' + '"pessoa": [{' +
      '"tipo_inscricao": "1", ' + '"inscricao": "' + ParCandidato.CPFCandidato +
      '", ' + '"nome": "' + ParCandidato.NomeCandidato + '", ' +
      '"tipo_pessoa": "C", ' + '"area_ciretran": "' + LRPad(ParCFC.Cod_Ciretran,
      4, '0', 'L') + '", ' + '"registro": "' + ParCandidato.RENACHCandidato +
      '", ' + '"local_exame": "0", ' + '"local_busca": "' + local_busca + '", '
      + '"municipio": "0000", ' + '"excecao": "0", ' + '"tipoTela": "E", ' +
      '"flag": "null", ' + '"param1": "1" }]}'), 0) as TJSONObject;

    // 'http://127.0.0.1:9292/grupocriar/servidor/operacao/biometria_foto';
    IdHTTP1 := TIdHTTP.Create(nil);
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication := false;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.Charset := 'UTF-8';

    JsonStreamEnvio := TStringStream.Create('', TEncoding.UTF8);
    JsonStreamEnvio.WriteString(EnvioBiometriaFoto.ToJSON);

    JsonStreamRetorno := TStringStream.Create('', TEncoding.UTF8);

    try
      // IdHTTP.Get(URL, JsonStreamRetorno);
      IdHTTP1.Post('http://127.0.0.1:' + Porta +
        '/grupocriar/servidor/operacao/biometria_foto', JsonStreamEnvio,
        JsonStreamRetorno);
      JsonStreamRetorno.Position := 0;
      StrRetorno := JsonStreamRetorno.ReadString(JsonStreamRetorno.Size);
      Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StrRetorno),
        0) as TJSONObject;
    except
      on E: EIdHTTPProtocolException do
      begin

        Result := TJSONObject.ParseJSONValue
          (TEncoding.UTF8.GetBytes
          ('{"result":[{"resultado":[{"foto1":"","foto2":"","foto3":"","codigo":"D998","mensagem":"Foto n�o est� funcionando corretamente!","program_server":"'
          + IntToStr(ParServidor.ID_Sistema) + '","user":"' + Parametros.Usuario
          + '"}]}]}'), 0) as TJSONObject;

        ArquivoLog.GravaArquivoLog('Identifica��o Foto Prova HTTP:// - ' +
          E.Message);
        ArquivoLog.GravaArquivoLog('http://127.0.0.1:' + Porta +
          '/grupocriar/servidor/operacao/biometria_foto - {' +
          JsonStreamEnvio.DataString + '} - {' +
          JsonStreamRetorno.DataString + '}');
        ArquivoLog.Gravar;
      end;
      on E: Exception do
      begin

        Result := TJSONObject.ParseJSONValue
          (TEncoding.UTF8.GetBytes
          ('{"result":[{"resultado":[{"foto1":"","foto2":"","foto3":"","codigo":"D998","mensagem":"Foto n�o est� funcionando corretamente!","program_server":"'
          + IntToStr(ParServidor.ID_Sistema) + '","user":"' + Parametros.Usuario
          + '"}]}]}'), 0) as TJSONObject;

        ArquivoLog.GravaArquivoLog('Identifica��o Foto Prova HTTP:// - ' +
          E.Message);
        ArquivoLog.GravaArquivoLog('http://127.0.0.1:' + Porta +
          '/grupocriar/servidor/operacao/biometria_foto - {' +
          JsonStreamEnvio.DataString + '} - {' +
          JsonStreamRetorno.DataString + '}');
        ArquivoLog.Gravar;
      end;

    end;

  end;

end;

Function LRPad(Str: String; Size: Integer; Pad: char; LorR: char): string;
var
  i, cont: Integer;
  s: string;
begin
  cont := Length(Str);
  s := '';
  if upCase(LorR) = 'L' then
  begin
    for i := 1 to Size - cont do
      s := s + Pad;
    s := s + Str;
  end
  else
  begin
    for i := 1 to Size - cont do
      s := s + Pad;
    s := Str + s;
  end;
  LRPad := copy(s, 1, Size);
end;

{ Tretorno }

Procedure TretornoRest.MontaRetorno(ArgJso: TJSONObject);
var
  i, j: Integer;

  jSubObj: TJSONObject;

  jaresult: TJSONArray;
  jpresult: TJSONPair;

  jaresultado: TJSONArray;
  jpresultado: TJSONPair;

  jSubPar: TJSONPair;
begin

  // dada a seguinte string em nota��o JSON que ser� convertida pela fun��o ParseJSONValue
  // em um objeto nativo do delphi do tipo TJSONObject
  jpresult := ArgJso.Pairs[0];

  if jpresult.JsonString.ToString = '"result"' then
  begin
    jaresult := (jpresult.JsonValue as TJSONArray);
    jpresultado := (jaresult.Items[0] as TJSONObject).Pairs[0];

    // pega o par zero
    jaresultado := (jpresultado.JsonValue as TJSONArray);

    if jpresultado.JsonString.ToString = '"resultado"' then
    begin

      for i := 0 to jaresultado.Count - 1 do
      begin
        // itera o array para pegar cada elemento
        jSubObj := (jaresultado.Items[i] as TJSONObject);

        // quantidade de pares do objeto
        for j := 0 to jSubObj.Count - 1 do
        begin
          // itera o objeto para pegar cada par
          jSubPar := jSubObj.Pairs[j];

          // pega o par no �ndice j
          // do par pega separado a chave e o valor usando Value
          if jSubPar.JsonString.Value = 'foto1' then
            Self.Foto := jSubPar.JsonValue.Value;

          if jSubPar.JsonString.Value = 'codigo' then
            Self.Codigo := jSubPar.JsonValue.Value;

          if jSubPar.JsonString.Value = 'mensagem' then
            Self.Mensagem := jSubPar.JsonValue.Value;

        end;

      end;

      if (Self.Codigo = 'B995') then
      begin

        if ParFotoExame.Prova_Ativo or ParFotoExame.Simulado_Ativo then
        begin
          if TelaExameBiometriaFoto then
            Self.Mensagem :=
              'As biometrias n�o conferem. A prova ser� bloqueada.' + #13 +
              'Aguarde o desbloqueio que ser� realizado pelo DETRAN.'
          else
            Self.Mensagem :=
              'As biometrias n�o conferem com as que foram cadastradas na matr�cula.'
              + #13 + 'Fa�a o recadastro das biometrias.';
        end
        else
        begin

          if ParCandidato.TipoProva = 'S' then
            Self.Mensagem := 'A exce��o digital autom�tica foi confirmada. ' +
              'Essa captura e o Teste Simulado est�o sendo marcados e ser�o auditados pelo DETRAN.'
          else
            Self.Mensagem := 'A exce��o digital autom�tica foi confirmada. ' +
              'Essa captura e a Prova est�o sendo marcadas e ser�o auditadas pelo DETRAN.';

        end;

      end;

      if (Self.Codigo = 'B900') then
      begin
        if TelaExameBiometriaFoto then
          Self.Mensagem :=
            'A biometria/foto foi cancelada pelo usu�rio. A prova ser� bloqueada.'
            + #13 + 'Aguarde o desbloqueio que ser� realizado pelo DETRAN.'
        else
          Self.Mensagem := 'A biometria/foto foi cancelada pelo usu�rio.';

      end;

    end;

  end;

end;

end.
