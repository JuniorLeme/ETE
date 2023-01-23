unit FrmConfirmacao;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, ClsParametros,
  Vcl.ButtonGroup,
  Vcl.Imaging.pngimage, MaskUtils, ClsCandidatoControl, ClsFuncoes,
  ClsQuestionario, ClsCFCControl,
  ClsMonitoramentoRTSPControl, ClsListaBloqueio, ClsOperacoesControl,
  clsDVRFerramentas,ClsConexaoFerramentas,
  ClsDetecta, Vcl.Imaging.jpeg, IdICMPClient, IdStack;

type
  TFrm_Confirmacao = class(TForm)
    Image1: TImage;
    SBtAplicar: TSpeedButton;
    SBtCancelar: TSpeedButton;
    LblTitulo: TLabel;
    Label_NomeCandidato: TLabel;
    Label_CPF: TLabel;
    Label_Curso: TLabel;
    LabelData: TLabel;
    LabelHora: TLabel;
    Label59: TLabel;
    Label58: TLabel;
    SBtInformacoes: TSpeedButton;
    Image2: TImage;
    GroupBox1: TGroupBox;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    LblGerandoQuestionario: TLabel;
    LblAtualizandoandamento: TLabel;
    LblEnviandoimagemcandidato: TLabel;
    LblIniciandomonitoramento: TLabel;
    LblVerificandomonitoramento: TLabel;
    Image8: TImage;
    Lbl_VerificaBloqueio: TLabel;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Label_aguarde: TLabel;
    SBtSair: TSpeedButton;
    Timer1: TTimer;
    Timer2: TTimer;
    LabelNascimento: TLabel;

    procedure SBtCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SBtAplicarClick(Sender: TObject);
    procedure SBtInformacoesClick(Sender: TObject);
    procedure SBtSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);

  private
    Reinicia: Boolean;
    blnSEitran: Boolean;
    function EnvioSEITran: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Confirmacao: TFrm_Confirmacao;

implementation

uses FrmPrincipal, FrmMensagemDetecta, ClsOperacoesRest,
  ClsEnvio.Inicio.SEITran,
  System.JSON, ClsRetorno.SEITran;

{$R *.dfm}

function TFrm_Confirmacao.EnvioSEITran: Boolean;
var
  objEnvioInicioSEITran: TEnvioInicioSEITran;
  objRetornoInicioSEITran: TRetronoSEITranInicio;
  objCon: TOperacaoRestful;
  TextoAviso: string;
