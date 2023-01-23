unit ClsBiometriaFoto;

interface
  uses
    System.SysUtils, System.IniFiles, System.Win.Registry, Winapi.Windows,
    Winapi.WinSvc, System.Classes, Vcl.Dialogs, Tlhelp32, System.JSON,
    ClsParametros, ClsFuncoes, Datasnap.DSClientRest, ClsClientRestBiometria,
    ClsProva, IPPeerClient, IdHashMessageDigest, IdTCPConnection, IdTCPClient,
    IdBaseComponent, IdComponent, IdICMPClient;

type

  TToken = class

  protected

  public
    Token: string;
    CodigoRetorno: string;
    MensagemRetorno: string;
    function GetToken(program_server: Integer; program_version: string;
      user: string; password: string): String;
    function PingSevidoresCRIAR(arServidor: string): Boolean;
  end;

  TBiometriaFoto = class

  protected

    Token: TToken;
    function MD5(const texto:string):string;
  public

    CodigoRetorno: string;
    MensagemRetorno: string;

    program_server: String;
    show_message: String;
    tipo_biometria: Integer;
    tentativasbiometria: Integer;
    quantidadeBiometria: Integer;
    com_foto: string;
    tipo_foto: Integer;
    quantidadefoto: Integer;
    nome: String;
    inscricao: String;
    registro: string;
    tipo_pessoa: string;
    tipo_inscricao: Integer;
    local_busca: Integer;
    param1: Integer;
    area_ciretran: Integer;
    municipio: Integer;
    local_exame: Integer;

    function GetBiometriaFoto: Boolean;
    function GetBiometria: Boolean;
    function GetFoto: Boolean;
  end;

var BiometriaFoto : TBiometriaFoto;

implementation

function TBiometriaFoto.GetBiometria: Boolean;
var
  DSRestConn: TDSRestConnection;
  OperStart: TOperClientBiometria;

  EnvioBiometriaFoto: TJSONObject;
  RetornoBiometriaFoto: TJSONObject;

  I, j: Integer;

  jSubObj: TJSONObject;
  ja: TJSONArray;
  jp, jSubPar: TJSONPair;
  strRENACHCandidato: string;
  strRetornoAutomatico : string;

