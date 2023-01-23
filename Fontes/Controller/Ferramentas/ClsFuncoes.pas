unit ClsFuncoes;

interface

uses Winapi.Windows, VCL.Forms, Winapi.Messages, Winapi.WinSock, WinInet, System.SysUtils,
  System.Variants, System.IniFiles, System.Win.Registry, VCL.Dialogs, System.StrUtils,
  System.UITypes, System.Classes, Tlhelp32, VCL.Imaging.jpeg, Winapi.Shlobj, ClsGerenciarObjeto,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, Datasnap.DSClientRest,
  System.Win.ComObj, Winapi.ActiveX;

type
  TArquivoLog = class

  protected
    LogsLista: TStringList;
    Gravando: Boolean;

  public
    procedure Gravar;
    procedure GravaArquivoLog(Linha: WideString);
    function LimpaArquivoLog(Linha: WideString): Boolean;

    destructor Destroy;
    constructor Create;

  end;

  TSunB = packed record
    s_b1, s_b2, s_b3, s_b4: byte;
  end;

  TSunW = packed record
    s_w1, s_w2: word;
  end;

  PIPAddr = ^TIPAddr;

  TIPAddr = record
    case integer of
      0:
        (S_un_b: TSunB);
      1:
        (S_un_w: TSunW);
      2:
        (S_addr: longword);
  end;

  Maquina = class
    Nome: string;
    MAC: string;
    IP: string;
  private
    function SysComputerName: string;
    function GetIP: string;
  public
    constructor Create;
  end;

  IPAddr = TIPAddr;

function EnviarAviso(Tipo: TMsgDlgType; Texto: String): Boolean;

function KillTask(ExeFileName: string): integer;

function ValidarSoftwareAberto(ExeFileName: String): Boolean;
procedure ProcessaMensagensWindows(var Msg: TMsg; var Handled: Boolean);

function IcmpCreateFile: THandle; stdcall; external 'icmp.dll';
function IcmpCloseHandle(icmpHandle: THandle): Boolean; stdcall;
  external 'icmp.dll';
function IcmpSendEcho(icmpHandle: THandle; DestinationAddress: IPAddr;
  RequestData: Pointer; RequestSize: Smallint; RequestOptions: Pointer;
  ReplyBuffer: Pointer; ReplySize: DWORD; Timeout: DWORD): DWORD; stdcall;
  external 'icmp.dll';

function IsNT: Boolean;

function CaptaParametros(Area, Chave: string): string;
function GravaParametros(Area, Chave, Valor: string): Boolean;

function UserProgranData: string;
function UserProfileDir: string;