begin
  // SEITran
  Result := False;

  if ParCFC.URLSEITrans <> '' then
  begin
    objCon := TOperacaoRestful.Create(Self);
    objRetornoInicioSEITran := TRetronoSEITranInicio.Create;
    objEnvioInicioSEITran := TEnvioInicioSEITran.Create;
    objEnvioInicioSEITran.CFC := ParCFC.id_cfc;
    objEnvioInicioSEITran.CPF := ParCandidato.CPFCandidato;

    try
      objRetornoInicioSEITran.AsJson :=
        objCon.ExecutarConsultar(
          ParCFC.URLSEITrans + 'iniciar/cpf',
          objEnvioInicioSEITran.AsJson, 'A Prova será finalizada!');

      ArquivoLog.GravaArquivoLog('Envio INICIO Seitran - ' + objEnvioInicioSEITran.AsJson);
      ArquivoLog.GravaArquivoLog('Envio INICIO Seitran CFC - ' + objEnvioInicioSEITran.CFC);
      ArquivoLog.GravaArquivoLog('Envio INICIO Seitran CPF - ' + objEnvioInicioSEITran.CPF);
      ArquivoLog.GravaArquivoLog('Path INICIO Seitran - ' + ParCFC.URLSEITrans + 'iniciar/cpf');
      ArquivoLog.GravaArquivoLog('Retorno INICIO Seitran - ' + objRetornoInicioSEITran.AsJson);
      ArquivoLog.GravaArquivoLog('Retorno INICIO Seitran cod - ' +  objRetornoInicioSEITran.Retorno.codigo);
      ArquivoLog.GravaArquivoLog('Retorno INICIO Seitran descr - ' +  objRetornoInicioSEITran.Retorno.descricao);

      //Andre - forçar retorno OK do SEITran
      //objRetornoInicioSEITran.Retorno.codigo := 'B0000';   //<<<============

      if Assigned(objRetornoInicioSEITran) then
      begin
        if Assigned(objRetornoInicioSEITran.Retorno) then
        begin
          if objRetornoInicioSEITran.Retorno.codigo <> 'B0000' then
          begin
            ArquivoLog.GravaArquivoLog
              ('Operação Inicio prova SEI Tran. - ' +
              Trim(objRetornoInicioSEITran.Retorno.codigo));

            if Trim(objRetornoInicioSEITran.Retorno.descricao) <> '' then
            begin
              Label_aguarde.Caption :=
              Trim(objRetornoInicioSEITran.Retorno.descricao);
              TextoAviso := objRetornoInicioSEITran.Retorno.descricao;
            end
            else
              TextoAviso :=
                'Falha na comunicação com o servidor SEI Tran.!' + #13
                + 'Verifique a internet e tente mais tarde';
          end
          else
            Result := True;

        end
        else
          TextoAviso :=
            'Falha na comunicação com o servidor SEI Tran.!' + #13 +
            'Verifique a internet e tente mais tarde';
      end
      else
        TextoAviso := 'Falha na comunicação com o servidor SEI Tran.!'
        + #13 + 'Verifique a internet e tente mais tarde';

    finally
      FreeAndNil(objCon);
      FreeAndNil(objRetornoInicioSEITran);
      FreeAndNil(objEnvioInicioSEITran);
    end;

    if Not TextoAviso.IsEmpty then
      EnviarAviso(mtInformation, TextoAviso);

  end
  else
    Result := True;

end;

procedure TFrm_Confirmacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if not Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;
end;

procedure TFrm_Confirmacao.FormCreate(Sender: TObject);
begin

  Timer1.Enabled := False;

  Reinicia := False;


  Label_NomeCandidato.Caption := ParCandidato.NomeCandidato;
  Label_CPF.Caption := FormatMaskText('000\.000\.000\-00;0;_',
    ParCandidato.CPFCandidato);
  // LabelSexo.Caption := ParCandidato.Sexo;
  LabelNascimento.Caption := ParCandidato.Nascimento;
  Label_Curso.Caption := ParCandidato.CursoCandidato;
  LabelData.Caption := FormatDateTime('dd/mm/yyyy', Now);
  LabelHora.Caption := FormatDateTime('hh:mm', Now);

  SBtInformacoes.Visible := (ParCFC.Tela_Instrucoes = 'S');






end;

procedure TFrm_Confirmacao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_HOME then
    SBtAplicarClick(Self);
  // SBtInformacoesClick(Self); a Pedido do Harold 02/07/2018

  if Key = VK_LEFT then
    SBtCancelarClick(Self);

  if Key = VK_RIGHT then
    SBtAplicarClick(Self);

  if Key = VK_END then
    SBtSairClick(Self);

end;

procedure TFrm_Confirmacao.SBtAplicarClick(Sender: TObject);
var
  Oper200710: T200710;
  Oper200100: T200100;
  Oper200110: T200110;
  TextoAviso: string;
  I: Integer;
  Exec200110: Boolean;
