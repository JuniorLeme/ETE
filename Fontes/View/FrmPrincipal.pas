unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ShellApi, ClsOper100100,
  ClsOper900600, ClsFuncoes, Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes,
  ClsParametros,
  System.TypInfo, ClsCFCControl, clsDialogos, ClsServidorControl,
  ClsCandidatoControl,
  ClsOperacoes, ClsQuestionario, ClsThreadDetecta, ClsListaBloqueio,
  ClsMonitoramentoRTSPControl,
  Vcl.OleServer, Vcl.Imaging.pngimage, IdBaseComponent, clsDVRFerramentas,
  IdComponent,
  ClsDigitalFotoExame, ClsDetecta, IdIOHandler, IdIOHandlerStream,
  ClsConexaoFerramentas, ClsListaProdutoID;

type
  TFrm_Menu = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    TmrX9: TTimer;
    TmrLog: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TmrX9Timer(Sender: TObject);
    procedure TmrLogTimer(Sender: TObject);
  private

    const
    // Janela: Integer = SW_SHOWNORMAL;
    Janela: Integer = SW_HIDE;

    procedure TrataErros(Sender: TObject; E: Exception);
    function CRCUpDate: Boolean;
    function BiometrikaUpDate: Boolean;
    function GetBuildInfo(Prog: string): string;
    function gravaArquivoBat(cmd: String): PChar;
    { Private declarations }
  public
    Procedure AbreTela;
    { Public declarations }
  end;

var
  Frm_Menu: TFrm_Menu;

implementation

uses
  FrmLogin, FrmIdentificaCandidato, frmCadastroCandidato, FrmInformacoes,
  FrmAvisoOperacoes, FrmTeclado, FrmConfirmacao, FrmQuestionario, FrmResultado,
  ClseProvaConst, FrmAviso;

{$R *.dfm}

procedure TFrm_Menu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // parametros.Free;
  ArquivoLog.gravar;
end;

function TFrm_Menu.gravaArquivoBat(cmd: String): PChar;
var
  arq: TextFile;
begin

  Result := '';

  if Pos('biometrika_sharp-setup.exe', cmd) > 0 then
  begin
    if FileExists(ExtractFilePath(ParamStr(0)) + 'biometrika_sharp-setup.bat')
    then
      DeleteFile(ExtractFilePath(ParamStr(0)) + 'biometrika_sharp-setup.bat');

    Result := PChar(ExtractFilePath(ParamStr(0)) +
      'biometrika_sharp-setup.bat');
  end;

  if Pos('crc-setup.exe', cmd) > 0 then
  begin
    if FileExists(ExtractFilePath(ParamStr(0)) + 'crc-setup.bat') then
      DeleteFile(ExtractFilePath(ParamStr(0)) + 'crc-setup.bat');

    Result := PChar(ExtractFilePath(ParamStr(0)) + 'crc-setup.bat');
  end;

  if Result = '' then
  begin
    if FileExists(ExtractFilePath(ParamStr(0)) + 'start.bat') then
      DeleteFile(ExtractFilePath(ParamStr(0)) + 'start.bat');

    Result := PChar(ExtractFilePath(ParamStr(0)) + 'start.bat');
  end;

  AssignFile(arq, Result);
  Rewrite(arq);
  WriteLn(arq, cmd);
  CloseFile(arq);

end;

function TFrm_Menu.GetBuildInfo(Prog: string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1: Word;
  V2: Word;
  V3: Word;
  // V4: Word;
begin

  try

    VerInfoSize := GetFileVersionInfoSize(PChar(Prog), Dummy);

    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(Prog), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);

    with (VerValue^) do
    begin
      V1 := dwFileVersionMS shr 16;
      V2 := dwFileVersionMS and $FFFF;
      V3 := dwFileVersionLS shr 16;
      // V4 := dwFileVersionLS and $FFFF;
    end;
    FreeMem(VerInfo, VerInfoSize);
    Result := Format('%d.%d.%d', [V1, V2, V3]);

  except
    Result := '1.0.0';
  end;

end;

function TFrm_Menu.CRCUpDate: Boolean;
var
  caminho: PChar;
  VersaoCRC: string;
  VersaoCRCSetup: string;