function LeftStr(Texto: string; cDigitos: integer): String;
function RightStr(Texto: string; cDigitos: integer): String;
function HparaN(Hora: Real): Real;
function NparaH(Numero: Real): Real;
function ReplaceStr(Str: WideString; Old, New: String): string;
function textocaixabaixa(const S: string): string;
function textocaixaalta(const S: string): string;
function IsWindows64: Boolean;
function iif(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
function GetSpecialFolderPath(folder: integer): string;
function GetVersaoArq: string;
function GetListSistemResource(Arg: TStringList): TStringList;

procedure AtualizarForm(NomeForm: TForm; ID_Sistema: integer);
procedure SalvarForm(NomeForm: TForm);
Function LRPad(Str: String; Size: integer; Pad: char; LorR: char): string;
function ProcurarWebcam: String;

const
  AVICAP32 = 'AVICAP32.dll';
  SECURITY_NT_AUTHORITY: _SID_IDENTIFIER_AUTHORITY =
    (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID: CARDINAL = $00000020;
  DOMAIN_ALIAS_RID_ADMINS: CARDINAL = $00000220;


var
  ArquivoLog: TArquivoLog;

implementation
	uses clseProvaConst, vcl.Controls;

function ProcurarWebcam: String;
  const
  wbemFlagForwardOnly = $00000020;

  var
  FSWbemLocator: OleVariant;
  FWMIService: OleVariant;
  FWbemObjectSet: OleVariant;
  FWbemObject: OleVariant;
  oEnum: IEnumvariant;
  iValue: longword;
  ListaCamera: TStringList;
begin

  ListaCamera := TStringList.Create;
  ListaCamera.Clear;

  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\cimv2', '', '');
  FWbemObjectSet := FWMIService.ExecQuery(
    'SELECT * '+
    ' FROM  Win32_PnPEntity '+
    ' WHERE (Service = ''usbvideo'' or Service = ''USBET'' or Caption LIKE ''%Camera%'' ) ' + // or PNPDeviceID = LIKE ''%\IMAGE\%''
    '  and Status = ''OK''', 'WQL', wbemFlagForwardOnly);

  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    try

      try
        ListaCamera.Add(FWbemObject.Caption);
      except
      on E: Exception do
        Continue;
      end;

      FWbemObject := Unassigned;
    except
      on E: Exception do
      begin
        FWbemObject := Unassigned;
      end;
    end;

  end;

  if ListaCamera.Count > 0 then
    Result := ListaCamera[0];

end;

Function LRPad(Str: String; Size: integer; Pad: char; LorR: char): string;
var
  i, cont: integer;
  S: string;
  // Str: string a ser preenchida
  // Size: qual o tamanho que ela deve ficar
  // Pad: Qual ser� o preenchimento
  // LorR: esquerda ou direita?
begin
  cont := Length(Str);
  S := '';
  if upCase(LorR) = 'L' then
  begin
    for i := 1 to Size - cont do
      S := S + Pad;
    S := S + Str;
  end
  else
  begin
    for i := 1 to Size - cont do
      S := S + Pad;
    S := Str + S;
  end;
  LRPad := copy(S, 1, Size);
end;

function GetListSistemResource(Arg: TStringList): TStringList;

const
  wbemFlagForwardOnly = $00000020;

var
  FSWbemLocator: OleVariant;
  FWMIService: OleVariant;
  FWbemObjectSet: OleVariant;
  FWbemObject: OleVariant;
  oEnum: IEnumvariant;
  iValue: longword;
  i: integer;
begin

  Result := TStringList.Create;
  Result.Clear;

  for i := 0 to Arg.Count - 1 do
  begin

    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost',
      'root\cimv2', '', '');

    if (Trim(Arg[i]) = 'Win32_NetworkAdapter') then
    begin
      FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM ' + Trim(Arg[i]) +
        ' where MACAddress is not null ', 'WQL', wbemFlagForwardOnly);
    end
    else
    begin
      FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM ' + Trim(Arg[i]),
        'WQL', wbemFlagForwardOnly);
    end;

    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

    while oEnum.Next(1, FWbemObject, iValue) = 0 do
    begin
      try

        try

          if (Trim(Arg[i]) = 'Win32_Service') or
            (Trim(Arg[i]) = 'Win32_Keyboard') or
            (Trim(Arg[i]) = 'Win32_ServiceControl') or
            (Trim(Arg[i]) = 'Win32_Process') or
            (Trim(Arg[i]) = 'Win32_OperatingSystem') or
            (Trim(Arg[i]) = 'Win32_Product') then
            Result.Add(FWbemObject.Caption)
          else
          begin

            if (Trim(Arg[i]) = 'Win32_NetworkAdapter') then
            begin
              Result.Add(FWbemObject.MACAddress)
            end
            else
              Result.Add(FWbemObject.DeviceID);
          end;

        except
          on E: Exception do
            Continue;
        end;

        FWbemObject := Unassigned;
      except
        on E: Exception do
        begin
          FWbemObject := Unassigned;
        end;
      end;
    end;

  end;

end;

constructor Maquina.Create;
begin
  Nome := SysComputerName;
  IP := GetIP;
end;

function EnviarAviso(Tipo: TMsgDlgType; Texto: String): Boolean;
begin

  Result := False;

  Application.NormalizeTopMosts;
  Texto := Trim(Texto);

  if Tipo = mtConfirmation then
  begin
    if Application.MessageBox(PWideChar(Texto), PWideChar(Application.Title), MB_ICONQUESTION + MB_YESNO) = mrYes then
    begin
      Result := true;
    end;
  end;

  if Tipo = mtInformation then
  begin
    Application.MessageBox(PWideChar(Texto), PWideChar(Application.Title), MB_ICONEXCLAMATION + MB_OK);
    Result := true;
  end;

  Application.RestoreTopMosts;