begin

  TextoAviso := '';

  if Debug then
    ArquivoLog.GravaArquivoLog('# Confirmação Botão Próximo ');

  Label_aguarde.Visible := True;

  Timer1.Enabled := True;

  Label_aguarde.Caption := #13 + 'Aguarde...';
  GroupBox1.Visible := True;
  Label_aguarde.Visible := True;

  SBtAplicar.Enabled := False;

  if (ParListaAplicativos <> nil) and (ParListaDispositivos <> nil) and
    (ParListaServicosAtivos <> nil) and (ParListaProcessosAtivos <> nil) and
    (ParMacAdress <> nil) and (ParSistemaOperacional <> nil) then
  begin

    Label_aguarde.Caption := #13 + 'Aguarde. Validando computador...';
    Label_aguarde.Repaint;

    if (ParDetecta.Prova_Ativo) and (ParCandidato.TipoProva = 'P') then
    begin
      if Debug then
        ArquivoLog.GravaArquivoLog('# Confirmação Indentifica computador ');

      // if ParListaAplicativos.Count = 0 then
      // ParListaAplicativos.Assign(GetListSistemResource(ParListaAplicativos.Classe));

      ParListaDispositivos.Assign
        (GetListSistemResource(ParListaDispositivos.Classe));

      ParListaServicosAtivos.Assign
        (GetListSistemResource(ParListaServicosAtivos.Classe));

      ParListaProcessosAtivos.Assign
        (GetListSistemResource(ParListaProcessosAtivos.Classe));

    end;

    if (ParDetecta.Simulado_Ativo) and (ParCandidato.TipoProva = 'S') then
    begin

      if Debug then
        ArquivoLog.GravaArquivoLog('# Confirmação Indentifica computador ');

      if ParListaAplicativos.Count = 0 then
        ParListaAplicativos.Assign
          (GetListSistemResource(ParListaAplicativos.Classe));

      ParListaDispositivos.Assign
        (GetListSistemResource(ParListaDispositivos.Classe));

      ParListaServicosAtivos.Assign
        (GetListSistemResource(ParListaServicosAtivos.Classe));

      ParListaProcessosAtivos.Assign
        (GetListSistemResource(ParListaProcessosAtivos.Classe));
    end;

    if Debug then
    begin
      ArquivoLog.GravaArquivoLog('# Confirmação Indentificação básica ');
    end;

    if ParMacAdress.Count = 0 then
    begin
      ParMacAdress.Assign(GetListSistemResource(ParMacAdress.Classe));
    end;

    if ParSistemaOperacional.Count = 0 then
    begin
      ParSistemaOperacional.Assign
        (GetListSistemResource(ParSistemaOperacional.Classe));
    end;

  end;

  Label_aguarde.Caption := #13 + 'Aguarde...';
  Label_aguarde.Repaint;

  Self.Repaint;
  if Debug then
    ArquivoLog.GravaArquivoLog('# Confirmação 200100 ');

  // Efetuar a operação 200100
  Oper200100 := T200100.Create;
  Oper200100.Retorno := Oper200100.Consulta200100;

  if Oper200100.Retorno.IsValid then
  begin
    GroupBox1.Caption := Oper200100.Retorno.mensagem;
    Lbl_VerificaBloqueio.Enabled := True;
    Image9.Visible := False;
    ArquivoLog.GravaArquivoLog('Operação 200100 - ' +
      Trim(Oper200100.Retorno.codigo));

    Exec200110 := False;
    for I := 1 to ParQuestionario.Perguntas.Count do
    begin
      if ParQuestionario.Perguntas.Items[I].PerguntaImagem <> '' then
        Exec200110 := True;
    end;

    if Exec200110 then
    begin
      Oper200110 := T200110.Create;
      Oper200110.Retorno := Oper200110.Consulta200110;
    end;

  end
  else
  begin
    // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
    // SBtAplicar.Enabled := True;
    ArquivoLog.GravaArquivoLog('Operação 200100 - ' +
      Trim(Oper200100.Retorno.codigo) + ' - ' + Oper200100.Retorno.mensagem);

    if Trim(Oper200100.Retorno.mensagem) <> '' then
    begin
      Label_aguarde.Caption := Trim(Oper200100.Retorno.mensagem);
      TextoAviso := Oper200100.Retorno.mensagem;
    end
    else
    begin
      TextoAviso := 'Falha na comunicação com o servidor!' + #13 +
        'Verifique a internet e tente mais tarde';
    end;

    if Trim(Oper200100.Retorno.codigo) <> 'B67' then
      EnviarAviso(mtInformation, TextoAviso);

    //Andre - versao 4.0.0
    //Retorno = B35
    //Este aluno já realizou uma avaliação teórica. Não é mais possível realizar provas
    if (Trim(Oper200100.Retorno.codigo) = 'B35') and (TextoAviso <> '') then
      Application.Terminate;

    TextoAviso := '';
    Self.Repaint;
  end;

  // Verifica se é permitido ler Processos e Serviços
  if ((ParCandidato.TipoProva = 'P') and
    (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) then
  begin
    if Debug then
      ArquivoLog.GravaArquivoLog('# Confirmação 200710 ');
    Oper200710 := T200710.Create;

    try
      // Envia Lista
      Oper200710.Retorno := Oper200710.Consulta200710;

      if not Oper200710.Retorno.IsValid then
      begin
        GroupBox1.Visible := True;
        Label_aguarde.Visible := True;

        if (Oper200710.Retorno.MensagemTipo = 'E') or
          (Oper200710.Retorno.MensagemTipo = 'R') then
        begin
          if Oper200710.Retorno.MensagemTipo = 'R' then
          begin
            Frm_MensagemDetecta := TFrm_MensagemDetecta.Create(Self);
            Frm_MensagemDetecta.MmMensagemDetecta.Lines.Clear;
            Frm_MensagemDetecta.MmMensagemDetecta.Text :=
              Oper200710.Retorno.MensagemDetecta.Text;
            Frm_MensagemDetecta.ShowModal;
          end
          else
            MessageDlg(Oper200710.Retorno.mensagem, mtInformation, [mbOK], 0);

          Lbl_VerificaBloqueio.Enabled := False;
          Image9.Visible := True;

          LblEnviandoimagemcandidato.Enabled := False;
          Image10.Visible := True;

          LblAtualizandoandamento.Enabled := False;
          Image11.Visible := True;

          LblVerificandomonitoramento.Enabled := False;
          Image12.Visible := True;

          LblIniciandomonitoramento.Enabled := False;
          SBtAplicar.Enabled := True;

          Exit;
          // Application.Terminate;
        end;
      end;
    except
      on E: Exception do
      begin
        ArquivoLog.GravaArquivoLog('Operação 200710 - ' + E.Message);
        Label_aguarde.Caption :=
          'Não foi possível executar a validação desse computador. Reinicie o programa e tente novamente.';
        GroupBox1.Visible := True;
        Label_aguarde.Visible := True;

        // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
        // SBtAplicar.Enabled := True;
        Self.Repaint;

        EnviarAviso(mtInformation,
          'Não foi possível executar a validação desse computador. Reinicie o programa e tente novamente.');
        ExitProcess(0);

      end;
    end;

  end
  else
  begin
    if ParDetecta <> nil then
    begin
      if ((ParCandidato.TipoProva = 'S') and
        (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
      begin
        if Debug then
          ArquivoLog.GravaArquivoLog('# Confirmação 200710 ');

        Oper200710 := T200710.Create;

        try
          // Envia Lista
          Oper200710.Retorno := Oper200710.Consulta200710;

          if (not Oper200710.Retorno.IsValid) and
            (Oper200710.Retorno.MensagemDetecta.Count > 0) then
          begin
            GroupBox1.Visible := True;
            Label_aguarde.Visible := True;

            if (Oper200710.Retorno.MensagemTipo = 'E') or
              (Oper200710.Retorno.MensagemTipo = 'R') then
            begin
              if Oper200710.Retorno.MensagemTipo = 'R' then
              begin
                Frm_MensagemDetecta := TFrm_MensagemDetecta.Create(Self);
                Frm_MensagemDetecta.MmMensagemDetecta.Lines.Clear;
                Frm_MensagemDetecta.MmMensagemDetecta.Text :=
                  Oper200710.Retorno.MensagemDetecta.Text;
                Frm_MensagemDetecta.ShowModal;
              end
              else
                MessageDlg(Oper200710.Retorno.mensagem, mtInformation,
                  [mbOK], 0);

              Lbl_VerificaBloqueio.Enabled := False;
              Image9.Visible := True;

              LblEnviandoimagemcandidato.Enabled := False;
              Image10.Visible := True;

              LblAtualizandoandamento.Enabled := False;
              Image11.Visible := True;

              LblVerificandomonitoramento.Enabled := False;
              Image12.Visible := True;

              LblIniciandomonitoramento.Enabled := False;
              SBtAplicar.Enabled := True;

              Exit;

              // Application.Terminate;
            end
          end;

        except
          on E: Exception do
          begin
            ArquivoLog.GravaArquivoLog('Operação 200710 - ' + E.Message);
            Label_aguarde.Caption :=
              'Não foi possível executar a validação desse computador. Reinicie o programa e tente novamente.';
            GroupBox1.Visible := True;
            Label_aguarde.Visible := True;

            // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
            // SBtAplicar.Enabled := True;
            Self.Repaint;

            EnviarAviso(mtInformation,
              'Não foi possível executar a validação desse computador. Reinicie o programa e tente novamente.');
            ExitProcess(0);
          end;

        end;

      end
      else
      begin
        GroupBox1.Visible := True;
        Label_aguarde.Visible := True;
      end;
    end
    else
    begin
      GroupBox1.Visible := True;
      Label_aguarde.Visible := True;
    end;
  end;

  TThread.Synchronize(nil,
    procedure
    var
      Oper200200: T200200;
      TextoAviso: string;
    begin
      if Debug then
        ArquivoLog.GravaArquivoLog('# Confirmação 200200 ');

      // Efetuar a operação 200200
      Oper200200 := T200200.Create;
      Oper200200.Retorno := Oper200200.Consulta200200;

      if Oper200200.Retorno.IsValid then
      begin
        GroupBox1.Caption := Oper200200.Retorno.mensagem;
        LblEnviandoimagemcandidato.Enabled := True;
        LblAtualizandoandamento.Enabled := True;

        Image10.Visible := False;
        ArquivoLog.GravaArquivoLog('Operação 200200 - ' +
          Trim(Oper200200.Retorno.codigo));
      end
      else
      begin
        // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
        // SBtAplicar.Enabled := True;
        ArquivoLog.GravaArquivoLog('Operação 200200 - ' +
          Trim(Oper200200.Retorno.codigo) + ' - ' +
          Oper200200.Retorno.mensagem);

        Image3.Visible := True;
        Image8.Visible := True;
        Image5.Visible := True;
        Image6.Visible := True;
        Image7.Visible := True;
        Image4.Visible := True;
        GroupBox1.Visible := False;

        if Trim(Oper200200.Retorno.mensagem) <> '' then
        begin
          Label_aguarde.Caption := Trim(Oper200200.Retorno.mensagem);
          TextoAviso := Oper200200.Retorno.mensagem;
        end
        else begin
          TextoAviso := 'Falha na comunicação com o servidor!' + #13 +
            'Verifique a internet e tente mais tarde';

          EnviarAviso(mtInformation, TextoAviso);
          TextoAviso := '';
        end;

        Timer2.Enabled := True;
      end;
    end);

  TThread.Synchronize(nil,
    procedure
    var
      Oper200500: T200500;
      TextoAviso: string;
    begin

      if ParCandidato.TipoProva = 'S' then
      begin
        if ParCandidato.RegistroPresenca = 'N' then
        begin
          // Efetuar a operação 200500
          if Trim(ParCandidato.Foto) <> '' then
          begin
            if Debug then
              ArquivoLog.GravaArquivoLog('# Confirmação 200500 ');
            Oper200500 := T200500.Create;
            Oper200500.Retorno := Oper200500.Consulta200500;

            if Oper200500.Retorno.IsValid then
            begin
              GroupBox1.Caption := Oper200500.Retorno.mensagem;
              LblIniciandomonitoramento.Enabled := True;
              LblAtualizandoandamento.Enabled := True;
              Image11.Visible := False;
              ArquivoLog.GravaArquivoLog('Operação 200500 - ' +
                Trim(Oper200500.Retorno.codigo));

            end
            else
            begin
              // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
              // SBtAplicar.Enabled := True;
              ArquivoLog.GravaArquivoLog('Operação 200500 - ' +
                Trim(Oper200500.Retorno.codigo) + ' - ' +
                Oper200500.Retorno.mensagem);

              if Trim(Oper200500.Retorno.codigo) = 'D998' then
                TextoAviso := 'Não foi possível envia a foto do candidato!'
              else
              begin

                if Trim(Oper200500.Retorno.mensagem) <> '' then
                begin
                  Label_aguarde.Caption := Trim(Oper200500.Retorno.mensagem);
                  TextoAviso := Oper200500.Retorno.mensagem;
                end
                else
                  TextoAviso := 'Falha na comunicação com o servidor!' + #13 +
                    'Verifique a internet e tente mais tarde';

              end;

              EnviarAviso(mtInformation, TextoAviso);
              TextoAviso := '';
            end;

          end
          else
          begin
            LblIniciandomonitoramento.Enabled := True;
            LblAtualizandoandamento.Enabled := True;
            Image11.Visible := False;
          end;
        end
        else
        begin
          LblIniciandomonitoramento.Enabled := True;
          LblAtualizandoandamento.Enabled := True;
          Image11.Visible := False;
        end;

      end;
    end);

  TThread.Synchronize(nil,
    procedure
    var
      Oper200500: T200500;
      TextoAviso: string;
    begin

      if (ParCandidato.TipoProva = 'P') then
      begin
        if ParCandidato.RegistroPresenca = 'N' then
        begin
          // Efetuar a operação 200500
          if Trim(ParCandidato.Foto) <> '' then
          begin
            if Debug then
              ArquivoLog.GravaArquivoLog('# Confirmação 200500 ');
            Oper200500 := T200500.Create;
            Oper200500.Retorno := Oper200500.Consulta200500;

            if Oper200500.Retorno.IsValid then
            begin
              GroupBox1.Caption := Oper200500.Retorno.mensagem;
              LblIniciandomonitoramento.Enabled := True;
              LblAtualizandoandamento.Enabled := True;
              Image11.Visible := False;
              ArquivoLog.GravaArquivoLog('Operação 200500 - ' +
                Trim(Oper200500.Retorno.codigo));

              blnSEitran := EnvioSEITran;
              if Not blnSEitran  then
                Application.Terminate;

            end
            else
            begin
              // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
              // SBtAplicar.Enabled := True;
              ArquivoLog.GravaArquivoLog('Operação 200500 - ' +
                Trim(Oper200500.Retorno.codigo) + ' - ' +
                Oper200500.Retorno.mensagem);

              if Trim(Oper200500.Retorno.codigo) = 'D998' then
                TextoAviso := 'Não foi possível envia a foto do candidato!'
              else
              begin

                if Trim(Oper200500.Retorno.mensagem) <> '' then
                begin
                  Label_aguarde.Caption := Trim(Oper200500.Retorno.mensagem);
                  TextoAviso := Oper200500.Retorno.mensagem;
                end
                else
                  TextoAviso := 'Falha na comunicação com o servidor!' + #13 +
                    'Verifique a internet e tente mais tarde';

              end;

              EnviarAviso(mtInformation, TextoAviso);
              TextoAviso := '';

            end;

          end
          else
          begin
            LblIniciandomonitoramento.Enabled := True;
            LblAtualizandoandamento.Enabled := True;
            Image11.Visible := False;
          end;
        end
        else
        begin
          LblIniciandomonitoramento.Enabled := True;
          LblAtualizandoandamento.Enabled := True;
          Image11.Visible := False;
        end;
      end;
    end);

  TThread.Synchronize(nil,
    procedure
    begin

      if ParMonitoramentoFluxoRTSP <> nil then
      begin
        TelaIdentificaCandidato := False;
        TelaFoto := False;
        TelaBiometria := False;
        Reinicia := True;
        TelaInformacoes := False;
        TelaTeclado := False;
        TelaConfirmacao := False;
        TelaQuestionario := False;
        Frm_Menu.AbreTela;
        LblVerificandomonitoramento.Enabled := True;
        Image12.Visible := False;
      end;

    end);

  Self.Refresh;

end;

procedure TFrm_Confirmacao.SBtCancelarClick(Sender: TObject);
begin
  TelaIdentificaCandidato := True;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := False;
  TelaTeclado := False;
  TelaConfirmacao := False;
  TelaQuestionario := False;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Confirmacao.SBtInformacoesClick(Sender: TObject);
begin
  TelaIdentificaCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := True;
  TelaTeclado := False;
  TelaConfirmacao := False;
  TelaQuestionario := False;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Confirmacao.SBtSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_Confirmacao.Timer1Timer(Sender: TObject);
begin
  // GravaArquivoLog ('Verificando ...  ');
  if (Lbl_VerificaBloqueio.Enabled) and (LblGerandoQuestionario.Enabled) and
    (LblEnviandoimagemcandidato.Enabled) and (LblAtualizandoandamento.Enabled)
    and (LblVerificandomonitoramento.Enabled) and
    (LblIniciandomonitoramento.Enabled) and (Timer1.Enabled) then
  begin

    Timer1.Enabled := False;

    TelaIdentificaCandidato := False;
    TelaFoto := False;
    TelaBiometria := False;
    Reinicia := True;
    TelaInformacoes := False;
    TelaTeclado := False;
    TelaConfirmacao := False;
    TelaQuestionario := True;

    if DVRFerramentas <> nil then
    begin

      if DVRFerramentas.cfcliveSituacao > 0 then
      begin
        if DVRFerramentas.cfcliveTipo = 'erro' then
        begin

          Timer1.Enabled := False;
          if EnviarAviso(mtInformation, DVRFerramentas.cfcliveMensagem) then
            Application.Terminate;

        end;

      end;

    end;

    if Debug then
      ArquivoLog.GravaArquivoLog('# Confirmação Abre Questionário ');

    Frm_Menu.AbreTela;
    Close;
  end

end;

procedure TFrm_Confirmacao.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;

  TThread.Synchronize(nil,
    procedure
    var
      Oper200200: T200200;
      TextoAviso: string;
    begin
      if Debug then
        ArquivoLog.GravaArquivoLog('# Confirmação 200200 ');

      if Not blnSEitran then
        Exit;

      // Efetuar a operação 200200
      Oper200200 := T200200.Create;
      Oper200200.Retorno := Oper200200.Consulta200200;

      if Oper200200.Retorno.IsValid then
      begin
        GroupBox1.Caption := Oper200200.Retorno.mensagem;
        LblEnviandoimagemcandidato.Enabled := True;
        LblAtualizandoandamento.Enabled := True;

        Image10.Visible := False;
        ArquivoLog.GravaArquivoLog('Operação 200200 - ' +
          Trim(Oper200200.Retorno.codigo));
      end
      else
      begin
        // A pedido do Osvaldo para o cliente não ficar tentando 15/09/2017
        // SBtAplicar.Enabled := True;
        ArquivoLog.GravaArquivoLog('Operação 200200 - ' +
          Trim(Oper200200.Retorno.codigo) + ' - ' +
          Oper200200.Retorno.mensagem);

        Image3.Visible := True;
        Image8.Visible := True;
        Image5.Visible := True;
        Image6.Visible := True;
        Image7.Visible := True;
        Image4.Visible := True;
        GroupBox1.Visible := False;

        if Trim(Oper200200.Retorno.mensagem) <> '' then
        begin
          Label_aguarde.Caption := Trim(Oper200200.Retorno.mensagem);
          TextoAviso := Oper200200.Retorno.mensagem;
        end
        else
          TextoAviso := 'Falha na comunicação com o servidor!' + #13 +
            'Verifique a internet e tente mais tarde';

         EnviarAviso(mtInformation, TextoAviso);
        Timer2.Enabled := True;
      end;
    end);

end;




end.
