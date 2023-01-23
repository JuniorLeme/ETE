unit FrmIdentificaCandidato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ImgList, Xml.XMLDoc, FrmPrincipal,
  System.UITypes, ClsDetecta,
  MaskUtils, IdcoderMIME, Vcl.OleCtrls, SHDocVw, ClsOperacoes, ClsListaBloqueio,
  ClsThreadDetecta,
  ClsFuncoes, clsDialogos, clsParametros, ClsSincronizarProva, ClsOper100300,
  ClsOper200400,
  ClsOper100700, ClsOper300100, ClsOper100110, ClsServidorControl,
  ClsCFCControl, ClsQuestionario,
  ClsDigitalFotoExame, ClsCandidatoControl, ClsDigitalFoto,
  ClsMonitoramentoRTSP,
  ClsMonitoramentoRTSPControl, ClsConexaoFerramentas;

type
  TFrm_IdentificaCandidato = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SBtConsultaCandidato: TSpeedButton;
    SBtProva: TSpeedButton;
    EdRENACH: TButtonedEdit;
    SBtSimulado: TSpeedButton;
    SBtRegistro: TSpeedButton;
    Image2: TImage;
    SpeedButton2: TSpeedButton;
    EditCpf: TEdit;
    EditNome: TEdit;
    EditCurso: TEdit;
    EditCidade: TEdit;
    EditNascimento: TEdit;
    EditSexo: TEdit;
    Label9: TLabel;
    Image3: TImage;
    SBtCadastraCandidato: TSpeedButton;
    LblInformacoes: TLabel;
    Image4: TImage;
    Label8: TLabel;
    Btn_BiometriaFotoTeste: TSpeedButton;
    Image1: TImage;
    WebBrowser1: TWebBrowser;
    BtnDVR: TSpeedButton;
    LblDVRStatus: TLabel;
    cbxMotorBiometrico: TComboBox;
    LblMotorBiometrico: TLabel;
    procedure SBtConsultaCandidatoClick(Sender: TObject);
    procedure EdRENACHRightButtonClick(Sender: TObject);
    procedure SBtProvaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdRENACHKeyPress(Sender: TObject; var Key: Char);
    procedure SBtSimuladoClick(Sender: TObject);
    procedure SBtRegistroClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Image2DblClick(Sender: TObject);
    procedure EdRENACHChange(Sender: TObject);
    procedure EditCpfEnter(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure SBtCadastraCandidatoClick(Sender: TObject);
    procedure Btn_BiometriaFotoTesteClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure BtnDVRClick(Sender: TObject);
    procedure cbxMotorBiometricoChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image3DblClick(Sender: TObject);
  private
    NovaBiometria: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Reinicia: Boolean;
  Frm_IdentificaCandidato: TFrm_IdentificaCandidato;

implementation

uses FrmAvisoOperacoes, clsDVRFerramentas, clseProvaConst;

{$R *.dfm}

procedure TFrm_IdentificaCandidato.EditCpfEnter(Sender: TObject);
begin
  EdRENACH.SetFocus;
end;

procedure TFrm_IdentificaCandidato.EdRENACHChange(Sender: TObject);
begin
  EditCpf.Text := '';
  EditNome.Text := '';
  EditCurso.Text := '';
  EditCidade.Text := '';
  EditNascimento.Text := '';
  EditSexo.Text := '';

  SBtSimulado.Enabled := false;
  SBtProva.Enabled := false;
  SBtRegistro.Enabled := false;
end;

procedure TFrm_IdentificaCandidato.EdRENACHKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    if SBtSimulado.Enabled = false then
      SBtConsultaCandidatoClick(Self);
end;

procedure TFrm_IdentificaCandidato.EdRENACHRightButtonClick(Sender: TObject);
begin
  (Sender as TButtonedEdit).Clear;
end;

procedure TFrm_IdentificaCandidato.SBtCadastraCandidatoClick(Sender: TObject);
begin
  ParCandidato.TipoProva := 'S';
  ParCandidato.ResgistrarPresenca := false;
  TelaIdentificaCandidato := false;
  TelaCadastraCandidato := True;
  TelaBiometria := false;
  TelaFoto := false;
  TelaConfirmacao := false;
  TelaBiometriaFoto := false;
  Reinicia := True;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_IdentificaCandidato.SBtConsultaCandidatoClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper300Env: T100300Envio;
  Oper300Ret: T100300Retorno;
begin

  ParCFC.AvisoSEITran := False;

  TelaExameBiometriaFoto := false;
  TelaBiometria := false;
  TelaBiometriaFoto := false;
  TelaFoto := false;
  TelaResultado := false;
  TelaQuestionario := false;
  TelaResultadoBiometriaFoto := false;
  TelaExameBiometriaFoto := false;

  // Validar as informações digitadas
  if Trim(EdRENACH.Text) = '' then
    Exit;

  if UpperCase(Label1.Caption) = 'RENACH' then
  begin
    if Length(Trim(EdRENACH.Text)) <> 9 then
    Begin
      DialogoMensagem('Número de RENACH inválido!', mtInformation);
      Exit;
    End;
  end
  else
  begin
    if Length(Trim(EdRENACH.Text)) <> 11 then
    begin
      DialogoMensagem('Número de CPF inválido!', mtInformation);
      Exit;
    end;
  end;

  // Efetuar a operação 100200
  Oper300Env := T100300Envio.Create;
  Oper300Ret := T100300Retorno.Create;
  Consulta := MainOperacao.Create(Self, '100300');
  Oper300Ret.MontaXMLRetorno
    (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
    Oper300Env.MontaXMLEnvio(EdRENACH.Text),
    'Verifique sua conexão e tente novamente.'));

  if Oper300Ret.IsValid then
  begin

    TThread.Synchronize(nil,
      procedure
      var
        Consulta: MainOperacao;
        Oper100110Env: T100110Envio;
        Oper100110Ret: T100110Retorno;

        Oper200400Env: T200400Envio;
        Oper200400Ret: T200400Retorno;

        ListaProvasPendente: TListaProvasPendente;
        I: Integer;

        IdDecoderMIME: TIdDecoderMIME;
        xmlhash: TXMLDocument;
      begin

        // Sincronizar
        Oper100110Env := T100110Envio.Create;
        Oper100110Ret := T100110Retorno.Create;
        Consulta := MainOperacao.Create(Self, '100110');

        Oper100110Ret.MontaRetorno(Consulta.consultar
          (IntToStr(ParServidor.ID_Sistema), Oper100110Env.MontaXMLEnvio('M')));

        if Oper100110Ret.IsValid then
        begin

          ListaProvasPendente := TListaProvasPendente.Create;
          ListaProvasPendente.ListarArquivos(UserProgranData +
            strFileEnviar, True);

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
                xmlhash.Active := false;
                xmlhash.LoadFromFile(ListaProvasPendente[0]);
                xmlhash.Active := True;

                IdDecoderMIME := TIdDecoderMIME.Create(Self);
                WebBrowser1.Navigate(IdDecoderMIME.DecodeString
                  (xmlhash.ChildNodes.Get(0).ChildNodes.Get(0)
                  .ChildNodes.findnode('hash').Text));
                xmlhash.Active := false;

                FreeAndNil(xmlhash);

                DeleteFile(ListaProvasPendente[0]);
                ListaProvasPendente.Delete(0);

              end;
            end;
          end;
        end;
      end);

    if Label2.Caption = 'CPF' then
      EditCpf.Text := FormatMaskText('000\.000\.000\-00;0;_',
        ParCandidato.CPFCandidato)
    else
      EditCpf.Text := ParCandidato.RENACHCandidato;

    if Debug then
    begin
      ArquivoLog.GravaArquivoLog(' Nome: ' + ParCandidato.NomeCandidato);
      ArquivoLog.GravaArquivoLog(' Curso: ' + ParCandidato.CursoCandidato);
      ArquivoLog.GravaArquivoLog(' Cidade: ' +
        ParCandidato.Municipio_Candidato);
      ArquivoLog.GravaArquivoLog(' Nascimento: ' + ParCandidato.Nascimento);
      ArquivoLog.GravaArquivoLog(' Sexo: ' + ParCandidato.Sexo);
    end;

    EditNome.Text := ParCandidato.NomeCandidato;
    EditCurso.Text := ParCandidato.CursoCandidato;
    EditCidade.Text := ParCandidato.Municipio_Candidato;
    EditNascimento.Text := ParCandidato.Nascimento;
   // EditSexo.Text := ParCandidato.Sexo;

    SBtSimulado.Enabled := True;
    SBtProva.Enabled := True;
    SBtRegistro.Enabled := True;

    SBtProva.Enabled := (ParCandidato.prova = 'S');
    SBtSimulado.Enabled := (ParCandidato.Simulado = 'S');

    if SBtProva.Enabled then
    begin

      if (ParCFC.Biometria_prova = 'S') or (ParCFC.Biometria_Foto_prova = 'S')
      then
        SBtRegistro.Enabled := True
      else
        SBtRegistro.Enabled := false;

    end
    else
    begin

      if (ParCFC.Biometria_Simulado = 'S') or
        (ParCFC.Biometria_Foto_Simulado = 'S') then
        SBtRegistro.Enabled := True
      else
        SBtRegistro.Enabled := false;

    end;

    if (Parametros.TipoBiometria = 'C#') or (Parametros.TipoBiometria = 'XE')
    then
    begin
      Btn_BiometriaFotoTeste.Visible := (ParCandidato.Excecao = 'N');
      Btn_BiometriaFotoTeste.Enabled := (ParCandidato.Excecao = 'N');
    end
    else
    begin
      Btn_BiometriaFotoTeste.Visible := false;
      Btn_BiometriaFotoTeste.Enabled := false;
    end;

    Self.Repaint;

    TelaIdentificaCandidato := false;
    TelaFoto := false;
  end
  else
  begin
    DialogoMensagem(Oper300Ret.mensagem, mtInformation);
    Self.Repaint;
  end;

