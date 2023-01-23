unit FrmResultado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.UITypes,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, MSHTML, Vcl.StdCtrls, Vcl.Buttons, Vcl.OleCtrls, SHDocVw,
  VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, Vcl.ComCtrls, MaskUtils, Base64,
  ClsMonitoramentoRTSP, Vcl.Imaging.pngimage, ShellApi, VCLTee.TeeGDIPlus,
  ClsListaBloqueio,
  ClsOper200710, ClsParametros, ClsQuestionario, ClsCFCControl,
  ClsCandidatoControl, ClsServidorControl,
  ClsMonitoramentoRTSPControl, ClsOper200400, ClsOper200500, ClsOperacoes,
  ClsConexaoFerramentas,
  ClsDigitalFotoExame, ClsDetecta, System.Generics.Collections, Xml.XMLDoc,
  IdcoderMIME,
  ClsSincronizarProva;

type

  TFrm_Resultado = class(TForm)
    Image1: TImage;
    Label_CPFProva: TLabel;
    Label_NomeProva: TLabel;
    Image2: TImage;
    Label_CursoProva: TLabel;
    SBtFinalizar: TSpeedButton;
    SBtCancelar: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListBox1: TListBox;
    PageControl1: TPageControl;
    TSImpressao: TTabSheet;
    WBImpressao: TWebBrowser;
    TSGrafico: TTabSheet;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    TSGrafico3: TTabSheet;
    Chart1: TChart;
    Series1: TBarSeries;
    ChrtAproveitamento: TChart;
    Series2: TPieSeries;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    MmResultado: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SBtFinalizarClick(Sender: TObject);
    procedure WBImpressaoDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure Timer1Timer(Sender: TObject);
  private

    Indice: Integer;
    controlehash: Boolean;

    procedure onRetorno200400(Sender: T200400Retorno);
    procedure FinalizaStream;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Resultado: TFrm_Resultado;
  Reinicia: Boolean;

implementation

uses FrmPrincipal, FrmAvisoOperacoes, ClsFuncoes, clsDialogos, ClsOperacoesRest,
  ClsEnvio.Inicio.SEITran, System.JSON, ClsRetorno.SEITran, clseProvaConst,
  FrmAviso;

{$R *.dfm}

procedure TFrm_Resultado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ArquivoLog.GravaArquivoLog('# Fechando tela resultado ');

  if not Reinicia then
  begin
    ArquivoLog.GravaArquivoLog('# Reinicio tela resultado ');
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;

end;

procedure TFrm_Resultado.FormCreate(Sender: TObject);
var
  lstDisciplina: TStringList;
  Disc: String;
  I: Integer;
