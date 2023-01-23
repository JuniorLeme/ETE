unit FrmAviso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.StdCtrls,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ClsMonitoramentoRTSP, ClsListaBloqueio, ClsParametros, ClsQuestionario,
  ClsCFCControl, ClsCandidatoControl, ClsServidorControl, ClsDetecta,
  ClsMonitoramentoRTSPControl, ClsConexaoFerramentas, ClsDigitalFotoExame,
  ClsSincronizarProva, ClsOper200710, ClsOper200400, ClsOper200500,
  ClsOperacoes, clsDVRFerramentas, ClsMonitoramentoFFMpeg, Vcl.ExtCtrls,

  Vcl.Imaging.pngimage;

type
  TFrm_Aviso = class(TForm)
    TmrAvisos: TTimer;
    Image1: TImage;
    lblAviso: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TmrAvisosTimer(Sender: TObject);
  private
    { Private declarations }
    ThreadFFMpeg: TThreadFFMpeg;
    tentativasBiometria: Integer;
    TextoAviso: string;
    i: integer;
    cont: integer;
    caminho: PChar;


    procedure Operacao200500;
    function Aviso(Tipo: TMsgDlgType; Texto: String): Boolean;
    function fRetornoSeitran(blnretonoBioFoto: Boolean): Boolean;
   // function fFinalizarProva(): boolean;

   // procedure onRetorno200400(Sender: T200400Retorno);
    procedure pFinalizaPorTempo;
    procedure pFinalizaAntesDoTempo;
    procedure pRetornoBiometria(blnretonoBioFoto: Boolean);
    procedure pCapturaBiometriaFoto;

  public
    MostraMsg: Integer;
  end;

var
  Frm_Aviso: TFrm_Aviso;

implementation

uses ClsFuncoes, ClsEnvio.Inicio.SEITran, ClsOperacoesRest, ClsRetorno.SEITran,
  FrmPrincipal, clsDialogos, ClseProvaConst;

{$R *.dfm}

procedure TFrm_Aviso.FormCreate(Sender: TObject);
begin
  tentativasBiometria := 0;
  lblAviso.Caption := '';
  lblAviso.Caption := 'Aguarde a aplicação concluir a prova!';
  lblAviso.Refresh;
 // fFinalizarProva;
end;

procedure TFrm_Aviso.TmrAvisosTimer(Sender: TObject);
begin
  Inc(tentativasBiometria);
  TmrAvisos.Enabled := False;

  if tentativasBiometria > 9 then      //   só para teste Adriano
  begin
    {lblAviso.Caption :=
     'Você excedeu o limite de tentativas de validação biometrica '+ #13 +
     'Informe ao responsavel pelo CFC ' + #13 +
     'O programa vai ser finalizado!';
    lblAviso.Refresh;
    Sleep(5000);}

    DialogoMensagem('Você excedeu o limite de tentativas de validação biométrica '+ #13 +
     'Informe ao responsável pelo CFC ' + #13 +
     'O programa vai ser finalizado!',mtWarning);

    Application.Terminate;
    ModalResult := mrCancel;
    Exit;

  end;

  if ParFotoExame <> nil then
  begin
    // Fianliza Prova
    if ParQuestionario.Tempo = 0 then
      pFinalizaPorTempo;

    if ParQuestionario.Tempo > 0 then
      pFinalizaAntesDoTempo;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