end;

procedure TFrm_IdentificaCandidato.SBtProvaClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper100700Env: T100700Envio;
  Oper100700Ret: T100700Retorno;

  Digital: TDigitalRest;
  Foto: TFotoRest;
  Ret: TRetornoRest;

  MonitoramentoClntSckt: TMonitoramentoClntSckt;
  StatusMonitoramento: string;
  Tetativas: Integer;

  Conexao: TConexao;
begin
  ParCandidato.RegistroPresenca := 'N';

  try
    if Conexao.Telnet(ParMonitoramentoRTSP.Endereco_Servidor,
      ParMonitoramentoRTSP.Porta_Servidor) then
      ArquivoLog.GravaArquivoLog('identificação - Monitoramento Porta ' +
        ParMonitoramentoRTSP.Porta_Servidor.ToString + ': on ')
    else
      ArquivoLog.GravaArquivoLog('identificação - Monitoramento Porta ' +
        ParMonitoramentoRTSP.Porta_Servidor.ToString + ': off ');
  except
    on E: Exception do
  end;

  try
    if Conexao.Telnet(ParMonitoramentoRTSP.Endereco_Servidor, 6563) then
      ArquivoLog.GravaArquivoLog
        ('identificação - Monitoramento Porta 6563: on ')
    else
      ArquivoLog.GravaArquivoLog
        ('identificação - Monitoramento Porta 6563: off ');
  except
    on E: Exception do
  end;

  Tetativas := 0;

  repeat
    if ParListaMonitoramentoRTSP.Count > 0 then
      ParMonitoramentoRTSP := TMonitoramentoRTSP
        (ParListaMonitoramentoRTSP.Objects[Tetativas]);

    StatusMonitoramento := '';
    MonitoramentoClntSckt := TMonitoramentoClntSckt.Create(Self);
    StatusMonitoramento := MonitoramentoClntSckt.SendSocketComand
      (ParMonitoramentoRTSP.Verificar_Servidor);
    MonitoramentoClntSckt.Free;

    if ParMonitoramentoFluxoRTSP = nil then
      ParMonitoramentoFluxoRTSP := TMonitoramentoFluxoRTSP.Create;

    ParMonitoramentoFluxoRTSP.Fluxo := 0;
    ParMonitoramentoFluxoRTSP.DescricaoFluxo := '';
    ParMonitoramentoFluxoRTSP.Status := StatusMonitoramento;

    if StatusMonitoramento = '' then
      Inc(Tetativas)
    else
      Tetativas := 10000;

  until (Tetativas >= ParListaMonitoramentoRTSP.Count);

  if (StatusMonitoramento = 'F') or (StatusMonitoramento = '') then
  begin
    DialogoMensagem('Atenção!' + #13 +
      'O candidato não pode fazer a prova. O monitoramento está inativo, entre em contato com o suporte!',
      mtInformation);
    Exit;
  end;

  TelaExameBiometriaFoto := false;
  SBtProva.Enabled := false;

  Reinicia := True;
  if (ParCandidato.prova = 'N') then
  begin
    DialogoMensagem('Atenção!' + #13 +
      'O candidato não pode fazer a prova. Verifique a matricula.',
      mtInformation);
    Exit;
  end;

  ParCandidato.TipoProva := 'P';
  ParCandidato.ResgistrarPresenca := false;
  TelaIdentificaCandidato := false;
  TelaBiometria := false;

  // Verifica se é permitido ler Processos e Serviços
  if ((ParCandidato.TipoProva = 'P') and
    (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) or
    ((ParCandidato.TipoProva = 'S') and
    (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
  begin
    // Consulta Lista
    Consulta := MainOperacao.Create(Self, '100700');
    Oper100700Env := T100700Envio.Create;
    Oper100700Ret := T100700Retorno.Create;
    Oper100700Ret.MontarRetorno
      (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
      Oper100700Env.MontaXMLEnvio));

    if Oper100700Ret.IsValid then
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

    end
    else
    begin
      EnviarAviso(mtInformation,
        'Não foi possível executar a validação desse computador.' + #13 +
        ' Reinicie o programa e tente novamente.');
      SBtProva.Enabled := True;
    end;
  end;

  ArquivoLog.GravaArquivoLog('Nome ' + ParCandidato.NomeCandidato + ' - ' +
    'Exceção ' + ParCandidato.Excecao + ' - ' + 'Biometria/Foto Prova ' +
    ParCFC.Biometria_Foto_prova + ' - ' + 'Biometria Prova ' +
    ParCFC.Biometria_prova);

  if ParCandidato.RegistroPresenca = 'S' then
  begin
    TelaFoto := false;

    if ParCFC.Tela_Teclado = 'S' then
    begin
      TelaConfirmacao := false;
      TelaTeclado := True;
    end
    else
    begin
      TelaConfirmacao := True;
      TelaTeclado := false;
    end;

  end
  else
  begin
    TelaConfirmacao := false;

    Digital := TDigitalRest.Create;
    Foto := TFotoRest.Create;
    Ret := TRetornoRest.Create;

    try

      if ParCandidato.Excecao = 'S' then
      begin
        if NovaBiometria then
        begin
          Ret.MontaRetorno(Foto.conect());
          if Ret.IsValid then
          begin
            ParCandidato.Foto := Ret.Foto;
            if ParCFC.Tela_Teclado = 'S' then
            begin
              TelaConfirmacao := false;
              TelaTeclado := True;
            end
            else
            begin
              TelaConfirmacao := True;
              TelaTeclado := false;
            end;

          end
          else
          begin
            EnviarAviso(mtInformation, Ret.mensagem);
          end;
        end
        else
          TelaFoto := True;
      end
      else if (ParCFC.Biometria_Foto_prova = 'S') then
      begin

        if NovaBiometria then
        begin
          Ret.MontaRetorno(Digital.conect());
          if Ret.IsValid then
          begin
            Ret.MontaRetorno(Foto.conect());
            if Ret.IsValid then
            begin
              ParCandidato.Foto := Ret.Foto;
              if ParCFC.Tela_Teclado = 'S' then
              begin
                TelaConfirmacao := false;
                TelaTeclado := True;
              end
              else
              begin
                TelaConfirmacao := True;
                TelaTeclado := false;
              end;

            end
            else
            begin
              EnviarAviso(mtInformation, Ret.mensagem);
            end;

          end
          else
          begin

            if ParFotoExame.Prova_Ativo then
              EnviarAviso(mtInformation, Ret.mensagem)
            else
            begin

              EnviarAviso(mtInformation, Ret.mensagem);
              if Ret.codigo = 'B995' then
              begin
                ParCandidato.Excecao := 'S';
                SBtProvaClick(Self);
              end;

            end;

          end;
        end
        else
          TelaBiometriaFoto := True;

      end
      else if (ParCFC.Biometria_prova = 'S') then
      begin

        if NovaBiometria then
        begin
          Ret.MontaRetorno(Digital.conect());
          if Ret.IsValid then
          begin
            EnviarAviso(mtInformation, Ret.mensagem);
            if ParCFC.Tela_Teclado = 'S' then
            begin
              TelaConfirmacao := false;
              TelaTeclado := True;
            end
            else
            begin
              TelaConfirmacao := True;
              TelaTeclado := false;
            end;

          end
          else
          begin

            if ParFotoExame.Prova_Ativo then
              EnviarAviso(mtInformation, Ret.mensagem)
            else
            begin

              EnviarAviso(mtInformation, Ret.mensagem);
              if Ret.codigo = 'B995' then
              begin
                ParCandidato.Excecao := 'S';
                SBtProvaClick(Self);
              end;

            end;

          end;

        end
        else
          TelaBiometria := True;
      end
      else
      begin

        if NovaBiometria then
        begin
          Ret.MontaRetorno(Foto.conect());
          if Ret.IsValid then
          begin
            ParCandidato.Foto := Ret.Foto;
            if ParCFC.Tela_Teclado = 'S' then
            begin
              TelaConfirmacao := false;
              TelaTeclado := True;
            end
            else
            begin
              TelaConfirmacao := True;
              TelaTeclado := false;
            end;

          end
          else
          begin
            EnviarAviso(mtInformation, Ret.mensagem);
          end;
        end
        else
          TelaFoto := True;
      end;

    except
      on E: Exception do
      begin
        ArquivoLog.GravaArquivoLog('Identificação Biometria/Foto Prova - ' +
          E.Message);
        EnviarAviso(mtInformation,
          'Biometria/Foto não está funcionando corretamente!');
      end;
    end;
  end;

  if TelaTeclado or TelaConfirmacao or TelaFoto or TelaBiometria or TelaBiometriaFoto
  then
  begin
    Frm_Menu.AbreTela;
    Close;
  end
  else
    SBtProva.Enabled := True;

end;

procedure TFrm_IdentificaCandidato.SBtSimuladoClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper100700Env: T100700Envio;
  Oper100700Ret: T100700Retorno;
  Digital: TDigitalRest;
  Foto: TFotoRest;
  Ret: TRetornoRest;
  MonitoramentoClntSckt: TMonitoramentoClntSckt;
  StatusMonitoramento: string;
  Tetativas: Integer;
  Conexao: TConexao;
begin

  ParCandidato.TipoProva := 'S';
  ParCandidato.ResgistrarPresenca := false;
  TelaIdentificaCandidato := false;
  TelaBiometriaFoto := false;
  TelaBiometria := false;
  TelaFoto := false;

  TelaExameBiometriaFoto := false;

  SBtSimulado.Enabled := false;
  Reinicia := True;

  try
    if Conexao.Telnet(ParMonitoramentoRTSP.Endereco_Servidor,
      ParMonitoramentoRTSP.Porta_Servidor) then
      ArquivoLog.GravaArquivoLog('IniciaStream - Monitoramento Porta ' +
        ParMonitoramentoRTSP.Porta_Servidor.ToString + ': on ')
    else
      ArquivoLog.GravaArquivoLog('IniciaStream - Monitoramento Porta ' +
        ParMonitoramentoRTSP.Porta_Servidor.ToString + ': off ');
  except
    on E: Exception do
  end;

  try
    if Conexao.Telnet(ParMonitoramentoRTSP.Endereco_Servidor, 6563) then
      ArquivoLog.GravaArquivoLog('IniciaStream - Monitoramento Porta 6563: on ')
    else
      ArquivoLog.GravaArquivoLog
        ('IniciaStream - Monitoramento Porta 6563: off ');
  except
    on E: Exception do
  end;

  if ParDetecta <> nil then
  begin
    // Verifica se é permitido ler Processos e Serviços
    if ((ParCandidato.TipoProva = 'P') and
      (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) or
      ((ParCandidato.TipoProva = 'S') and
      (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
    begin
      // Consulta Lista
      Consulta := MainOperacao.Create(Self, '100700');
      Oper100700Env := T100700Envio.Create;
      Oper100700Ret := T100700Retorno.Create;
      Oper100700Ret.MontarRetorno
        (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
        Oper100700Env.MontaXMLEnvio));

      if Oper100700Ret.IsValid then
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

      end
      else
      begin
        EnviarAviso(mtInformation,
          'Não foi possível executar a validação desse computador.' + #13 +
          ' Reinicie o programa e tente novamente.');
        ExitProcess(0);
      end;

    end;
  end;

  if ParCFC.Monitoramento_Simulado = 'S' then
  begin

    Tetativas := 0;
    repeat

      if ParListaMonitoramentoRTSP.Count > 0 then
        ParMonitoramentoRTSP := TMonitoramentoRTSP
          (ParListaMonitoramentoRTSP.Objects[Tetativas]);

      StatusMonitoramento := '';
      MonitoramentoClntSckt := TMonitoramentoClntSckt.Create(Self);
      StatusMonitoramento := MonitoramentoClntSckt.SendSocketComand
        (ParMonitoramentoRTSP.Verificar_Servidor);
      MonitoramentoClntSckt.Free;

      if StatusMonitoramento = '' then
        Inc(Tetativas)
      else
        Tetativas := 10000;

    until (Tetativas >= ParListaMonitoramentoRTSP.Count);

    if (StatusMonitoramento = 'F') or (StatusMonitoramento = '') then
    begin
      DialogoMensagem('Atenção!' + #13 +
        'O candidato não pode fazer a prova. O monitoramento está inativo, entre em contato com o suporte!',
        mtInformation);
      Exit;
    end;

  end;

  if (ParCandidato.Simulado = 'N') then
  begin
    DialogoMensagem('Atenção!' + #13 +
      'O candidato não pode fazer o simulado. Verifique a matricula.',
      mtInformation);
    Exit;
  end;

  if ParCandidato.RegistroPresenca = 'S' then
  begin
    TelaFoto := false;
    TelaConfirmacao := True;
  end
  else
  begin
    TelaConfirmacao := false;

    Digital := TDigitalRest.Create;
    Foto := TFotoRest.Create;
    Ret := TRetornoRest.Create;

    try

      if (ParCFC.Biometria_Foto_Simulado = 'S') then
      begin

        if ParCandidato.Excecao = 'S' then
        begin

          if NovaBiometria then
          begin
            Ret.MontaRetorno(Foto.conect());
            if Ret.IsValid then
            begin
              ParCandidato.Foto := Ret.Foto;
              if ParCFC.Tela_Teclado = 'S' then
              begin
                TelaConfirmacao := false;
                TelaTeclado := True;
              end
              else
              begin
                TelaConfirmacao := True;
                TelaTeclado := false;
              end;

            end
            else
            begin
              EnviarAviso(mtInformation, Ret.mensagem);
            end;
          end
          else
            TelaFoto := True;
        end
        else
        begin
          if NovaBiometria then
          begin
            Ret.MontaRetorno(Digital.conect());
            if Ret.IsValid then
            begin
              Ret.MontaRetorno(Foto.conect());
              if Ret.IsValid then
              begin
                ParCandidato.Foto := Ret.Foto;
                if ParCFC.Tela_Teclado = 'S' then
                begin
                  TelaConfirmacao := false;
                  TelaTeclado := True;
                end
                else
                begin
                  TelaConfirmacao := True;
                  TelaTeclado := false;
                end;

              end
              else
              begin
                EnviarAviso(mtInformation, Ret.mensagem);
              end;

            end
            else
            begin
              if ParFotoExame.Simulado_Ativo then
                EnviarAviso(mtInformation, Ret.mensagem)
              else
              begin

                EnviarAviso(mtInformation, Ret.mensagem);
                if Ret.codigo = 'B995' then
                begin
                  ParCandidato.Excecao := 'S';
                  SBtProvaClick(Self);
                end;

              end;

            end;
          end
          else
            TelaBiometriaFoto := True;
        end;

      end
      else if (ParCFC.Biometria_Simulado = 'S') then
      begin

        if ParCandidato.Excecao = 'S' then
        begin

          if NovaBiometria then
          begin
            Ret.MontaRetorno(Foto.conect());
            if Ret.IsValid then
            begin
              ParCandidato.Foto := Ret.Foto;
              if ParCFC.Tela_Teclado = 'S' then
              begin
                TelaConfirmacao := false;
                TelaTeclado := True;
              end
              else
              begin
                TelaConfirmacao := True;
                TelaTeclado := false;
              end;

            end
            else
            begin
              EnviarAviso(mtInformation, Ret.mensagem);
            end;
          end
          else
            TelaFoto := True;
        end
        else
        begin
          if NovaBiometria then
          begin
            Ret.MontaRetorno(Digital.conect());
            if Ret.IsValid then
            begin
              EnviarAviso(mtInformation, Ret.mensagem);
              if ParCFC.Tela_Teclado = 'S' then
              begin
                TelaConfirmacao := false;
                TelaTeclado := True;
              end
              else
              begin
                TelaConfirmacao := True;
                TelaTeclado := false;
              end;
            end
            else
            begin
              if ParFotoExame.Simulado_Ativo then
                EnviarAviso(mtInformation, Ret.mensagem)
              else
              begin

                EnviarAviso(mtInformation, Ret.mensagem);
                if Ret.codigo = 'B995' then
                begin
                  ParCandidato.Excecao := 'S';
                  SBtProvaClick(Self);
                end;

              end;

            end;

          end
          else
            TelaBiometria := True;
        end;
      end
      else if ParCFC.Tela_Teclado = 'S' then
      begin
        TelaConfirmacao := false;
        TelaTeclado := True;
      end
      else
      begin
        TelaConfirmacao := True;
        TelaTeclado := false;
      end;

    except
      on E: Exception do
      begin
        ArquivoLog.GravaArquivoLog('Identificação Biometria/Foto Simulado - ' +
          E.Message);
        EnviarAviso(mtInformation,
          'Biometria/Foto não está funcionando corretamente!');
      end;
    end;

  end;

  if TelaTeclado or TelaConfirmacao or TelaFoto or TelaBiometria or TelaBiometriaFoto
  then
  begin
    Frm_Menu.AbreTela;
    Close;
  end
  else
    SBtSimulado.Enabled := True;

end;

procedure TFrm_IdentificaCandidato.Btn_BiometriaFotoTesteClick(Sender: TObject);
begin

  Btn_BiometriaFotoTeste.Enabled := false;

  ParCandidato.TipoProva := 'P';

  try

    if ParCandidato.Excecao = 'S' then
      ParFotoExame.Foto
    else if (ParCFC.Biometria_Foto_prova = 'S') then
      ParFotoExame.BiometriaFoto
    else if (ParCFC.Biometria_prova = 'S') then
      ParFotoExame.BiometriaFoto
    else
      ParFotoExame.Foto;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Identificação Biometria/Foto Teste - ' +
        E.Message);
      EnviarAviso(mtInformation,
        'Biometria/Foto não está funcionando corretamente!');
    end;
  end;

  ParCandidato.TipoProva := '';
  TelaExameBiometriaFoto := false;
  Btn_BiometriaFotoTeste.Enabled := True;

end;

procedure TFrm_IdentificaCandidato.cbxMotorBiometricoChange(Sender: TObject);
begin

  Parametros.TipoBiometria := cbxMotorBiometrico.Text;

  if (Parametros.TipoBiometria = 'C#') or (Parametros.TipoBiometria = 'XE') then
    NovaBiometria := True
  else
    NovaBiometria := false;

end;

procedure TFrm_IdentificaCandidato.BtnDVRClick(Sender: TObject);
begin

  BtnDVR.Enabled := false;
  LblDVRStatus.Visible := True;
  LblDVRStatus.Caption := 'DVR: Aguarde...';
  LblDVRStatus.Caption := 'DVR ' + DVRFerramentas.DVRStatus;
  BtnDVR.Enabled := True;

end;

procedure TFrm_IdentificaCandidato.SpeedButton2Click(Sender: TObject);
begin
  ArquivoLog.GravaArquivoLog('# Cancelamento tela Identificação');
  TelaIdentificaCandidato := false;
  TelaFoto := false;
  TelaBiometria := false;
  Reinicia := false;
  TelaInformacoes := false;
  TelaTeclado := false;
  TelaQuestionario := false;
  TelaResultado := false;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_IdentificaCandidato.SBtRegistroClick(Sender: TObject);
var
  Digital: TDigitalRest;
  Foto: TFotoRest;
  Ret: TRetornoRest;

  Consulta: MainOperacao;
  Oper300100Env: T300100Envio;
  Oper300100Ret: T300100Retorno;

begin

  if (ParCandidato.prova = 'N') and (ParCandidato.Simulado = 'N') then
  begin
    DialogoMensagem('Atenção!' + #13 +
      'O candidato não pode registrar presença. Verifique a matricula.',
      mtInformation);
    Exit;
  end;

  if (ParCFC.prova = 'S') then
    ParCandidato.TipoProva := 'P'
  else
  begin
    if (ParCFC.Simulado = 'S') then
      ParCandidato.TipoProva := 'S';
  end;

  ParCandidato.RegistroPresenca := 'N';
  ParCandidato.ResgistrarPresenca := True;
  TelaIdentificaCandidato := false;

  Reinicia := True;

  Digital := TDigitalRest.Create;
  Foto := TFotoRest.Create;
  Ret := TRetornoRest.Create;

  try

    if (ParCFC.Biometria_Foto_prova = 'S') then
    begin

      if ParCandidato.Excecao = 'S' then
      begin

        if NovaBiometria then
        begin

          Ret.MontaRetorno(Foto.conect());
          if Ret.IsValid then
          begin
            ParCandidato.Foto := Ret.Foto;

            // Efetuar a operação 300100
            Oper300100Env := T300100Envio.Create;
            Oper300100Ret := T300100Retorno.Create;
            Consulta := MainOperacao.Create(Self, '100700');
            Oper300100Ret.MontaRetorno
              (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
              Oper300100Env.MontaXMLEnvio(ParCandidato.IdCandidato,
              ParCandidato.Foto)));

            if Oper300100Ret.IsValid then
            begin
              DialogoMensagem('A presença foi registrada com sucesso!',
                mtInformation);
              EdRENACH.Clear;
              SBtConsultaCandidatoClick(Self);
            end
            else
              DialogoMensagem(Oper300100Ret.mensagem, mtInformation);

          end
          else
          begin
            EnviarAviso(mtInformation, Ret.mensagem);
          end;

        end
        else
          TelaFoto := True;

      end
      else
      begin

        if NovaBiometria then
        begin

          Ret.MontaRetorno(Digital.conect());
          if Ret.IsValid then
          begin

            Ret.MontaRetorno(Foto.conect());
            if Ret.IsValid then
            begin
              ParCandidato.Foto := Ret.Foto;

              // Efetuar a operação 300100
              Oper300100Env := T300100Envio.Create;
              Oper300100Ret := T300100Retorno.Create;
              Consulta := MainOperacao.Create(Self, '300100');
              Oper300100Ret.MontaRetorno
                (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
                Oper300100Env.MontaXMLEnvio(ParCandidato.IdCandidato,
                ParCandidato.Foto)));

              if Oper300100Ret.IsValid then
              begin
                DialogoMensagem('A presença foi registrada com sucesso!',
                  mtInformation);
                EdRENACH.Clear;
                SBtConsultaCandidatoClick(Self);
              end
              else
                DialogoMensagem(Oper300100Ret.mensagem, mtInformation);

            end
            else
            begin
              EnviarAviso(mtInformation, Ret.mensagem);
            end;

          end
          else
          begin
            if ParFotoExame.Prova_Ativo then
              EnviarAviso(mtInformation, Ret.mensagem)
            else
            begin

              EnviarAviso(mtInformation, Ret.mensagem);
              if Ret.codigo = 'B995' then
              begin
                ParCandidato.Excecao := 'S';
                SBtRegistroClick(Self);
              end;

            end;

          end;

        end
        else
          TelaBiometriaFoto := True;

      end;

    end
    else if (ParCFC.Biometria_Simulado = 'S') then
    begin

      if ParCandidato.Excecao = 'S' then
      begin

        if NovaBiometria then
        begin

          Ret.MontaRetorno(Foto.conect());
          if Ret.IsValid then
          begin
            ParCandidato.Foto := Ret.Foto;

            // Efetuar a operação 300100
            Oper300100Env := T300100Envio.Create;
            Oper300100Ret := T300100Retorno.Create;
            Consulta := MainOperacao.Create(Self, '300100');
            Oper300100Ret.MontaRetorno
              (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
              Oper300100Env.MontaXMLEnvio(ParCandidato.IdCandidato,
              ParCandidato.Foto)));

            if Oper300100Ret.IsValid then
            begin
              DialogoMensagem('A presença foi registrada com sucesso!',
                mtInformation);
              EdRENACH.Clear;
              SBtConsultaCandidatoClick(Self);
            end
            else
              DialogoMensagem(Oper300100Ret.mensagem, mtInformation);

          end
          else
          begin
            EnviarAviso(mtInformation, Ret.mensagem);
          end;

        end
        else
          TelaFoto := True;

      end
      else
      begin

        if NovaBiometria then
        begin

          Ret.MontaRetorno(Digital.conect());
          if Ret.IsValid then
          begin
            EnviarAviso(mtInformation, Ret.mensagem);

            // Efetuar a operação 300100
            Oper300100Env := T300100Envio.Create;
            Oper300100Ret := T300100Retorno.Create;
            Consulta := MainOperacao.Create(Self, '300100');
            Oper300100Ret.MontaRetorno
              (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
              Oper300100Env.MontaXMLEnvio(ParCandidato.IdCandidato,
              ParCandidato.Foto)));

            if Oper300100Ret.IsValid then
            begin
              DialogoMensagem('A presença foi registrada com sucesso!',
                mtInformation);
              EdRENACH.Clear;
              SBtConsultaCandidatoClick(Self);
            end
            else
              DialogoMensagem(Oper300100Ret.mensagem, mtInformation);

          end
          else
          begin
            if ParFotoExame.Simulado_Ativo then
              EnviarAviso(mtInformation, Ret.mensagem)
            else
            begin

              EnviarAviso(mtInformation, Ret.mensagem);
              if Ret.codigo = 'B995' then
              begin
                ParCandidato.Excecao := 'S';
                SBtRegistroClick(Self);
              end;

            end;

          end;

        end
        else
          TelaBiometriaFoto := True;

      end;

    end;

    if TelaConfirmacao or TelaFoto or TelaBiometria or TelaBiometriaFoto then
    begin
      Frm_Menu.AbreTela;
      Close;
    end

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog
        ('Identificação Biometria/Foto Registro de Presença - ' + E.Message);
      EnviarAviso(mtInformation,
        'Biometria/Foto não está funcionando corretamente!');
    end;
  end;

