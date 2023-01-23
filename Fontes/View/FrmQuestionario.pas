unit FrmQuestionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls, ShellApi, MaskUtils, Vcl.Buttons, IdCoderMIME, IdICMPClient,
  Vcl.Printers,
  ClsCandidatoControl, ClsServidorControl, ClsOper200400, ClsOper200500,
  ClsQuestionario, ClsParametros,
  ClsOper200200, ClsOper200210, ClsOperacoes, ClsListaBloqueio, ClsThread200710,
  ClsConexaoFerramentas,
  ClsDetecta, ClsCFCControl, ClsMonitoramentoRTSPControl, Winapi.ActiveX,
  System.Threading, ClsCronometros,
  ClsMonitoramentoRTSP, ClsMonitoramentoFFMpeg, ClsDigitalFotoExame,
  clsDVRFerramentas, IdThreadComponent,
  IdBaseComponent, IdScheduler, IdSchedulerOfThread, ClsOper400100,
  IdSchedulerOfThreadPool;

type
  TFrm_Questionario = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label_CPFProva: TLabel;
    Label_NomeProva: TLabel;
    Label_CursoProva: TLabel;
    Label100: TLabel;
    Label_Numero: TLabel;
    LabelMateria: TLabel;
    Label_Questao: TLabel;
    Label_RespostaA: TLabel;
    Label_RespostaC: TLabel;
    Label_RespostaD: TLabel;
    Label_RespostaE: TLabel;
    Image_OpcaoA_Over: TImage;
    Image_OpcaoB_Over: TImage;
    Image_OpcaoC_Over: TImage;
    Image_OpcaoD_Over: TImage;
    Image_OpcaoE_Over: TImage;
    Image_OpcaoA: TImage;
    Image_OpcaoB: TImage;
    Image_OpcaoC: TImage;
    Image_OpcaoD: TImage;
    Image_OpcaoE: TImage;
    Label_Tempo: TLabel;
    Label25: TLabel;
    Image25: TImage;
    Image42: TImage;
    Label33: TLabel;
    Image45: TImage;
    Label34: TLabel;
    Image43: TImage;
    Label60: TLabel;
    TmrCronometro: TTimer;
    SBtAnterior: TSpeedButton;
    SBtCancelar: TSpeedButton;
    SBtFinalizar: TSpeedButton;
    SBtProximo: TSpeedButton;
    GridPanel1: TGridPanel;
    EdtControledeTeclas: TEdit;
    TmrMonitoramento: TTimer;
    LblPergunta: TLabel;
    Label_RespostaB: TLabel;
    ImgCFCLive: TImage;
    TmrBiometriaFoto: TTimer;
    TmrListaBloqueio: TTimer;
    ImgPlacas: TImage;
    Pnl_MensagemDetecta: TPanel;
    BtnSair: TButton;
    BtnImprimir: TButton;
    MmMensagemDetecta: TMemo;
    PnlMonitoramento: TPanel;
    LblMonitoramento: TLabel;
    LblCamera: TLabel;
    LblStatusMonitoramentoRTSP: TLabel;
    LblFluxo: TLabel;
    Tmr200200: TTimer;
    LblAviso: TLabel;
    Tmr200400: TTimer;
    Label1: TLabel;
    TmrDVR: TTimer;
    IdThread200400: TIdThreadComponent;
    IdThread200200: TIdThreadComponent;
    IdThreadMonitoramento: TIdThreadComponent;
    IdThreadListaBloqueio: TIdThreadComponent;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TmrCronometroTimer(Sender: TObject);
    procedure SBtAnteriorClick(Sender: TObject);
    procedure SBtProximoClick(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure Image_OpcaoAClick(Sender: TObject);
    procedure SBtFinalizarClick(Sender: TObject);
    procedure EdtControledeTeclasKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label25Click(Sender: TObject);
    procedure Label33Click(Sender: TObject);
    procedure Label34Click(Sender: TObject);
    procedure Label60Click(Sender: TObject);
    procedure TmrMonitoramentoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TmrBiometriaFotoTimer(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    function Aviso(Tipo: TMsgDlgType; Texto: String;
      Silent: Boolean = True): Boolean;
    procedure Tmr200200Timer(Sender: TObject);
    procedure Tmr200400Timer(Sender: TObject);
    procedure TmrDVRTimer(Sender: TObject);
    procedure IdThread200400Run(Sender: TIdThreadComponent);
    procedure IdThread200200Run(Sender: TIdThreadComponent);
    procedure IdThreadMonitoramentoRun(Sender: TIdThreadComponent);
    procedure IdThreadListaBloqueioRun(Sender: TIdThreadComponent);
    procedure TmrListaBloqueioTimer(Sender: TObject);

  private

    ThreadCronometro: TThreadThreadCronometro;
    ThreadFFMpeg: TThreadFFMpeg;

    Reinicia: Boolean;
    ControledeJanela: Boolean;
    ControleFluxoFX: Integer;

    procedure MostraQuestoes(NumeroQuestao: Integer);
    procedure onMostraQuestao(Sender: TObject);
    procedure CarregaImagem(Componente: TControl; Imagem: string;
      ID_Sistema: Integer);
    Procedure Operacao200500;
    Procedure Retorno200710Detecta(Sender: TObject);
    Function  detectawebcam: Boolean;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Questionario: TFrm_Questionario;

  // Bloqueio: Boolean;
  CaixaAlta, CaixaBaixa: Boolean;
  AndamentoControle: string;

implementation

uses
  FrmPrincipal, ClsFuncoes, FrmAviso;

{$R *.dfm}

function TFrm_Questionario.Aviso(Tipo: TMsgDlgType; Texto: String;
  Silent: Boolean = True): Boolean;
begin
  Result := False;

  LblAviso.Caption := '';

  Parametros.AguardarAviso := True;

  Application.NormalizeTopMosts;
  Texto := Trim(Texto);

  if Tipo = mtConfirmation then
  begin
    if Application.MessageBox(PWideChar(Texto), PWideChar(Application.Title),
      MB_ICONQUESTION + MB_YESNO) = mrYes then
    begin
      Result := True;
    end;
  end;

  if (Tipo = mtInformation) and Silent then
  begin
    TThread.Synchronize(nil,
      procedure
      begin

        LblAviso.Caption := PWideChar(Application.Title) + #13 +
          PWideChar(Texto);
        LblAviso.Font.Color := clBlue;

        Sleep(500);
        LblAviso.Font.Color := clBlack;

        Sleep(500);
        LblAviso.Font.Color := clBlue;

        Sleep(500);
        LblAviso.Font.Color := clBlack;

      end);

    Result := True;
  end;

  if (Tipo = mtInformation) and (Silent = False) then
  begin
    Application.MessageBox(PWideChar(Texto), PWideChar(Application.Title),
      MB_ICONEXCLAMATION + MB_OK);
    Result := True;
  end;

  Application.RestoreTopMosts;

  Parametros.AguardarAviso := False;
end;

procedure TFrm_Questionario.BtnImprimirClick(Sender: TObject);
Var
  P: Integer;
  MemoFile: TextFile;
Begin

  AssignPrn(MemoFile);
  Rewrite(MemoFile);

  For P := 0 to MmMensagemDetecta.Lines.Count - 1 do
    Writeln(MemoFile, '      ' + MmMensagemDetecta.Lines[P]);

  CloseFile(MemoFile);
end;

procedure TFrm_Questionario.BtnSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_Questionario.CarregaImagem(Componente: TControl; Imagem: string;
ID_Sistema: Integer);
var
  png: TPngImage;
  ResourceStream: TResourceStream;
begin

  try
    png := TPngImage.Create;

    ResourceStream := TResourceStream.Create(Hinstance, Imagem, RT_RCDATA);
    png.LoadFromStream(ResourceStream);

    if (Componente is TImage) then
      (Componente as TImage).Picture.Assign(png);

  finally
    FreeANDNIL(png);
    FreeANDNIL(ResourceStream);
  end;

end;

function TFrm_Questionario.detectawebcam: Boolean;
begin

  if ProcurarWebcam = '' then
  begin
    Result := False;
  end
  else
    Result := True;

end;

procedure TFrm_Questionario.EdtControledeTeclasKeyUp(Sender: TObject;
var Key: Word; Shift: TShiftState);
begin

  if Parametros.AguardarAviso then
    abort;

  if Key = VK_DELETE then
  begin
    ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida := '';
    MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1));
  end;

  if Key = VK_LEFT then
    SBtAnteriorClick(Self);

  if Key = VK_RIGHT then
    SBtProximoClick(Self);

  if Key = VK_END then
    SBtFinalizarClick(Self);

  if Key = 65 then
    ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida := 'A';

  if Key = 66 then
    ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida := 'B';

  if Key = 67 then
    ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida := 'C';

  if (Key = 68) and (ParQuestionario.Perguntas.Items
    [StrToIntDef(Label_Numero.Caption, 0)].RespostaD <> '') then
    ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida := 'D';

  if (Key = 69) and (ParQuestionario.Perguntas.Items
    [StrToIntDef(Label_Numero.Caption, 0)].RespostaE <> '') then
    ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida := 'E';

  if Key in [65, 66, 67, 68, 69] then
  begin
    if (ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
      ].RespostaEscolhida <> '') then
    begin
      MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1));

      // Para alguns estados não deve ir o recuso de
      // avanço automático, o cliente quer avançar manualmente.
      if ParServidor.AvancoAutomatico = 'S' then
      begin
        if (StrToIntDef(Label_Numero.Caption, 0)) < ParQuestionario.Perguntas.Count
        then
          MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1) + 1)
        else
          MostraQuestoes(1);
      end
      else
      begin
        if (StrToIntDef(Label_Numero.Caption, 0) - 1) <
          ParQuestionario.Perguntas.Count then
          MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1))
        else
          MostraQuestoes(1);
      end;

    end;

  end;

  EdtControledeTeclas.Clear;
  EdtControledeTeclas.SetFocus;
