unit FrmBiometriaFotos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, TlHelp32,
  clsParametros, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, MSHTML, ClsOper300100,
  ClsCandidatoControl, ClseProvaConst, ClsServidorControl, ShellApi, Vcl.Imaging.pngimage,
  ClsFuncoes, Vcl.ComCtrls, Vcl.Imaging.jpeg, Winapi.MMSystem, IdCoderMIME, ClsOperacoes,
  ClsCFCControl, ClsQuestionario;

type
  TPropertyControl = RECORD
    PCLabel: TLabel;
    PCTrackbar: TTrackBar;
    PCCheckbox: TCheckBox;
  END;

  TFrm_BiometriaFotos = class(TForm)
    Panel1: TPanel;
    SBtAplicar: TSpeedButton;
    SBtSair: TSpeedButton;
    SBtCancelar: TSpeedButton;
    Timer1: TTimer;
    Panel5: TPanel;
    Panel2: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    ImgCapturada: TImage;
    SpeedButton_RunVideo: TSpeedButton;
    WebBrowser1: TWebBrowser;
    MmAvisoFlash: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure SBtSairClick(Sender: TObject);
    procedure SBtAplicarClick(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton_RunVideoClick(Sender: TObject);
    procedure SpeedButton_PauseClick(Sender: TObject);
  private
    ImagemPadrao: TPngImage;
    Function LRPad(Str: String; Size: Integer; Pad: char; LorR: char): string;
    procedure ExecuteScript(doc: IHTMLDocument2; script: string; language: string);
    procedure InicializarBiometria;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_BiometriaFotos: TFrm_BiometriaFotos;
  FotoCapturada, BiometriaInicializada, Reinicia: Boolean;

implementation

uses FrmAvisoOperacoes, FrmPrincipal, clsDialogos;

{$R *.dfm}

procedure TFrm_BiometriaFotos.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  { Encerra o java }
  WebBrowser1.Navigate('about:blank');
  KillTask('java.exe');
  KillTask('jp2launcher.exe');

  if not Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;

end;

procedure TFrm_BiometriaFotos.FormCreate(Sender: TObject);
begin
  Reinicia := False;
  ImagemPadrao := TPngImage.Create;
  ImagemPadrao.Assign(ImgCapturada.Picture.Graphic);
end;

procedure TFrm_BiometriaFotos.FormShow(Sender: TObject);
begin

  if ParCandidato.ResgistrarPresenca then
    SBtAplicar.Caption := '&Registrar'
  else
    SBtAplicar.Caption := '&Próximo';

  BiometriaInicializada := False;
  FotoCapturada := False;
  InicializarBiometria;

  if (TelaExameBiometriaFoto) and (ParQuestionario.Id_prova > 0) then
    SBtCancelar.Visible := False
  else
    SBtCancelar.Visible := True;

end;

procedure TFrm_BiometriaFotos.SBtAplicarClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper300Env: T300100Envio;
  Oper300ret: T300100Retorno;
begin

  SBtAplicar.Enabled := False;

  if ParCandidato.ResgistrarPresenca then
  begin

    // Efetuar a operação 300100
    Consulta := MainOperacao.Create(Self);
    Oper300Env := T300100Envio.Create;
    Oper300ret := T300100Retorno.Create;
    Oper300ret.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper300Env.MontaXMLEnvio(ParCandidato.IdCandidato, ParCandidato.Foto)));

    if Trim(Oper300ret.codigo) = 'B000' then
    begin
      DialogoMensagem('A presença foi registrada com sucesso!', mtInformation);

      Reinicia := True;
      TelaFoto := False;
      TelaBiometria := False;
      TelaBiometriaFoto := False;

      if ParCandidato.ResgistrarPresenca then
      begin
        TelaIdentificaCandidato := True;
        TelaConfirmacao := False
      end
      else
      begin
        TelaIdentificaCandidato := False;
        if ParCFC.Tela_Teclado = 'S' then
        begin
          TelaConfirmacao := False;
          TelaTeclado := True;
        end
        else
        begin
          TelaConfirmacao := True;
          TelaTeclado := False;
        end;
      end;

      Frm_Menu.AbreTela;
      Close;
    end
    else
    begin

      if TelaExameBiometriaFoto and (Oper300ret.codigo = 'D998') then
      begin

        Reinicia := True;
        TelaFoto := False;
        TelaBiometria := False;
        TelaBiometriaFoto := False;

        if ParCandidato.ResgistrarPresenca then
        begin
          TelaIdentificaCandidato := True;
          TelaConfirmacao := False
        end
        else
        begin
          TelaIdentificaCandidato := False;
          if ParCFC.Tela_Teclado = 'S' then
          begin
            TelaConfirmacao := False;
            TelaTeclado := True;
          end
          else
          begin
            TelaConfirmacao := True;
            TelaTeclado := False;
          end;
        end;

        Frm_Menu.AbreTela;
        Close;

      end
      else
      begin
        DialogoMensagem(Oper300ret.mensagem, mtInformation);
        Self.Repaint;
      end;
    end;

  end
  else
  begin

    TelaIdentificaCandidato := False;
    TelaFoto := False;
    TelaBiometria := False;
    TelaBiometriaFoto := False;

    if TelaExameBiometriaFoto then
    begin
      Reinicia := True;

      TelaIdentificaCandidato := False;
      TelaFoto := False;
      TelaBiometria := False;
      TelaInformacoes := False;
      TelaTeclado := False;
      TelaConfirmacao := False;
      TelaQuestionario := False;
    end
    else if TelaResultadoBiometriaFoto then
    begin
      Reinicia := True;

      TelaResultadoBiometriaFoto := False;
      TelaIdentificaCandidato := False;
      TelaFoto := False;
      TelaBiometria := False;
      TelaInformacoes := False;
      TelaTeclado := False;
      TelaConfirmacao := False;
      TelaQuestionario := False;
      TelaResultado := True;
    end
    else if ParCFC.Tela_Teclado = 'S' then
    begin
      TelaConfirmacao := False;
      TelaTeclado := True;
    end
    else
    begin
      TelaConfirmacao := True;
      TelaTeclado := False;
    end;

    Reinicia := True;

    if TelaExameBiometriaFoto then
      ModalResult := mrOk
    else
      Frm_Menu.AbreTela;

    Close;
  end;
