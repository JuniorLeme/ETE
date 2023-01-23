unit frmCadastroCandidato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ClsParametros, ClsOperacoes, ClsCFCControl, ClsFuncoes,
  ClsOper100310,
  ClsCandidatoControl, System.MaskUtils, ClsServidorControl, ClsDigitalFoto,
  Vcl.Mask,
  ClsMonitoramentoRTSP, ClsMonitoramentoRTSPControl, ClsOper100700,
  ClsListaBloqueio,
  ClsDetecta, ClsThreadDetecta;

type
  Tfrm_CadastroCandidato = class(TForm)
    Label9: TLabel;
    SBtSimulado: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image3: TImage;
    EditCpf: TEdit;
    EditNome: TEdit;
    CbBSexo: TComboBox;
    cbbCurso: TComboBox;
    EditNascimento: TMaskEdit;
    SBtCancelar: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure EdRENACHRightButtonClick(Sender: TObject);
    procedure SBtSimuladoClick(Sender: TObject);
    procedure SBtProvaClick(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure EditNascimentoExit(Sender: TObject);
  private
    Reinicia: Boolean;
    NovaBiometria: Boolean;
    function ObterIdade(DataNasc: TDateTime; DataAtual: TDateTime): integer;
    function ValidaCPF(Num: string): Boolean;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_CadastroCandidato: Tfrm_CadastroCandidato;

implementation

uses FrmPrincipal, clsDialogos;
{$R *.dfm}

procedure Tfrm_CadastroCandidato.EditNascimentoExit(Sender: TObject);
begin
  try
    if Trim(EditNascimento.Text) <> '/  /' then
    begin
      if StrToDateDef(EditNascimento.Text, 0) = 0 then
      begin
        EnviarAviso(mtInformation, 'Data de Nascimento incorreta!');
        EditNascimento.Clear;
      end
      else
      begin
        if ObterIdade(StrToDateDef(EditNascimento.Text, 0), Now) < 18 then
        begin
          EnviarAviso(mtInformation, 'O candidato deve ter no mínimo 18 anos!');
          EditNascimento.Clear;
        end;
      end;
    end
    else
      EditNascimento.Clear;
  except
    on E: Exception do
      EditNascimento.Clear;
  end;
end;

function Tfrm_CadastroCandidato.ObterIdade(DataNasc: TDateTime;
  DataAtual: TDateTime): integer;
var
  DiaNasc: word;
  MesNasc: word;
  AnoNasc: word;
  DiaAtual: word;
  MesAtual: word;
  AnoAtual: word;
begin
  if DataAtual > DataNasc then
  begin
    DecodeDate(DataNasc, AnoNasc, MesNasc, DiaNasc);
    DecodeDate(DataAtual, AnoAtual, MesAtual, DiaAtual);
    if (MesAtual > MesNasc) or ((MesAtual = MesNasc) and (DiaAtual >= DiaNasc))
    then
      Result := AnoAtual - AnoNasc
    else
      Result := AnoAtual - AnoNasc - 1;
  end
  else
    Result := 0;
end;

function Tfrm_CadastroCandidato.ValidaCPF(Num: string): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9: integer;
  d1, d2: integer;
  digitado, calculado: string;
begin
  Result := True;

  // Num := TrocaLetra(Num,' ','');

  if Num <> '' then
  begin
    if Length(Trim(Num)) = 11 then
    begin
      n1 := StrToInt(Num[1]);
      n2 := StrToInt(Num[2]);
      n3 := StrToInt(Num[3]);
      n4 := StrToInt(Num[4]);
      n5 := StrToInt(Num[5]);
      n6 := StrToInt(Num[6]);
      n7 := StrToInt(Num[7]);
      n8 := StrToInt(Num[8]);
      n9 := StrToInt(Num[9]);

      d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 *
        9 + n1 * 10;
      d1 := 11 - (d1 mod 11);
      if d1 >= 10 then
        d1 := 0;

      d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 *
        9 + n2 * 10 + n1 * 11;
      d2 := 11 - (d2 mod 11);
      if d2 >= 10 then
        d2 := 0;

      calculado := IntToStr(d1) + IntToStr(d2);
      digitado := Num[10] + Num[11];

      Result := (calculado = digitado);
    end
    else
      Result := False;
  end;
end;

procedure Tfrm_CadastroCandidato.EdRENACHRightButtonClick(Sender: TObject);
begin
  (Sender as TButtonedEdit).Clear;
end;

procedure Tfrm_CadastroCandidato.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TelaExameBiometriaFoto := False;

  if not Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;
end;

procedure Tfrm_CadastroCandidato.FormCreate(Sender: TObject);
var
  I: integer;
begin
  Reinicia := False;
  ArquivoLog.GravaArquivoLog('# ' + Self.Caption);

  EditCpf.Text := '';
  EditNome.Text := '';
  cbbCurso.ItemIndex := -1;
  EditNascimento.Text := '';
  CbBSexo.ItemIndex := -1;

  SBtSimulado.Visible := (ParCFC.Tela_Cadastro_Simulado = 'S');
  // SBtProva.Visible := (ParCFC.Tela_Cadastro_prova = 'S');

  cbbCurso.Items.Clear;

  if ParCFC.Tela_Cadastro_Simulado = 'S' then
  begin

    for I := 0 to Length(ParCFC.ListaCursoDescriSimulado) - 1 do
    begin

      if Trim(ParCFC.ListaCursoDescriSimulado[I]) <> '' then
        cbbCurso.Items.Add(ParCFC.ListaCursoDescriSimulado[I]);

    end;

  end;

  if ParCFC.Tela_Cadastro_prova = 'S' then
  begin

    for I := 0 to Length(ParCFC.ListaCursoDescriProva) - 1 do
    begin

      if Trim(ParCFC.ListaCursoDescriProva[I]) <> '' then
        cbbCurso.Items.Add(ParCFC.ListaCursoDescriProva[I]);

    end;
  end;

end;

procedure Tfrm_CadastroCandidato.SBtCancelarClick(Sender: TObject);
begin
  TelaIdentificaCandidato := True;
  TelaCadastraCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;
  TelaBiometriaFoto := False;
  TelaConfirmacao := False;
  Reinicia := True;
  Frm_Menu.AbreTela;
  Close;
end;

procedure Tfrm_CadastroCandidato.SBtProvaClick(Sender: TObject);
begin
  ParCandidato.TipoProva := 'P';
end;

procedure Tfrm_CadastroCandidato.SBtSimuladoClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper310Env: T100310Envio;
  Oper310Ret: T100310Retorno;
  Digital: TDigitalRest;
  Foto: TFotoRest;
  Ret: TRetornoRest;

  // #####################

  Oper100700Env: T100700Envio;
  Oper100700Ret: T100700Retorno;

  MonitoramentoClntSckt: TMonitoramentoClntSckt;
  StatusMonitoramento: string;
  Tetativas: integer;

begin

  if Debug then
    ArquivoLog.GravaArquivoLog('cadastro do aluno validação');

  Reinicia := True;
  ParCandidato.TipoProva := 'S';

  // Validar as informações digitadas
  if not ValidaCPF(EditCpf.Text) then
  begin
    DialogoMensagem('CPF Incorreto!', mtInformation);
    EditCpf.SetFocus;
    Exit;
  end;

  if Trim(EditNome.Text) = '' then
  begin
    DialogoMensagem('Informe o nome do candidato!', mtInformation);
    EditNome.SetFocus;
    Exit;
  end;

  if Length(Trim(EditCpf.Text)) <> 11 then
  begin
    DialogoMensagem('Número de CPF inválido!', mtInformation);
    EditCpf.SetFocus;
    Exit;
  end;

  if cbbCurso.ItemIndex = -1 then
  begin
    DialogoMensagem('Selecione o curso!', mtInformation);
    cbbCurso.SetFocus;
    Exit;
  end;

  if CbBSexo.ItemIndex = -1 then
  begin
    DialogoMensagem('Selecione o sexo!', mtInformation);
    CbBSexo.SetFocus;
    Exit;
  end;

  if Debug then
    ArquivoLog.GravaArquivoLog('cadastro do aluno 100310');

  Consulta := MainOperacao.Create(Self, '100310');
  Oper310Env := T100310Envio.Create;
  Oper310Ret := T100310Retorno.Create;

  ParCandidato.CPFCandidato := Trim(EditCpf.Text);
  ParCandidato.RENACHCandidato := '000000000';

  if Trim(EditNome.Text) <> '' then
    ParCandidato.NomeCandidato := EditNome.Text;

  if Trim(CbBSexo.Text) <> '' then
    ParCandidato.CursoCandidato := ParCFC.ListaCursoCodSimulado
      [cbbCurso.ItemIndex];

  ParCandidato.Municipio_Candidato := ' ';

  if Trim(EditNascimento.Text) <> '' then
    ParCandidato.Nascimento := EditNascimento.Text;

  if Trim(CbBSexo.Text) <> '' then
    ParCandidato.Sexo := CbBSexo.Text;

  Oper310Ret.MontaXMLRetorno
    (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
    Oper310Env.MontaXMLEnvio(ParCandidato),
    'Verifique sua conexão e tente novamente.'));

  if Oper310Ret.IsValid then
  begin

    if Debug then
      ArquivoLog.GravaArquivoLog('cadastro do aluno - 100310 valida');

    ParCandidato.Simulado := 'S';

    ParCandidato.TipoProva := 'S';
    ParCandidato.ResgistrarPresenca := False;
    TelaIdentificaCandidato := False;
    TelaBiometriaFoto := False;
    TelaBiometria := False;
    TelaFoto := False;

    TelaExameBiometriaFoto := False;

    SBtSimulado.Enabled := False;
    Reinicia := True;

    if ParDetecta <> nil then
    begin

      if Debug then
        ArquivoLog.GravaArquivoLog('cadastro do aluno - detecta');

      // Verifica se é permitido ler Processos e Serviços
      if ((ParCandidato.TipoProva = 'P') and
        (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) or
        ((ParCandidato.TipoProva = 'S') and
        (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
      begin

        if Debug then
          ArquivoLog.GravaArquivoLog('cadastro do aluno 100700');

        // Consulta Lista
        Consulta := MainOperacao.Create(Self, '100700');
        Oper100700Env := T100700Envio.Create;
        Oper100700Ret := T100700Retorno.Create;
        Oper100700Ret.MontarRetorno
          (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
          Oper100700Env.MontaXMLEnvio,
          'Verifique sua conexão e tente novamente.'));

        if Oper100700Ret.IsValid then
        begin

          if Debug then
            ArquivoLog.GravaArquivoLog('cadastro do aluno 100700 valida');

          ThrdDispositivos := TThrdDetecta.Create;
          ThrdDispositivos.NumLista := 2;
          ThrdDispositivos.Tipo := 1;

          ThrdServicos := TThrdDetecta.Create;
          ThrdServicos.NumLista := 3;
          ThrdServicos.Tipo := 1;

          ThrdProcessos := TThrdDetecta.Create;
          ThrdProcessos.NumLista := 4;
          ThrdProcessos.Tipo := 1;

          if Debug then
            ArquivoLog.GravaArquivoLog
              ('cadastro do aluno detecta está coletando os dados');

        end
        else
        begin

          if Debug then
            ArquivoLog.GravaArquivoLog('cadastro do aluno - 100700 invalida');

          EnviarAviso(mtInformation,
            'Não foi possível executar a validação desse computador.' + #13 +
            ' Reinicie o programa e tente novamente.');
          ExitProcess(0);
        end;

      end;
    end;

    if ParCFC.Monitoramento_Simulado = 'S' then
    begin

      if Debug then
        ArquivoLog.GravaArquivoLog('cadastro do aluno simulado monitoramento');

      Tetativas := 0;
      repeat

        if ParListaMonitoramentoRTSP.Count > 0 then
          ParMonitoramentoRTSP :=
            TMonitoramentoRTSP(ParListaMonitoramentoRTSP.Objects[Tetativas]);

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
      TelaFoto := False;
      TelaConfirmacao := True;
    end
    else
    begin
      TelaConfirmacao := False;

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
                TelaTeclado := True;
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
                  TelaTeclado := True;
                end
                else
                begin
                  EnviarAviso(mtInformation, Ret.mensagem);
                end;

              end
              else
                EnviarAviso(mtInformation, Ret.mensagem);

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
                TelaTeclado := True;
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
                TelaTeclado := True;
              end
              else
                EnviarAviso(mtInformation, Ret.mensagem);

            end
            else
              TelaBiometria := True;

          end;
        end
        else
          TelaConfirmacao := True;

      except
        on E: Exception do
        begin
          ArquivoLog.GravaArquivoLog
            ('Cadastro do aluno Biometria/Foto Simulado - ' + E.Message);
          EnviarAviso(mtInformation,
            'Biometria/Foto não está funcionando corretamente!');
        end;
      end;

    end;

    if TelaConfirmacao or TelaFoto or TelaBiometria or TelaBiometriaFoto then
    begin
      TelaCadastraCandidato := False;
      Frm_Menu.AbreTela;
      Close;
    end
    else
      SBtSimulado.Enabled := True;

  end
  else
  begin
    DialogoMensagem(Oper310Ret.mensagem, mtInformation);
    Self.Repaint;
  end;

end;

procedure Tfrm_CadastroCandidato.SpeedButton2Click(Sender: TObject);
begin
  ArquivoLog.GravaArquivoLog('# Cancelamento tela Cadastro');
  TelaIdentificaCandidato := False;
  TelaCadastraCandidato := False;
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

end.