end;

procedure TFrm_Questionario.FormClose(Sender: TObject;
var Action: TCloseAction);
var
  txtDialogo: string;
  Consulta: MainOperacao;

  Oper400Env: T400100Envio;
  Oper400ret: T400100Retorno;
begin
  // Efetuar a operação 400100
  Consulta := MainOperacao.Create(nil, '400100');

  Oper400Env := T400100Envio.Create;
  Oper400ret := T400100Retorno.Create;

  try
    ParMonitoramentoFluxoRTSP.Status := 'F';

    Oper400ret.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema),
      Oper400Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
      ParCandidato.TipoProva, Trim(ParMonitoramentoFluxoRTSP.Cam),
      ParMonitoramentoRTSP.Endereco_Servidor,
      'rtsp://' + ParMonitoramentoRTSP.Endereco_Servidor + ':563/h264_' +
      ParMonitoramentoFluxoRTSP.Cam + '.sdp'),
      'A Prova está pausada, pois não há conexão com a Internet. Verifique sua conexão.'
      + #13 + 'Monitoramento em alerta.'));

  except
    on E: Exception do
  end;

  if (TelaResultado = False) and (ControledeJanela = False) then
  begin

    if ParCandidato.TipoProva = 'S' then
      txtDialogo := 'Deseja realmente fechar o Teste Simulado? '
    else
      txtDialogo := 'Deseja realmente fechar a prova? ';

    if Aviso(mtConfirmation, txtDialogo, False) then
    begin
      ParMonitoramentoFluxoRTSP.Status := '';
      Reinicia := False;
    end
    else
      abort;

  end;

  if Reinicia = False then
  begin
    // deste jeito funciona
    KillTask('ffmpeg.exe');
    KillTask('eStatusDVRSharp.exe');

    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  try
    if ThreadCronometro <> nil then
      ThreadCronometro.Terminate;
    Sleep(500);
  except
    on E: Exception do
  end;

  Action := caFree;

end;

procedure TFrm_Questionario.FormCreate(Sender: TObject);
var
  I: Integer;
  Rotulo: TLabel;
  RespostaEscolhida: string;