begin

  inherited;

  try
    Result := True;
    Token := TToken.Create;
    Token.GetToken(Parametros.IdSistema, Parametros.Versao, ParCFC.Usuario, LowerCase(MD5(ParCFC.Senha)));

    if Token.CodigoRetorno = 'D555' then
    begin
      CodigoRetorno := 'D555';
      MensagemRetorno := 'Modo offline';
      Result := True;
    end;

    if Trim(ParCandidato.RENACHCandidato) = '' then
      strRENACHCandidato := ParCandidato.CPFCandidato
    else
      strRENACHCandidato := ParCandidato.RENACHCandidato;

    if TelaExameBiometriaFoto then
      strRetornoAutomatico := ',"avanco_automatico":"S"'
    else
      strRetornoAutomatico := ',"avanco_automatico":"N"';

    EnvioBiometriaFoto := TJSONObject.Create;
    EnvioBiometriaFoto := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes('{"sistema": [{"program_server": "' +
      IntToStr(Parametros.IdSistema) + '","show_message":"N","token":"' + Token.Token + '"}],' +
      '"biometria": [{"tipo_biometria": "1","tentativas": "3","quantidade": "10","com_foto": "S","dedo_vivo":"S"}],'
      + '"foto": [{"tipo_foto": "1","quantidade": "1","transmitir": "S"}],' +
      '"pessoa": [{"nome": "' + ParCandidato.NomeCandidato + '","inscricao": "'
      + ParCandidato.CPFCandidato + '","registro": "' + strRENACHCandidato +
      '",' + '"tipo_pessoa": "C","tipo_inscricao": "2","local_busca": "2","param1": "1",'
      + '"area_ciretran": "' + ParCFC.Cod_Ciretran + '","municipio": "' +
      ParCandidato.Municipio_Candidato + '", "local_exame": "1"}]}'), 0)
      as TJSONObject;

    DSRestConn := TDSRestConnection.Create(nil);

    DSRestConn.Port := 9191;
    DSRestConn.Context := 'grupocriar/';
    DSRestConn.RESTContext := 'servidor/';
    DSRestConn.LoginPrompt := False;
    DSRestConn.UniqueId := '{79BDA36A-D3EC-4D2D-863C-C3888691083B}';

    RetornoBiometriaFoto := TJSONObject.Create;
    OperStart := TOperClientBiometria.Create(DSRestConn);
    RetornoBiometriaFoto := OperStart.biometria_foto
      (EnvioBiometriaFoto, 'token');

    jp := RetornoBiometriaFoto.Pairs[0];
    ja := (jp.JsonValue as TJSONArray);

    if jp.JsonString.ToString = '"resultado"' then
    begin
      if ja.Items[0].Value <> 'null' then
      begin
        for I := 0 to ja.Count - 1 do
        begin
          // itera o array para pegar cada elemento
          jSubObj := (ja.Items[I] as TJSONObject);

          // quantidade de pares do objeto
          for j := 0 to jSubObj.Count - 1 do
          begin
            // itera o objeto para pegar cada par
            jSubPar := jSubObj.Pairs[j];

            // pega o par no índice j
            // do par pega separado a chave e o valor usando Value
            if jSubPar.JsonString.Value = 'codigo' then
              CodigoRetorno := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'mensagem' then
              MensagemRetorno := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'foto' then
              if Trim (jSubPar.JsonValue.Value) <> '' then
                ParCandidato.Foto := jSubPar.JsonValue.Value;

          end;
        end;
      end;
    end;

    if CodigoRetorno = 'B000' then
      Result := True
    else
    begin
      Result := False;

      // Usuário cancela B900
      // Usuário cancela B025
      // Usuário cancela B995
      if (CodigoRetorno = 'B025') or (CodigoRetorno = 'B995') then
      begin

        if Parquestionario.id_prova = 0 then
        begin

            MensagemRetorno :=
                            'As biometrias não conferem com as que foram cadastradas na matrícula.'+ #13 +
                            'Faça o recadastro das biometrias.';

        end
        else
        begin

          if TelaExameBiometriaFoto then
            MensagemRetorno :=
                            'As biometrias não conferem. A prova será bloqueada.'+ #13+
                            'Aguarde o desbloqueio que será realizado pelo DETRAN.'
          else
            MensagemRetorno :=
                            'As biometrias não conferem com as que foram cadastradas na matrícula.'+ #13+
                            'Faça o recadastro das biometrias.';
        end;


      end;

    end;

    OperStart.DisposeOf;

  except on E: Exception do
    begin
      GravaArquivoLog(self,' Biomatria - ' + E.Message);
      Result := False;
    end;
  end;

end;

function TBiometriaFoto.MD5(const texto:string):string;
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

function TBiometriaFoto.GetBiometriaFoto: Boolean;
var
  DSRestConn: TDSRestConnection;
  OperStart: TOperClientBiometria;

  EnvioBiometriaFoto: TJSONObject;
  RetornoBiometriaFoto: TJSONObject;

  I, j: Integer;

  jSubObj: TJSONObject;
  ja: TJSONArray;
  jp, jSubPar: TJSONPair;
  strRENACHCandidato: string;
  strRetornoAutomatico: string;