begin
  // Monta o Resultado

  if (frm_aviso.MostraMsg = 1) then
     label2.Visible:= true;

  if ParCandidato.TipoProva = 'P' then
  begin
    if ParCFC.Impressao_Gabarito_Prova = 'S' then
      SpeedButton1.Enabled := True
    else
      SpeedButton1.Enabled := False;

    if ParCFC.Impressao_Questionario_Prova = 'S' then
      SpeedButton4.Enabled := True
    else
      SpeedButton4.Enabled := False;
  end;

  if ParCandidato.TipoProva = 'S' then
  begin
    if ParCFC.Impressao_Gabarito_Simulado = 'S' then
      SpeedButton1.Enabled := True
    else
      SpeedButton1.Enabled := False;

    if ParCFC.Impressao_Questionario_Simulado = 'S' then
      SpeedButton4.Enabled := True
    else
      SpeedButton4.Enabled := False;
  end;

  TSImpressao.TabVisible := False;
  TSGrafico.TabVisible := False;
  TSGrafico3.TabVisible := False;

  PageControl1.ActivePage := TSGrafico;
  Reinicia := False;

  Label_CPFProva.Caption := 'CPF: ' + FormatMaskText('000\.000\.000\-00;0;_',
    ParCandidato.CPFCandidato);
  Label_NomeProva.Caption := ParCandidato.NomeCandidato;
  Label_CursoProva.Caption := 'Curso: ' + ParCandidato.CursoCandidato;

  MmResultado.Lines.Clear;

  MmResultado.Lines.Add('  ');
  MmResultado.Lines.Add('             RESUMO ');
  MmResultado.Lines.Add('  ');
  MmResultado.Lines.Add(' Aproveitamento:       ' +
    RightStr('     ' + FormatFloat('#0.00',
    (ParQuestionario.TotalRespostasCorretas / ParQuestionario.Perguntas.Count)
    * 100), 6) + '% ');
  MmResultado.Lines.Add('-------------------------------------');
  MmResultado.Lines.Add('  ');
  MmResultado.Lines.Add(' Total de Perguntas:    ' +
    RightStr('  ' + IntToStr(ParQuestionario.Perguntas.Count), 2));
  MmResultado.Lines.Add(' Respostas Corretas:    ' +
    RightStr('  ' + IntToStr(ParQuestionario.TotalRespostasCorretas), 2));
  MmResultado.Lines.Add(' Respostas Incorretas:  ' +
    RightStr('  ' + IntToStr(ParQuestionario.TotalRespostasErradas), 2));
  MmResultado.Lines.Add('  ');
  MmResultado.Lines.Add(' Tempo de Prova:        ' +
    RightStr('  ' + IntToStr(ParQuestionario.TempoTotal), 2));
  MmResultado.Lines.Add(' Tempo Decorrido:       ' +
    RightStr('  ' + IntToStr(ParQuestionario.TempoDecorrido), 2));
  MmResultado.Lines.Add('    ');

  MmResultado.Lines.Add(' Resultado por Disciplina');
  MmResultado.Lines.Add('-------------------------------------');
  MmResultado.Lines.Add('  ');

  lstDisciplina := TStringList.Create;
  for Disc in ParQuestionario.Disciplinas.Keys do
    if Length(Trim(Disc)) > 3 then
      lstDisciplina.Add(Disc);

  for I := 0 to lstDisciplina.Count - 1 do
  begin

    if ParQuestionario.Disciplinas.Items[lstDisciplina[I]].ResultadoDisciplina
      <> '' then
    begin
      MmResultado.Lines.Add(' ' + ParQuestionario.Disciplinas.Items
        [lstDisciplina[I]].ResultadoDisciplina);
      MmResultado.Lines.Add(' - Corretas:            ' +
        RightStr('  ' + IntToStr(ParQuestionario.Disciplinas.Items
        [lstDisciplina[I]].ResultadoDisciplinaCertas), 2));
      MmResultado.Lines.Add(' - Incorretas:          ' +
        RightStr('  ' + IntToStr(ParQuestionario.Disciplinas.Items
        [lstDisciplina[I]].ResultadoDisciplinaErradas), 2));
      MmResultado.Lines.Add('    ');
    end;

  end;

  SpeedButton2Click(Self);

  SpeedButton3.Enabled := True;
  SpeedButton2.Enabled := True;

  if ParCFC.Impressao_Gabarito_Prova = 'S' then
    SpeedButton1.Enabled := True
  else
    SpeedButton1.Enabled := False;

  Try
    if Trim(ParQuestionario.url_Hash) <> '' then
    begin
      ArquivoLog.GravaArquivoLog(ParQuestionario.url_Hash);
      WBImpressao.Navigate(ParQuestionario.url_Hash);
      controlehash := True;
      // 000 - Hash da prova gerado com sucesso
    end;
  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Resultado Monitoramento - ' + E.Message);
  end;

  ChrtAproveitamento.Enabled := False;
  Chart1.Enabled := False;

end;

