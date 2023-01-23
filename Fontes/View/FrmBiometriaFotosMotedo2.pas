unit FrmBiometriaFotosMotedo2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Win.ScktComp, Winapi.MMSystem, SHDocVw, TlHelp32, ShellApi,
  clsParametros, ClsOper300100, Vcl.Graphics, MSHTML, Vcl.Controls, Vcl.Forms, ClsServidorControl,
  Vcl.Dialogs, Vcl.OleCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, ClsCandidatoControl,
  ClsCFCControl, ClsOperacoes, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.ComCtrls,
  IdCoderMIME;

type
  TFrm_BiometriaFotosMotedo2 = class(TForm)
    Panel1: TPanel;
    SBtAplicar: TSpeedButton;
    SBtRecarregar: TSpeedButton;
    SBtSair: TSpeedButton;
    SBtCancelar: TSpeedButton;
    Timer1: TTimer;
    Panel5: TPanel;
    Panel2: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    ImgCapturada: TImage;
    SpeedButton_Pause: TSpeedButton;
    SpeedButton_Stop: TSpeedButton;
    SpeedButton_RunVideo: TSpeedButton;
    Label_Cameras: TLabel;
    ComboBox_Cams: TComboBox;
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure SBtSairClick(Sender: TObject);
    procedure SBtAplicarClick(Sender: TObject);
    procedure SBtRecarregarClick(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton_RunVideoClick(Sender: TObject);
    procedure SpeedButton_PauseClick(Sender: TObject);
    procedure SpeedButton_StopClick(Sender: TObject);
    procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
  private
    ImagemPadrao: TPngImage;
    Arquivo: TMemoryStream;

    Function LRPad(Str: String; Size: integer; Pad: char; LorR: char): string;
    function Gerafoto(Foto: TMemoryStream): WideString;
    procedure ExecuteScript(doc: IHTMLDocument2; script: string; language: string);
    function BmpToJpg(MyBMP: TBitmap): TJPEGImage;
    procedure InicializarBiometria;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_BiometriaFotosMotedo2: TFrm_BiometriaFotosMotedo2;
  FotoCapturada, BiometriaInicializada, Reinicia: Boolean;

implementation

uses FrmAvisoOperacoes, FrmPrincipal, ClsFuncoes, clsDialogos;

{$R *.dfm}

function TFrm_BiometriaFotosMotedo2.BmpToJpg(MyBMP: TBitmap): TJPEGImage;
begin
  Result := TJPEGImage.Create;
  try
    with MyBMP do
    begin
      with Result do
      begin
        Assign(MyBMP);
        CompressionQuality := 75; // min. 1 - max. 100
        Compress;
      end;
    end;
  finally

  end;
end;

procedure TFrm_BiometriaFotosMotedo2.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  try
//    Camera1.Actif := False;
  except

  end;

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

procedure TFrm_BiometriaFotosMotedo2.FormCreate(Sender: TObject);
begin
  Reinicia := False;
  ImagemPadrao := TPngImage.Create;
  ImagemPadrao.Assign(ImgCapturada.Picture.Graphic);
  ImgCapturada.Left := 2;
end;

procedure TFrm_BiometriaFotosMotedo2.FormShow(Sender: TObject);
begin

  if ParCandidato.ResgistrarPresenca then
    SBtAplicar.Caption := '&Registrar'
  else
    SBtAplicar.Caption := '&Próximo';

  ComboBox_Cams.Items.Clear;

  try
    ImgCapturada.Left := 500;

//    Camera1.Left := 6;
//    Camera1.Actif := True;

    InicializarBiometria;

//    ComboBox_Cams.Items.Add(Camera1.CaptureDriverName);
    ComboBox_Cams.ItemIndex := 0;

  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Falha na camera: ' + E.Message);
      MessageDlg('Não foi encontrada a Webcam.' + #13 + 'Certifique-se de que a câmera esteja conectada ' + 'e corretamente configurada.', mtError, [mbOk], 0);
    end;
  end;

  BiometriaInicializada := False;
  FotoCapturada := False;

end;

procedure TFrm_BiometriaFotosMotedo2.SBtAplicarClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper300100Env: T300100Envio;
  Oper300100Ret: T300100Retorno;
begin

  SBtAplicar.Enabled := False;

  if ParCandidato.ResgistrarPresenca then
  begin
    // Efetuar a operação 300100
    Oper300100Env := T300100Envio.Create;
    Oper300100Ret := T300100Retorno.Create;
    Consulta := MainOperacao.Create(Self, '100700');
    Oper300100Ret.MontaRetorno(Consulta.consultar(IntToStr(ParServidor.ID_Sistema), Oper300100Env.MontaXMLEnvio(ParCandidato.IdCandidato, ParCandidato.Foto)));

    if Oper300100Ret.IsValid then
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
    Else
    begin
      DialogoMensagem(Oper300100Ret.mensagem, mtInformation);
      Self.Repaint;
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

procedure TFrm_BiometriaFotosMotedo2.SBtRecarregarClick(Sender: TObject);
begin
  SBtAplicar.Enabled := False;
  SBtRecarregar.Enabled := True;
  ImgCapturada.Picture.Bitmap.Empty;
  ImgCapturada.Picture.Graphic.Empty;

  { Encerra o java }
  try
    ExecuteScript(WebBrowser1.Document as IHTMLDocument2, 'finalizar()', 'javascript');
    Sleep(3000);
    WebBrowser1.Navigate('about:blank');
    KillTask('java.exe');
    KillTask('jp2launcher.exe');

    WebBrowser1.Navigate(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=BA' + ParCandidato.RENACHCandidato +
      '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');
  except
    on E: Exception do
    begin

    end;
  end;
end;

Function TFrm_BiometriaFotosMotedo2.LRPad(Str: String; Size: integer; Pad: char; LorR: char): string;
var
  i, cont: integer;
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

procedure TFrm_BiometriaFotosMotedo2.SBtSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_BiometriaFotosMotedo2.SpeedButton_PauseClick(Sender: TObject);
var
  BMP: TBitmap;
begin

  ImgCapturada.Left := 2;

//  Camera1.Left := 500;

  SBtAplicar.Enabled := False;

  ImgCapturada.Picture.Bitmap.Empty;
  ImgCapturada.Picture.Graphic.Empty;

//  Camera1.CapturaImagem(ImgCapturada);

  BMP := TBitmap.Create;
  BMP.Assign(ImgCapturada.Picture.Bitmap);

  ImgCapturada.Picture.Bitmap := nil;
  ImgCapturada.Picture.Graphic := nil;

  ImgCapturada.Picture.Assign(BmpToJpg(BMP));

  ArquivoLog.GravaArquivoLog('Operação 300');

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Screen.Cursor := crDefault;
  SpeedButton_Pause.Enabled := False;

  if Arquivo = nil then
    Arquivo := TMemoryStream.Create
  else
    Arquivo.Clear;

  ImgCapturada.Picture.Graphic.SaveToStream(Arquivo);

  if Arquivo.Size > 0 then
  begin
    SBtAplicar.Enabled := True;
    ParCandidato.Foto := Gerafoto(Arquivo);

    if TelaExameBiometriaFoto then
      SBtAplicarClick(Self);

  end;

end;

procedure TFrm_BiometriaFotosMotedo2.SpeedButton_RunVideoClick(Sender: TObject);
begin
  ImgCapturada.Left := 500;
  SBtAplicar.Enabled := False;

//  Camera1.Left := 6;
//  Camera1.Actif := False;
//  Camera1.Actif := True;

  InicializarBiometria;
end;

procedure TFrm_BiometriaFotosMotedo2.SpeedButton_StopClick(Sender: TObject);
begin

  ImgCapturada.Left := 2;
//  Camera1.Left := 500;
  ComboBox_Cams.Items.Clear;

  SBtAplicar.Enabled := False;

//  if Camera1.Actif then
//  begin
//    Camera1.SelectConfig;
//
//    Camera1.Actif := False;
//    Camera1.Actif := True;
//
//    ComboBox_Cams.Items.Add(Camera1.CaptureDriverName);
//    ComboBox_Cams.ItemIndex := 0;
//
//    ImgCapturada.Left := 500;
//    Camera1.Left := 6;
//
//  end
//  else
//  begin
//    try
//      Camera1.Actif := True;
//      Camera1.SelectConfig;
//
//      ImgCapturada.Left := 500;
//      Camera1.Left := 6;
//
//      Camera1.Actif := False;
//      Camera1.Actif := True;
//
//      ComboBox_Cams.Items.Add(Camera1.CaptureDriverName);
//      ComboBox_Cams.ItemIndex := 0;
//
//    except
//      on E: Exception do
//      begin
//        ArquivoLog.GravaArquivoLog('Falha na camera: ' + E.Message);
//        MessageDlg('Não foi encontrada a Webcam.' + #13 + 'Certifique-se de que a câmera esteja conectada ' + 'e corretamente configurada.', mtError,
//          [mbOk], 0);
//      end;
//    end;
//  end;
end;

procedure TFrm_BiometriaFotosMotedo2.SBtCancelarClick(Sender: TObject);
begin
  Reinicia := True;
  TelaTerminarAplicacao := False;
  TelaIdentificaCandidato := True;
  TelaFoto := False;
  TelaBiometria := False;
  TelaBiometriaFoto := False;
  TelaConfirmacao := False;
  Frm_Menu.AbreTela;
  Close;
end;

function TFrm_BiometriaFotosMotedo2.Gerafoto(Foto: TMemoryStream): WideString;
var
  IdEncoderMIME1: TIdEncoderMIME;
begin

  Foto.Position := 0;
  IdEncoderMIME1 := TIdEncoderMIME.Create(Self);
  Result := IdEncoderMIME1.EncodeStream(Foto, Foto.Size);

end;

procedure TFrm_BiometriaFotosMotedo2.Timer1Timer(Sender: TObject);
var
  Tr: IHTMLTxtRange;
begin

  try

    if Assigned(WebBrowser1.Document) then
    begin

      if ((WebBrowser1.Document AS IHTMLDocument2).body AS IHTMLBodyElement) <> nil then
        Tr := ((WebBrowser1.Document AS IHTMLDocument2).body AS IHTMLBodyElement).CreateTextRange;

      Application.ProcessMessages;

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
              DialogoMensagem('As biometrias não conferem. A prova será bloqueada.' + #13 + 'Aguarde o desbloqueio que será realizado pelo DETRAN.', mtWarning);
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
                DialogoMensagem('A exceção digital automática foi confirmada. ' + 'Essa captura e a Prova estão sendo marcadas e serão auditadas pelo DETRAN.',
                  mtWarning);

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
  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Applet - Exeção - ' + E.Message);
    end;
  End;

end;

procedure TFrm_BiometriaFotosMotedo2.ExecuteScript(doc: IHTMLDocument2; script: string; language: string);
begin
  try
    if doc <> nil then
    begin
      if doc.parentWindow <> nil then
        doc.parentWindow.ExecScript(script, OleVariant(language));
    end;
  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Falha no apllet - execução do script ');
  end;
end;

procedure TFrm_BiometriaFotosMotedo2.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  WebBrowser1.OleObject.Document.body.Style.OverflowX := 'hidden';
  WebBrowser1.OleObject.Document.body.Style.OverflowY := 'hidden';
  Timer1.Enabled := True;
end;

procedure TFrm_BiometriaFotosMotedo2.WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  ArquivoLog.GravaArquivoLog('Falha no apllet ');
  ArquivoLog.GravaArquivoLog('Falha no apllet - Disp: ' + VarToStr(pDisp) + ' - URL: ' + URL + ' - Frame: ' + Frame + ' - StatusCode: ' + StatusCode);
end;

procedure TFrm_BiometriaFotosMotedo2.InicializarBiometria;
begin
  { Encerra o java }
  WebBrowser1.Navigate('about:blank');
  KillTask('java.exe');
  KillTask('jp2launcher.exe');

  Sleep(3000);

  WebBrowser1.Navigate(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=' + ParCFC.UF +
    ParCandidato.RENACHCandidato + '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');

  ArquivoLog.GravaArquivoLog(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=' + ParCFC.UF +
    ParCandidato.RENACHCandidato + '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');
end;

end.