begin

  // Só em caso de teste
  // ParCandidato.Excecao := 'N';

  ControleFluxoFX := 0;
  ParCandidato.Cont200400 := 0;
  TmrDVR.Enabled := False;

  if DVRFerramentas <> nil then
  begin
    if DVRFerramentas.Tempo > 0 then
      TmrDVR.Interval := DVRFerramentas.Tempo * 1000;

    TmrDVR.Enabled := True;
  end;

  LblAviso.Caption := '';

  MmMensagemDetecta.Top := 0;
  MmMensagemDetecta.Left := 0;

  Pnl_MensagemDetecta.Top := -5000;
  Pnl_MensagemDetecta.Left := -5000;

  Pnl_MensagemDetecta.Visible := False;

  if ParDetecta <> nil then
  begin

    TmrListaBloqueio.Enabled := True;

    // Verifica se é permitido ler Processos e Serviços
    if ((ParCandidato.TipoProva = 'P') and
      (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) or
      ((ParCandidato.TipoProva = 'S') and
      (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
    begin

      try
        // Envia Lista
        TThread200710.Create(Retorno200710Detecta);

        Pnl_MensagemDetecta.Top := -5000;
        Pnl_MensagemDetecta.Left := -5000;

        Pnl_MensagemDetecta.Visible := False;
      except
        on E: Exception do
          ArquivoLog.GravaArquivoLog('Operação 200710 - ' + E.Message);
      end;
    end;
  end
  else
    TmrListaBloqueio.Enabled := False;

  Image1.SendToBack;

  Reinicia := False;
  AndamentoControle := 'I';

  Label_CPFProva.Caption := 'CPF: ';
  Label_NomeProva.Caption := '';
  Label_CursoProva.Caption := 'Curso: ';
  Label_Tempo.Caption := '00';
  LabelMateria.Caption := 'Disciplina: ';
  Label_Numero.Caption := '00';
  Label_Questao.Caption := ' ';
  Label_RespostaA.Caption := ' ';
  Label_RespostaB.Caption := ' ';
  Label_RespostaC.Caption := ' ';
  Label_RespostaD.Caption := ' ';
  Label_RespostaE.Caption := ' ';

  GridPanel1.ColumnCollection.Clear;

  Label_CPFProva.Caption := 'CPF: ' + FormatMaskText('000\.000\.000\-00;0;_',
    ParCandidato.CPFCandidato);
  Label_NomeProva.Caption := '' + ParCandidato.NomeCandidato;
  Label_CursoProva.Caption := 'Curso: ' + ParCandidato.CursoCandidato;
  Label_Tempo.Caption := '00';

  ParQuestionario.Tempo := NparaH(ParQuestionario.TempoTotal -
    HparaN(ParQuestionario.TempoDecorrido));

  TmrCronometro.Enabled := True;

  if ParCandidato.TipoProva = 'P' then
  begin

    if ParFotoExame <> nil then    begin
      //ParFotoExame.Prova_Tempo := 4;  //adriano p/ teste
      ArquivoLog.GravaArquivoLog(' Tempo de captura da biometria ' +
        IntToStr(((ParFotoExame.Prova_Tempo * 1000) * 60)));
      TmrBiometriaFoto.Interval := ((ParFotoExame.Prova_Tempo * 1000) * 60);
      TmrBiometriaFoto.Enabled := ParFotoExame.Prova_Ativo;
    end;

    if ParDetecta <> nil then
    begin
      ArquivoLog.GravaArquivoLog(' Tempo de bloqueio ' +
        IntToStr((ParFotoExame.Prova_Tempo * 1000)));
      TmrListaBloqueio.Interval :=
        ((ParDetecta.Verifica_Processos_tempo_Prova * 1000) * 60);
      TmrListaBloqueio.Enabled := ParDetecta.Prova_Ativo;
    end;

    if (ParCFC.Monitoramento_prova = 'S') then
    begin
      TmrMonitoramento.Enabled := True;
      ArquivoLog.GravaArquivoLog('Criar Formulário - Monitoramento: on ');
    end
    else
    begin
      TmrMonitoramento.Enabled := False;
      ArquivoLog.GravaArquivoLog('Criar Formulário - Monitoramento: off ');
    end;

  end
  else if ParCandidato.TipoProva = 'S' then
  begin

    if ParFotoExame <> nil then
    begin
      ArquivoLog.GravaArquivoLog(' Tempo de captura da biometria ' +
        IntToStr(((ParFotoExame.Prova_Tempo * 1000) * 60)));
      TmrBiometriaFoto.Interval := (ParFotoExame.Simulado_Tempo * 1000) * 60;
      TmrBiometriaFoto.Enabled := ParFotoExame.Simulado_Ativo;
    end;

    if ParDetecta <> nil then
    begin
      ArquivoLog.GravaArquivoLog(' Tempo de bloqueio ' +
        IntToStr(((ParFotoExame.Prova_Tempo * 1000) * 60)));
      TmrListaBloqueio.Interval :=
        ((ParDetecta.Verifica_Processos_tempo_simulado * 1000) * 60);
      TmrListaBloqueio.Enabled := ParDetecta.Simulado_Ativo;
    end;

    if (ParCFC.Monitoramento_Simulado = 'S') then
    begin
      TmrMonitoramento.Enabled := True;
      ArquivoLog.GravaArquivoLog('Criar Formulário - Monitoramento: on ');
    end
    else
    begin
      TmrMonitoramento.Enabled := False;
      ArquivoLog.GravaArquivoLog('Criar Formulário - Monitoramento: off ');
    end;

  end;

  RespostaEscolhida := '';

  for I := 0 to ParQuestionario.Perguntas.Count - 1 do
  begin

    GridPanel1.ColumnCollection.Add;
    GridPanel1.ColumnCollection.Items[I].SizeStyle := ssAbsolute;
    GridPanel1.ColumnCollection.Items[I].Value := 22;

    Rotulo := TLabel.Create(Self);
    Rotulo.Parent := GridPanel1;
    Rotulo.Align := alClient;
    Rotulo.Name := 'LblNumeroQuestao' + RightSTR('00' + IntToStr(I + 1), 2);

    RespostaEscolhida := ParQuestionario.Perguntas.Items[I + 1]
      .RespostaEscolhida;

    if RespostaEscolhida <> '' then
    begin
      Rotulo.Caption := RightSTR('00' + IntToStr(I + 1), 2) + '  ' +
        RightSTR(' ' + RespostaEscolhida, 1);
      Rotulo.Font.Color := clBlack;
    end
    else
    begin
      Rotulo.Caption := RightSTR('00' + IntToStr(I + 1), 2) + '    ';
      Rotulo.Font.Color := clBlue;
    end;

    Rotulo.AutoSize := True;
    Rotulo.Alignment := taCenter;
    Rotulo.Color := clWhite;
    Rotulo.Transparent := False;
    Rotulo.Layout := tlCenter;
    Rotulo.Font.Style := [fsBold];
    Rotulo.WordWrap := True;
    Rotulo.OnClick := onMostraQuestao;

  end;

  GridPanel1.Refresh;
  MostraQuestoes(1);

  // Prepara o questionário para a prova monitoramento
  if (ParCFC.Monitoramento_prova = 'S') and (ParCandidato.TipoProva = 'P') then
  begin

    PnlMonitoramento.Visible := True;
    LblCamera.Visible := True;
    LblStatusMonitoramentoRTSP.Visible := True;
    LblMonitoramento.Visible := True;
    LblFluxo.Visible := True;

  end;

  if (ParCFC.Monitoramento_Simulado = 'S') and (ParCandidato.TipoProva = 'S')
  then
  begin

    PnlMonitoramento.Visible := True;
    LblCamera.Visible := True;
    LblStatusMonitoramentoRTSP.Visible := True;
    LblMonitoramento.Visible := True;
    LblFluxo.Visible := True;

  end;

end;

procedure TFrm_Questionario.FormShow(Sender: TObject);
begin

  if DVRFerramentas <> nil then
  begin

    if DVRFerramentas.cfcliveSituacao > 0 then
    begin
      ImgCFCLive.Picture := nil;
      CarregaImagem(ImgCFCLive, 'A0' + IntToStr(DVRFerramentas.cfcliveSituacao), ParServidor.ID_Sistema);
      ImgCFCLive.Refresh;
      ImgCFCLive.Hint := DVRFerramentas.cfcliveHint;
    end;

  end;

  Self.Refresh;

  if AndamentoControle = 'I' then
    AndamentoControle := 'P';

  // Prepara o questionário para a prova monitoramento
  if (ParCFC.Monitoramento_prova = 'S') and (ParCandidato.TipoProva = 'P') then
  begin

    LblCamera.Caption := 'Câmera: ';
    LblStatusMonitoramentoRTSP.Caption := 'Situação:';
    LblFluxo.Caption := 'Fluxo:';

    TThread.Synchronize(nil,
      procedure
      begin

        ParMonitoramentoFluxoRTSP.Cam := '';
        ParMonitoramentoFluxoRTSP.Fluxo := 0;

        LblCamera.Caption := ParMonitoramentoRTSP.Camera;
        LblStatusMonitoramentoRTSP.Caption :=
          ParMonitoramentoFluxoRTSP.DescricaoMonitoramentoRTSP;
        LblFluxo.Caption := ParMonitoramentoFluxoRTSP.DescricaoFluxo;

        ThreadFFMpeg := TThreadFFMpeg.Create;
        ThreadFFMpeg.NameThreadForDebugging('StatusMonitoramentoRTSP',
          ThreadFFMpeg.ThreadID);
        ThreadFFMpeg.AbrirFFMpeg := True;
        ThreadFFMpeg.Start;

        { Atualiza o registro de monitoramento online }
        TmrCronometro.Enabled := True;

        ArquivoLog.GravaArquivoLog(' BtnCamClick(Self); ');
      End);

  end;

  if (ParCFC.Monitoramento_Simulado = 'S') and (ParCandidato.TipoProva = 'S')
  then
  begin

    LblCamera.Caption := 'Câmera: ';
    LblStatusMonitoramentoRTSP.Caption := 'Situação:';
    LblFluxo.Caption := 'Fluxo:';

    TThread.Synchronize(nil,
      procedure
      begin

        ParMonitoramentoFluxoRTSP.Cam := '';
        ParMonitoramentoFluxoRTSP.Fluxo := 0;

        ThreadFFMpeg := TThreadFFMpeg.Create;
        ThreadFFMpeg.NameThreadForDebugging('AbrirFFMpeg',
          ThreadFFMpeg.ThreadID);
        ThreadFFMpeg.AbrirFFMpeg := True;
        ThreadFFMpeg.Start;

        { Atualiza o registro de monitoramento online }

        TmrCronometro.Enabled := True;

        ArquivoLog.GravaArquivoLog(' BtnCamClick(Self); ');
      End);

  end;

  if ThreadCronometro = nil then
    ThreadCronometro := TThreadThreadCronometro.Create;

  ThreadCronometro.Start;
end;

procedure TFrm_Questionario.IdThread200400Run(Sender: TIdThreadComponent);
var
  Consulta: MainOperacao;
  Oper200400Env: T200400Envio;
  Oper200400Ret: T200400Retorno;
begin
  CoInitializeEx(nil, 2);
  Consulta := MainOperacao.Create(Self, '200400');
  Oper200400Env := T200400Envio.Create;
  Oper200400Ret := T200400Retorno.Create;

  try
    // Efetuar a operação 200400
    Oper200400Ret.MontaRetorno('A',
      Consulta.Consultar(IntToStr(ParServidor.ID_Sistema),
      Oper200400Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
      ParCandidato.TipoProva, AndamentoControle,
      IntToStr(ParQuestionario.TempoDecorrido)), ''));
  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('operção 200400 - ' + E.Message);
  end;

  if Trim(Oper200400Ret.codigo) = 'D998' then
    Oper200400Ret.codigo := 'B000';

  if Oper200400Ret.IsValid then
  else
  begin
    Aviso(mtInformation, Oper200400Ret.mensagem);
    Self.Repaint;
  end;

  IdThread200400.Terminate;
end;

procedure TFrm_Questionario.IdThreadListaBloqueioRun
  (Sender: TIdThreadComponent);
begin

  if ParQuestionario.Tempo > 0 then
    if ParDetecta <> nil then
      TThread200710.Create(Retorno200710Detecta);

  IdThreadListaBloqueio.Terminate;

end;

procedure TFrm_Questionario.IdThreadMonitoramentoRun
  (Sender: TIdThreadComponent);
var
  Consulta: MainOperacao;
  Oper400Env: T400100Envio;
  Oper400ret: T400100Retorno;
begin

  CoInitializeEx(nil, 2);

  if Debug then
    ArquivoLog.GravaArquivoLog(' Monitoramento status:' +
      ParMonitoramentoFluxoRTSP.Status);

  if ParMonitoramentoFluxoRTSP.Status = 'F' then
  begin
    // LblCamera.Caption := ParMonitoramentoRTSP.Camera;
    LblStatusMonitoramentoRTSP.Caption := 'Situação:';
    LblFluxo.Caption := 'Fluxo:';
  end;

  if (ParCFC.Monitoramento_prova = 'S') and (ParCandidato.TipoProva = 'P') then
  begin
    if detectawebcam then
    else
    begin
      IdThreadMonitoramento.Stop;
      IdThreadMonitoramento.Terminate;

      TmrCronometro.Enabled := False;
      TmrMonitoramento.Enabled := False;
      TmrBiometriaFoto.Enabled := False;
      TmrListaBloqueio.Enabled := False;
      Tmr200200.Enabled := False;
      Tmr200400.Enabled := False;
      TmrDVR.Enabled := False;

      if not IdThreadMonitoramento.Terminated then
        IdThreadMonitoramento.Terminate;

      if not IdThreadListaBloqueio.Terminated then
        IdThreadListaBloqueio.Terminate;

      if not IdThread200200.Terminated then
        IdThread200200.Terminate;

      if not IdThread200400.Terminated then
        IdThread200400.Terminate;

      Aviso(mtInformation,
          'Não identificamos uma câmera em seu computador. A Prova será fechada. Reconecte a câmera e reinicie a Prova.',
          False);

      ControledeJanela := True;
      TelaTerminarAplicacao := True;
      TelaIdentificaCandidato := False;
      TelaFoto := False;
      TelaBiometria := False;
      Reinicia := False;
      TelaInformacoes := False;
      TelaTeclado := False;
      TelaQuestionario := False;
      TelaResultado := False;

      Frm_Menu.AbreTela;
      Close;

      KillTask('ffmpeg.exe');
      KillTask('ETE_XE.exe');

      Exit;
    end;
  end;

  if (ParCFC.Monitoramento_Simulado = 'S') and (ParCandidato.TipoProva = 'S')
  then
  begin
    if detectawebcam then
    else
    begin
      IdThreadMonitoramento.Stop;
      IdThreadMonitoramento.Terminate;

      TmrCronometro.Enabled := False;
      TmrMonitoramento.Enabled := False;
      TmrBiometriaFoto.Enabled := False;
      TmrListaBloqueio.Enabled := False;
      Tmr200200.Enabled := False;
      Tmr200400.Enabled := False;
      TmrDVR.Enabled := False;

      if not IdThreadMonitoramento.Terminated then
        IdThreadMonitoramento.Terminate;

      if not IdThreadListaBloqueio.Terminated then
        IdThreadListaBloqueio.Terminate;

      if not IdThread200200.Terminated then
        IdThread200200.Terminate;

      if not IdThread200400.Terminated then
        IdThread200400.Terminate;

      Aviso(mtInformation,
          'Não identificamos uma câmera em seu computador. A Prova será fechada. Reconecte a câmera e reinicie a Prova.',
          False);

      ControledeJanela := True;
      TelaTerminarAplicacao := True;
      TelaIdentificaCandidato := False;
      TelaFoto := False;
      TelaBiometria := False;
      Reinicia := False;
      TelaInformacoes := False;
      TelaTeclado := False;
      TelaQuestionario := False;
      TelaResultado := False;

      Frm_Menu.AbreTela;
      Close;

      KillTask('ffmpeg.exe');
      KillTask('ETE_XE.exe');

      Exit;
    end;
  end;

  try

    if ParQuestionario.Tempo > 0 then
    begin

      if ParMonitoramentoFluxoRTSP.Status = 'FX' then
      begin

        Inc(ControleFluxoFX);

        if ControleFluxoFX > 5 then
        begin

          Aviso(mtInformation, 'O monitoramento foi desabilitado. ' +
            'Verifique sua câmera e conexão com a internet.', False);

          // Efetuar a operação 400100
          Consulta := MainOperacao.Create(Self, '400100');

          Oper400Env := T400100Envio.Create;
          Oper400ret := T400100Retorno.Create;

          try
            ParMonitoramentoFluxoRTSP.Status := 'FX';

            Oper400ret.MontaRetorno
              (Consulta.Consultar(IntToStr(ParServidor.ID_Sistema),
              Oper400Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
              ParCandidato.TipoProva, Trim(ParMonitoramentoFluxoRTSP.Cam),
              ParMonitoramentoRTSP.Endereco_Servidor,
              'rtsp://' + ParMonitoramentoRTSP.Endereco_Servidor + ':563/h264_'
              + ParMonitoramentoFluxoRTSP.Cam + '.sdp'),
              'A Prova está pausada, pois não há conexão com a Internet. Verifique sua conexão.'
              + #13 + 'Monitoramento em alerta.'));

          except
            on E: Exception do
          end;

          KillTask('ffmpeg.exe');
          KillTask('ETE_XE.exe');

        end;

      end;

      if (ParMonitoramentoFluxoRTSP.Status <> 'G') then
      begin

        ArquivoLog.GravaArquivoLog('Reinicia Monitoramento');
        TelaIdentificaCandidato := False;
        TelaFoto := False;
        TelaBiometria := False;
        Reinicia := False;
        TelaTeclado := False;
        TelaConfirmacao := False;
        TelaQuestionario := False;

        ParMonitoramentoFluxoRTSP.Fluxo := 0;

        ThreadFFMpeg := TThreadFFMpeg.Create;
        ThreadFFMpeg.NameThreadForDebugging('AbrirFFMpeg',
          ThreadFFMpeg.ThreadID);
        ThreadFFMpeg.AbrirFFMpeg := True;
        ThreadFFMpeg.Start;

      end
      else
      begin
        ThreadFFMpeg := TThreadFFMpeg.Create;
        ThreadFFMpeg.NameThreadForDebugging('VarificaFFMpeg',
          ThreadFFMpeg.ThreadID);
        ThreadFFMpeg.VarificaFFMPeg := True;
        ThreadFFMpeg.Start;

        ControleFluxoFX := 0;
      End;

      LblCamera.Caption := ParMonitoramentoRTSP.Camera;
      LblStatusMonitoramentoRTSP.Caption :=
        ParMonitoramentoFluxoRTSP.DescricaoMonitoramentoRTSP;
      LblFluxo.Caption := ParMonitoramentoFluxoRTSP.DescricaoFluxo;

      if Debug then
      begin
        ArquivoLog.GravaArquivoLog(' Monitoramento - ' +
          ParMonitoramentoRTSP.Camera);
        ArquivoLog.GravaArquivoLog(' Monitoramento - ' +
          ParMonitoramentoFluxoRTSP.DescricaoMonitoramentoRTSP);
        ArquivoLog.GravaArquivoLog(' Monitoramento - ' +
          ParMonitoramentoFluxoRTSP.DescricaoFluxo);
      end;

    end
    else
    begin
      ArquivoLog.GravaArquivoLog('Monitoramento => # Tempo : 0 ');
    end;

    IdThreadMonitoramento.Terminate;

  except
    on E: Exception do
    begin

      if Debug then
      begin
        ArquivoLog.GravaArquivoLog('Monitoramento: ' + E.Message);
        ArquivoLog.Gravar;
      end;

      IdThreadMonitoramento.Terminate;
    end;
  end;

end;

procedure TFrm_Questionario.IdThread200200Run(Sender: TIdThreadComponent);
var
  Consulta: MainOperacao;
  Oper200200Env: T200200Envio;
  Oper200200Ret: T200200Retorno;
begin

  CoInitializeEx(nil, 2);

  // Efetuar a operação 200200
  Consulta := MainOperacao.Create(Self, '200200');
  Oper200200Env := T200200Envio.Create;
  Oper200200Ret := T200200Retorno.Create;

  try
    Oper200200Ret.MontaRetorno
      (Consulta.Consultar(IntToStr(ParServidor.ID_Sistema),
      Oper200200Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
      ParCandidato.TipoProva), ''));

    if Trim(Oper200200Ret.codigo) = 'D998' then
      Oper200200Ret.codigo := 'B000';

    if (Oper200200Ret.IsValid) and (ParMonitoramentoFluxoRTSP.Status = 'G') then
    begin

      try

        if DVRFerramentas <> nil then
        begin

          if DVRFerramentas.cfcliveSituacao > 0 then
          begin
            ImgCFCLive.Picture := nil;
            CarregaImagem(ImgCFCLive,
              'A0' + IntToStr(DVRFerramentas.cfcliveSituacao),
              ParServidor.ID_Sistema);
            ImgCFCLive.Refresh;
            ImgCFCLive.Hint := DVRFerramentas.cfcliveHint;
          end;

        end;

      except
        on E: Exception do
      end;

    end;

  except
    on E: Exception do
  end;

  IdThread200200.Terminate;

end;

procedure TFrm_Questionario.Image_OpcaoAClick(Sender: TObject);
begin

  ParQuestionario.Perguntas.Items[StrToIntDef(Label_Numero.Caption, 0)
    ].RespostaEscolhida := Copy(TImage(Sender).Name, 12, 1);

  if StrToIntDef(Label_Numero.Caption, 1) <= ParQuestionario.Perguntas.Count
  then
    MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1));

  if ParServidor.AvancoAutomatico = 'S' then
  begin
    if StrToIntDef(Label_Numero.Caption, 1) < ParQuestionario.Perguntas.Count
    then
      MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1) + 1)
    else
      MostraQuestoes(1);
  end;