end;

procedure TFrm_IdentificaCandidato.FormClose(Sender: TObject;
var Action: TCloseAction);
begin

  TelaExameBiometriaFoto := false;

  if not Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;

end;

procedure TFrm_IdentificaCandidato.FormCreate(Sender: TObject);
begin

  if (Parametros.TipoBiometria = 'C#') or (Parametros.TipoBiometria = 'XE') then
    NovaBiometria := True
  else
    NovaBiometria := false;

  LblInformacoes.Caption := 'Computador ' + Parametros.Computador;
  Label8.Caption := GetVersaoArq;

  Reinicia := false;
  ArquivoLog.GravaArquivoLog('# ' + Self.Caption);

  EditCpf.Text := '';
  EditNome.Text := '';
  EditCurso.Text := '';
  EditCidade.Text := '';
  EditNascimento.Text := '';
  EditSexo.Text := '';

  SBtProva.Visible := ParCFC.prova = 'S';
  SBtProva.Enabled := false;

  SBtSimulado.Visible := ParCFC.Simulado = 'S';
  SBtSimulado.Enabled := false;

  SBtRegistro.Visible := (ParCFC.Biometria_prova = 'S') or
    (ParCFC.Biometria_Simulado = 'S') or (ParCFC.Biometria_Foto_prova = 'S') or
    (ParCFC.Biometria_Foto_Simulado = 'S');

  if ParFotoExame <> nil then
    SBtRegistro.Visible := (ParFotoExame.Prova_Ativo = false)
  else
    SBtRegistro.Visible := True;

  SBtRegistro.Enabled := false;

  SBtCadastraCandidato.Visible := (ParCFC.Tela_Cadastro_Simulado = 'S');