procedure TFrm_Resultado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_LEFT then
  begin
    if Indice > 3 then
      Indice := 0;

    case Indice of
      0:
        begin
          if SpeedButton1.Visible then
            SpeedButton1Click(Self);
        end;
      1:
        begin
          if SpeedButton4.Visible then
            SpeedButton4Click(Self);
        end;
      2:
        begin
          if SpeedButton2.Visible then
            SpeedButton2Click(Self);
        end;
      3:
        begin
          if SpeedButton2.Visible then
            SpeedButton2Click(Self);
        end;
    end;

    Inc(Indice);
  end;

  if Key = VK_RIGHT then
  begin
    if Indice > 3 then
      Indice := 0;

    case Indice of
      0:
        begin
          if SpeedButton1.Visible then
            SpeedButton1Click(Self);
        end;
      1:
        begin
          if SpeedButton4.Visible then
            SpeedButton4Click(Self);
        end;
      2:
        begin
          if SpeedButton2.Visible then
            SpeedButton2Click(Self);
        end;
      3:
        begin
          if SpeedButton2.Visible then
            SpeedButton2Click(Self);
        end;
    end;

    Inc(Indice);
  end;

  if Key = VK_HOME then
    SBtCancelarClick(Self);

  if Key = VK_END then
    SBtFinalizarClick(Self);

end;

procedure TFrm_Resultado.FinalizaStream;
var
  MonitoramentoClntSckt: TMonitoramentoClntSckt;
  FinalizaMonitoramento: string;
  Tetativas: Integer;
  Conexao: TConexao;
begin

  try

    FinalizaMonitoramento := '';
    Tetativas := 0;

    // deste jeito funciona
    KillTask('ffmpeg.exe');

    if Conexao.PingDNSGrupoCRIAR then
    begin

      repeat

        if ParListaMonitoramentoRTSP.Count > 0 then
          ParMonitoramentoRTSP :=
            TMonitoramentoRTSP(ParListaMonitoramentoRTSP.Objects[Tetativas]);

        MonitoramentoClntSckt := TMonitoramentoClntSckt.Create(Self);
        FinalizaMonitoramento := MonitoramentoClntSckt.SendSocketComand
          (ParMonitoramentoRTSP.finalizar_Gravacao +
          ReplaceStr(Parametros.NomeSistema, '-' + LowerCase(ParCFC.UF), '') +
          ';' + ParCFC.UF + ';' + ParCFC.id_cfc + ';' +
          IntToStr(ParQuestionario.Id_prova) + ';' + ParCandidato.CPFCandidato +
          ';' + ParMonitoramentoFluxoRTSP.Cam + ';');
        MonitoramentoClntSckt.Free;

        if FinalizaMonitoramento = '' then
          Inc(Tetativas)
        else
          Tetativas := 10000;

      until (Tetativas >= ParListaMonitoramentoRTSP.Count);

    end;

    if FinalizaMonitoramento = 'OK' then
      ParMonitoramentoFluxoRTSP.Cam := '';

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('monitoramento - Finalizar  - ' + E.Message);
      ArquivoLog.GravaArquivoLog('monitoramento - Finalizar  - camera: ' +
        ParMonitoramentoFluxoRTSP.Cam + ' - ' + E.Message);
    end;
  end;

end;

procedure TFrm_Resultado.FormShow(Sender: TObject);
begin

  try
    if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
      FinalizaStream;
  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('monitoramento - Finalizar  - ' + E.Message);
      ArquivoLog.GravaArquivoLog('monitoramento - Finalizar  - camera: ' +
        ParMonitoramentoFluxoRTSP.Cam + ' - ' + E.Message);
    end;
  end;

  SpeedButton2Click(SpeedButton2);
  PageControl1.ActivePage := TSGrafico3;
  ChrtAproveitamento.Title.Caption := 'Aproveitamento';
  Chart1.Title.Caption := 'Aproveitamento por disciplina';

  // Botões de 0 até 3
  Indice := 0;

end;

procedure TFrm_Resultado.onRetorno200400(Sender: T200400Retorno);
var
  I: Integer;
  P: Integer;
  ParDisciplina: TDisciplina;
  lstDisciplina: TStringList;
  Disc: String;
  D: Integer;

  objEnvioFinalSEITran: TEnvioFinalSEITran;
  objRetornoFinalSEITran: TRetronoSEITranFinal;
  objCon: TOperacaoRestful;