begin
  inherited;

  try

    Result := True;
    Token := TToken.Create;
    Token.GetToken(Parametros.IdSistema, Parametros.Versao, ParCFC.Usuario,
                    LowerCase(MD5(ParCFC.Senha)));

    if Token.CodigoRetorno = 'D555' then
    begin
      CodigoRetorno := 'D555';
      MensagemRetorno := 'Modo offline';
      Result := True;
    end;

    if Trim(ParCandidato.RENACHCandidato) = '' then
      strRENACHCandidato := ParCandidato.CPFCandidato
    else
      strRENACHCandidato := ParCandidato.RENACHCandidato;

    if TelaExameBiometriaFoto then
      strRetornoAutomatico := '"avanco_automatico":"S"'
    else
      strRetornoAutomatico := '"avanco_automatico":"N"';

    EnvioBiometriaFoto := TJSONObject.Create;
    EnvioBiometriaFoto := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(
        '{"sistema": '+
          '[{"program_server": "' + IntToStr(Parametros.IdSistema) + '",'+
          '"program_version":"'+ Parametros.Versao + '",'+
          '"user":"'+ ParCFC.Usuario +'",'+
          '"show_message":"N",'+
          '"token":"' + Token.Token + '"}],' +
        '"biometria": '+
          '[{"tipo_biometria": "1",'+
          '"tentativas": "3",'+
          '"quantidade": "10",'+
		      '"qtde_minima": "3",'+
          '"dedo_vivo":"S",'+
          '"com_foto": "S" }],'+
        '"foto": '+
          '[{"tipo_foto": "1",'+
          '"quantidade": "1",'+
          '"transmitir": "S",'+
          strRetornoAutomatico+'}],' +
        '"pessoa": '+
          '[{"tipo_inscricao": "2",'+
          '"inscricao": "' + ParCandidato.CPFCandidato + '",'+
          '"nome": "' + ParCandidato.NomeCandidato + '",'+
          '"tipo_pessoa": "C",'+
          '"area_ciretran": "' + ParCFC.Cod_Ciretran + '",'+
          '"registro": "' + strRENACHCandidato + '",' +
          '"local_exame": "1",'+
          '"local_busca": "2",'+
          '"municipio": "0",'+
          '"param1": "1" }]}')
      , 0) as TJSONObject;

    DSRestConn := TDSRestConnection.Create(nil);

    DSRestConn.Port := 9191;
    DSRestConn.Context := 'grupocriar/';
    DSRestConn.RESTContext := 'servidor/';
    DSRestConn.LoginPrompt := False;
    DSRestConn.UniqueId := '{79BDA36A-D3EC-4D2D-863C-C3888691083B}';

    RetornoBiometriaFoto := TJSONObject.Create;
    OperStart := TOperClientBiometria.Create(DSRestConn);
    RetornoBiometriaFoto := OperStart.biometria_foto
      (EnvioBiometriaFoto, 'token');

    jp := RetornoBiometriaFoto.Pairs[0];
    ja := (jp.JsonValue as TJSONArray);

    if jp.JsonString.ToString = '"resultado"' then
    begin

      if ja.Items[0].Value <> 'null' then
      begin

        for I := 0 to ja.Count - 1 do
        begin
          // itera o array para pegar cada elemento
          jSubObj := (ja.Items[I] as TJSONObject);

          // quantidade de pares do objeto
          for j := 0 to jSubObj.Count - 1 do
          begin
            // itera o objeto para pegar cada par
            jSubPar := jSubObj.Pairs[j];

            // pega o par no índice j
            // do par pega separado a chave e o valor usando Value
            if jSubPar.JsonString.Value = 'codigo' then
              CodigoRetorno := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'mensagem' then
              MensagemRetorno := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'foto' then
              if Trim (jSubPar.JsonValue.Value) <> '' then
                ParCandidato.Foto := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'foto1' then
              if Trim (jSubPar.JsonValue.Value) <> '' then
                ParCandidato.Foto := jSubPar.JsonValue.Value;

          end;
        end;
      end;
    end;

    if (CodigoRetorno = 'B000') then
    begin
      if ParCandidato.Foto = '' then
      begin
        CodigoRetorno := 'B998';
        MensagemRetorno := 'A imagem da foto não foi gerada corretamente!';
        Result := False;
      end
      else
        Result := True
    end
    else
    begin

      Result := False;

      // Usuário cancela B900
      // Usuário cancela B025
      // Usuário cancela B995

      if (CodigoRetorno = 'B025') or (CodigoRetorno = 'B995') then
      begin

        if Parquestionario.id_prova = 0 then
        begin

            MensagemRetorno :=
                            'As biometrias não conferem com as que foram cadastradas na matrícula.'+ #13 +
                            'Faça o recadastro das biometrias.';

        end
        else
        begin

          if TelaExameBiometriaFoto then
            MensagemRetorno :=
                            'As biometrias não conferem. A prova será bloqueada.'+ #13+
                            'Aguarde o desbloqueio que será realizado pelo DETRAN.'
          else
            MensagemRetorno :=
                            'As biometrias não conferem com as que foram cadastradas na matrícula.'+ #13+
                            'Faça o recadastro das biometrias.';
        end;

      end
      else
      begin
          MensagemRetorno := MensagemRetorno ;
      end;

    end;

    OperStart.DisposeOf;

  except on E: Exception do
    begin
      GravaArquivoLog(self,' BiomatriaFoto - ' + E.Message);
      Result := False;
    end;
  end;

