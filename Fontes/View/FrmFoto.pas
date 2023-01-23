unit FrmFoto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  TlHelp32, ShellApi, clsParametros, ClsCFCControl, ClsOper300100, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.ComCtrls, IdCoderMIME, ClsCandidatoControl,
  IdCoder, IdCoder3to4, Vcl.OleCtrls, ClseProvaConst,
  ClsServidorControl, ClsOperacoes;

type
  TFrm_Foto = class(TForm)
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
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    ComboBox_DisplayMode: TComboBox;
    ImgCapturada: TImage;
    MmAvisoFlash: TMemo;
    SpeedButton2: TSpeedButton;
    procedure SBtSairClick(Sender: TObject);
    procedure SBtAplicarClick(Sender: TObject);
    procedure SBtCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton_PauseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    OperMonit: integer;
    // ShockwaveFlash1: TShockwaveFlash;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Foto: TFrm_Foto;
  Reinicia: boolean;

implementation

uses FrmAvisoOperacoes, FrmPrincipal, ClsFuncoes, clsDialogos;

{$R *.dfm}

procedure TFrm_Foto.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if not Reinicia then
    TelaTerminarAplicacao := True;

//  ShockwaveFlash1.Stop;
  Action := caFree;

end;

procedure TFrm_Foto.FormCreate(Sender: TObject);
begin

  ImgCapturada.Left := 1018;
  ImgCapturada.Top := 1083;

//  ShockwaveFlash1.Left := 18;
//  ShockwaveFlash1.Top := 135;

  if FileExists(UserProfileDir + strFileProva + '\captura_foto.swf') then
  begin
//    ShockwaveFlash1.Base := UserProfileDir + strFileProva + '\captura_foto.swf';
//    ShockwaveFlash1.Movie := UserProfileDir + strFileProva + '\captura_foto.swf';
//    ShockwaveFlash1.Play;
  end
  else if FileExists(UserProgranData + strFileProva +  '\captura_foto.swf') then
  begin
//    ShockwaveFlash1.Base := UserProgranData + strFileProva + '\captura_foto.swf';
//    ShockwaveFlash1.Movie := UserProgranData + strFileProva + '\captura_foto.swf';
//    ShockwaveFlash1.Play;
  end;

end;

procedure TFrm_Foto.FormShow(Sender: TObject);
begin
  Reinicia := false;
  TelaTerminarAplicacao := false;

  if ParCandidato.ResgistrarPresenca then
  begin
    if ParCandidato.Excecao = 'S' then
      SBtAplicar.Caption := '&Registrar'
    else
      SBtAplicar.Caption := '&Próximo';
  end
  else
    SBtAplicar.Caption := '&Próximo';

  if TelaExameBiometriaFoto then
    SBtCancelar.Visible := false
  else
    SBtCancelar.Visible := True;

end;

procedure TFrm_Foto.SBtAplicarClick(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper300Env: T300100Envio;
  Oper300ret: T300100Retorno;
begin
  SBtAplicar.Enabled := false;

  if (ParCandidato.Excecao = 'S') then
  begin
    if (ParCandidato.ResgistrarPresenca) then
    BEGIN
      // Efetuar a operação 100200
      Consulta := MainOperacao.Create(Self);
      Oper300Env := T300100Envio.Create;
      Oper300ret := T300100Retorno.Create;
      Oper300ret.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper300Env.MontaXMLEnvio(ParCandidato.IdCandidato, ParCandidato.Foto)));

      if Oper300ret.isValid then
      begin
        DialogoMensagem('A presença foi registrada com sucesso!', mtInformation);

        TelaFoto := false;
        TelaBiometria := false;
        TelaConfirmacao := false;
        TelaIdentificaCandidato := True;
        Reinicia := True;
        Frm_Menu.AbreTela;
        Close;
      end
      else
      begin
        DialogoMensagem(Oper300ret.mensagem, mtInformation);
        SBtRecarregar.Enabled := True;
        Self.Repaint;
      end;

    END
    else
    begin
      TelaIdentificaCandidato := false;
      TelaFoto := false;
      TelaBiometria := false;
      Reinicia := True;

      if TelaExameBiometriaFoto then
      begin
        Reinicia := True;

        TelaIdentificaCandidato := false;
        TelaFoto := false;
        TelaBiometria := false;
        TelaInformacoes := false;
        TelaTeclado := false;
        TelaConfirmacao := false;
        TelaQuestionario := false;
      end
      else if TelaResultadoBiometriaFoto then
      begin
        Reinicia := True;

        TelaResultadoBiometriaFoto := false;
        TelaIdentificaCandidato := false;
        TelaFoto := false;
        TelaBiometria := false;
        TelaInformacoes := false;
        TelaTeclado := false;
        TelaConfirmacao := false;
        TelaQuestionario := false;
        TelaResultado := True;
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

      if TelaExameBiometriaFoto then
        ModalResult := mrOk
      else
        Frm_Menu.AbreTela;

      Close;
    end;
  end
  else
  begin
    TelaIdentificaCandidato := false;
    TelaFoto := false;
    TelaBiometria := True;
    TelaConfirmacao := false;
    Reinicia := True;
    Frm_Menu.AbreTela;
    Close;
  end;
end;

procedure TFrm_Foto.SBtSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_Foto.SBtCancelarClick(Sender: TObject);
begin

  Reinicia := True;
  TelaIdentificaCandidato := True;
  TelaFoto := false;
  TelaBiometria := false;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Foto.SpeedButton2Click(Sender: TObject);
begin

  ImgCapturada.Left := 1018;
  ImgCapturada.Top := 1083;

//  ShockwaveFlash1.Left := 18;
//  ShockwaveFlash1.Top := 135;

//  ShockwaveFlash1.Stop;
//  ShockwaveFlash1.Play;

  ImgCapturada.Picture.Bitmap := nil;
  ImgCapturada.Picture.Graphic := nil;

  SpeedButton_Pause.Enabled := True;
  SBtAplicar.Enabled := false;

end;

procedure TFrm_Foto.SpeedButton_PauseClick(Sender: TObject);
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

//    ShockwaveFlash1.Left := 1018;
//    ShockwaveFlash1.Top := 1083;
//    ShockwaveFlash1.Stop;

    ImgCapturada.Left := 18;
    ImgCapturada.Top := 135;

    IdDecoderMIME1 := TIdDecoderMIME.Create(Self);
    IdDecoderMIME1.DecodeStream(ParCandidato.Foto, strmFoto);
    strmFoto.Position := 0;

    jpgFoto := TJPEGImage.Create;
    jpgFoto.LoadFromStream(strmFoto);
    // jpgFoto.SaveToFile('C:\Transito\fotoCandidato.jpg');

    SpeedButton_Pause.Enabled := false;

    ImgCapturada.Visible := True;
    ImgCapturada.Picture.Bitmap := nil;
    ImgCapturada.Picture.Graphic := nil;
    ImgCapturada.Picture.Assign(jpgFoto);

    Screen.Cursor := crDefault;
    SpeedButton_Pause.Enabled := false;

    OperMonit := 0;

    if OperMonit <> 0 then
    begin
      TelaLogin := True;
      TelaIdentificaCandidato := false;
      TelaFoto := True;
      TelaBiometria := false;
      Reinicia := True;
      Frm_Menu.AbreTela;
      Close;
    end
    else
    begin
      if ParCandidato.Foto <> '' then
      begin
        SBtAplicar.Enabled := True;
      end;
    end;

  end;

end;

end.