begin

  if Trim(Sender.codigo) <> '' then
  begin

    if (Trim(Sender.codigo) = 'B000') then
    begin
      objRetornoFinalSEITran := TRetronoSEITranFinal.Create;
      objEnvioFinalSEITran := TEnvioFinalSEITran.Create;
      objEnvioFinalSEITran.CFC := ParCFC.id_cfc;
      objEnvioFinalSEITran.CPF := ParCandidato.CPFCandidato;

      try
        objCon := TOperacaoRestful.Create(Self);
        objRetornoFinalSEITran.AsJson := objCon.ExecutarConsultar
          (ParCFC.URLSEITrans + 'resultado/cpf', objEnvioFinalSEITran.AsJson,
          'A Prova não será finalizada!');

        if Assigned(objRetornoFinalSEITran) then
        begin
          if Assigned(objRetornoFinalSEITran.Retorno) then
          begin
            if objRetornoFinalSEITran.Retorno.codigo <> 'B000' then
            begin
              ArquivoLog.GravaArquivoLog('Operação Inicio prova SEI Tran. - ' +
                Trim(objRetornoFinalSEITran.Retorno.codigo));
            end;
          end;
        end;
      finally
        FreeAndNil(objRetornoFinalSEITran);
        FreeAndNil(objEnvioFinalSEITran);
      end;
    end;

    if (Trim(Sender.codigo) <> 'B000') then
    begin

      // ## Cuidado ##
      // Em função da operação ter falhado deve zerar para não duplicar o valor;
      ParQuestionario.TotalRespostasCorretas := 0;
      ParQuestionario.TotalRespostasErradas := 0;
      // ## Neste ponto ##

      for P := 1 to ParQuestionario.Perguntas.Count do
      begin

        if ParQuestionario.Perguntas[P] <> nil then
        begin

          if ParQuestionario.Perguntas[P].RespostaEscolhida = ParQuestionario.
            Perguntas[P].RespostaCorreta then
            ParQuestionario.TotalRespostasCorretas :=
              ParQuestionario.TotalRespostasCorretas + 1
          else
            ParQuestionario.TotalRespostasErradas :=
              ParQuestionario.TotalRespostasErradas + 1;

          if ParQuestionario.Disciplinas.ContainsKey
            (ParQuestionario.Perguntas[P].PerguntaMateria) then
            ParDisciplina := ParQuestionario.Disciplinas.Items
              [ParQuestionario.Perguntas[P].PerguntaMateria]
          else
            ParDisciplina := TDisciplina.Create;

          if ParDisciplina <> nil then
          begin

            ParDisciplina.ResultadoDisciplina := ParQuestionario.Perguntas[P]
              .PerguntaMateria;
            ParDisciplina.ResultadoDisciplinaPerg :=
              ParDisciplina.ResultadoDisciplinaPerg + 1;

            if ParQuestionario.Perguntas[P].RespostaEscolhida = ParQuestionario.
              Perguntas[P].RespostaCorreta then
              ParDisciplina.ResultadoDisciplinaCertas :=
                ParDisciplina.ResultadoDisciplinaCertas + 1
            else
              ParDisciplina.ResultadoDisciplinaErradas :=
                ParDisciplina.ResultadoDisciplinaErradas + 1;

            if ParQuestionario.Disciplinas.ContainsKey
              (ParQuestionario.Perguntas[P].PerguntaMateria) then
            begin
              ParQuestionario.Disciplinas.Remove
                (ParQuestionario.Perguntas[P].PerguntaMateria);
              ParQuestionario.Disciplinas.Add
                (ParQuestionario.Perguntas[P].PerguntaMateria, ParDisciplina);
            end
            else
              ParQuestionario.Disciplinas.Add
                (ParQuestionario.Perguntas[P].PerguntaMateria, ParDisciplina);

          end;

        end;

      end;

    end
    else
    begin
      DeleteFile(UserProgranData + strFileEnviar + '\200400' +
        IntToStr(ParQuestionario.Id_prova) + ParCandidato.CPFCandidato + '.ep');
    end;

    ListBox1.Items.Clear;

    ListBox1.Items.Add('  ');
    ListBox1.Items.Add('             RESUMO ');
    ListBox1.Items.Add('  ');
    ListBox1.Items.Add(' Aproveitamento:       ' +
      RightStr('     ' + FormatFloat('#0.00',
      (ParQuestionario.TotalRespostasCorretas / ParQuestionario.Perguntas.Count)
      * 100), 6) + '% ');
    ListBox1.Items.Add('--------------------------------');
    ListBox1.Items.Add('  ');
    ListBox1.Items.Add(' Total de Perguntas:    ' +
      RightStr('  ' + IntToStr(ParQuestionario.Perguntas.Count), 2));
    ListBox1.Items.Add(' Respostas Corretas:    ' +
      RightStr('  ' + IntToStr(ParQuestionario.TotalRespostasCorretas), 2));
    ListBox1.Items.Add(' Respostas Incorretas:  ' +
      RightStr('  ' + IntToStr(ParQuestionario.TotalRespostasErradas), 2));
    ListBox1.Items.Add('  ');
    ListBox1.Items.Add(' Tempo de Prova:        ' +
      RightStr('  ' + IntToStr(ParQuestionario.TempoTotal), 2));
    ListBox1.Items.Add(' Tempo Decorrido:       ' +
      RightStr('  ' + IntToStr(ParQuestionario.TempoDecorrido), 2));
    ListBox1.Items.Add('    ');

    ListBox1.Items.Add(' Resultado por Disciplina');
    ListBox1.Items.Add('--------------------------------');
    ListBox1.Items.Add('  ');

    lstDisciplina := TStringList.Create;
    for Disc in ParQuestionario.Disciplinas.Keys do
      if Length(Trim(Disc)) > 3 then
        lstDisciplina.Add(Disc);

    for I := 0 to lstDisciplina.Count - 1 do
    begin

      if ParQuestionario.Disciplinas.Items[lstDisciplina[I]].ResultadoDisciplina
        <> '' then
      begin
        ListBox1.Items.Add(' ' + ParQuestionario.Disciplinas.Items
          [lstDisciplina[I]].ResultadoDisciplina);
        ListBox1.Items.Add(' - Corretas:            ' +
          RightStr('  ' + IntToStr(ParQuestionario.Disciplinas.Items
          [lstDisciplina[I]].ResultadoDisciplinaCertas), 2));
        ListBox1.Items.Add(' - Incorretas:          ' +
          RightStr('  ' + IntToStr(ParQuestionario.Disciplinas.Items
          [lstDisciplina[I]].ResultadoDisciplinaErradas), 2));
        ListBox1.Items.Add('    ');
      end;

    end;

    SpeedButton2Click(Self);

    SpeedButton3.Enabled := True;
    SpeedButton2.Enabled := True;
    if ParCFC.Impressao_Gabarito_Prova = 'S' then
      SpeedButton1.Enabled := True
    else
      SpeedButton1.Enabled := False;

  end;