begin

  Result := True;

  VersaoCRC := '';
  VersaoCRCSetup := '';

  TThread.Synchronize(nil,
    procedure
    begin

      try

        if FileExists(PChar(UserProfileDir + '\Criar\CRC-XE\crcxe.exe')) then
        begin

          if FileExists(PChar(UserProfileDir + strFileProva + '\crc-setup.exe'))
          then
          begin

            VersaoCRC := GetBuildInfo(UserProfileDir +
              '\Criar\CRC-XE\crcxe.exe');
            VersaoCRCSetup := GetBuildInfo(UserProfileDir + strFileProva +
              '\crc-setup.exe');

            if VersaoCRC = VersaoCRCSetup then
            begin
              caminho := PChar(UserProfileDir + '\Criar\CRC-XE\crcxe.exe');
              // Executor é o crcxe.exe
              ShellExecute(Application.Handle, PChar('open'), caminho, '',
                nil, Janela);
            end
            else
            begin
              if FileExists(PChar(UserProfileDir + strFileProva +
                '\crc-setup.exe')) then
              begin
                caminho := gravaArquivoBat(PChar('crc-setup.exe /Silent'));
                ShellExecute(Application.Handle, PChar('open'), caminho, '',
                  nil, Janela);
              end;
            end;

          end
          else
          begin
            caminho := PChar(UserProfileDir + '\Criar\CRC-XE\crcxe.exe');
            // Executor é o crcxe.exe
            ShellExecute(Application.Handle, PChar('open'), caminho, '',
              nil, Janela);
          end;

        end
        else
        begin

          if FileExists(PChar(UserProfileDir + strFileProva + '\crc-setup.exe'))
          then
          begin
            caminho := gravaArquivoBat(PChar('crc-setup.exe /Silent'));
            ShellExecute(Application.Handle, PChar('open'), caminho, '',
              nil, Janela);
          end;

        end;

      except
        on E: Exception do
      end;

    end);

end;

function TFrm_Menu.BiometrikaUpDate: Boolean;
var
  caminho: PChar;
  HwndeBio: THandle;
begin

  Result := True;

  TThread.Synchronize(nil,
    procedure
    begin

      try

        if FileExists(PChar(UserProfileDir +
          '\Criar\eBiometrikaSharp\Digital\Biometrika.exe')) then
        begin

          caminho := PChar(UserProfileDir +
            '\Criar\eBiometrikaSharp\Digital\Biometrika.exe');
          ShellExecute(Application.Handle, PChar('open'), caminho, '',
            nil, Janela);

          caminho := PChar(UserProfileDir +
            '\Criar\eBiometrikaSharp\Fotos\BiometrikaF.exe');
          ShellExecute(Application.Handle, PChar('open'), caminho, '',
            nil, Janela);

        end
        else
        begin

          if FileExists(PChar(UserProfileDir + strFileProva +
            '\biometrika_sharp-setup.exe')) then
          begin
            caminho := gravaArquivoBat
              (PChar('biometrika_sharp-setup.exe /Silent'));
            ShellExecute(Application.Handle, PChar('open'), caminho, '',
              nil, Janela);
          end
          else
          begin

            HwndeBio := FindWindow('TApplication', 'e-Biometrika XE');
            if HwndeBio = 0 then
            begin

              if FileExists(PChar(UserProfileDir +
                '\Criar\e-Biometrika-XE\eBiometrikaXE.exe')) then
              begin
                caminho := PChar(UserProfileDir +
                  '\Criar\e-Biometrika-XE\eBiometrikaXE.exe');
                ShellExecute(Application.Handle, PChar('open'), caminho, '',
                  nil, Janela);
              end;

            end;

          end;

        end;

      except
        on E: Exception do
      end;

    end);

end;

procedure TFrm_Menu.FormCreate(Sender: TObject);
var
  f: TMemoryStream;

  Consulta: MainOperacao;
  Oper100Env: T100100Envio;
  Oper100ret: T100100Retorno;

  Oper900600Env: T900600Envio;
  Oper900600ret: T900600Retorno;

  Conexao: TConexao;
  ProdutoID : TProdutoID;