end;

procedure TFrm_Questionario.Label25Click(Sender: TObject);
begin
  if Label_Questao.Font.Size >= 8 then
  begin
    Label_Questao.Font.Size := Label_Questao.Font.Size - 1;
    Label_RespostaA.Font.Size := Label_RespostaA.Font.Size - 1;
    Label_RespostaB.Font.Size := Label_RespostaB.Font.Size - 1;
    Label_RespostaC.Font.Size := Label_RespostaC.Font.Size - 1;
    Label_RespostaD.Font.Size := Label_RespostaD.Font.Size - 1;
    Label_RespostaE.Font.Size := Label_RespostaE.Font.Size - 1;
  end;
end;

procedure TFrm_Questionario.Label33Click(Sender: TObject);
begin
  if Label_Questao.Font.Size <= 13 then
  begin
    Label_Questao.Font.Size := Label_Questao.Font.Size + 1;
    Label_RespostaA.Font.Size := Label_RespostaA.Font.Size + 1;
    Label_RespostaB.Font.Size := Label_RespostaB.Font.Size + 1;
    Label_RespostaC.Font.Size := Label_RespostaC.Font.Size + 1;
    Label_RespostaD.Font.Size := Label_RespostaD.Font.Size + 1;
    Label_RespostaE.Font.Size := Label_RespostaE.Font.Size + 1;
  end;