end;

{ TToken }

function TToken.GetToken(program_server: Integer; program_version: string;
  user: string; password: string): String;
var
  DSRestConn: TDSRestConnection;
  OperStart: TOperClientBiometria;

  EnvioToken: TJSONObject;
  RetornoToken: TJSONObject;

  I, j: Integer;

  jSubObj: TJSONObject;
  ja: TJSONArray;
  jp, jSubPar: TJSONPair;

begin
  inherited;
  try

    EnvioToken := TJSONObject.Create;
    EnvioToken := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes('{"token":[{' + '"program_server":"' +
      IntToStr(program_server) + '",' + '"program_version":"' + program_version
      + '",' + '"user":"' + user + '",' + '"password":"' + password + '"}]}'),
      0) as TJSONObject;

    DSRestConn := TDSRestConnection.Create(nil);

    DSRestConn.Port := 9191;
    DSRestConn.Context := 'grupocriar/';
    DSRestConn.RESTContext := 'servidor/';
    DSRestConn.LoginPrompt := False;
    DSRestConn.UniqueId := '{79BDA36A-D3EC-4D2D-863C-C3888691083B}';

    RetornoToken := TJSONObject.Create;
    OperStart := TOperClientBiometria.Create(DSRestConn);
    RetornoToken := OperStart.Token(EnvioToken, 'token');

    jp := RetornoToken.Pairs[0];
    ja := (jp.JsonValue as TJSONArray);

    if jp.JsonString.ToString = '"resultado"' then
    begin
      if ja.Items[0].Value <> 'null' then
      begin
        for I := 0 to ja.Count - 1 do
        begin
          // itera o array para pegar cada elemento
          jSubObj := (ja.Items[I] as TJSONObject);

          // quantidade de pares do objeto
          for j := 0 to jSubObj.Count - 1 do
          begin
            // itera o objeto para pegar cada par
            jSubPar := jSubObj.Pairs[j];

            // pega o par no índice j
            // do par pega separado a chave e o valor usando Value
            if jSubPar.JsonString.Value = 'codigo' then
            begin
              CodigoRetorno := jSubPar.JsonValue.Value;
            end;

            if jSubPar.JsonString.Value = 'mensagem' then
            begin
              MensagemRetorno := jSubPar.JsonValue.Value;
            end;

            if jSubPar.JsonString.Value = 'token' then
            begin
              Result := jSubPar.JsonValue.Value;
              Token := Result;
            end;

          end;

        end;
      end;
    end;

  except on E: Exception do
    begin
      GravaArquivoLog(self,' Parametros - SO e MAC - ' + E.Message);

      if (PingSevidoresCRIAR('internic.net')) and
         (ParCFC.offline = 'S') then
      begin
        CodigoRetorno := 'D555';
        MensagemRetorno := 'Modo offline';
        Result := '';
      end;

    end;
  end;

end;

function TBiometriaFoto.GetFoto: Boolean;
var
  DSRestConn: TDSRestConnection;
  OperStart: TOperClientBiometria;

  EnvioFoto: TJSONObject;
  RetornoFoto: TJSONObject;

  I, j: Integer;

  jSubObj: TJSONObject;
  ja: TJSONArray;
  jp, jSubPar: TJSONPair;

  strRENACHCandidato: string;