begin
  if Debug then
    ArquivoLog.GravaArquivoLog('# Trata erro ');

  Conexao := nil;

  Application.OnException := TrataErros;

  ParListaMonitoramentoRTSP := TStringList.Create;

  try
    if not DirectoryExists(UserProgranData + strFileEnviar) then
      CreateDir(UserProgranData + strFileEnviar);
  except
    on E: Exception do
    begin
      if Debug then
        ArquivoLog.GravaArquivoLog('# Criar pasta "enviar" - ' + E.Message);
    end;
  end;

  if Debug then
    ArquivoLog.GravaArquivoLog('# Abrir CRC XE  ');

  if Not Debug then
    CRCUpDate;

  if Debug then
    ArquivoLog.GravaArquivoLog('# Abrir bimatrika ');

  if Not Debug then
    BiometrikaUpDate;

  if Debug then
    ArquivoLog.GravaArquivoLog('# Varifica o arquivo Log');

  if FileExists(UserProgranData + strFileLog) then
  begin

    f := TMemoryStream.Create;
    f.LoadFromFile(UserProgranData + strFileLog);

    if Debug then
      ArquivoLog.GravaArquivoLog('# Tamanho do arquivo Log ' + f.Size.ToString);

    if f.Size > 10000000 then
    begin
      f.Free;
      DeleteFile(UserProgranData + strFileLog);
    end
    else
      f.Free;
  end;

  if Conexao.PingDNSGrupoCRIAR then
    ArquivoLog.GravaArquivoLog('# Teste de Internet on ')
  else
    ArquivoLog.GravaArquivoLog('# Teste de Internet off ');

  if Conexao.Telnet('200.233.218.159', 443) then
    ArquivoLog.GravaArquivoLog('# Teste de porta 443 on ')
  else
    ArquivoLog.GravaArquivoLog('# Teste de porta 443 off ');

  ArquivoLog.GravaArquivoLog
    ('# Inicio ------------------------------------------------- ');

  TelaLogin := False;
  if Debug then
    ArquivoLog.GravaArquivoLog('# Inicio 900600 ');

  // Inicio ----------------------------------------
  // Não alterar este bloco sem perguntar antes
  Oper900600Env := T900600Envio.Create;
  Oper900600ret := T900600Retorno.Create;

  try
    // Neste caso o id do sistema é 259403 mesmo * Não troque
    Oper900600ret.MontaXMLRetorno(Oper900600Env.MontaXMLEnvio);
    // Fim -------------------------------------------

    if Oper900600ret.IsValid then
    begin

      if Debug then
        ArquivoLog.GravaArquivoLog('# Inicio 900600 valida');

      ParFotoExame := TDigitalFotoExame.Create(Application);

      ParMonitoramentoRTSP := TMonitoramentoRTSP.Create;
      ParMonitoramentoFluxoRTSP := TMonitoramentoFluxoRTSP.Create;
      ParMonitoramentoFluxoRTSP.Fluxo := 0;
      ParMonitoramentoFluxoRTSP.DescricaoFluxo := '';

      ParServidor := Servidor.Create;

      parametros := TParametros.Create;

      parametros.NumeroAviso := 0;

      ParCFC := CFC.Create;

      ParMacAdress := TMacAdress.Create;
      ParMacAdress.Classe := TStringList.Create;
      ParMacAdress.Classe.Add('Win32_NetworkAdapter');

      ParSistemaOperacional := TSistemaOperacional.Create;
      ParSistemaOperacional.Classe := TStringList.Create;
      ParSistemaOperacional.Classe.Add('Win32_OperatingSystem');

      ThrdMAC := TThrdDetecta.Create;
      ThrdMAC.NumLista := 5;
      ThrdMAC.Tipo := 1;

      ThrdSO := TThrdDetecta.Create;
      ThrdSO.NumLista := 6;
      ThrdSO.Tipo := 1;

      ParDetecta := TDetecta.Create;

      ParListaProcessosAtivos := TListaProcessosAtivos.Create;
      ParListaProcessosAtivos.Classe := TStringList.Create;

      ParListaServicosAtivos := TListaServicosAtivos.Create;
      ParListaServicosAtivos.Classe := TStringList.Create;

      ParListaDispositivos := TListaDispositivos.Create;
      ParListaDispositivos.Classe := TStringList.Create;

      ParListaAplicativos := TListaAplicativos.Create;
      ParListaAplicativos.Classe := TStringList.Create;
      ParListaAplicativos.Classe.Add('Win32_Product');
      ParListaAplicativos.ListaSoftwaresIgnodos := TStringList.Create;

      ThrdAplicativos := TThrdDetecta.Create;
      ThrdAplicativos.NumLista := 1;
      ThrdAplicativos.Tipo := 1;

      if Debug then
        ArquivoLog.GravaArquivoLog('# Inicio parametros ');

      if Debug then
        ArquivoLog.GravaArquivoLog('# Inicio usuário ' +
          Trim(parametros.Usuario));

      if (Trim(parametros.Usuario) <> '') and (Trim(parametros.Senha) <> '') and
        (Trim(parametros.Computador) <> '') then
      begin

        if Debug then
          ArquivoLog.GravaArquivoLog('# Inicio 100100 ');

        Oper100Env := T100100Envio.Create;
        Oper100ret := T100100Retorno.Create;


        if ListaProdutoID.IndexOf('ETE SP') > -1 then
        begin
          ProdutoID := TProdutoID(ListaProdutoID.Objects
            [ListaProdutoID.IndexOf('ETE SP')]);
          ParServidor.ID_Sistema := StrToIntDef(ProdutoID.servidor, 0);
        end;
        if ParServidor.ID_Sistema > 0 then
          AtualizarForm(Self, ParServidor.ID_Sistema);


        Consulta := MainOperacao.Create(Self, '100100');
        Oper100ret.MontaRetorno
          (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
          Oper100Env.MontaXMLEnvio(parametros.Usuario, parametros.Senha,
          parametros.Identificacao)));

        if Oper100ret.IsValid then
        begin

          if Debug then
            ArquivoLog.GravaArquivoLog('# Inicio 100100 - valida');

          TelaIdentificaCandidato := True;
          TelaLogin := True;
        end
        else
        begin
          if Debug then
            ArquivoLog.GravaArquivoLog('# Inicio 100100 - retorno' +
              Oper100ret.codigo + ' - ' + Oper100ret.Mensagem);
        end;

        if Oper100ret.codigo = 'B27' then
        begin
          EnviarAviso(mtInformation, Oper100ret.Mensagem);
          Application.Terminate;
        end;

      end;

      ParCandidato := TCandidato.Create;

    end
    else
    begin
      EnviarAviso(mtInformation, 'Verifique sua conexão e tente novamente.');
      Application.Terminate;
    end;

  except
    on E: Exception do
    begin
      EnviarAviso(mtInformation, 'Verifique sua conexão e tente novamente.');
      Application.Terminate;
    end;

  end;

  AbreTela;