end;

procedure TFrm_IdentificaCandidato.FormKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin

  if (Key = vkG) and (GetKeyState(VK_SHIFT) <> 0) then
  begin
    if LblMotorBiometrico.Visible then
    begin
      LblMotorBiometrico.Visible := false;
      cbxMotorBiometrico.Visible := false;
    end
    else
    begin
      LblMotorBiometrico.Visible := True;
      cbxMotorBiometrico.Visible := True;
    end;
  end;

end;

procedure TFrm_IdentificaCandidato.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #27 then
    Application.Terminate;

end;

procedure TFrm_IdentificaCandidato.FormShow(Sender: TObject);
begin

  if UpperCase(Label1.Caption) = 'RENACH' then
    EdRENACH.MaxLength := 9
  else
    EdRENACH.MaxLength := 11;

  EdRENACH.Hint := 'Informe o ' + Label1.Caption + ' do aluno.';

  Self.Caption := Self.Caption + ' - ' + ParCFC.nome_fantasia + ' - ID ' +
    Parametros.Identificacao;

  KillTask('ffmpeg.exe');

// BtnDVR.Visible := (DVRFerramentas <> nil);

end;

procedure TFrm_IdentificaCandidato.Image1DblClick(Sender: TObject);
var
  ListaProvasPendente: TListaProvasPendente;
  I: Integer;

  IdDecoderMIME: TIdDecoderMIME;
  xmlhash: TXMLDocument;
  Consulta: MainOperacao;
  Oper100110Env: T100110Envio;
  Oper100110Ret: T100110Retorno;

  Oper200400Env: T200400Envio;
  Oper200400Ret: T200400Retorno;