end;

procedure TFrm_Questionario.Label34Click(Sender: TObject);
begin
  CaixaAlta := True;
  CaixaBaixa := False;

  Label_Questao.Caption := textocaixaalta(Label_Questao.Caption);
  Label_RespostaA.Caption := textocaixaalta(Label_RespostaA.Caption);
  Label_RespostaB.Caption := textocaixaalta(Label_RespostaB.Caption);
  Label_RespostaC.Caption := textocaixaalta(Label_RespostaC.Caption);
  Label_RespostaD.Caption := textocaixaalta(Label_RespostaD.Caption);
  Label_RespostaE.Caption := textocaixaalta(Label_RespostaE.Caption);
end;

procedure TFrm_Questionario.Label60Click(Sender: TObject);
begin

  CaixaAlta := False;
  CaixaBaixa := True;

  Label_Questao.Caption := textocaixaalta(Copy(Label_Questao.Caption, 1, 1)) +
    textocaixabaixa(Copy(Label_Questao.Caption, 2,
    length(Label_Questao.Caption)));
  Label_RespostaA.Caption := textocaixaalta(Copy(Label_RespostaA.Caption, 1, 1))
    + textocaixabaixa(Copy(Label_RespostaA.Caption, 2,
    length(Label_RespostaA.Caption)));
  Label_RespostaB.Caption := textocaixaalta(Copy(Label_RespostaB.Caption, 1, 1))
    + textocaixabaixa(Copy(Label_RespostaB.Caption, 2,
    length(Label_RespostaB.Caption)));
  Label_RespostaC.Caption := textocaixaalta(Copy(Label_RespostaC.Caption, 1, 1))
    + textocaixabaixa(Copy(Label_RespostaC.Caption, 2,
    length(Label_RespostaC.Caption)));
  Label_RespostaD.Caption := textocaixaalta(Copy(Label_RespostaD.Caption, 1, 1))
    + textocaixabaixa(Copy(Label_RespostaD.Caption, 2,
    length(Label_RespostaD.Caption)));
  Label_RespostaE.Caption := textocaixaalta(Copy(Label_RespostaE.Caption, 1, 1))
    + textocaixabaixa(Copy(Label_RespostaE.Caption, 2,
    length(Label_RespostaE.Caption)));

end;

procedure TFrm_Questionario.onMostraQuestao(Sender: TObject);
begin
  MostraQuestoes(StrToIntDef(Copy(TLabel(Sender).Caption, 1, 2), 1));
end;

procedure TFrm_Questionario.Operacao200500;
begin

  TThread.Synchronize(nil,
    procedure
    var
      Consulta: MainOperacao;
      Oper200500Env: T200500Envio;
      Oper200500Ret: T200500Retorno;
    begin

      Consulta := MainOperacao.Create(Self, '200500');
      Oper200500Env := T200500Envio.Create;
      Oper200500Ret := T200500Retorno.Create;

      try
        Oper200500Ret.MontaRetorno(Consulta.Consultar
          (IntToStr(ParServidor.ID_Sistema),
          Oper200500Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
          ParCandidato.TipoProva, ParCandidato.Bloqueado, ParCandidato.Foto),
          'A Prova está pausada, pois não há conexão com a Internet. Verifique sua conexão.')
          );

        if Trim(Oper200500Ret.codigo) = 'D998' then
          Oper200500Ret.codigo := 'B000';

        if (Oper200500Ret.IsValid) and (ParMonitoramentoFluxoRTSP.Status > 'G')
        then
        begin

          if DVRFerramentas.cfcliveSituacao > 0 then
          begin
            ImgCFCLive.Picture := nil;
            CarregaImagem(ImgCFCLive,
              'A0' + IntToStr(DVRFerramentas.cfcliveSituacao),
              ParServidor.ID_Sistema);
            ImgCFCLive.Refresh;
            ImgCFCLive.Hint := DVRFerramentas.cfcliveHint;
          end;
        end
        else
        begin

          if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
          begin
            ThreadFFMpeg := TThreadFFMpeg.Create;
            ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
              ThreadFFMpeg.ThreadID);
            ThreadFFMpeg.MatarFFMpeg := True;
            ThreadFFMpeg.Start;
          end;

        end;

      except
        on E: Exception do
      end;

    end);

end;

procedure TFrm_Questionario.SBtAnteriorClick(Sender: TObject);
begin
  if (StrToIntDef(Label_Numero.Caption, 1) > 1) then
    MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1) - 1)
  else
    MostraQuestoes(ParQuestionario.Perguntas.Count);
end;

procedure TFrm_Questionario.SBtCancelarClick(Sender: TObject);
var
  txtDialogo: string;
begin

  if TelaResultado = False then
  begin

    if ParCandidato.TipoProva = 'S' then
      txtDialogo := 'Deseja realmente Cancelar o Teste Simulado? '
    else
      txtDialogo := 'Deseja realmente Cancelar a prova? ';

    if Aviso(mtConfirmation, txtDialogo, False) then
    begin

      try
        if ThreadCronometro <> nil then
          ThreadCronometro.Terminate;
        Sleep(500);
      except
        on E: Exception do
      end;

      ControledeJanela := True;
      TelaIdentificaCandidato := True;
      TelaFoto := False;
      TelaBiometria := False;
      Reinicia := True;
      TelaInformacoes := False;
      TelaTeclado := False;
      TelaQuestionario := False;
      TelaResultado := False;
      Frm_Menu.AbreTela;
      Close;
    end;

  end;

end;

procedure TFrm_Questionario.SBtFinalizarClick(Sender: TObject);
var
  txtDialogo: WideString;
 // retonoBioFoto: Boolean;
  I: Integer;