end;

procedure TFrm_Resultado.SBtCancelarClick(Sender: TObject);
begin
  ArquivoLog.GravaArquivoLog('# Cancelamento tela resultado  ');
  TelaIdentificaCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := False;
  TelaTeclado := False;
  TelaQuestionario := False;
  TelaResultado := False;
  TelaLogin := False;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Resultado.SBtFinalizarClick(Sender: TObject);
begin
  ArquivoLog.GravaArquivoLog('# Cancelamento tela resultado  ');
  TelaIdentificaCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := False;
  TelaInformacoes := False;
  TelaTeclado := False;
  TelaQuestionario := False;
  TelaResultado := False;
  TelaLogin := False;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Resultado.SpeedButton1Click(Sender: TObject);
var
  caminho: PChar;
  B64: string;

  Consulta: MainOperacao;
  Oper200400Env: T200400Envio;
  Oper200400Ret: T200400Retorno;

  xmlhash: TXMLDocument;
  IdDecoderMIME: TIdDecoderMIME;
  ListaProvasPendente: TListaProvasPendente;
  I: Integer;

  WebBrowser1: TWebBrowser;
begin

  // Endereço da prova
  // Parametro "o" = 1=Simulado, 2=Prova, 3=Imagem
  // Parametro "h" =Base64(id_prova+id_cfc+cpf)
  // 'http://www.eprova.com.br/ba/sistema/operacoes_servidor.php?'+
  // 'vidia.keynet.com.br/eprova/ba/sistema/operacoes_servidor.php?'+

  // PageControl1.ActivePage := TSImpressao;

  // ListaProvasPendente := TListaProvasPendente.Create;
  // ListaProvasPendente.ListarArquivos(UserProgranData + strFileEnviar, True);
  //
  // if ListaProvasPendente.Count <> 0 then
  // begin
  //
  // if WebBrowser1 = nil then
  // begin
  // WebBrowser1 := TWebBrowser.Create(Self);
  // WebBrowser1.Left := -5000;
  // end;
  //
  // Application.ProcessMessages;
  //
  // for I := 0 to ListaProvasPendente.Count - 1 do
  // begin
  //
  // if pos('200400', ListaProvasPendente[0]) > 0 then
  // begin
  //
  // Consulta := MainOperacao.Create(Self, '200400');
  // Oper200400Env := T200400Envio.Create;
  // Oper200400Ret := T200400Retorno.Create;
  // Oper200400Ret.MontaRetorno('E', Consulta.consultar(IntToStr(ParServidor.ID_Sistema), Oper200400Env.MontaXMLEnvioSinc(ListaProvasPendente[0])));
  //
  // if Oper200400Ret.codigo = 'B000' then
  // begin
  //
  // xmlhash := TXMLDocument.Create(Self);
  // xmlhash.Active := False;
  // xmlhash.LoadFromFile(ListaProvasPendente[0]);
  // xmlhash.Active := True;
  //
  // IdDecoderMIME := TIdDecoderMIME.Create(Self);
  // WebBrowser1.Navigate(IdDecoderMIME.DecodeString(xmlhash.ChildNodes.Get(0).ChildNodes.Get(0).ChildNodes.findnode('hash').Text));
  // xmlhash.Active := False;
  //
  // FreeAndNil(xmlhash);
  //
  // DeleteFile(ListaProvasPendente[0]);
  // ListaProvasPendente.Delete(0);
  //
  // end;
  //
  // end;
  //
  // end;
  //
  // try
  // WebBrowser1 := nil;
  // WebBrowser1.Free;
  // except
  // on E: Exception do
  // end;
  //
  // end;

  if Trim(ParQuestionario.url_gabarito) <> '' then
  begin
    ArquivoLog.GravaArquivoLog(ParQuestionario.url_gabarito);
    // WebBrowser1.Navigate(ParQuestionario.url_gabarito);

    caminho := PChar(ParQuestionario.url_gabarito);

  end
  else
  begin

    B64 := Base64EncodeStr(IntToStr(ParQuestionario.Id_prova) + ParCFC.id_cfc +
      ParCandidato.CPFCandidato);

    ArquivoLog.GravaArquivoLog(ParCFC.url_gabarito + 'o=' +
      ParCFC.URL_Gabarito_Operacao + '&i=' + IntToStr(ParQuestionario.Id_prova)
      + '&h=' + B64);
    caminho := PChar(ParCFC.url_gabarito + 'o=' + ParCFC.URL_Gabarito_Operacao +
      '&i=' + IntToStr(ParQuestionario.Id_prova) + '&h=' + B64);

  end;

  ShellExecute(Application.Handle, PChar('open'), caminho, '', nil, SW_NORMAL);