end;

function Maquina.GetIP: string;

var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name: string;
begin

  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PAnsiChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PAnsiChar(Name));

  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d', [byte(h_addr^[0]), byte(h_addr^[1]),
      byte(h_addr^[2]), byte(h_addr^[3])]);
  end;

  WSACleanup;

end;

procedure SalvarForm(NomeForm: TForm);
begin
  GerComp := Gerenciador.Create;
  GerComp.FormToXMLDocument(NomeForm);
  GerComp.XMLObjetct.Active := true;
  GerComp.XMLObjetct.Active := False;
  GerComp.Free;
end;

procedure AtualizarForm(NomeForm: TForm; ID_Sistema: integer);
begin
  GerComp := Gerenciador.Create;
  GerComp.XMLDocumentToForm(NomeForm, ID_Sistema);
  GerComp.Free;
end;

function KillTask(ExeFileName: string): integer;

const
  PROCESS_TERMINATE = $0001;

var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
      Result := integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));

    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;

  CloseHandle(FSnapshotHandle);
end;

function ValidarSoftwareAberto(ExeFileName: String): Boolean;

const
  PROCESS_TERMINATE = $0001;

var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
    begin
      Result := true;
      Exit;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function IsWindows64: Boolean;

type
  TIsWow64Process = function(AHandle: THandle; var AIsWow64: BOOL)
    : BOOL; stdcall;

var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64: BOOL;
begin
  Result := False;

  vKernel32Handle := LoadLibrary('kernel32.dll');

  if (vKernel32Handle = 0) then
    Exit;

  try
    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');

    if not Assigned(vIsWow64Process) then
      Exit;

    vIsWow64Process(GetCurrentProcess, vIsWow64);
    Result := vIsWow64;
  finally
    FreeLibrary(vKernel32Handle);
  end;
end;

function textocaixabaixa(const S: string): string;

var
  Ch: char;
  L: integer;
  Source, Dest: PChar;
  Caracteres: TSysCharSet;
begin

  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  Caracteres := ['�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�'];

  while L <> 0 do
  begin

    Ch := Source^;

    if ((Ch >= 'A') and (Ch <= 'Z')) or (CharInSet(Ch, Caracteres)) then
      // (Ch in ['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�']) then
      Inc(Ch, 32);

    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function textocaixaalta(const S: string): string;
var
  Ch: char;
  L: integer;
  Source, Dest: PChar;
  Caracteres: TStringList;
  CaracteresDonw: TStringList;
begin

  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);

  Caracteres := TStringList.Create;
  Caracteres.Delimiter := ',';
  Caracteres.DelimitedText := '�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�';

  CaracteresDonw := TStringList.Create;
  CaracteresDonw.Delimiter := ',';
  CaracteresDonw.DelimitedText := '�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�';

  while L <> 0 do
  begin

    Ch := Source^;

    if ((Ch >= 'a') and (Ch <= 'z')) then
      Dec(Ch, 32);

    if CaracteresDonw.IndexOf(Ch) > 0 then
      Ch := Caracteres[CaracteresDonw.IndexOf(Ch)].ToCharArray[0];

    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);

  end;

end;

function ReplaceStr(Str: WideString; Old, New: String): string;

var
  i: integer;
  St: String;
begin
  i := 1;
  St := Str;

  i := PosEx(Old, St, i);

  While i <> 0 do
  begin
    Delete(St, i, Length(Old));
    If New <> '' then
      insert(New, St, i);
    i := i - Length(Old) + Length(New);
    i := PosEx(Old, St, i);
  end;

  Str := St;
  Result := St;
end;

function HparaN(Hora: Real): Real;
begin
  Result := Int(Hora) + ((Hora - Int(Hora)) * 1.666666);
end;