end;

Function TFrm_BiometriaFotos.LRPad(Str: String; Size: Integer; Pad: char; LorR: char): string;
var
  i, cont: Integer;
  s: string;
begin

  cont := Length(Str);
  s := '';

  if upCase(LorR) = 'L' then
  begin
    for i := 1 to Size - cont do
      s := s + Pad;
    s := s + Str;
  end
  else
  begin
    for i := 1 to Size - cont do
      s := s + Pad;
    s := Str + s;
  end;

  LRPad := copy(s, 1, Size);

end;

procedure TFrm_BiometriaFotos.SBtSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_BiometriaFotos.SpeedButton_PauseClick(Sender: TObject);
var
  strmFoto: TMemoryStream;
  jpgFoto: TJPEGImage;
  IdDecoderMIME1: TIdDecoderMIME;
begin

  // Exemplo para chamar o flash
  // ExternalInterface.addCallback("captura",captureImagem);
  // Tirar "<string> </string>"

  strmFoto := TMemoryStream.Create;
//  ParCandidato.Foto := ShockwaveFlash1.CallFunction('<invoke name="captura"><arguments><string>captureImagem</string></arguments></invoke>');
  ParCandidato.Foto := ReplaceStr(ParCandidato.Foto, '<string>', '');
  ParCandidato.Foto := ReplaceStr(ParCandidato.Foto, '</string>', '');

  if ParCandidato.Foto <> ImgNul then
  begin

