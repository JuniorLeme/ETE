unit ClsConexaoFerramentas;

interface

uses System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  Winsock, Vcl.Forms, ClsParametros, IdICMPClient, IdTelnet, Winapi.Windows,
  Winapi.Wininet, System.Win.Registry;

type
  TConexao = Class
  public
    function GetIP(const HostName: string): string;
    function PingDNSGrupoCRIAR: Boolean;
    Function Ping(argIP: String): Boolean;
    Function PingCMD(argIP: String): Boolean;
    Function Telnet(argIP: String; Porta: Integer): Boolean;
  private
    procedure RunDosInMemo(DosApp: String; AStrList: TStringList);
  End;

function GetRegistryValue(KeyName: string): string;

implementation

function GetRegistryValue(KeyName: string): string;
Var
  Registro: TRegistry;
begin

  Registro := TRegistry.Create;

  Registro.RootKey := HKEY_CURRENT_USER;

  if Registro.OpenKey(KeyName, true) then
    Result := Registro.ReadString(KeyName);

  Registro.CloseKey;

  Registro.Free;

end;

function TConexao.GetIP(const HostName: string): string;
var
  HostShortA: string;
  HostShortB: string;
  IdICMPClient: TIdICMPClient;
begin

  // Ping DNS do Grupo CRIAR
  try

    IdICMPClient := TIdICMPClient.Create(nil);

    if Pos('http://', HostName, 1) > 0 then
      HostShortA := ReplaceStr(HostName, 'http://', '')
    else
      HostShortA := HostName;

    HostShortA := Copy(HostShortA, 1, Pos('.com.br', HostShortA, 1) + 6);

    HostShortB := HostShortA;

    // (Parametros.ListaServidores.Objects[S] as TStringList)[E];
    IdICMPClient.Host := HostShortA;
    IdICMPClient.ReceiveTimeout := 3000;
    IdICMPClient.Ping;

    // HostShortB := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
    HostShortB := IdICMPClient.ReplyStatus.FromIpAddress;
    Result := ReplaceStr(HostName, HostShortA, HostShortB);

  except
    on E: Exception do

  end;

end;

function TConexao.Ping(argIP: String): Boolean;
var
  IdICMPClient: TIdICMPClient;
begin
  IdICMPClient := TIdICMPClient.Create(nil);

  try
    IdICMPClient.Host := argIP;
    IdICMPClient.ReceiveTimeout := 2000;
    IdICMPClient.Ping(argIP, 1);

    Result := (IdICMPClient.ReplyStatus.BytesReceived > 0);
  finally
    IdICMPClient.Free;
  end

end;

function TConexao.PingCMD(argIP: String): Boolean;
var
  C: Integer;
  Comando: string;
  intEnviados: Integer;
  intRecebidos: Integer;
  intPerdidos: Integer;
  strList: TStringList;
begin

  Comando := '';
  intEnviados := 0;
  intPerdidos := 0;

  // "189.123.114.50", 37777, "suport","aa1234"
  strList := TStringList.Create;
  strList.Clear;

  Comando := 'ping ' + Trim(argIP) + ' -n 2';

  strList.Add(Comando);
  RunDosInMemo(Comando, strList);

  for C := 0 to strList.Count - 1 do
  begin

    if Pos('Enviados = ', strList[C]) <> 0 then
      intEnviados := StrToIntDef
        (StringReplace(Copy(strList[C], Pos('Enviados = ', strList[C]) +
        length('Enviados = '), 3), ',', '', [rfReplaceAll]), 0);

    if Pos('Recebidos = ', strList[C]) <> 0 then
      intRecebidos :=
        StrToIntDef(StringReplace(Copy(strList[C], Pos('Recebidos = ',
        strList[C]) + length('Recebidos = '), 3), ',', '', [rfReplaceAll]), 0);

    if Pos('Perdidos = ', strList[C]) <> 0 then
      intPerdidos := StrToIntDef
        (StringReplace(Copy(strList[C], Pos('Perdidos = ', strList[C]) +
        length('Perdidos = '), 3), '(', '', [rfReplaceAll]), 0);

    if Pos('solicita��o ping n�o p�de encontrar o host', strList[C]) <> 0 then
    begin
      intEnviados := 10;
      intPerdidos := 10;
    end;

  end;

  if intPerdidos > (intEnviados / 2) then
    Result := False
  else
    Result := true;

  {
    Estat�sticas do Ping para 189.123.114.50:
    Pacotes: Enviados = 4, Recebidos = 4, Perdidos = 0 (0% de
    perda)
    solicita��o ping n�o p�de encontrar o host interni_c.net
  }