begin

  if Parametros.AguardarAviso then
    abort;

  TmrCronometro.Enabled := False;
  TmrMonitoramento.Enabled := False;
  TmrBiometriaFoto.Enabled := False;
  TmrListaBloqueio.Enabled := False;

  Tmr200200.Enabled := False;
  Tmr200400.Enabled := False;
  TmrDVR.Enabled := False;

  if ParQuestionario.TempoMinimo > ParQuestionario.TempoDecorrido then
  begin

    if ParCandidato.TipoProva = 'S' then
      txtDialogo := 'O teste não pode ser finalizado antes do tempo' +
        ' mínimo de ' + IntToStr(ParQuestionario.TempoMinimo) + ' min.'
    else
      txtDialogo := 'A prova não pode ser finalizada antes do tempo' +
        ' mínimo de ' + IntToStr(ParQuestionario.TempoMinimo) + ' min.';

    Aviso(mtInformation, txtDialogo, False);

    TmrCronometro.Enabled := True;
    TmrMonitoramento.Enabled := True;
    TmrBiometriaFoto.Enabled := True;
    Tmr200200.Enabled := True;

    if ParDetecta <> nil then
      TmrBiometriaFoto.Enabled := True;

    Exit;

  end;

  // Fianliza Prova

  if ParQuestionario.Tempo = 0 then
  begin
    Tmr200200.Enabled := False;

    if ParCandidato.TipoProva = 'S' then
      txtDialogo := 'O Teste Simulado foi finalizado por término de tempo.'
    else
      txtDialogo := 'A prova foi finalizada por término de tempo.';

    Aviso(mtInformation, txtDialogo, False);

    TmrDVR.Enabled := False;

    if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
    begin
      ThreadFFMpeg := TThreadFFMpeg.Create;
      ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg', ThreadFFMpeg.ThreadID);
      ThreadFFMpeg.MatarFFMpeg := True;
      ThreadFFMpeg.Start;
    end;

    Frm_Aviso := TFrm_Aviso.Create(Self);
    if Frm_Aviso.ShowModal <> mrOk then
      Exit;

    ControledeJanela := True;
    TelaIdentificaCandidato := False;
    TelaFoto := False;
    TelaBiometria := False;
    Reinicia := True;
    TelaInformacoes := False;
    TelaTeclado := False;
    TelaQuestionario := False;
    TelaResultado := True;
    TelaAvisos := False;

    if ParCandidato.Bloqueado = '' then
      ParCandidato.Bloqueado := 'N';

    Close;
    Frm_Menu.AbreTela;
  end
  else
  begin

    if ParQuestionario.SemResposta = 'N' then
    begin
      for I := 1 to ParQuestionario.Perguntas.Count do
      begin
        if ParQuestionario.Perguntas.Items[I].RespostaEscolhida = '' then
        begin
          Aviso(mtInformation,
            'Existem questões que ainda não foram respondidas. Não é permitido finalizar.',
            False);

          TmrCronometro.Enabled := True;
          Tmr200200.Enabled := True;

          if ParDetecta <> nil then
          begin
            TmrBiometriaFoto.Enabled := True;
          end;

          abort;
        end;
      end;
    end
    else
    begin

      I := 1;
      while I <= ParQuestionario.Perguntas.Count do
      begin

        if ParQuestionario.Perguntas.Items[I].RespostaEscolhida = '' then
        begin
          txtDialogo :=
            'Existem questões que ainda não foram respondidas. Deseja realmente finalizar?';
          I := ParQuestionario.Perguntas.Count + 1
        end;

        Inc(I);
      end;
    end;

    if Trim(txtDialogo) = '' then
      txtDialogo := 'DESEJA REALMENTE FINALIZAR?' + #13 +
        'DEPOIS DE FINALIZAR NÃO SERÁ POSSIVEL VOLTAR PARA AS QUESTÕES.';

    if Aviso(mtConfirmation, txtDialogo, False) then
    begin

      if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
      begin
        ThreadFFMpeg := TThreadFFMpeg.Create;
        ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
          ThreadFFMpeg.ThreadID);
        ThreadFFMpeg.MatarFFMpeg := True;
        ThreadFFMpeg.Start;
      end;

      Frm_Aviso := TFrm_Aviso.Create(Self);
      Frm_Aviso.ShowModal;

      Tmr200200.Enabled := False;
      TmrDVR.Enabled := False;

      ControledeJanela := True;
      Reinicia := True;
      TelaIdentificaCandidato := False;
      TelaConfirmacao := False;
      TelaInformacoes := False;
      TelaTeclado := False;
      TelaQuestionario := False;
      TelaFoto := False;
      TelaBiometria := False;
      TelaResultado := True;
      TelaAvisos := False;
      TelaQuestionario := False;

      Close;
      Frm_Menu.AbreTela;
    end
    else
    begin

      TmrCronometro.Enabled := True;
      Tmr200200.Enabled := True;

      if (ParCFC.Monitoramento_prova = 'S') and (ParCandidato.TipoProva = 'P')
      then
      begin

        if ParDetecta <> nil then
          TmrBiometriaFoto.Enabled := True;
      end;

      if (ParCFC.Monitoramento_Simulado = 'S') and (ParCandidato.TipoProva = 'S')
      then
      begin
        if ParDetecta <> nil then
          TmrBiometriaFoto.Enabled := True;
      end;

    end;

  end;
end;

procedure TFrm_Questionario.SBtProximoClick(Sender: TObject);
begin

  if (StrToIntDef(Label_Numero.Caption, 1) < ParQuestionario.Perguntas.Count)
  then
    MostraQuestoes(StrToIntDef(Label_Numero.Caption, 1) + 1)
  else
    MostraQuestoes(1);

end;

procedure TFrm_Questionario.Tmr200200Timer(Sender: TObject);
begin

  Application.HandleMessage; // IdleHandler
  IdThread200200.Start;

end;

procedure TFrm_Questionario.Tmr200400Timer(Sender: TObject);
begin

  Application.HandleMessage; // IdleHandler
  IdThread200400.Start;

end;

procedure TFrm_Questionario.TmrBiometriaFotoTimer(Sender: TObject);
  var
  retonoBioFoto: Boolean;
