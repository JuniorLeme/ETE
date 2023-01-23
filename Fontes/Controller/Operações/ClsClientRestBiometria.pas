//
// Created by the DataSnap proxy generator.
// 07/03/2016 08:35:51
//

unit ClsClientRestBiometria;

interface
  uses
    System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest,
    Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON,
    Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB,
    Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, IPPeerClient,
    Data.DBXJSONReflect;

type
  TOperClientBiometria = class(TDSAdminRestClient)
  private
    FtokenCommand: TDSRestCommand;
    FtokenCommand_Cache: TDSRestCommand;
    FupdatetokenCommand: TDSRestCommand;
    FupdatetokenCommand_Cache: TDSRestCommand;
    Fbiometria_fotoCommand: TDSRestCommand;
    Fbiometria_fotoCommand_Cache: TDSRestCommand;
    Fupdatebiometria_fotoCommand: TDSRestCommand;
    Fupdatebiometria_fotoCommand_Cache: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function token(Arg: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function token_Cache(Arg: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function updatetoken(Arg: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function updatetoken_Cache(Arg: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function biometria_foto(Arg: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function biometria_foto_Cache(Arg: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function updatebiometria_foto(Arg: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function updatebiometria_foto_Cache(Arg: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
  end;

const
  operacao_token: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  operacao_token_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  operacao_updatetoken: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  operacao_updatetoken_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  operacao_biometria_foto: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  operacao_biometria_foto_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  operacao_updatebiometria_foto: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  operacao_updatebiometria_foto_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Arg'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

implementation

function TOperClientBiometria.token(Arg: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if FtokenCommand = nil then
  begin
    FtokenCommand := FConnection.CreateCommand;
    FtokenCommand.RequestType := 'POST';
    FtokenCommand.Text := 'operacao."token"';
    FtokenCommand.Prepare(operacao_token);
  end;
  FtokenCommand.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  FtokenCommand.Execute(ARequestFilter);
  Result := TJSONObject(FtokenCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TOperClientBiometria.token_Cache(Arg: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FtokenCommand_Cache = nil then
  begin
    FtokenCommand_Cache := FConnection.CreateCommand;
    FtokenCommand_Cache.RequestType := 'POST';
    FtokenCommand_Cache.Text := 'operacao."token"';
    FtokenCommand_Cache.Prepare(operacao_token_Cache);
  end;
  FtokenCommand_Cache.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  FtokenCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FtokenCommand_Cache.Parameters[1].Value.GetString);
end;

function TOperClientBiometria.updatetoken(Arg: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if FupdatetokenCommand = nil then
  begin
    FupdatetokenCommand := FConnection.CreateCommand;
    FupdatetokenCommand.RequestType := 'POST';
    FupdatetokenCommand.Text := 'operacao."updatetoken"';
    FupdatetokenCommand.Prepare(operacao_updatetoken);
  end;
  FupdatetokenCommand.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  FupdatetokenCommand.Execute(ARequestFilter);
  Result := TJSONObject(FupdatetokenCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TOperClientBiometria.updatetoken_Cache(Arg: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FupdatetokenCommand_Cache = nil then
  begin
    FupdatetokenCommand_Cache := FConnection.CreateCommand;
    FupdatetokenCommand_Cache.RequestType := 'POST';
    FupdatetokenCommand_Cache.Text := 'operacao."updatetoken"';
    FupdatetokenCommand_Cache.Prepare(operacao_updatetoken_Cache);
  end;
  FupdatetokenCommand_Cache.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  FupdatetokenCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FupdatetokenCommand_Cache.Parameters[1].Value.GetString);
end;

function TOperClientBiometria.biometria_foto(Arg: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if Fbiometria_fotoCommand = nil then
  begin
    Fbiometria_fotoCommand := FConnection.CreateCommand;
    Fbiometria_fotoCommand.RequestType := 'POST';
    Fbiometria_fotoCommand.Text := 'operacao."biometria_foto"';
    Fbiometria_fotoCommand.Prepare(operacao_biometria_foto);
  end;
  Fbiometria_fotoCommand.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  Fbiometria_fotoCommand.Execute(ARequestFilter);
  Result := TJSONObject(Fbiometria_fotoCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TOperClientBiometria.biometria_foto_Cache(Arg: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if Fbiometria_fotoCommand_Cache = nil then
  begin
    Fbiometria_fotoCommand_Cache := FConnection.CreateCommand;
    Fbiometria_fotoCommand_Cache.RequestType := 'POST';
    Fbiometria_fotoCommand_Cache.Text := 'operacao."biometria_foto"';
    Fbiometria_fotoCommand_Cache.Prepare(operacao_biometria_foto_Cache);
  end;
  Fbiometria_fotoCommand_Cache.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  Fbiometria_fotoCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(Fbiometria_fotoCommand_Cache.Parameters[1].Value.GetString);
end;

function TOperClientBiometria.updatebiometria_foto(Arg: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if Fupdatebiometria_fotoCommand = nil then
  begin
    Fupdatebiometria_fotoCommand := FConnection.CreateCommand;
    Fupdatebiometria_fotoCommand.RequestType := 'POST';
    Fupdatebiometria_fotoCommand.Text := 'operacao."updatebiometria_foto"';
    Fupdatebiometria_fotoCommand.Prepare(operacao_updatebiometria_foto);
  end;
  Fupdatebiometria_fotoCommand.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  Fupdatebiometria_fotoCommand.Execute(ARequestFilter);
  Result := TJSONObject(Fupdatebiometria_fotoCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TOperClientBiometria.updatebiometria_foto_Cache(Arg: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if Fupdatebiometria_fotoCommand_Cache = nil then
  begin
    Fupdatebiometria_fotoCommand_Cache := FConnection.CreateCommand;
    Fupdatebiometria_fotoCommand_Cache.RequestType := 'POST';
    Fupdatebiometria_fotoCommand_Cache.Text := 'operacao."updatebiometria_foto"';
    Fupdatebiometria_fotoCommand_Cache.Prepare(operacao_updatebiometria_foto_Cache);
  end;
  Fupdatebiometria_fotoCommand_Cache.Parameters[0].Value.SetJSONValue(Arg, FInstanceOwner);
  Fupdatebiometria_fotoCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(Fupdatebiometria_fotoCommand_Cache.Parameters[1].Value.GetString);
end;

constructor TOperClientBiometria.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TOperClientBiometria.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TOperClientBiometria.Destroy;
begin
  FtokenCommand.DisposeOf;
  FtokenCommand_Cache.DisposeOf;
  FupdatetokenCommand.DisposeOf;
  FupdatetokenCommand_Cache.DisposeOf;
  Fbiometria_fotoCommand.DisposeOf;
  Fbiometria_fotoCommand_Cache.DisposeOf;
  Fupdatebiometria_fotoCommand.DisposeOf;
  Fupdatebiometria_fotoCommand_Cache.DisposeOf;
  inherited;
end;

end.