procedure TFrm_Aviso.Operacao200500;
begin

  TThread.Synchronize(nil,
    procedure
    var
      Consulta: MainOperacao;
      Oper200500Env: T200500Envio;
      Oper200500Ret: T200500Retorno;
    begin

      try
        Consulta := MainOperacao.Create(Self, '200500');
        Oper200500Env := T200500Envio.Create;
        Oper200500Ret := T200500Retorno.Create;
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

procedure TFrm_Aviso.pCapturaBiometriaFoto;
begin
  try
    if ParCandidato.Excecao = 'S' then
    begin
      pRetornoBiometria(ParFotoExame.Foto);
      Exit;
    end;

    if (ParCFC.Biometria_Foto_prova = 'S') then
    begin
      pRetornoBiometria(ParFotoExame.BiometriaFoto);
      Exit;
    end;

    if (ParCFC.Biometria_prova = 'S') then
    begin
      pRetornoBiometria(ParFotoExame.BiometriaFoto);
      Exit;
    end;

    if (ParCFC.Foto_prova = 'S') then
    begin
      pRetornoBiometria(ParFotoExame.Foto);
      Exit;
    end;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Aviso Biometria/Foto - ' + E.Message);
      lblAviso.Caption := 'Biometria/Foto não está funcionando corretamente!';
      lblAviso.Refresh;
    end;
  end;
end;

procedure TFrm_Aviso.pFinalizaAntesDoTempo;
begin
  if (ParFotoExame.Prova_Ativo) and (ParCandidato.TipoProva = 'P') then
  begin
    TelaResultado := False;
    TelaResultadoBiometriaFoto := True;
    pCapturaBiometriaFoto;
  end;

  if (ParFotoExame.Simulado_Ativo) and (ParCandidato.TipoProva = 'S') then
  begin
    TelaResultado := False;
    TelaResultadoBiometriaFoto := True;
    pCapturaBiometriaFoto;
  end;
end;

procedure TFrm_Aviso.pFinalizaPorTempo;
begin
  if ((ParFotoExame.Prova_Ativo) and (ParCandidato.TipoProva = 'P')) or
    ((ParFotoExame.Simulado_Ativo) and (ParCandidato.TipoProva = 'S')) then
  begin
    TelaResultado := False;
    TelaResultadoBiometriaFoto := True;
    pCapturaBiometriaFoto;
  end;
end;

procedure TFrm_Aviso.pRetornoBiometria(blnretonoBioFoto: Boolean);
var
  txtDialogo: string;
  TextoAviso: string;
  Env : integer;
  objEnvioFinalSEITran: TEnvioFinalSEITran;
  objRetornoFinalSEITran: TRetronoSEITranFinal;
  objCon: TOperacaoRestful;


begin



  if blnretonoBioFoto then
  begin
    objRetornoFinalSEITran := TRetronoSEITranFinal.Create;
    objEnvioFinalSEITran := TEnvioFinalSEITran.Create;
    objEnvioFinalSEITran.CFC := ParCFC.id_cfc;
    objEnvioFinalSEITran.CPF := ParCandidato.CPFCandidato;


    try
        objCon := TOperacaoRestful.Create(Self);
        objRetornoFinalSEITran.AsJson := objCon.ExecutarConsultar
         (ParCFC.URLSEITrans + '/resultado/cpf', objEnvioFinalSEITran.AsJson,
         'A Prova não será finalizada!');

        if Assigned(objRetornoFinalSEITran.Retorno) then
        begin
         // objRetornoFinalSEITran.Retorno.codigo:= 'B0000';   //Adriano usado para testes teste
          if objRetornoFinalSEITran.Retorno.codigo <> 'B0000' then
            begin
              blnretonoBioFoto := False;
              ArquivoLog.GravaArquivoLog('Operação FIM prova SEI Tran. - ' +
                Trim(objRetornoFinalSEITran.Retorno.codigo));
              TextoAviso := objRetornoFinalSEITran.Retorno.descricao;

            end
          else
            begin
              TelaResultado := True;
              TelaQuestionario := False;
              TelaInformacoes := False;
              TelaResultado := True;
              Frm_Menu.AbreTela;
              ModalResult := mrOK;
              Exit;

            end;





            if Not TextoAviso.IsEmpty then
            begin
              cont:= 0;

              repeat


                blnretonoBioFoto := True;
                if fRetornoSeitran(blnretonoBioFoto) then
                  begin
                    exit;
                  end;
                cont := cont + 1;
              until((cont = 10) or (env = 1));

              DialogoMensagem
                ('Não foi possível enviar o resultado da prova ao detran.' + #13 +
                  'Informe ao responsavel pelo CFC.',
                 mtWarning);

              MostraMsg:= 1;
             // ParCandidato.Bloqueado := 'S';  // Adriano alterado para testes 15/07
              Operacao200500;

             // TelaResultado := True;
              TelaQuestionario := False;
              TelaInformacoes := False;
              Frm_Menu.AbreTela;
              ModalResult := mrOk;
              exit;
            end;

        end;

    finally
      FreeAndNil(objRetornoFinalSEITran);
      FreeAndNil(objEnvioFinalSEITran);
    end;
  end;

  if blnretonoBioFoto then
    begin
      ParCandidato.Bloqueado := 'N';
      ModalResult := mrOk;
    end
  else
    begin
      if ParFotoExame.DigitalMensagem <> '' then
        txtDialogo := ParFotoExame.DigitalMensagem;

      if ParFotoExame.FotoMensagem <> '' then
      if ParFotoExame.FotoMensagem <> 'Sucesso' then
        txtDialogo := ParFotoExame.FotoMensagem;

      if ParCandidato.Bloqueado = 'S' then
        begin
          txtDialogo := txtDialogo;
         // lblAviso.Caption := txtDialogo;    //Adriano comentado para teste
         // lblAviso.Refresh;
          if Aviso(mtInformation, txtDialogo) then
          begin
           // TmrAvisos.Enabled := True;
           // Exit;
           Operacao200500;
           Application.Terminate;
          end;

        end
      else
        begin
          txtDialogo := txtDialogo + ' Deseja tentar novamente?';

          if Aviso(mtConfirmation, txtDialogo) then
          begin
            TmrAvisos.Enabled := True;
            Exit;
          end
          else
          begin
            ParCandidato.Bloqueado := 'S';
            Operacao200500;
            Application.Terminate;

          end;
        End;
  end;
end;

function TFrm_Aviso.Aviso(Tipo: TMsgDlgType; Texto: String): Boolean;
begin
  Result := False;

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

  if Tipo = mtInformation then
  begin
    Application.MessageBox(PWideChar(Texto), PWideChar(Application.Title),
      MB_ICONEXCLAMATION + MB_OK);
    Result := True;
  end;

  Application.RestoreTopMosts;

  Parametros.AguardarAviso := False;
end;


function TFrm_Aviso.fRetornoSeitran(blnretonoBioFoto: Boolean): Boolean;
var
  txtDialogo: string;
  TextoAviso: string;

  objEnvioFinalSEITran: TEnvioFinalSEITran;
  objRetornoFinalSEITran: TRetronoSEITranFinal;
  objCon: TOperacaoRestful;

begin

  //ParFotoExame.BiometriaFoto;
  //blnretonoBioFoto:= false; fazer controle para segunda tent de biometr
  if blnretonoBioFoto then
  begin

    objRetornoFinalSEITran := TRetronoSEITranFinal.Create;
    objEnvioFinalSEITran := TEnvioFinalSEITran.Create;
    objEnvioFinalSEITran.CFC := ParCFC.id_cfc;
    objEnvioFinalSEITran.CPF := ParCandidato.CPFCandidato;


    try
        objCon := TOperacaoRestful.Create(Self);
        objRetornoFinalSEITran.AsJson := objCon.ExecutarConsultar
          (ParCFC.URLSEITrans + '/resultado/cpf', objEnvioFinalSEITran.AsJson,
          'A Prova não será finalizada!');

        if Assigned(objRetornoFinalSEITran.Retorno) then
        begin
         // objRetornoFinalSEITran.Retorno.codigo:= 'B0000';
          if objRetornoFinalSEITran.Retorno.codigo <> 'B0000' then
            begin
              blnretonoBioFoto := False;
              ArquivoLog.GravaArquivoLog('Operação FIM prova SEI Tran. - ' +
                Trim(objRetornoFinalSEITran.Retorno.codigo));
              TextoAviso := objRetornoFinalSEITran.Retorno.descricao;
              Result:= false;
              EnviarAviso(mtInformation, TextoAviso);
            end
          else
            begin
              TelaQuestionario := False;
              TelaInformacoes := False;
              TelaResultado := True;
              Frm_Menu.AbreTela;
              ModalResult := mrOK;
              Result := True;
              Exit;

            end;
        end;

    finally
      FreeAndNil(objRetornoFinalSEITran);
      FreeAndNil(objEnvioFinalSEITran);
    end;
  end;
end;

{
function TFrm_Aviso.fFinalizarProva(): boolean;
var
  Consulta: MainOperacao;
  Oper200710Env: T200710Envio;
  Oper200710Ret: T200710Retorno;

  Oper200500Env: T200500Envio;
  Oper200500Ret: T200500Retorno;

  Oper200400Env: T200400Envio;
  Oper200400Ret: T200400Retorno;

  TestativasDeConexao: Integer;
begin

  TestativasDeConexao := 0;

  ArquivoLog.GravaArquivoLog('Resumo da Prova - Coletando a Biometria/Foto');

  TelaConfirmacao := False;
  TelaQuestionario := False;
  TelaExameBiometriaFoto := False;

  if ParCandidato.TipoProva = 'P' then
  begin

    if ParFotoExame.Prova_Ativo then
    begin

      repeat

        try

          ArquivoLog.GravaArquivoLog('Resumo da Prova - Operação 200500 ');
          Consulta := MainOperacao.Create(Self, '200500');
          Oper200500Env := T200500Envio.Create;
          Oper200500Ret := T200500Retorno.Create;
          Oper200500Ret.MontaRetorno
            (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
            Oper200500Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
            ParCandidato.TipoProva, ParCandidato.Bloqueado,
            ParCandidato.Foto)));

          ArquivoLog.GravaArquivoLog('Operação 200500 - ' + Oper200500Ret.codigo
            + ' - ' + Oper200500Ret.Mensagem);

        except
          on E: Exception do
            ArquivoLog.GravaArquivoLog('Operação 200500 - ' + E.Message);
        end;

        if Oper200500Ret.codigo <> 'B000' then
        begin
          sleep(1000);
          Inc(TestativasDeConexao);
        end;

        if TestativasDeConexao > 3 then
        begin
          TestativasDeConexao := 0;
          Break;
        end;

      until (Oper200500Ret.codigo = 'B000');

    end;
  end;

  if ParCandidato.TipoProva = 'S' then
  begin

    if ParDetecta <> nil then
    begin

      if ParFotoExame.Simulado_Ativo then
      begin

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
            ArquivoLog.GravaArquivoLog('Biometria/Foto - Resultado - ' +
              E.Message);
        end;

      end;

      repeat

        try

          ArquivoLog.GravaArquivoLog('Resumo da Prova - Operação 200500 ');
          Consulta := MainOperacao.Create(Self, '200500');
          Oper200500Env := T200500Envio.Create;
          Oper200500Ret := T200500Retorno.Create;
          Oper200500Ret.MontaRetorno
            (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
            Oper200500Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
            ParCandidato.TipoProva, ParCandidato.Bloqueado,
            ParCandidato.Foto)));

          ArquivoLog.GravaArquivoLog('Operação 200500 - ' + Oper200500Ret.codigo
            + ' - ' + Oper200500Ret.Mensagem);

        except
          on E: Exception do
            ArquivoLog.GravaArquivoLog('Operação 200500 - ' + E.Message);
        end;

        if Oper200500Ret.codigo <> 'B000' then
        begin
          sleep(1000);
          Inc(TestativasDeConexao);
        end;

        if TestativasDeConexao > 3 then
        begin
          TestativasDeConexao := 0;
          Break;
        end;

      until (Oper200500Ret.codigo = 'B000');

    end;
  end;

  try

    if ParCandidato.Bloqueado <> 'S' then
    begin

      repeat

        try
          // Efetuar a operação 200400
          ArquivoLog.GravaArquivoLog('Resumo da Prova - Operação 200400');
          Consulta := MainOperacao.Create(Self, '200400');
          Oper200400Env := T200400Envio.Create;
          Oper200400Ret := T200400Retorno.Create;
          Oper200400Ret.MontaRetorno('E',
            Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
            Oper200400Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
            ParCandidato.TipoProva, 'E',
            IntToStr(ParQuestionario.TempoDecorrido))));

          ArquivoLog.GravaArquivoLog('Operação 200400 - ' + Oper200400Ret.codigo
            + ' - ' + Oper200400Ret.Mensagem);

        except
          on E: Exception do
            ArquivoLog.GravaArquivoLog('Operação 200710 - ' + E.Message);
        end;

        if Oper200400Ret.codigo <> 'B000' then
        begin
          sleep(1000);
          Inc(TestativasDeConexao);
        end;

        if TestativasDeConexao > 3 then
        begin
          TestativasDeConexao := 0;
          Break;
        end;

      until (Oper200400Ret.codigo = 'B000');

     // onRetorno200400(Oper200400Ret);

    end
    else
    begin

      if Trim(ParFotoExame.FotoMensagem) <> '' then
      begin
        ArquivoLog.GravaArquivoLog(Trim(ReplaceStr(ParFotoExame.FotoMensagem,
          '.', '')) + '. A prova será bloqueada.' + #13 +
          'Aguarde o desbloqueio que será realizado pelo DETRAN.');
        EnviarAviso(mtInformation, Trim(ReplaceStr(ParFotoExame.FotoMensagem,
          '.', '')) + '. A prova será bloqueada.' + #13 +
          'Aguarde o desbloqueio que será realizado pelo DETRAN.');
      end;

      if Trim(ParFotoExame.DigitalMensagem) <> '' then
      begin
        ArquivoLog.GravaArquivoLog(Trim(ReplaceStr(ParFotoExame.DigitalMensagem,
          '.', '') + '. A prova será bloqueada.' + #13 +
          'Aguarde o desbloqueio que será realizado pelo DETRAN.'));
        EnviarAviso(mtInformation, Trim(ReplaceStr(ParFotoExame.DigitalMensagem,
          '.', '') + '. A prova será bloqueada.' + #13 +
          'Aguarde o desbloqueio que será realizado pelo DETRAN.'));
      end;

      KillTask('eProva.exe');
    end;

  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Operação 200400 - ' + E.Message);
  end;

  ArquivoLog.GravaArquivoLog('Resumo da Prova - Configurando o gráfico');
  ParQuestionario.ResultadoDisciplinaCorCertas[1] := clBlue; // Azul Claro
  ParQuestionario.ResultadoDisciplinaCorCertas[2] := clGreen; // verde Claro
  ParQuestionario.ResultadoDisciplinaCorCertas[3] := clYellow; // Amarelo Claro
  ParQuestionario.ResultadoDisciplinaCorCertas[4] := $000080FF; // laranja Claro
  ParQuestionario.ResultadoDisciplinaCorCertas[5] := clRed; // Vermelho

  ParQuestionario.ResultadoDisciplinaCorErradas[1] := $00BF0000; // Azul escuro
  ParQuestionario.ResultadoDisciplinaCorErradas[2] := $00006200; // verde escuro
  ParQuestionario.ResultadoDisciplinaCorErradas[3] := $0000B0B0; // Amarelo escuro
  ParQuestionario.ResultadoDisciplinaCorErradas[4] := $000065CA; // laranja escuro
  ParQuestionario.ResultadoDisciplinaCorErradas[5] := $000000AE; // amarelo escuro

  try

    if ParDetecta <> nil then
    begin

      if ((ParCandidato.TipoProva = 'P') and (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) or
         ((ParCandidato.TipoProva = 'S') and (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
      begin

        // Envia lista de Processos e Serviços
        Consulta := MainOperacao.Create(Self, '200710');
        Oper200710Env := T200710Envio.Create;
        Oper200710Ret := T200710Retorno.Create;
        Oper200710Ret.MontaRetorno
          (Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
          Oper200710Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
          ParCandidato.TipoProva, ParCandidato.IdCandidato,
          ParCandidato.CPFCandidato)));

        ArquivoLog.GravaArquivoLog('Operação 200710 - ' + Oper200710Ret.codigo +
          ' - ' + Oper200710Ret.Mensagem);

      end;



    end;

  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Operação 200710 - ' + E.Message);
  end;
end;

procedure TFrm_Aviso.onRetorno200400(Sender: T200400Retorno);
var
  P: Integer;
  ParDisciplina: TDisciplina;
  D: Integer;
begin

  if Trim(Sender.codigo) <> '' then
  begin

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

  end;

end; }


end.
