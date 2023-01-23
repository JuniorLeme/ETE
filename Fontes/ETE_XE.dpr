program ETE_XE;

{$R 'ImagemETE.res' 'Resource\ImagemETE.RC'}

uses
  Vcl.Forms,
  Winapi.Windows,
  Winapi.ShellAPI,
  System.SysUtils,
  Vcl.ComCtrls,
  Vcl.Dialogs,
  System.Classes,
  clsDialogos in 'C:\Lib\clsDialogos.pas',
  ClsOper100100 in 'Controller\OperacoesMCP\ClsOper100100.pas',
  ClsOper100300 in 'Controller\OperacoesMCP\ClsOper100300.pas',
  ClsOper100310 in 'Controller\OperacoesMCP\ClsOper100310.pas',
  ClsOper100700 in 'Controller\OperacoesMCP\ClsOper100700.pas',
  ClsOper200100 in 'Controller\OperacoesMCP\ClsOper200100.pas',
  ClsOper200200 in 'Controller\OperacoesMCP\ClsOper200200.pas',
  ClsOper200400 in 'Controller\OperacoesMCP\ClsOper200400.pas',
  ClsOper200500 in 'Controller\OperacoesMCP\ClsOper200500.pas',
  ClsOper300100 in 'Controller\OperacoesMCP\ClsOper300100.pas',
  ClsOper400100 in 'Controller\OperacoesMCP\ClsOper400100.pas',
  ClsOperacoes in 'Controller\OperacoesMCP\ClsOperacoes.pas',
  FrmAvisoConexao in 'View\FrmAvisoConexao.pas' {Frm_AvisoConexao},
  frmCadastroCandidato in 'View\frmCadastroCandidato.pas' {frm_CadastroCandidato},
  FrmConfirmacao in 'View\FrmConfirmacao.pas' {Frm_Confirmacao},
  FrmIdentificaCandidato in 'View\FrmIdentificaCandidato.pas' {Frm_IdentificaCandidato},
  FrmInformacoes in 'View\FrmInformacoes.pas' {Frm_Informacoes},
  FrmLogin in 'View\FrmLogin.pas' {Frm_Login},
  FrmPrincipal in 'View\FrmPrincipal.pas' {Frm_Menu},
  FrmQuestionario in 'View\FrmQuestionario.pas' {Frm_Questionario},
  FrmResultado in 'View\FrmResultado.pas' {Frm_Resultado},
  FrmTeclado in 'View\FrmTeclado.pas' {Frm_Teclado},
  ClsResourceETE in 'Controller\ClsResourceETE.pas',
  ClsOper200710 in 'Controller\OperacoesMCP\ClsOper200710.pas',
  FrmMensagemDetecta in 'View\FrmMensagemDetecta.pas' {Frm_MensagemDetecta},
  FrmClntMdlBiometria in 'View\FrmClntMdlBiometria.pas' {ClientModule1: TDataModule},
  ClsOper100110 in 'Controller\OperacoesMCP\ClsOper100110.pas',
  ClsOper200110 in 'Controller\OperacoesMCP\ClsOper200110.pas',
  ClsEnvioMCP in 'Controller\OperacoesMCP\ClsEnvioMCP.pas',
  ClsToken in 'Controller\OperacoesMCP\ClsToken.pas',
  ClsRetornoMCP in 'Controller\OperacoesMCP\ClsRetornoMCP.pas',
  ClsRetornoToken in 'Controller\OperacoesMCP\ClsRetornoToken.pas',
  ClsCFCControl in 'Model\ClsCFCControl.pas',
  ClseProvaConst in 'Controller\ClseProvaConst.pas',
  ClsCandidatoControl in 'Model\ClsCandidatoControl.pas',
  ClsServidorControl in 'Model\ClsServidorControl.pas',
  ClsOper900600 in 'Controller\OperacoesMCP\ClsOper900600.pas',
  ClsDigitalFoto in 'Controller\BiometriaFoto\ClsDigitalFoto.pas',
  ClsMonitoramentoRTSPControl in 'Model\ClsMonitoramentoRTSPControl.pas',
  FrmAvisoOperacoes in 'View\FrmAvisoOperacoes.pas' {Frm_AvisoOperacoes},
  ClsCronometros in 'Controller\Ferramentas\ClsCronometros.pas',
  ClsMonitoramentoFFMpeg in 'Controller\Monitoramento\ClsMonitoramentoFFMpeg.pas',
  ClsConexaoFerramentas in 'Controller\Ferramentas\ClsConexaoFerramentas.pas',
  ControllerCryptography in 'Controller\Ferramentas\ControllerCryptography.pas',
  ClsWebService in 'Controller\OperacoesMCP\ClsWebService.pas',
  clsDVRFerramentas in 'Controller\Monitoramento\clsDVRFerramentas.pas',
  ClsOper200210 in 'Controller\OperacoesMCP\ClsOper200210.pas',
  ClsOperacoesControl in 'Controller\OperacoesMCP\ClsOperacoesControl.pas',
  ClsThread200710 in 'Controller\OperacoesMCP\ClsThread200710.pas',
  ClsMonitoramentoRTSP in 'Controller\Monitoramento\ClsMonitoramentoRTSP.pas',
  ClsClientRestBiometria in 'Controller\BiometriaFoto\ClsClientRestBiometria.pas',
  ClsFuncoes in 'Controller\Ferramentas\ClsFuncoes.pas',
  ClsGerenciarObjeto in 'Controller\Ferramentas\ClsGerenciarObjeto.pas',
  ClsListaBloqueio in 'Controller\Ferramentas\ClsListaBloqueio.pas',
  ClsListaProdutoID in 'Model\ClsListaProdutoID.pas',
  ClsParametros in 'Controller\Ferramentas\ClsParametros.pas',
  ClsQuestionario in 'Model\ClsQuestionario.pas',
  ClsSincronizarProva in 'Controller\Ferramentas\ClsSincronizarProva.pas',
  ClsSmartapi in 'Controller\Ferramentas\ClsSmartapi.pas',
  ClsThreadDetecta in 'Controller\Ferramentas\ClsThreadDetecta.pas',
  ClsUsb in 'Controller\Ferramentas\ClsUsb.pas',
  ClsWbemScripting_TLB in 'Controller\Ferramentas\ClsWbemScripting_TLB.pas',
  ClsDetecta in 'Model\ClsDetecta.pas',
  ClsDigitalFotoExame in 'Controller\BiometriaFoto\ClsDigitalFotoExame.pas',
  ClsResourceSP in 'Controller\Resource\ClsResourceSP.pas',
  ClsResourceMG in 'Controller\Resource\ClsResourceMG.pas',
  ClsResourceAL in 'Controller\Resource\ClsResourceAL.pas',
  ClsResourceBA in 'Controller\Resource\ClsResourceBA.pas',
  ClsResourceSE in 'Controller\Resource\ClsResourceSE.pas',
  FrmBiometria in 'View\FrmBiometria.pas' {Frm_Biometria},
  FrmAviso in 'View\FrmAviso.pas' {Frm_Aviso},
  ClsOperacoesRest in 'Controller\OperacoesMCP\ClsOperacoesRest.pas',
  ClsEnvio.Inicio.SEITran in 'Controller\Operações\ClsEnvio.Inicio.SEITran.pas',
  ClsRetorno.SEITran in 'Controller\Operações\ClsRetorno.SEITran.pas',
  Cls.Json in 'Controller\Operações\Cls.Json.pas',
  cipher in 'C:\Lib\MD5\cipher.pas',
  Md5 in 'C:\Lib\MD5\Md5.pas',
  DCPconst in 'C:\Lib\MD5\DCPconst.pas',
  DCPcrypt in 'C:\Lib\MD5\DCPcrypt.pas',
  IDEA in 'C:\Lib\MD5\IDEA.pas',
  Base64 in 'C:\Lib\MD5\Base64.pas',
  Sha1 in 'C:\Lib\MD5\Sha1.pas';