begin
  inherited;

  try
    Result := True;
    Token := TToken.Create;
    Token.GetToken(Parametros.IdSistema, Parametros.Versao, ParCFC.Usuario, LowerCase(MD5(ParCFC.Senha)));

    if Token.CodigoRetorno = 'D555' then
    begin
      CodigoRetorno := 'D555';
      MensagemRetorno := 'Modo offline';
      Result := True;
    end;

    if Trim(ParCandidato.RENACHCandidato) = '' then
      strRENACHCandidato := ParCandidato.CPFCandidato
    else
      strRENACHCandidato := ParCandidato.RENACHCandidato;

    EnvioFoto := TJSONObject.Create;
    EnvioFoto := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(
        '{"sistema": '+
          '[{"program_server": "' + IntToStr(Parametros.IdSistema) + '",'+
          '"program_version":"'+ Parametros.Versao + '",'+
          '"user":"'+ ParCFC.Usuario +'",'+
          '"show_message":"N",'+
          '"token":"' + Token.Token + '"}],' +
        '"biometria": '+
          '[{"tipo_biometria": "4",'+
          '"tentativas": "3",'+
          '"quantidade": "1",'+
          '"qtde_minima": "3",'+
          '"dedo_vivo": "S",'+
          '"com_foto": "S"}],'+
        '"foto": '+
          '[{"tipo_foto": "1",'+
          '"quantidade": "1",'+
          '"transmitir": "S",'+
          '"avanco_automatico": "N" }],' +
        '"pessoa": '+
          '[{"tipo_inscricao": "2",'+
          '"inscricao": "' + ParCandidato.CPFCandidato + '",'+
          '"nome": "' + ParCandidato.NomeCandidato + '",'+
          '"tipo_pessoa": "C",'+
          '"area_ciretran": "' + ParCFC.Cod_Ciretran + '",'+
          '"registro": "' + strRENACHCandidato + '",' +
          '"local_exame": "2",'+
          '"local_busca": "2",'+
          '"municipio": "0",'+
          '"param1": "1" }]}')
      , 0 ) as TJSONObject;

    DSRestConn := TDSRestConnection.Create(nil);

    DSRestConn.Port := 9191;
    DSRestConn.Context := 'grupocriar/';
    DSRestConn.RESTContext := 'servidor/';
    DSRestConn.LoginPrompt := False;
    DSRestConn.UniqueId := '{79BDA36A-D3EC-4D2D-863C-C3888691083B}';

    RetornoFoto := TJSONObject.Create;
    OperStart := TOperClientBiometria.Create(DSRestConn);
    RetornoFoto := OperStart.biometria_foto(EnvioFoto, 'token');

    jp := RetornoFoto.Pairs[0];
    ja := (jp.JsonValue as TJSONArray);

    if jp.JsonString.ToString = '"resultado"' then
    begin
      if ja.Items[0].Value <> 'null' then
      begin
        for I := 0 to ja.Count - 1 do
        begin
          // itera o array para pegar cada elemento
          jSubObj := (ja.Items[I] as TJSONObject);

          // quantidade de pares do objeto
          for j := 0 to jSubObj.Count - 1 do
          begin
            // itera o objeto para pegar cada par
            jSubPar := jSubObj.Pairs[j];

            // pega o par no índice j
            // do par pega separado a chave e o valor usando Value
            if jSubPar.JsonString.Value = 'codigo' then
              CodigoRetorno := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'mensagem' then
              MensagemRetorno := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'foto' then
              if Trim (jSubPar.JsonValue.Value) <> '' then
                ParCandidato.Foto := jSubPar.JsonValue.Value;

            if jSubPar.JsonString.Value = 'foto1' then
              if Trim (jSubPar.JsonValue.Value) <> '' then
                ParCandidato.Foto := jSubPar.JsonValue.Value;

          end;

        end;
      end;
    end;

    if CodigoRetorno = 'B000' then
    begin
      if ParCandidato.Foto = '' then
      begin
        CodigoRetorno := 'B998';
        MensagemRetorno := 'A imagem da foto não foi gerada corretamente!';
        Result := False;
      end
      else
        Result := True
    end
    else
      Result := False;

    OperStart.DisposeOf;

  except on E: Exception do
    begin
      GravaArquivoLog(self,' Foto - ' + E.Message);
      Result := False;
    end;
  end;

end;

function TToken.PingSevidoresCRIAR(arServidor: string): Boolean;
var
  IdICMPClient: TIdICMPClient;
begin

  try

    IdICMPClient := TIdICMPClient.Create( nil );
    IdICMPClient.Host := arServidor;
    IdICMPClient.ReceiveTimeout := 500;
    IdICMPClient.Ping;

    Result := (IdICMPClient.ReplyStatus.BytesReceived  > 0);

  except on E: Exception do
    Result := True;  // Após testes retornar para false;
  end;

end;

end.
