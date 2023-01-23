unit ClsDigitalFotoExame;

interface

uses System.Classes, System.SysUtils, Vcl.Dialogs, Vcl.Controls, ClsCFCControl,
  ClsParametros, ClsDigitalFoto, ClsServidorControl, ClsFuncoes,
  ClsCandidatoControl,
  System.UITypes;

type
  TDigitalFotoExame = class(TComponent)
  protected
  public
    Prova_Ativo: Boolean;
    Prova_Quantidades: Integer;
    Prova_Tempo: Integer;

    Simulado_Ativo: Boolean;
    Simulado_Quantidades: Integer;
    Simulado_Tempo: Integer;

    FotoCodigo: string;
    FotoMensagem: string;

    DigitalCodigo: string;
    DigitalMensagem: string;

    function Foto: Boolean;
    function BiometriaFoto: Boolean;
  end;

var
  ParFotoExame: TDigitalFotoExame;

implementation

uses ClsMonitoramentoFFMpeg, ClsMonitoramentoRTSPControl, FrmBiometria;

function TDigitalFotoExame.BiometriaFoto: Boolean;
var
  Digital: TDigitalRest;
  Ret: TRetornoRest;
  NovaBiometria: Boolean;
  ThreadFFMpeg: TThreadFFMpeg;
begin

  if Trim(ParMonitoramentoFluxoRTSP.Cam) <> '' then
  begin
    ThreadFFMpeg := TThreadFFMpeg.Create;
    ThreadFFMpeg.NameThreadForDebugging('MatarFFMpeg', ThreadFFMpeg.ThreadID);
    ThreadFFMpeg.MatarFFMpeg := True;
    ThreadFFMpeg.Start;
  end;

  Result := False;
  NovaBiometria := False;

  if (Parametros.TipoBiometria = 'C#') or (Parametros.TipoBiometria = 'XE') then
    NovaBiometria := True;

 // TelaExameBiometriaFoto := True;

  // Tela de BiometriaFoto
  if ParCandidato.TipoProva = 'P' then
  begin

     if ParCFC.biometria_Foto_Prova = 'S' then
    begin

      if NovaBiometria then
      begin
        if ParCandidato.Excecao = 'N' then
        begin
          Digital := TDigitalRest.Create;
          Ret := TRetornoRest.Create;
          Ret.MontaRetorno(Digital.conect());

          if Ret.IsValid then
          begin
            if foto then
              Result:= True
            else
              begin
                Result:= false;
              end;
          end;

          DigitalCodigo := Ret.Codigo;
          DigitalMensagem := Ret.Mensagem;
        end
        else
        begin
          if foto then
            Result:= True
          else
            begin
              Result:= false;
            end;
        end;
      end
      else
        TelaBiometria := True;

    end;

  end;

  if ParCandidato.TipoProva = 'S' then
  begin

    if ParCFC.Biometria_Foto_Simulado = 'S' then
    begin

      if NovaBiometria then
      begin

        Digital := TDigitalRest.Create;
        Ret := TRetornoRest.Create;
        Ret.MontaRetorno(Digital.conect());

        if Ret.IsValid then
        begin
          // Segundo o Sérigio no dia 14/09/2017 as 14:50
          // durante a prova pode coletar apenas as biometrias
          // mantendo a foto e biometria no inicio da prova
          // Ret.MontaRetorno(Foto.conect());
          Foto;
          Result := Ret.IsValid;
          // ParCandidato.Foto := Ret.Foto;
        end;

        DigitalCodigo := Ret.Codigo;
        DigitalMensagem := Ret.Mensagem;

      end
      else
        TelaBiometria := True;

    end;

  end;
    // TelaExameBiometriaFoto:= false;
  if TelaExameBiometriaFoto then
  begin

    if TelaBiometria then
    begin

      try

        FindComponent('Frm_Biometria').Free;
        Frm_Biometria := TFrm_Biometria.Create(Self);
        // SalvarForm(Frm_Biometria);
        AtualizarForm(Frm_Biometria, ParServidor.ID_Sistema);
        Frm_Biometria.ShowModal;

        if Frm_Biometria.ModalResult = mrok then
        begin
          Result := False;
          ParCandidato.Bloqueado := 'S';
          FotoCodigo := 'B000';
          FotoMensagem := 'Biometria capturada com sucesso';
        end
        else
        begin
          Result := True;
          ParCandidato.Bloqueado := 'N';
          FotoCodigo := 'D010';
          FotoMensagem := 'Falha ao verificar a biometria';
        end;

      except
        on E: Exception do
          MessageDlg
            ('Falha ao capturar a foto, entre em contato com o suporte!!',
            mtInformation, [mbOK], 0);
      end;

    end
    else
    begin

      if (ParFotoExame.DigitalCodigo = 'B995') or
         (ParFotoExame.DigitalCodigo = 'B900') or
         (ParFotoExame.FotoCodigo = 'B900') then
           ParCandidato.Bloqueado := 'S'
      else
        ParCandidato.Bloqueado := 'N';

    end;

  end;

end;

function TDigitalFotoExame.Foto: Boolean;
var
  Foto: TFotoRest;
  Ret: TRetornoRest;
  NovaBiometria: Boolean;
begin

  Result := False;
  NovaBiometria := False;

  if (Parametros.TipoBiometria = 'C#') or (Parametros.TipoBiometria = 'XE') then
    NovaBiometria := True;

  // Tela de Foto
  if ParCandidato.TipoProva = 'P' then
  begin

    if ParCFC.Foto_Prova = 'S' then
    begin

      if NovaBiometria then
      begin

        Foto := TFotoRest.Create;
        Ret := TRetornoRest.Create;

        try
          Ret.MontaRetorno(Foto.conect());
          Result := Ret.IsValid;
          FotoCodigo := Ret.Codigo;
          FotoMensagem := Ret.Mensagem;
          ParCandidato.Foto := Ret.Foto;
        finally
          Foto.Free;
          Ret.Free;
        end;
      end
      else
        TelaBiometria := True;
    end;

  end;

  if ParCandidato.TipoProva = 'S' then
  begin
    if ParCFC.Foto_Simulado = 'S' then
    begin
      if NovaBiometria then
      begin
        Foto := TFotoRest.Create;
        Ret := TRetornoRest.Create;
        Ret.MontaRetorno(Foto.conect());
        Result := Ret.IsValid;
        FotoCodigo := Ret.Codigo;
        FotoMensagem := Ret.Mensagem;
        ParCandidato.Foto := Ret.Foto;
      end
      else
        TelaBiometria := True;
    end;
  end;

end;

end.