end;

procedure TFrm_Resultado.SpeedButton2Click(Sender: TObject);
var
  I: Integer;
  Disc: string;
  PCor: Double;
  TotalMat, PergTotal: Double;
  lstDisciplina: TStringList;
  cor: TColors;
begin

  if (Sender as TObject) = SpeedButton2 then
  begin
    PageControl1.ActivePage := TSGrafico3;
    Chart1.Series[0].ManualData := True;
    Chart1.Title.Caption := 'Aproveitamento por Disciplina';
    Chart1.Title.Font.Size := 12;

    PergTotal := (ParQuestionario.TotalRespostasCorretas /
      ParQuestionario.Perguntas.Count) * 100;

    if ParCandidato.TipoProva = 'S' then
      Label1.Caption := iif(PergTotal < 70.00, 'Não preparado', 'Preparado') +
        ' para realizar a prova oficial'
    else
      Label1.Caption := ' ';

    { if PergTotal >= 70.00 then
      Chart1.SubTitle.Caption := 'Preparado para realizar a prova oficial'
      else
      Chart1.SubTitle.Caption := 'Não preparado para realizar a prova oficial'; }

    Series1.Clear;

    lstDisciplina := TStringList.Create;
    for Disc in ParQuestionario.Disciplinas.Keys do
      if Length(Trim(Disc)) > 3 then
        lstDisciplina.Add(Disc);

    for I := 0 to lstDisciplina.Count - 1 do
    begin
      if ParQuestionario.Disciplinas.Items[lstDisciplina[I]].ResultadoDisciplina
        <> '' then
      begin
        TotalMat := ParQuestionario.Disciplinas.Items[lstDisciplina[I]]
          .ResultadoDisciplinaErradas + ParQuestionario.Disciplinas.Items
          [lstDisciplina[I]].ResultadoDisciplinaCertas;
        PCor := (ParQuestionario.Disciplinas.Items[lstDisciplina[I]]
          .ResultadoDisciplinaCertas * 100) / TotalMat;
        Chart1.Series[0].Add(StrToFloat(FormatFloat('#.00', PCor)),
          ParQuestionario.Disciplinas.Items[lstDisciplina[I]]
          .ResultadoDisciplina,
          ParQuestionario.ResultadoDisciplinaCorCertas[I]);
      end;
    end;

    Chart1.Refresh;

  end
  else
  begin
    PageControl1.ActivePage := TSGrafico;

    ChrtAproveitamento.Series[0].ManualData := True;

    ChrtAproveitamento.Title.Caption := 'Aproveitamento';
    ChrtAproveitamento.Title.Font.Size := 12;

    Series2.Clear;

    cor.R := 243;
    cor.G := 156;
    cor.B := 53;

    ChrtAproveitamento.Series[0].Add(ParQuestionario.TotalRespostasCorretas,
      'Corretas', $00A36644);
    ChrtAproveitamento.Series[0].Add(ParQuestionario.TotalRespostasErradas,
      'Incorretas', cor.color);

    // ChrtAproveitamento.Series[0].Add(ParQuestionario.TotalRespostasErradas, 'Incorretas', $000080FF); // Close
    // ChrtAproveitamento.Series[0].Add(ParQuestionario.TotalRespostasErradas, 'Incorretas', $000065CA); // Excuro

    ChrtAproveitamento.Refresh;

  end;

