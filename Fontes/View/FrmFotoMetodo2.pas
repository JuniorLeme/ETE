unit FrmFotoMetodo2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Win.ScktComp, Winapi.MMSystem, SHDocVw, TlHelp32, ShellApi,
  clsParametros, ClsOper300100, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.OleCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, MSHTML, IdCoderMIME,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.ComCtrls, ClsOperacoes, ClsCFCControl,
  ClsCandidatoControl, ClsServidorControl;

type
  TFrm_FotoMetodo2 = class(TForm)
    Panel1: TPanel;
    SBtAplicar: TSpeedButton;
    SBtRecarregar: TSpeedButton;
    SBtSair: TSpeedButton;
    SBtCancelar: TSpeedButton;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Image3: TImage;
    SpeedButton_Pause: TSpeedButton;
    ImgCapturada: TImage;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    ComboBox_DisplayMode: TComboBox;
    SpeedButton_Stop: TSpeedButton;
    Label_Cameras: TLabel;
    ComboBox_Cams: TComboBox;
    procedure SBtSairClick(Sender: TObject);
    procedure SBtAplicarClick(Sender: TObject);
    procedure SBtRecarregarClick(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton_PauseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton_StopClick(Sender: TObject);

  private
    OperMonit: Integer;
    Arquivo: TMemoryStream;
    RecebendoArquivo: Boolean;
    Function LRPad(Str: String; Size: Integer; Pad: char; LorR: char): string;
    function Gerafoto(Foto: TMemoryStream): WideString;
    function BmpToJpg(MyBMP: TBitmap): TJPEGImage;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_FotoMetodo2: TFrm_FotoMetodo2;
  Reinicia: Boolean;

implementation

uses FrmAvisoOperacoes, FrmPrincipal, ClsFuncoes, clsDialogos;
{$R *.dfm}

procedure TFrm_FotoMetodo2.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  try
//    Camera1.Actif := False;
  except

  end;

  if NOT Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;

end;

procedure TFrm_FotoMetodo2.FormShow(Sender: TObject);
begin

  Reinicia := False;
  TelaTerminarAplicacao := False;

  if ParCandidato.ResgistrarPresenca then
  begin
    if ParCandidato.Excecao = 'S' then
      SBtAplicar.Caption := '&Registrar'
    else
      SBtAplicar.Caption := '&Próximo';
  end
  else
    SBtAplicar.Caption := '&Próximo';

  ComboBox_Cams.Items.Clear;

  try
//    Camera1.Actif := True;
  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Falha na camera: ' + E.Message);
      MessageDlg('Não foi encontrada a Webcam.' + #13 + 'Certifique-se de que a câmera esteja conectada ' + 'e corretamente configurada.', mtError, [mbOk], 0);
    end;
  end;

  try
//    if Camera1.Actif then
//    begin
//      ComboBox_Cams.Items.Add(Camera1.CaptureDriverName);
//      ComboBox_Cams.ItemIndex := 0;
//    end
//    else
//    begin
//      ComboBox_Cams.Items.Add('Nenhuma câmera foi identificada');
//      ComboBox_Cams.ItemIndex := 0;
//    end;
  except
    on E: Exception do
      ArquivoLog.GravaArquivoLog('Falha na identificação do nome da camera: ' + E.Message);
  end;

end;

procedure TFrm_FotoMetodo2.SBtAplicarClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper300100Env: T300100Envio;
  Oper300100Ret: T300100Retorno;
begin

  SBtAplicar.Enabled := False;

  if (ParCandidato.Excecao = 'S') then
  begin
    if (ParCandidato.ResgistrarPresenca) then
    BEGIN

      // Efetuar a operação 300100
      Oper300100Env := T300100Envio.Create;
      Oper300100Ret := T300100Retorno.Create;
      Consulta := MainOperacao.Create(Self, '100700');
      Oper300100Ret.MontaRetorno(Consulta.consultar(IntToStr(ParServidor.ID_Sistema), Oper300100Env.MontaXMLEnvio(ParCandidato.IdCandidato,
        ParCandidato.Foto)));

      if Oper300100Ret.IsValid then
      begin
        DialogoMensagem('A presença foi registrada com sucesso!', mtInformation);

        TelaFoto := False;
        TelaBiometria := False;
        TelaConfirmacao := False;
        TelaIdentificaCandidato := True;
        Reinicia := True;
        Frm_Menu.AbreTela;
        Close;
      end
      else
      begin
        DialogoMensagem(Oper300100Ret.mensagem, mtInformation);
        SBtRecarregar.Enabled := True;
        Self.Repaint;
      end;

    END
    else
    begin
      TelaIdentificaCandidato := False;
      TelaFoto := False;
      TelaBiometria := False;
      Reinicia := True;

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

      if TelaExameBiometriaFoto then
        ModalResult := mrOk
      else
        Frm_Menu.AbreTela;

      Close;
    end;
  end
  else
  begin
    TelaIdentificaCandidato := False;
    TelaFoto := False;
    TelaBiometria := True;
    TelaConfirmacao := False;
    Reinicia := True;
    Frm_Menu.AbreTela;
    Close;
  end;
end;

function TFrm_FotoMetodo2.Gerafoto(Foto: TMemoryStream): WideString;
var
  IdEncoderMIME1: TIdEncoderMIME;
begin
  Foto.Position := 0;
  IdEncoderMIME1 := TIdEncoderMIME.Create(Self);
  Result := IdEncoderMIME1.EncodeStream(Foto, Foto.Size);
end;

procedure TFrm_FotoMetodo2.SBtRecarregarClick(Sender: TObject);
begin
  SBtAplicar.Enabled := False;
  SBtRecarregar.Enabled := True;
end;

Function TFrm_FotoMetodo2.LRPad(Str: String; Size: Integer; Pad: char; LorR: char): string;
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

procedure TFrm_FotoMetodo2.SBtSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_FotoMetodo2.SBtCancelarClick(Sender: TObject);
begin
  Reinicia := True;
  TelaTerminarAplicacao := False;
  TelaIdentificaCandidato := True;
  TelaFoto := False;
  TelaBiometria := False;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_FotoMetodo2.SpeedButton_PauseClick(Sender: TObject);
var
  BMP: TBitmap;
begin

  SpeedButton_Pause.Enabled := False;

  ImgCapturada.Picture.Bitmap := nil;
  ImgCapturada.Picture.Graphic := nil;

  ImgCapturada.Visible := True;
//  Camera1.CapturaImagem(ImgCapturada);

  BMP := TBitmap.Create;
  BMP.Assign(ImgCapturada.Picture.Bitmap);

  ImgCapturada.Picture.Bitmap := nil;
  ImgCapturada.Picture.Graphic := nil;

  ImgCapturada.Picture.Assign(BmpToJpg(BMP));

//  try
//    Camera1.Actif := False;
//    Camera1.Visible := False;
//  except
//    Camera1.Visible := False;
//  end;

  ArquivoLog.GravaArquivoLog('Operação 300');

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Screen.Cursor := crDefault;
  SpeedButton_Stop.Enabled := False;
  SpeedButton_Pause.Enabled := False;

  OperMonit := 0;

  if OperMonit <> 0 then
  begin
    TelaLogin := True;
    TelaIdentificaCandidato := False;
    TelaFoto := True;
    TelaBiometria := False;
    Reinicia := True;
    Frm_Menu.AbreTela;
    Close;
  end
  else
  begin
    RecebendoArquivo := False;
    SBtAplicar.Enabled := False;

    if Arquivo = nil then
      Arquivo := TMemoryStream.Create
    else
      Arquivo.Clear;

    ImgCapturada.Picture.Graphic.SaveToStream(Arquivo);

    if Arquivo.Size > 0 then
    begin
      SBtAplicar.Enabled := True;
      ParCandidato.Foto := Gerafoto(Arquivo);
    end;
  end;
end;

procedure TFrm_FotoMetodo2.SpeedButton_StopClick(Sender: TObject);
begin

  ComboBox_Cams.Items.Clear;

//  if Camera1.Actif then
//  begin
//    Camera1.SelectConfig;
//    Camera1.Actif := False;
//    Camera1.Actif := True;
//    ComboBox_Cams.Items.Add(Camera1.CaptureDriverName);
//    ComboBox_Cams.ItemIndex := 0;
//  end
//  else
//  begin
//    try
//      Camera1.Actif := True;
//      Camera1.SelectConfig;
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

function TFrm_FotoMetodo2.BmpToJpg(MyBMP: TBitmap): TJPEGImage;
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

  Except

  end;

end;

end.