end;

Procedure TFrm_Menu.AbreTela;
begin

  // Procedimento para teminar o Programa
  if TelaTerminarAplicacao then
  begin

    ArquivoLog.GravaArquivoLog
      ('# Fim ---------------------------------------------------- ');
    Close;
    Application.Terminate;
  end
  else
  begin

    if Debug then
      ArquivoLog.GravaArquivoLog('# Abrir tela ');

    if ParDetecta <> nil then
    begin
      if ParDetecta.Prova_Ativo then
      begin
        TmrX9.Interval := ((ParDetecta.Prova_Tempo * 100) * 60);
        TmrX9.Enabled := ParDetecta.Prova_Ativo;
      end
      else if ParDetecta.Simulado_Ativo then
      begin
        TmrX9.Interval := ((ParDetecta.Simulado_Tempo * 100) * 60);
        TmrX9.Enabled := ParDetecta.Simulado_Ativo;
      end;
    end;

    // Tela para Identificar o CFC
    if not TelaLogin then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Login ---------------------------------------------------- ');
      FindComponent('Frm_Login').Free;
      Frm_Login := TFrm_Login.Create(Self);
      // SalvarForm(Frm_Login);
      if ParServidor.ID_Sistema > 0 then
        AtualizarForm(Frm_Login, ParServidor.ID_Sistema);
      Frm_Login.Show;
    end;

    // Tela para Identificar o Candidato
    if TelaLogin and TelaIdentificaCandidato then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Identifica Candidato ------------------------------------- ');
      FindComponent('Frm_IdentificaCandidato').Free;
      Frm_IdentificaCandidato := TFrm_IdentificaCandidato.Create(Self);
      // SalvarForm(Frm_IdentificaCandidato);
      AtualizarForm(Frm_IdentificaCandidato, ParServidor.ID_Sistema);
      Frm_IdentificaCandidato.Show;
    end;

    // Tela para Cadastrar o Candidato
    if TelaLogin and TelaCadastraCandidato then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Cadastra Candidato ------------------------------------- ');
      FindComponent('frm_CadastroCandidato').Free;
      frm_CadastroCandidato := Tfrm_CadastroCandidato.Create(Self);
      // SalvarForm(frm_CadastroCandidato);
      AtualizarForm(frm_CadastroCandidato, ParServidor.ID_Sistema);
      frm_CadastroCandidato.Show;
    end;

    // Tela de Confirmação
    if TelaLogin and TelaConfirmacao then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Confirmação Candidato ------------------------------------- ');
      FindComponent('Frm_Confirmacao').Free;
      Frm_Confirmacao := TFrm_Confirmacao.Create(Self);
      // SalvarForm(Frm_Confirmacao);
      AtualizarForm(Frm_Confirmacao, ParServidor.ID_Sistema);
      Frm_Confirmacao.Show;
    end;

    // Tela de Informações
    if TelaLogin and TelaInformacoes then
    begin

      if ParCFC.Tela_Instrucoes = 'S' then
      begin
        ArquivoLog.GravaArquivoLog
          ('# Instruções ------------------------------------- ');
        FindComponent('Frm_Informacoes').Free;
        Frm_Informacoes := TFrm_Informacoes.Create(Self);
        // SalvarForm(Frm_Informacoes);
        AtualizarForm(Frm_Informacoes, ParServidor.ID_Sistema);
        Frm_Informacoes.Show;
      end
      else
        TelaTeclado := True;

    end;

    // Tela de Teste do Teclado
    if TelaLogin and TelaTeclado then
    begin

      if ParCFC.Tela_Teclado = 'S' then
      begin
        ArquivoLog.GravaArquivoLog
          ('# Teste do teclado ------------------------------------- ');
        FindComponent('Frm_Teclado').Free;
        Frm_Teclado := TFrm_Teclado.Create(Self);
        // SalvarForm(Frm_Teclado);
        AtualizarForm(Frm_Teclado, ParServidor.ID_Sistema);
        Frm_Teclado.Show;
      end
      else
        TelaQuestionario := True;

    end;

    // Tela de Questionário
    if TelaLogin and TelaQuestionario then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Questionário ------------------------------------- ');
      FindComponent('Frm_Questionario').Free;
      Frm_Questionario := TFrm_Questionario.Create(Self);
      // SalvarForm(Frm_Questionario);
      AtualizarForm(Frm_Questionario, ParServidor.ID_Sistema);
      Frm_Questionario.Show;
    end;

    // Tela de Questionário
    if TelaLogin and TelaAvisos then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Questionário ------------------------------------- ');
      FindComponent('Frm_Aviso').Free;
      Frm_Aviso := TFrm_Aviso.Create(Self);
      // SalvarForm(Frm_Questionario);
      // AtualizarForm(Frm_Questionario, ParServidor.ID_Sistema);
      Frm_Aviso.Show;
    end;

    // Tela de Resultado
    if TelaLogin and TelaResultado then
    begin
      ArquivoLog.GravaArquivoLog
        ('# Resultado ------------------------------------- ');
      FindComponent('Frm_Resultado').Free;
      Frm_Resultado := TFrm_Resultado.Create(Self);
      // SalvarForm(Frm_Resultado);
      AtualizarForm(Frm_Resultado, ParServidor.ID_Sistema);
      Frm_Resultado.Show;
    end;

    if Screen.FormCount < 2 then
    begin
      FindComponent('Frm_IdentificaCandidato').Free;
      Frm_IdentificaCandidato := TFrm_IdentificaCandidato.Create(Self);
      AtualizarForm(Frm_IdentificaCandidato, ParServidor.ID_Sistema);
      Frm_IdentificaCandidato.Show;
    end;

  end;

end;

procedure TFrm_Menu.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_Menu.TmrLogTimer(Sender: TObject);
begin
  ArquivoLog.gravar;
end;

procedure TFrm_Menu.TmrX9Timer(Sender: TObject);
begin

  if TelaResultado = True then
    TmrX9.Enabled := False
  else
  begin

    ThrdDispositivos := TThrdDetecta.Create;
    ThrdDispositivos.NumLista := 2;
    ThrdDispositivos.Tipo := 1;

    ThrdServicos := TThrdDetecta.Create;
    ThrdServicos.NumLista := 3;
    ThrdServicos.Tipo := 1;

    ThrdProcessos := TThrdDetecta.Create;
    ThrdProcessos.NumLista := 4;
    ThrdProcessos.Tipo := 1;

  end;

end;

procedure TFrm_Menu.TrataErros(Sender: TObject; E: Exception);
begin

  if Debug then
    ArquivoLog.GravaArquivoLog('# ' + Sender.ClassName + ' - Falha - ' +
      E.Message);

end;

end.
