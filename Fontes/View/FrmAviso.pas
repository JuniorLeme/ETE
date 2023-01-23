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
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TmrAvisosTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    fEnvioEncerramento: Boolean;

    Function Operacao200500: Boolean;
    function Aviso(Tipo: TMsgDlgType; Texto: String): Boolean;

    procedure pFinalizaProva;
    function pRetornoBiometria(blnretonoBioFoto: Boolean): Boolean;
    Function pCapturaBiometriaFoto: Boolean;
    function SEITran: Boolean;
    function Envio200400Encerramento: Boolean;
  public
  end;

var
  Frm_Aviso: TFrm_Aviso;

implementation

uses ClsFuncoes, ClsEnvio.Inicio.SEITran, ClsOperacoesRest, ClsRetorno.SEITran,
  FrmPrincipal, clsDialogos, ClseProvaConst;

{$R *.dfm}

procedure TFrm_Aviso.FormCreate(Sender: TObject);
begin
  lblAviso.Caption := '';
  lblAviso.Caption := 'Aguarde a aplicação concluir a prova!';
  lblAviso.Refresh;

  Button1.Tag := 1;
  fEnvioEncerramento := False;
end;

function TFrm_Aviso.Envio200400Encerramento: Boolean;
var
  Consulta: MainOperacao;
  Oper200400Env: T200400Envio;
  Oper200400Ret: T200400Retorno;
  TestativasDeConexao: Integer;
begin
  TestativasDeConexao := 0;

  repeat
    Consulta := MainOperacao.Create(Self, '200400');
    Oper200400Env := T200400Envio.Create;
    Oper200400Ret := T200400Retorno.Create;

    try
      // Efetuar a operação 200400
      ArquivoLog.GravaArquivoLog('Resumo da Prova - Operação 200400');
      Oper200400Ret.MontaRetorno('E',
        Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
        Oper200400Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
        ParCandidato.TipoProva, 'E',
        IntToStr(ParQuestionario.TempoDecorrido))));

      Result := Oper200400Ret.IsValid;

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
      Break;

  until (Oper200400Ret.IsValid);

end;

procedure TFrm_Aviso.TmrAvisosTimer(Sender: TObject);
begin
  TmrAvisos.Enabled := False;

  if Not fEnvioEncerramento then
    fEnvioEncerramento := Envio200400Encerramento;

  if Not fEnvioEncerramento  then
  begin
    lblAviso.Caption := '';
    lblAviso.Caption := 'Falha no envio do encerramento da prova!';
    lblAviso.Refresh;
    TmrAvisos.Enabled := True;
  end
  else
  if ParFotoExame <> nil then
  begin
    pFinalizaProva;
  end
  else
    ModalResult := mrOk;

end;

Function TFrm_Aviso.Operacao200500: Boolean;
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

    Result := Oper200500Ret.IsValid;
  finally
    FreeAndNil(Consulta);
    FreeAndNil(Oper200500Env);
    FreeAndNil(Oper200500Ret);
  end;
end;

Function TFrm_Aviso.pCapturaBiometriaFoto: Boolean;
begin
  try
    if ParCandidato.Excecao = 'S' then
      Result := pRetornoBiometria(ParFotoExame.Foto)
    else if (ParCFC.Biometria_prova = 'S') then
      Result := pRetornoBiometria(ParFotoExame.BiometriaFoto)
    else if (ParCFC.Biometria_Foto_prova = 'S')then
      Result := pRetornoBiometria(ParFotoExame.BiometriaFoto)
    else if (ParCFC.Foto_prova = 'S') then
      Result := pRetornoBiometria(ParFotoExame.Foto);

    if Result then
      Result := SEITran;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Aviso Biometria/Foto - ' + E.Message);
      Aviso(mtWarning, 'Biometria/Foto não está funcionando corretamente!');
    end;
  end;
end;

procedure TFrm_Aviso.pFinalizaProva;
begin
  if ((ParFotoExame.Prova_Ativo) and (ParCandidato.TipoProva = 'P')) or
     ((ParFotoExame.Simulado_Ativo) and (ParCandidato.TipoProva = 'S')) then
  begin
    if Not pCapturaBiometriaFoto then
    begin
      Button1.Tag := Button1.Tag + 1;

      if Button1.Tag > 4 then
      begin
        Aviso(mtWarning,
         'Você excedeu o limite de tentativas de validação biométrica '+ #13 +
         'Informe ao responsável pelo CFC ' + #13 +
         'O programa vai ser finalizado!');
        ModalResult := mrCancel;
      end;

    end
    else
      ModalResult := mrOk;
  end
  else
    ModalResult := mrOk;
end;

function TFrm_Aviso.pRetornoBiometria(blnretonoBioFoto: Boolean): Boolean;
var
  txtDialogo: string;