begin

  if ParQuestionario.Tempo > 0 then
  begin

    if ParCandidato.Excecao <> 'S' then
    begin

      TThread.Synchronize(nil,
        procedure
        var

          txtAviso: string;

        begin

          CoInitializeEx(nil, 2);

          ArquivoLog.GravaArquivoLog('Captura a Biometria (Não é Exceção Digital)');

          retonoBioFoto := False;
          TmrBiometriaFoto.Enabled := False;
          ThreadCronometro.PauseT := True;
          TelaConfirmacao := False;
          TelaQuestionario := False;
          TelaExameBiometriaFoto := True;
          ParCandidato.Bloqueado := 'N';

          try

            if (ParCFC.Biometria_Foto_prova = 'S') then
              retonoBioFoto := ParFotoExame.BiometriaFoto
            Else if (ParCFC.Biometria_prova = 'S') then
              retonoBioFoto := ParFotoExame.BiometriaFoto;

            if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
            begin
              ThreadFFMpeg := TThreadFFMpeg.Create;
              ThreadFFMpeg.MatarFFMpeg := True;
              ThreadFFMpeg.Start;
              TmrMonitoramento.Enabled := True;
            end;

          except
            on E: Exception do
            begin
              ArquivoLog.GravaArquivoLog('Questionrio Biometria/Foto - ' +
                E.Message);
              Aviso(mtInformation,
                'Biometria/Foto no está funcionando corretamente!', False);
            end;
          end;

          try

            if retonoBioFoto then
            begin
              Operacao200500;

              if ParMonitoramentoFluxoRTSP.Cam <> '' then
                TmrMonitoramento.Enabled := True;

              TmrBiometriaFoto.Enabled := True;
            end
            else
            begin
              TmrMonitoramento.Enabled := False;
              TmrBiometriaFoto.Enabled := False;
              TmrListaBloqueio.Enabled := False;
              ParCandidato.Bloqueado   := 'S';
              Tmr200200.Enabled := False;

              if ParFotoExame.DigitalMensagem <> '' then
                if ParFotoExame.DigitalMensagem <> 'Sucesso' then
              begin
                txtAviso := ParFotoExame.DigitalMensagem;
              end
              else if ParFotoExame.FotoMensagem <> '' then
              begin
                txtAviso := ParFotoExame.FotoMensagem;
              end
              else
                txtAviso :=
                  'Execute a prova novamente. No foi possvel validar a biometria !';

              Aviso(mtInformation, txtAviso, False);

              if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
              begin
                ThreadFFMpeg := TThreadFFMpeg.Create;
                ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
                  ThreadFFMpeg.ThreadID);
                ThreadFFMpeg.MatarFFMpeg := True;
                ThreadFFMpeg.Start;
                TmrMonitoramento.Enabled := True;
              end;

              if ParCandidato.Bloqueado = 'S' then
              begin
                Operacao200500;
                Application.Terminate;
              end
              else
              begin

                if Aviso(mtInformation, txtAviso, False) then
                begin

                  TThread.Synchronize(nil,
                    procedure
                    begin
                      CoInitializeEx(nil, 2);
                      TmrBiometriaFotoTimer(Self);
                    end);

                end
                else
                begin

                  if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
                  begin
                    ThreadFFMpeg := TThreadFFMpeg.Create;
                    ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
                      ThreadFFMpeg.ThreadID);
                    ThreadFFMpeg.MatarFFMpeg := True;
                    ThreadFFMpeg.Start;
                    TmrMonitoramento.Enabled := True;
                  end;

                  Application.Terminate;

                end;

              end;

            end;

          except
            on E: Exception do
              ArquivoLog.GravaArquivoLog('operao 200500 - ' + E.Message);
          end;

          ThreadCronometro.PauseT:= false;
        end);

    end
    else  //TRECHO NOVO
    begin

      TThread.Synchronize(nil,
        procedure
        var
          txtAviso: string;
        begin
          CoInitializeEx(nil, 2);

          ArquivoLog.GravaArquivoLog('Captura a Foto (Exceção Digital)');

          retonoBioFoto := False;
          TmrBiometriaFoto.Enabled := False;
          ThreadCronometro.PauseT := True;
          TelaConfirmacao := False;
          TelaQuestionario := False;
          TelaExameBiometriaFoto := True;
          ParCandidato.Bloqueado := 'N';

          repeat

            try
              retonoBioFoto := ParFotoExame.BiometriaFoto;
            except
              on E: Exception do
              begin
                ArquivoLog.GravaArquivoLog('Questionario Foto - ' +
                  E.Message);
                Aviso(mtInformation,
                  'Foto nao esta funcionando corretamente!', False);
              end;
            end;

            try
              if not retonoBioFoto then
              begin
                if ParFotoExame.FotoMensagem <> '' then
                  txtAviso := ParFotoExame.FotoMensagem
                else
                  txtAviso := '';
              end
              else
              begin
                //Gravar a Foto no Banco
                Operacao200500;

                if ParMonitoramentoFluxoRTSP.Cam <> '' then
                  TmrMonitoramento.Enabled := True;

                ThreadCronometro.PauseT:= false;
                TmrMonitoramento.Enabled := True;
                TmrBiometriaFoto.Enabled := True;
                TmrListaBloqueio.Enabled := True;
                ParCandidato.Bloqueado   := 'N';
                Tmr200200.Enabled := True;

                Exit;
              end;
            except
              on E: Exception do
                ArquivoLog.GravaArquivoLog('Problema na chamada do Biometrika para Foto apenas - na Exceção Digital) - ' + E.Message);
            end;

          until ( Not Aviso(TMsgDlgType.mtConfirmation, 'Não foi possivel validar a biometria/foto.'+ #13 + ' Deseja tentar novamente?', False));

          if (not retonoBioFoto) and (txtAviso <> '') then
          begin
            // inicio aqui
            TmrMonitoramento.Enabled := False;
            TmrBiometriaFoto.Enabled := False;
            TmrListaBloqueio.Enabled := False;
            ParCandidato.Bloqueado   := 'S';
            Tmr200200.Enabled := False;

            if ParFotoExame.DigitalMensagem <> '' then
              if ParFotoExame.DigitalMensagem <> 'Sucesso' then
            begin
              txtAviso := ParFotoExame.DigitalMensagem;
            end
            else if ParFotoExame.FotoMensagem <> '' then
            begin
              txtAviso := ParFotoExame.FotoMensagem;
            end
            else
              txtAviso := 'Execute a prova novamente. No foi possvel validar a biometria !';

            Aviso(mtInformation, txtAviso, False);

            if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
            begin
              ThreadFFMpeg := TThreadFFMpeg.Create;
              ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
                ThreadFFMpeg.ThreadID);
              ThreadFFMpeg.MatarFFMpeg := True;
              ThreadFFMpeg.Start;
              TmrMonitoramento.Enabled := True;
            end;

            if ParCandidato.Bloqueado = 'S' then
            begin
              Operacao200500;
              Application.Terminate;
            end
            else
            begin
              if Aviso(mtInformation, txtAviso, False) then
              begin

                TThread.Synchronize(nil,
                  procedure
                  begin
                    CoInitializeEx(nil, 2);
                    TmrBiometriaFotoTimer(Self);
                  end);

              end
              else
              begin
                if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
                begin
                  ThreadFFMpeg := TThreadFFMpeg.Create;
                  ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
                    ThreadFFMpeg.ThreadID);
                  ThreadFFMpeg.MatarFFMpeg := True;
                  ThreadFFMpeg.Start;
                  TmrMonitoramento.Enabled := True;
                end;
                Application.Terminate;
              end;
            end;
            //fim aqui
          end;

          ThreadCronometro.PauseT:= False;
          TmrBiometriaFoto.Enabled := True;
        end);
    end;
  end;
end;

procedure TFrm_Questionario.TmrCronometroTimer(Sender: TObject);
begin

  if Parametros.TerminarProva then
  begin

    TmrCronometro.Enabled := False;
    TmrMonitoramento.Enabled := False;
    TmrBiometriaFoto.Enabled := False;
    TmrListaBloqueio.Enabled := False;
    Tmr200200.Enabled := False;
    Tmr200400.Enabled := False;
    TmrDVR.Enabled := False;

    if not IdThreadMonitoramento.Terminated then
      IdThreadMonitoramento.Terminate;

    if not IdThreadListaBloqueio.Terminated then
      IdThreadListaBloqueio.Terminate;

    if not IdThread200200.Terminated then
      IdThread200200.Terminate;

    if not IdThread200400.Terminated then
      IdThread200400.Terminate;

    ControledeJanela := True;
    TelaTerminarAplicacao := Parametros.TerminarProva;
    TelaIdentificaCandidato := False;
    TelaFoto := False;
    TelaBiometria := False;
    Reinicia := False;
    TelaInformacoes := False;
    TelaTeclado := False;
    TelaQuestionario := False;
    TelaResultado := False;

    Frm_Menu.AbreTela;
    Close;

  end;

  if StrToIntDef(Copy(FormatFloat('00.00', ParQuestionario.Tempo), 1, 2), 0) = 0 then
  begin
    Label_Tempo.Font.Color := clRed;
    Label_Tempo.Caption := Copy(FormatFloat('00.00', ParQuestionario.Tempo), 1,
      2) + ':' + Copy(FormatFloat('00.00', ParQuestionario.Tempo), 4, 2);
    Label_Tempo.Refresh;
  end
  else
  begin
    Label_Tempo.Caption := Copy(FormatFloat('00.00', ParQuestionario.Tempo), 1,
      2) + ':' + Copy(FormatFloat('00.00', ParQuestionario.Tempo), 4, 2);
    Label_Tempo.Font.Color := clBlack;
    Label_Tempo.Refresh;
  end;

  if ParQuestionario.Tempo <> 0 then
    ParQuestionario.TempoDecorrido :=
      (StrToIntDef(Copy(FormatFloat('00.00', ParQuestionario.Tempo), 1, 2), 0) -
      ParQuestionario.TempoTotal) * -1;

  if ParQuestionario.Tempo = 0 then
  begin

    // Feito desta forma para que não fique
    // Criando varias tela de dialogo uma sobre da outra
    if TmrCronometro.Enabled then
    begin
      SBtFinalizarClick(Self);
      TmrCronometro.Enabled := False;
      TmrMonitoramento.Enabled := False;
      TmrBiometriaFoto.Enabled := False;
      TmrListaBloqueio.Enabled := False;
    end;

  end;

end;

procedure TFrm_Questionario.TmrDVRTimer(Sender: TObject);
begin

  TThread.Synchronize(nil,
    procedure
    var
      Consulta: MainOperacao;
      Oper200210Env: T200210Envio;
      Oper200210Ret: T200210Retorno;
      txtDialogo: string;
    begin

      CoInitializeEx(nil, 2);

      if (ParCandidato.TipoProva = 'P') and (DVRFerramentas <> nil) then
      begin
        if DVRFerramentas.Verificar = 'S' then
        begin
          if Trim(DVRFerramentas.Endereco) <> '' then
          begin
            if DVRFerramentas.DVRStatus = 'Desligado' then
            begin
              txtDialogo :=
                'O Monitoramento da SALA da prova está apresentando ' + #13 +
                'problemas.Verifique se o equipamento está ativo!';
              ThreadCronometro.PauseT := True;

              ControledeJanela := True;
              TelaIdentificaCandidato := True;
              TelaFoto := False;
              TelaBiometria := False;
              Reinicia := True;
              TelaInformacoes := False;
              TelaTeclado := False;
              TelaQuestionario := False;
              TelaResultado := False;

              ThreadFFMpeg := TThreadFFMpeg.Create;
              ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg',
                ThreadFFMpeg.ThreadID);
              ThreadFFMpeg.MatarFFMpeg := True;
              ThreadFFMpeg.Start;

              Aviso(mtInformation, txtDialogo, False);

              Frm_Menu.AbreTela;
              Close;

              Application.Terminate;
            end;
          end;
        end;

        // Efetuar a operação 200200
        Consulta := MainOperacao.Create(Self, '200210');
        Oper200210Env := T200210Envio.Create;
        Oper200210Ret := T200210Retorno.Create;
        Oper200210Ret.MontaRetorno(Consulta.Consultar
          (IntToStr(ParServidor.ID_Sistema),
          Oper200210Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
          ParCandidato.TipoProva), ''));
      end;
    end);