begin

  // Sincronizar
  Oper100110Env := T100110Envio.Create;
  Oper100110Ret := T100110Retorno.Create;
  Consulta := MainOperacao.Create(Self, '100110');
  Oper100110Ret.MontaRetorno
    (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
    Oper100110Env.MontaXMLEnvio('M')));

  if Oper100110Ret.IsValid then
  begin

    ListaProvasPendente := TListaProvasPendente.Create;
    ListaProvasPendente.ListarArquivos(UserProgranData + strFileEnviar, True);

    for I := 0 to ListaProvasPendente.Count - 1 do
    begin

      if copy(ListaProvasPendente[0], 0, 6) = '200400' then
      begin

        Oper200400Env := T200400Envio.Create;
        Oper200400Ret := T200400Retorno.Create;
        Consulta := MainOperacao.Create(Self, '200400');
        Oper200400Ret.MontaRetorno('E',
          Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
          Oper200400Env.MontaXMLEnvioSinc(ListaProvasPendente[0])));

        if Oper100110Ret.IsValid then
        begin

          xmlhash := TXMLDocument.Create(Self);
          xmlhash.Active := false;
          xmlhash.LoadFromFile(ListaProvasPendente[0]);
          xmlhash.Active := True;

          IdDecoderMIME := TIdDecoderMIME.Create(Self);
          WebBrowser1.Navigate
            (IdDecoderMIME.DecodeString(xmlhash.ChildNodes.Get(0)
            .ChildNodes.Get(0).ChildNodes.findnode('hash').Text));
          xmlhash.Active := false;

          FreeAndNil(xmlhash);

          DeleteFile(ListaProvasPendente[0]);
          ListaProvasPendente.Delete(0);

        end;

      end;

    end;

  end;

  EnviarAviso(mtInformation, 'Sincronização efetuada com sucesso!');

end;

procedure TFrm_IdentificaCandidato.Image2DblClick(Sender: TObject);
begin
  if DialogoMensagem
    ('Deseja realmente excluir os parâmetros de inicialização do sistema ' +
    'nesse computador (' + Parametros.Computador + ') ?', mtConfirmation) = mrYes
  then
  begin

    Parametros.ApagaParametrosCRC;

    DialogoMensagem('Atenção!' + #13 +
      'Os parâmetros foram excluídos. O sistema precisa ser reiniciado agora.',
      mtInformation);
    Application.Terminate;

  end;
end;

procedure TFrm_IdentificaCandidato.Image3DblClick(Sender: TObject);
begin
  Debug := True;
end;

end.