begin
  Result := blnretonoBioFoto;

  if Result then
  begin
    Result := Operacao200500;

    if Result then
      ParCandidato.Foto := '';
  end
  else
  begin
    if ParFotoExame.DigitalMensagem <> '' then
      txtDialogo := ParFotoExame.DigitalMensagem;

    if txtDialogo <> EmptyStr then
      txtDialogo := txtDialogo + ', ';

    if ParFotoExame.FotoMensagem <> '' then
      txtDialogo := txtDialogo + ParFotoExame.FotoMensagem;

    txtDialogo := txtDialogo + #13+
      'Deseja tentar novamewnte?';

    Aviso(mtConfirmation, txtDialogo);
  end;
end;

function TFrm_Aviso.SEITran: Boolean;
Var
  objEnvioFinalSEITran: TEnvioFinalSEITran;
  objRetornoFinalSEITran: TRetronoSEITranFinal;
  objCon: TOperacaoRestful;
  TextoAviso: string;
begin

  objCon := TOperacaoRestful.Create(Self);
  objRetornoFinalSEITran := TRetronoSEITranFinal.Create;
  objEnvioFinalSEITran := TEnvioFinalSEITran.Create;
  objEnvioFinalSEITran.CFC := ParCFC.id_cfc;
  objEnvioFinalSEITran.CPF := ParCandidato.CPFCandidato;

  try
    if ParCFC.URLSEITrans <> '' then
    begin
      objRetornoFinalSEITran.AsJson := objCon.ExecutarConsultar
       (ParCFC.URLSEITrans + 'resultado/cpf', objEnvioFinalSEITran.AsJson,
       'A Prova não será finalizada!');

      ArquivoLog.GravaArquivoLog('Envio FINAL Seitran - ' + objEnvioFinalSEITran.AsJson);
      ArquivoLog.GravaArquivoLog('Envio FINAL Seitran CFC - ' + objEnvioFinalSEITran.CFC);
      ArquivoLog.GravaArquivoLog('Envio FINAL Seitran CPF - ' + objEnvioFinalSEITran.CPF);
      ArquivoLog.GravaArquivoLog('Path FINAL Seitran - ' + ParCFC.URLSEITrans + 'resultado/cpf');
      ArquivoLog.GravaArquivoLog('Retorno FINAL Seitran - ' + objRetornoFinalSEITran.AsJson);
      ArquivoLog.GravaArquivoLog('Retorno FINAL Seitran cod - ' +  objRetornoFinalSEITran.Retorno.codigo);
      ArquivoLog.GravaArquivoLog('Retorno FINAL Seitran descr - ' +  objRetornoFinalSEITran.Retorno.descricao);

      //Andre - forçar retorno OK do SEITran
      //objRetornoFinalSEITran.Retorno.codigo := 'B0000';   //<<<============

      if Assigned(objRetornoFinalSEITran.Retorno) then
      begin
        if objRetornoFinalSEITran.Retorno.codigo = '' then
        begin
          Result := False;
          TextoAviso := 'Falha na comunicação com o servidor SEITran.' + #13 +
          'Deseja tentar novamente?';

          ArquivoLog.GravaArquivoLog('Operação FIM prova SEITran. - ' +
            Trim(objRetornoFinalSEITran.Retorno.codigo));

          Aviso(mtConfirmation , TextoAviso);
        end
        else if objRetornoFinalSEITran.Retorno.codigo <> 'B0000' then
        begin
          Result := False;

          ArquivoLog.GravaArquivoLog('Operação FIM prova SEITran. - ' +
            Trim(objRetornoFinalSEITran.Retorno.codigo));

          TextoAviso := objRetornoFinalSEITran.Retorno.descricao  + #13 +
          'Deseja tentar novamente?';

          if objRetornoFinalSEITran.Retorno.descricao <> EmptyStr then
            Aviso(mtConfirmation , TextoAviso);
        end
        else
          Result := True;
      end;

    end
    else
      Result := True;

  finally
    ParCFC.AvisoSEITran := (Not Result);

    FreeAndNil(objCon);
    FreeAndNil(objRetornoFinalSEITran);
    FreeAndNil(objEnvioFinalSEITran);
  end;
end;

function TFrm_Aviso.Aviso(Tipo: TMsgDlgType; Texto: String): Boolean;
begin
  Result := True;

  lblAviso.Caption := '';
  lblAviso.Caption := Texto;
  lblAviso.Refresh;

  if Tipo = mtConfirmation then
    Button1.Visible := True
  else
    Button1.Visible := False;

  Button1.Refresh;
end;

procedure TFrm_Aviso.Button1Click(Sender: TObject);
begin
  lblAviso.Caption := '';
  lblAviso.Caption := 'Aguarde a aplicação concluir a prova!';
  lblAviso.Refresh;

  Button1.Visible := False;
  Button1.Refresh;

  TmrAvisos.Enabled := True;
end;

end.