function NparaH(Numero: Real): Real;
begin
  Result := 0;

  Try
    if Numero > 0 then
      Result := Int(Numero) + ((Numero - Int(Numero)) / 1.666666);

    if strToInt(copy(FloatToStrF(Result, ffNumber, 60, 2),
      Length(FloatToStrF(Result, ffNumber, 60, 2)) - 1, 2)) = 60 then
      Result := Result + 0.40;
  except
    begin
      Result := 0;
    end;
  end;
end;

function LeftStr(Texto: string; cDigitos: integer): String;
begin
  Result := copy(Texto, 1, cDigitos);
end;

function RightStr(Texto: string; cDigitos: integer): String;
begin
  Result := copy(Texto, Length(Texto) - cDigitos + 1, cDigitos);
end;

procedure ProcessaMensagensWindows(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.wParam = vk_Return then
    Screen.ActiveForm.Perform(WM_NextDlgCtl, 0, 0);
end;

function IsNT: Boolean;

Var
  ovi: TOSVersionInfo;
begin
  FillChar(ovi, SizeOf(ovi), 0);
  ovi.dwOSVersionInfoSize := SizeOf(ovi);
  GetVersionEx(ovi);
  Result := ovi.dwPlatformId = VER_PLATFORM_WIN32_NT;
end;

function CaptaParametros(Area, Chave: string): string;

var
  Ini: TIniFile;
begin
  Result := 'Erro';

  if FileExists(UserProgranData + '\Criar\Parametros.cfg') then
  begin
    Ini := TIniFile.Create(UserProgranData + '\Criar\Parametros.cfg');
    Result := Ini.ReadString(Area, Chave, 'Erro');
    Ini.Free;
  end;
end;

function GravaParametros(Area, Chave, Valor: string): Boolean;

var
  Ini: TIniFile;
begin
  if FileExists(UserProgranData + '\Criar\Parametros.cfg') then
  begin
    Ini := TIniFile.Create(UserProgranData + '\Criar\Parametros.cfg');
    Ini.WriteString(Area, Chave, Valor);
    Ini.Free;
  end;

  Result := true;
end;

function GetSpecialFolderPath(folder: integer): string;

const
  SHGFP_TYPE_CURRENT = 0;

var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

function UserProgranData: string;
begin
  Result := GetSpecialFolderPath(CSIDL_COMMON_APPDATA);
end;

function UserProfileDir: string;
begin
  if IsWindows64 then
    Result := GetSpecialFolderPath(CSIDL_PROGRAM_FILESX86)
  else
    Result := GetSpecialFolderPath(CSIDL_PROGRAM_FILES);
end;

function Maquina.SysComputerName: string;

var
  i: DWORD;
begin
  i := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, i);
  GetComputerName(PChar(Result), i);
  Result := string(PChar(Result));
end;

destructor TArquivoLog.Destroy;
begin
  Gravar;
  inherited Destroy;
end;

constructor TArquivoLog.Create;
begin
  Gravando := False;
  LogsLista := TStringList.Create;
  LogsLista.Clear;
  LogsLista.Add('# e-Prova arquivo iniciado');
end;

Procedure TArquivoLog.GravaArquivoLog(Linha: WideString);
var
  DataHora: string;
begin

  try
    if Gravando = False then
    begin
      DataHora := DateTimeToStr(Now);
      LogsLista.Add(DataHora + ' -> ' + Linha + '');
    end;
  except
    on E: Exception do
  end;

end;

Procedure TArquivoLog.Gravar;
var
  TmpLogsLista: WideString;
  ArquivoLog: TextFile;
  Arquivo: string;
begin

  Gravando := true;

  try

    if LogsLista <> nil then
    begin
      if LogsLista.Count > 0 then
      begin

        TmpLogsLista := LogsLista.Text;
        LogsLista.Clear;
        Arquivo := UserProgranData + strFileLog;

        if FileExists(Arquivo) then
        begin
          AssignFile(ArquivoLog, Arquivo);
          Append(ArquivoLog);
          Writeln(ArquivoLog, TmpLogsLista);
          Closefile(ArquivoLog);
        end
        else
        begin

          if not DirectoryExists(UserProgranData + strFileProva) then
            ForceDirectories(UserProgranData + strFileProva);

          AssignFile(ArquivoLog, UserProgranData + strFileLog);
          Rewrite(ArquivoLog);
          Writeln(ArquivoLog, TmpLogsLista);
          Closefile(ArquivoLog);
        end;

      end;
    end;
    Gravando := False;
  except
    on E: Exception do
      Gravando := False;
  end;