//    ShockwaveFlash1.Left := 1005;
//    ShockwaveFlash1.Top := 1009;
//    ShockwaveFlash1.Stop;

    ImgCapturada.Left := 5;
    ImgCapturada.Top := 95;

    IdDecoderMIME1 := TIdDecoderMIME.Create(Self);
    IdDecoderMIME1.DecodeStream(ParCandidato.Foto, strmFoto);
    strmFoto.Position := 0;

    jpgFoto := TJPEGImage.Create;
    jpgFoto.LoadFromStream(strmFoto);

    ImgCapturada.Visible := True;
    ImgCapturada.Picture.Bitmap := nil;
    ImgCapturada.Picture.Graphic := nil;
    ImgCapturada.Picture.Assign(jpgFoto);

    SBtAplicar.Enabled := False;

    ArquivoLog.GravaArquivoLog('Desligando a câmera');

    if ParCandidato.Foto <> '' then
    begin
      SBtAplicar.Enabled := True;

      if TelaExameBiometriaFoto then
        SBtAplicarClick(Self);
    end;

  end
  else
  begin
    // “ Prezado usuário é necessário clicar no Botão Permitir para que o Botão Próximo seja habilitado.Caso o Botão Negar seja pressionado é necessário clicar no
    // Botão Reiniciar para que o Botão Próximo seja habilitado ”.
  end;

end;

procedure TFrm_BiometriaFotos.SpeedButton_RunVideoClick(Sender: TObject);
begin
  ExecuteScript(WebBrowser1.Document as IHTMLDocument2, 'finalizar()', 'javascript');
  Sleep(3000);
  InicializarBiometria;
end;

procedure TFrm_BiometriaFotos.SBtCancelarClick(Sender: TObject);
begin

  Reinicia := True;

  if TelaExameBiometriaFoto then
  begin
    TelaIdentificaCandidato := False;
    TelaFoto := False;
    TelaBiometria := False;
    TelaInformacoes := False;
    TelaTeclado := False;
    TelaConfirmacao := False;
    TelaQuestionario := False;
    ModalResult := mrOk
  end
  else
  begin
    TelaIdentificaCandidato := True;
    TelaFoto := False;
    TelaBiometria := False;
    TelaBiometriaFoto := False;
    TelaConfirmacao := False;
    Frm_Menu.AbreTela;
  end;

  Close;

end;

procedure TFrm_BiometriaFotos.Timer1Timer(Sender: TObject);
var
  Tr: IHTMLTxtRange;