end;

procedure TFrm_Questionario.TmrListaBloqueioTimer(Sender: TObject);
begin

  IdThreadListaBloqueio.Start;

end;

Procedure TFrm_Questionario.Retorno200710Detecta(Sender: TObject);
Begin

  if (ParDetecta.MensagemTipo = 'R') then
  begin

    if ParDetecta.MensagemTipo = 'R' then
    begin
      Pnl_MensagemDetecta.Top := Self.Height div 4;
      Pnl_MensagemDetecta.Left := Self.Width div 4;

      Pnl_MensagemDetecta.Visible := True;
      MmMensagemDetecta.Lines.Clear;
      MmMensagemDetecta.Text := ParDetecta.MensagemDetecta;
    end;

  end;

end;

procedure TFrm_Questionario.TmrMonitoramentoTimer(Sender: TObject);
begin

  Application.HandleMessage; // IdleHandler
  IdThreadMonitoramento.Start;

end;

procedure TFrm_Questionario.MostraQuestoes(NumeroQuestao: Integer);
var
  I: Integer;
  msPlaca: TMemoryStream;
  IdDecoderMIME1: TIdDecoderMIME;
  jpg: TJPEGImage;
begin

  if Parametros.AguardarAviso then
    abort;

  for I := 1 to ParQuestionario.Perguntas.Count do
  begin

    if Trim(ParQuestionario.Perguntas.Items[I].RespostaEscolhida) <> '' then
    begin
      TLabel(FindComponent('LblNumeroQuestao' + RightSTR('00' + IntToStr(I), 2))
        ).Color := clWhite;
      TLabel(FindComponent('LblNumeroQuestao' + RightSTR('00' + IntToStr(I), 2))
        ).Font.Color := clBlack;
    end
    else
    begin
      TLabel(FindComponent('LblNumeroQuestao' + RightSTR('00' + IntToStr(I), 2))
        ).Color := clWhite;
      TLabel(FindComponent('LblNumeroQuestao' + RightSTR('00' + IntToStr(I), 2))
        ).Font.Color := clBlue;
    end;

  end;

  Image_OpcaoA.Visible := True;
  Image_OpcaoB.Visible := True;
  Image_OpcaoC.Visible := True;
  Image_OpcaoD.Visible := True;
  Image_OpcaoE.Visible := True;

  LabelMateria.Caption := 'Disciplina: ' + ParQuestionario.Perguntas.Items
    [NumeroQuestao].PerguntaMateria;
  Label_Numero.Caption := RightSTR('00' + IntToStr(NumeroQuestao), 2);

  if CaixaAlta then
  begin
    Label_Questao.Caption := textocaixaalta(ParQuestionario.Perguntas.Items
      [NumeroQuestao].Pergunta);
    Label_RespostaA.Caption :=
      textocaixaalta(ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaA);
    Label_RespostaB.Caption :=
      textocaixaalta(ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaB);
    Label_RespostaC.Caption :=
      textocaixaalta(ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaC);
    Label_RespostaD.Caption :=
      textocaixaalta(ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaD);
    Label_RespostaE.Caption :=
      textocaixaalta(ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaE);
  end
  else
  begin
    if CaixaBaixa then
    begin
      Label_Questao.Caption :=
        textocaixabaixa(ParQuestionario.Perguntas.Items[NumeroQuestao]
        .Pergunta);
      Label_RespostaA.Caption :=
        textocaixabaixa(ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaA);
      Label_RespostaB.Caption :=
        textocaixabaixa(ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaB);
      Label_RespostaC.Caption :=
        textocaixabaixa(ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaC);
      Label_RespostaD.Caption :=
        textocaixabaixa(ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaD);
      Label_RespostaE.Caption :=
        textocaixabaixa(ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaE);
    end
    else
    begin
      Label_Questao.Caption := ParQuestionario.Perguntas.Items
        [NumeroQuestao].Pergunta;
      Label_RespostaA.Caption := ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaA;
      Label_RespostaB.Caption := ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaB;
      Label_RespostaC.Caption := ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaC;
      Label_RespostaD.Caption := ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaD;
      Label_RespostaE.Caption := ParQuestionario.Perguntas.Items[NumeroQuestao]
        .RespostaE;
    end;
  end;

  if Trim(ParQuestionario.Perguntas.Items[NumeroQuestao].PerguntaImagem) <> ''
  then
  begin
    jpg := TJPEGImage.Create;

    Label_Questao.Width := 630;
    Label_RespostaA.Width := 630;
    Label_RespostaB.Width := 630;

    msPlaca := TMemoryStream.Create;

    try
      msPlaca.Position := 0;
    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog('Falha ao criar o arquivo de memória - ' +
          E.Message);
    end;

    try

      if Copy(ParQuestionario.Perguntas.Items[NumeroQuestao].PerguntaImagem, 1,
        4) = 'http' then
      begin
        ArquivoLog.GravaArquivoLog(' Imagem  gerada com HTTP');
      end
      else
      begin
        IdDecoderMIME1 := TIdDecoderMIME.Create(Self);
        IdDecoderMIME1.DecodeStream(ParQuestionario.Perguntas.Items
          [NumeroQuestao].PerguntaImagem, msPlaca);
        FreeANDNIL(IdDecoderMIME1);
      end;

    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog('Falha ao decodificar a imagem - ' +
          E.Message);
    end;

    try

      if msPlaca.Position > 0 then
      begin
        msPlaca.Position := 0;
        jpg.LoadFromStream(msPlaca);
      end
      else
        ArquivoLog.GravaArquivoLog(' Imagem  gerada com zero bits ');

    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog('Falha ao Gerar a imagem - ' + E.Message);
    end;

    try

      if jpg <> nil then
      begin
        ImgPlacas.Picture.Assign(jpg);
        ImgPlacas.BringToFront;
        ImgPlacas.Repaint;

        msPlaca.Free;
        jpg.Free;
      End
      else
        ArquivoLog.GravaArquivoLog('Falha ao Gerar a jpg da placa');

    except
      on E: Exception do
        ArquivoLog.GravaArquivoLog('Falha ao carregar a imagem - ' + E.Message);
    end;

  end
  else
  begin
    Label_Questao.Width := 745;
    Label_RespostaA.Width := 930;
    Label_RespostaB.Width := 930;

    ImgPlacas.Picture.Graphic := nil;
    ImgPlacas.BringToFront;
    ImgPlacas.Repaint;

  end;

  if Trim(ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaEscolhida) <> ''
  then
  begin
    TLabel(FindComponent('Image_Opcao' + ParQuestionario.Perguntas.Items
      [NumeroQuestao].RespostaEscolhida)).Visible := False;
    TLabel(FindComponent('Image_Opcao' + ParQuestionario.Perguntas.Items
      [NumeroQuestao].RespostaEscolhida + '_Over')).Visible := True;

    TLabel(FindComponent('LblNumeroQuestao' + RightSTR('00' +
      IntToStr(NumeroQuestao), 2))).Caption :=
      RightSTR('00' + IntToStr(NumeroQuestao), 2) + '  ' +
      RightSTR(' ' + ParQuestionario.Perguntas.Items[NumeroQuestao]
      .RespostaEscolhida, 1);
  end
  else
    TLabel(FindComponent('LblNumeroQuestao' + RightSTR('00' +
      IntToStr(NumeroQuestao), 2))).Caption :=
      RightSTR('00' + IntToStr(NumeroQuestao), 2) + '    ';

  if ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaD = '' then
  begin
    Image_OpcaoD.Visible := False;
    Image_OpcaoD_Over.Visible := False;
  end;

  if ParQuestionario.Perguntas.Items[NumeroQuestao].RespostaE = '' then
  begin
    Image_OpcaoE.Visible := False;
    Image_OpcaoE_Over.Visible := False;
  end;

  if (FindComponent('LblNumeroQuestao' + Label_Numero.Caption) is TLabel) then
  begin
    TLabel(FindComponent('LblNumeroQuestao' + Label_Numero.Caption)).Color
      := clBlue;
    TLabel(FindComponent('LblNumeroQuestao' + Label_Numero.Caption)).Font.Color
      := clWhite;
  end;

  Self.Refresh;

end;

end.