end;

function TConexao.PingDNSGrupoCRIAR: Boolean;
const
  // Local system has a valid connection to the Internet, but it might or might
  // not be currently connected.
  INTERNET_CONNECTION_CONFIGURED = $40;

  // Local system uses a local area network to connect to the Internet.
  INTERNET_CONNECTION_LAN = $02;

  // Local system uses a modem to connect to the Internet
  INTERNET_CONNECTION_MODEM = $01;

  // Local system is in offline mode.
  INTERNET_CONNECTION_OFFLINE = $20;

  // Local system uses a proxy server to connect to the Internet
  INTERNET_CONNECTION_PROXY = $04;

  // Local system has RAS installed.
  INTERNET_RAS_INSTALLED = $10;

var
  InetState: Cardinal;
begin

  try

    Result := InternetGetConnectedState(@InetState, 0);

    if (Result and (InetState and INTERNET_CONNECTION_CONFIGURED =
      INTERNET_CONNECTION_CONFIGURED)) then
    begin
      Result := Ping('internic.net');
    end
    else if (InetState and INTERNET_CONNECTION_OFFLINE =
      INTERNET_CONNECTION_OFFLINE) then
      Result := False
    else if (InetState and INTERNET_CONNECTION_LAN <> 0) then
    begin

      if not(Ping('internic.net')) then
        Result := False
      else if (InetState and INTERNET_CONNECTION_OFFLINE <> 0) then
        Result := False
      else if (InetState and INTERNET_CONNECTION_CONFIGURED <> 0) then
        Result := False;
    end;

  except
    on E: Exception do
      Result := False
  end;

end;

function TConexao.Telnet(argIP: String; Porta: Integer): Boolean;
var
  IdTelnet1: TIdTelnet;
Begin

  {
    A Porta[443] est� aberta.
    Verifica��o Terminada.

    Erro: Socket Error # 10061
    Connection refused.
    Verifica��o Terminada.

    A Porta[443] est� aberta.
    Verifica��o Terminada.

    Erro: Socket Error # 11001
    Host not found.
    Verifica��o Terminada.
  }

  IdTelnet1 := TIdTelnet.Create(nil);

  Try
    IdTelnet1.Host := argIP;

    Application.ProcessMessages;
    IdTelnet1.Port := Porta;

    IdTelnet1.Connect;

    Result := IdTelnet1.Connected;

    IdTelnet1.Disconnect;

  Except
    On E: Exception do
    Begin
      Result := False;
    End;
  End;

end;

procedure TConexao.RunDosInMemo(DosApp: String; AStrList: TStringList);
const
  ReadBuffer = 2400;
var
  Security: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  start: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  Buffer: PAnsiChar;
  BytesRead: DWORD;
  Apprunning: DWORD;
begin

  With Security do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := true;
    lpsecuritydescriptor := nil;
  end;

  if Createpipe(ReadPipe, WritePipe, @Security, 0) then
  begin
    Buffer := AllocMem(ReadBuffer + 1);
    FillChar(start, SizeOf(start), #0);
    start.cb := SizeOf(start);
    start.hStdOutput := WritePipe;
    start.hStdInput := ReadPipe;
    start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;

    // if CreateProcess(nil, Pchar(DosApp), @Security, @Security, true, NORMAL_PRIORITY_CLASS, nil, nil, start, ProcessInfo) then
    if CreateProcess(nil, PChar(DosApp), @Security, @Security, true,
      NORMAL_PRIORITY_CLASS, nil, nil, start, ProcessInfo) then
    begin

      repeat
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess, 100);
        Application.ProcessMessages;
      until (Apprunning <> WAIT_TIMEOUT);

      Repeat
        BytesRead := 0;
        ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil);
        Buffer[BytesRead] := #0;
        OemToAnsi(Buffer, Buffer);
        AStrList.Text := AStrList.Text + String(Buffer);
        Sleep(100);
      until (BytesRead < ReadBuffer);

    end;

    FreeMem(Buffer);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);

  end;
end;

end.