begin

  try

    if Assigned(WebBrowser1.Document) then
    begin

      Tr := ((WebBrowser1.Document AS IHTMLDocument2).body AS IHTMLBodyElement).CreateTextRange;

      if Tr <> nil then
      begin

        if (Trim(Tr.text) = '2') then
        begin

          Try
            Timer1.Enabled := False;

            if ParServidor.ID_Sistema = 591804 then
            begin

              if TelaExameBiometriaFoto then
                ParCandidato.Bloqueado := 'S';

              if TelaExameBiometriaFoto then
              begin
                DialogoMensagem('As biometrias não conferem. A prova será bloqueada.' + #13 + 'Aguarde o desbloqueio que será realizado pelo DETRAN.',
                  mtWarning);
                Application.Terminate;
              end
              else
              begin
                DialogoMensagem('As biometrias não conferem com as que foram cadastradas na matrícula.' + #13 + 'Faça o recadastro das biometrias.', mtWarning);
                SpeedButton_RunVideoClick(Self);
              end;

            end
            else
            begin

              // Neste momento passa a ser exeção digital nesta prova
              // porque a biometria não confere
              ParCandidato.Excecao := 'A';

              if ParServidor.ID_Sistema = 806076 then // 806076 = id do Sistema de Alagoas
              begin
                if ParCandidato.TipoProva = 'S' then
                  DialogoMensagem('A exceção digital automática foi confirmada. ' + 'Essa captura e o Teste Simulado estão sendo marcado e será auditado.',
                    mtWarning)
                else
                  DialogoMensagem('A exceção digital automática foi confirmada. ' + 'Essa captura e a Prova estão sendo marcado e será auditado.', mtWarning);
              end
              else
              begin
                if ParCandidato.TipoProva = 'S' then
                  DialogoMensagem('A exceção digital automática foi confirmada. ' +
                    'Essa captura e o Teste Simulado estão sendo marcados e serão auditados pelo DETRAN.', mtWarning)
                else
                  DialogoMensagem('A exceção digital automática foi confirmada. ' +
                    'Essa captura e a Prova estão sendo marcadas e serão auditadas pelo DETRAN.', mtWarning);

              end;

              ExecuteScript(WebBrowser1.Document as IHTMLDocument2, 'finalizar()', 'javascript');
              SpeedButton_PauseClick(Self);
            end;
          except
            on E: Exception do
            begin
              ArquivoLog.GravaArquivoLog('Biometria/Foto - Exeção - ' + E.Message);
            end;
          End;

        end;

        if Trim(Tr.text) = '9' then
        begin
          Try
            SBtAplicar.Enabled := False;
            { ???????????????????? }
          except
            on E: Exception do
            begin
              ArquivoLog.GravaArquivoLog('Biometria/Foto - Aguardando - ' + E.Message);
            end;
          End;

        end;

        if Pos('FOTO', Trim(Tr.text)) > 0 then
        begin
          if not FotoCapturada then
          begin

            Try
              FotoCapturada := True;
              SpeedButton_PauseClick(Self);
            except
              on E: Exception do
              begin
                ArquivoLog.GravaArquivoLog('Biometria/Foto - Foto - ' + E.Message);
              end;
            End;

          end;
        end;

        if Pos('SUCESSO:', Trim(Tr.text)) > 0 then
        begin

          Try
            Timer1.Enabled := False;
            SpeedButton_PauseClick(Self);
          except
            on E: Exception do
            begin
              ArquivoLog.GravaArquivoLog('Biometria/Foto - Sucesso - ' + E.Message);
            end;
          End;

        end;

      end;

    end;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Applet - Exeção - ' + E.Message);
    end;

  End;

end;

procedure TFrm_BiometriaFotos.ExecuteScript(doc: IHTMLDocument2; script: string; language: string);
begin
  if doc <> nil then
  begin
    if doc.parentWindow <> nil then
      doc.parentWindow.ExecScript(script, OleVariant(language));
  end;
end;

procedure TFrm_BiometriaFotos.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  WebBrowser1.OleObject.Document.body.Style.OverflowX := 'hidden';
  WebBrowser1.OleObject.Document.body.Style.OverflowY := 'hidden';

  Timer1.Enabled := True;
end;

procedure TFrm_BiometriaFotos.InicializarBiometria;
begin

  ImgCapturada.Left := 1005;
  ImgCapturada.Top := 1009;

//  ShockwaveFlash1.Left := 5;
//  ShockwaveFlash1.Top := 95;
//  ShockwaveFlash1.Stop;

  if FileExists(UserProfileDir + strFileProva + '\captura_foto.swf') then
  begin
//    ShockwaveFlash1.Base := UserProfileDir + strFileProva + '\captura_foto.swf';
//    ShockwaveFlash1.Movie := UserProfileDir + strFileProva + '\captura_foto.swf';
  end
  else if FileExists(UserProgranData + strFileProva +  '\captura_foto.swf') then
  begin
//    ShockwaveFlash1.Base := UserProgranData + strFileProva + '\captura_foto.swf';
//    ShockwaveFlash1.Movie := UserProgranData + strFileProva + '\captura_foto.swf';
  end;

//  ShockwaveFlash1.Play;

  ImgCapturada.Picture.Bitmap := nil;
  ImgCapturada.Picture.Graphic := nil;

  SBtAplicar.Enabled := False;
  Sleep(3000);

  { Encerra o java }
  WebBrowser1.Navigate('about:blank');
  KillTask('java.exe');
  KillTask('jp2launcher.exe');

  WebBrowser1.Navigate(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=' + ParCFC.UF +
    ParCandidato.RENACHCandidato + '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');

  ArquivoLog.GravaArquivoLog(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=' + ParCFC.UF +
    ParCandidato.RENACHCandidato + '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');

end;

end.