end;

procedure TFrm_Resultado.SpeedButton4Click(Sender: TObject);
var
  caminho: PChar;
  B64: String;

  Consulta: MainOperacao;
  Oper200400Env: T200400Envio;
  Oper200400Ret: T200400Retorno;

  xmlhash: TXMLDocument;
  IdDecoderMIME: TIdDecoderMIME;
  ListaProvasPendente: TListaProvasPendente;
  I: Integer;

  WebBrowser1: TWebBrowser;
begin

  // Endereço da prova
  // Parametro "o" = 2=Prova e 1=Simulado
  // Parametro "h" =Base64(id_prova+id_cfc+cpf)
  // 'http://www.eprova.com.br/ba/sistema/operacoes_servidor.php?'+
  // 'vidia.keynet.com.br/eprova/ba/sistema/operacoes_servidor.php?'+
  // PageControl1.ActivePage := TSImpressao;

  ListaProvasPendente := TListaProvasPendente.Create;
  ListaProvasPendente.ListarArquivos(UserProgranData + strFileEnviar, True);

  if ListaProvasPendente.Count <> 0 then
  begin

    if WebBrowser1 = nil then
    begin
      WebBrowser1 := TWebBrowser.Create(Self);
      WebBrowser1.Left := -5000;
    end;

    Application.ProcessMessages;

    for I := 0 to ListaProvasPendente.Count - 1 do
    begin

      if pos('200400', ListaProvasPendente[0]) > 0 then
      begin

        Consulta := MainOperacao.Create(Self, '200400');
        Oper200400Env := T200400Envio.Create;
        Oper200400Ret := T200400Retorno.Create;
        Oper200400Ret.MontaRetorno('E',
          Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
          Oper200400Env.MontaXMLEnvioSinc(ListaProvasPendente[0])));

        if Oper200400Ret.codigo = 'B000' then
        begin

          xmlhash := TXMLDocument.Create(Self);
          xmlhash.Active := False;
          xmlhash.LoadFromFile(ListaProvasPendente[0]);
          xmlhash.Active := True;

          IdDecoderMIME := TIdDecoderMIME.Create(Self);
          WebBrowser1.Navigate
            (IdDecoderMIME.DecodeString(xmlhash.ChildNodes.Get(0)
            .ChildNodes.Get(0).ChildNodes.findnode('hash').Text));
          xmlhash.Active := False;

          FreeAndNil(xmlhash);

          DeleteFile(ListaProvasPendente[0]);
          ListaProvasPendente.Delete(0);

        end;

      end;

    end;

    try
      WebBrowser1 := nil;
      WebBrowser1.Free;
    except
      on E: Exception do
    end;

  end;

  if Trim(ParQuestionario.url_prova) <> '' then
  begin
    ArquivoLog.GravaArquivoLog(ParQuestionario.url_prova);
    caminho := PChar(ParQuestionario.url_prova);
  end
  else
  begin

    B64 := Base64EncodeStr(IntToStr(ParQuestionario.Id_prova) + ParCFC.id_cfc +
      ParCandidato.CPFCandidato);

    ArquivoLog.GravaArquivoLog(ParCFC.url_prova + 'o=' +
      ParCFC.URL_Prova_Operacao + '&i=' + IntToStr(ParQuestionario.Id_prova) +
      '&h=' + B64);
    caminho := PChar(ParCFC.url_prova + 'o=' + ParCFC.URL_Prova_Operacao + '&i='
      + IntToStr(ParQuestionario.Id_prova) + '&h=' + B64);

  end;

  ShellExecute(Application.Handle, PChar('open'), caminho, '', nil, SW_NORMAL);