{$R *.res}

var
  PreviousHandle: THandle;

begin

  if Pos('ETE XE', ParamStr(0)) > 0 then
    strFileProva := '\Criar\ETE XE'
  else
    strFileProva := '\Criar\e-Prova XE';

  if Pos('ETE XE', ParamStr(0)) > 0 then
    strFileLog := strFileProva + '\ETE.log'
  else
    strFileLog := strFileProva + '\eProva.log';

  strFileEnviar := strFileProva + '\enviar';

  strNomeArq := 'Parametros.xml';

  Debug := False;

  {$IFDEF DEBUG}
    Debug := True;
  {$ENDIF}

  PreviousHandle := FindWindow('TApplication', 'ETE XE');

  ArquivoLog := TArquivoLog.Create;

  ArquivoLog.GravaArquivoLog('Debug: ' + Debug.ToString);

  if PreviousHandle <> 0 then
  begin
    SetForegroundWindow(PreviousHandle);
    Application.Terminate;
  end;

  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  FormatSettings.ShortTimeFormat := 'hh:mm:ss';

  Application.Title := 'ETE XE';
  Application.CreateForm(TFrm_Menu, Frm_Menu);
  Application.CreateForm(TFrm_AvisoOperacoes, Frm_AvisoOperacoes);
  Application.MainFormOnTaskbar := False;
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Run;

end.