end;

function TArquivoLog.LimpaArquivoLog(Linha: WideString): Boolean;
begin
  try
    if FileExists(UserProgranData + strFileLog) then
      DeleteFile(UserProgranData + strFileLog);

    Result := true;
  except
    on E: Exception do
      Result := False;
  end;
end;

function iif(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
begin
  if Expressao then
    Result := ParteTRUE
  else
    Result := ParteFALSE;
end;

function GetVersaoArq: string;
const
  InfoNum           = 10;
  InfoStr           : Array[1..InfoNum] of String =
    ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
    'LegalCopyright', 'LegalTradeMarks', 'OriginalFilename',
    'ProductName', 'ProductVersion', 'Comments');
var
  fCompanyName      : String;
  fFileDescription  : String;
  fFileVersion      : String;
  fInternalName     : String;
  fLegalCopyright   : String;
  fLegalTradeMark   : String;
  fOriginalFileName : String;
  fProductName      : String;
  fProductVersion   : String;
  fComments         : String;
  S                 : String;
  Len               : Cardinal;
  n                 : Cardinal;
  Buf               : PChar;
  Value             : PChar;
  Arquivo           : string;
  Propriedade       : string;
  iLastError: DWord;
begin
  Arquivo :=  ParamStr(0);
  Propriedade := 'ProductVersion';

  S := Arquivo;
  n := GetFileVersionInfoSize(PChar(S), n);

  if n > 0 then begin
     Buf := AllocMem(n);
     try
       GetFileVersionInfo(PChar(S), 0, n, Buf);

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[1]), Pointer(Value), Len) then
         fCompanyName := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[2]), Pointer(Value), Len) then
         fFileDescription := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[3]), Pointer(Value), Len) then
         fFileVersion := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[4]), Pointer(Value), Len) then
         fInternalName := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[5]), Pointer(Value), Len) then
         fLegalCopyright := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[6]), Pointer(Value), Len) then
         fLegalTradeMark := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[7]), Pointer(Value), Len) then
         fOriginalFileName := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[8]), Pointer(Value), Len) then
         fProductName := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[9]), Pointer(Value), Len) then
         fProductVersion := Value;

       if VerQueryValue(Buf, PChar('StringFileInfo\041604E4\' + InfoStr[10]), Pointer(Value), Len) then
         fComments := Value;
     finally
       FreeMem(Buf, n);
     end;
  end
  else
  begin
    iLastError := GetLastError;
    // Result := Format('GetFileVersionInfo failed: (%d) %s', [iLastError, SysErrorMessage(iLastError)]);

    fCompanyName := '';
    fFileDescription := '';
    fFileVersion := '';
    fInternalName := '';
    fLegalCopyright := '';
    fLegalTradeMark := '';
    fOriginalFileName := '';
    fProductName := '';
    fProductVersion := '';
    fComments := '';
  end;

  if Propriedade = 'CompanyName' then result := fCompanyName;
  if Propriedade = 'FileDescription' then result := fFileDescription;
  if Propriedade = 'FileVersion' then result := fFileVersion;
  if Propriedade = 'InternalName' then result := fInternalName;
  if Propriedade = 'LegalCopyright' then result := fLegalCopyright;
  if Propriedade = 'LegalTradeMarks' then result := fLegalTradeMark;
  if Propriedade = 'OriginalFilename' then result := fOriginalFileName;
  if Propriedade = 'ProductName' then result := fProductName;
  if Propriedade = 'ProductVersion' then result := fProductVersion;
  if Propriedade = 'Comments' then result := fComments;

  if Result = EmptyStr then
    Result := '4.1.0';

end;

end.