end;

procedure TFrm_Resultado.Timer1Timer(Sender: TObject);
begin
  if label2.Caption = '' then
    label2.Caption := 'Não foi possível enviar o resultado da prova ao Detran informe ao responsável pelo CFC'
  else
    label2.Caption := '';
end;

procedure TFrm_Resultado.WBImpressaoDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  Tr: IHTMLTxtRange;
begin

  // Retorno
  // 000 - Hash da prova gerado com sucesso
  try

    if controlehash then
    begin
      WBImpressao.OleObject.Document.Body.Style.OverflowX := 'hidden';
      WBImpressao.OleObject.Document.Body.Style.OverflowY := 'hidden';
      Try
        if Assigned(WBImpressao.Document) then
        begin
          Tr := ((WBImpressao.Document AS IHTMLDocument2)
            .Body AS IHTMLBodyElement).CreateTextRange;

          if pos('sucesso', Trim(Tr.Text)) > 0 then
            WBImpressao.Navigate('about:blank')
          else
          begin
            WBImpressao.Navigate('about:blank');
            WBImpressao.Navigate(ParQuestionario.url_Hash);
          end;

          controlehash := False;
          ArquivoLog.GravaArquivoLog(Trim(Tr.Text));
        end;
      except

      End;
    end;

  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Resulta - Hash - ' + E.Message);
  end;

end;

end.
