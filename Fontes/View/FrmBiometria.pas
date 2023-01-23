unit FrmBiometria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, TlHelp32,
  clsParametros, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, MSHTML, ClsOper300100,
  ShellApi, Vcl.Imaging.pngimage, ClsCandidatoControl, ClsCFCControl,
  ClsServidorControl, ClsFuncoes;

type
  TFrm_Biometria = class(TForm)
    Panel1: TPanel;
    SBtAplicar: TSpeedButton;
    SBtRecarregar: TSpeedButton;
    SBtSair: TSpeedButton;
    SBtCancelar: TSpeedButton;
    Timer1: TTimer;
    Panel5: TPanel;
    Image3: TImage;
    Panel2: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
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
  private
    Function LRPad(Str: String; Size: integer; Pad: char; LorR: char): string;
    procedure ExecuteScript(doc: IHTMLDocument2; script: string; language: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Biometria: TFrm_Biometria;
  Reinicia: Boolean;

implementation

uses FrmAvisoOperacoes, FrmPrincipal, clsDialogos;

{$R *.dfm}

procedure TFrm_Biometria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if NOT Reinicia then
    TelaTerminarAplicacao := True;

  Action := caFree;
end;

procedure TFrm_Biometria.FormCreate(Sender: TObject);
begin
  Reinicia := False;
end;

procedure TFrm_Biometria.FormShow(Sender: TObject);
begin

  { Encerra o java }
  WebBrowser1.Navigate('about:blank');
  KillTask('java.exe');
  KillTask('jp2launcher.exe');

  if ParCandidato.ResgistrarPresenca then
    SBtAplicar.Caption := '&Registrar'
  else
    SBtAplicar.Caption := '&Próximo';

  WebBrowser1.Navigate(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=BA' + ParCandidato.RENACHCandidato +
    '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');

  ArquivoLog.GravaArquivoLog(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=BA' + ParCandidato.RENACHCandidato +
    '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');
end;

procedure TFrm_Biometria.SBtAplicarClick(Sender: TObject);
begin
  SBtAplicar.Enabled := False;

  TelaIdentificaCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;

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
  else
  begin

    TelaConfirmacao := True;
    Reinicia := True;
  end;

  if TelaExameBiometriaFoto then
    ModalResult := mrOk
  else
    Frm_Menu.AbreTela;

  Close;

end;

procedure TFrm_Biometria.SBtRecarregarClick(Sender: TObject);
begin
  SBtAplicar.Enabled := False;
  SBtRecarregar.Enabled := True;

  { Encerra o java }
  ExecuteScript(WebBrowser1.Document as IHTMLDocument2, 'finalizar()', 'javascript');
  WebBrowser1.Navigate('about:blank');
  KillTask('java.exe');
  KillTask('jp2launcher.exe');

  Sleep(5000);

  WebBrowser1.Navigate(ParCFC.URL_Biometria + '?tipo=' + '1' + '&inscricao=' + ParCandidato.CPFCandidato + '&registro=BA' + ParCandidato.RENACHCandidato +
    '&nome=' + Trim(ParCandidato.NomeCandidato) + '&area=' + LRPad(ParCFC.Cod_Ciretran, 4, '0', 'L') + '&tentativas=3');

end;

Function TFrm_Biometria.LRPad(Str: String; Size: integer; Pad: char; LorR: char): string;
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

procedure TFrm_Biometria.SBtSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrm_Biometria.SBtCancelarClick(Sender: TObject);
begin
  TelaIdentificaCandidato := False;
  TelaFoto := True;
  TelaBiometria := False;
  TelaConfirmacao := False;
  Reinicia := True;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Biometria.ExecuteScript(doc: IHTMLDocument2; script: string; language: string);
begin
  if doc <> nil then
  begin
    if doc.parentWindow <> nil then
      doc.parentWindow.ExecScript(script, OleVariant(language));
  end;
end;

procedure TFrm_Biometria.Timer1Timer(Sender: TObject);
var
  Tr: IHTMLTxtRange;
begin
  Try
    if Assigned(WebBrowser1.Document) then
    begin
      Tr := ((WebBrowser1.Document AS IHTMLDocument2).body AS IHTMLBodyElement).CreateTextRange;

      if (Trim(Tr.text) = '2') then
      begin
        SBtAplicar.Enabled := True;
        Timer1.Enabled := False;

        // Neste momento passa a ser exeção digital nesta prova
        // porque a biometria não confere
        ParCandidato.Excecao := 'A';

        if ParServidor.ID_Sistema = 806076 then // 806076 = id do Sistema de Alagoas
        begin
          if ParCandidato.TipoProva = 'S' then
            DialogoMensagem('A exceção digital automática foi confirmada. ' + 'Essa captura e o Teste Simulado estão sendo marcado e será auditado.', mtWarning)
          else
            DialogoMensagem('A exceção digital automática foi confirmada. ' + 'Essa captura e a Prova estão sendo marcado e será auditado.', mtWarning);
        end
        else
        begin
          if ParCandidato.TipoProva = 'S' then
            DialogoMensagem('A exceção digital automática foi confirmada. ' +
              'Essa captura e o Teste Simulado estão sendo marcadas e serão auditadas pelo DETRAN.', mtWarning)
          else
            DialogoMensagem('A exceção digital automática foi confirmada. ' + 'Essa captura e a Prova estão sendo marcadas e serão auditadas pelo DETRAN.',
              mtWarning);

        end;

        ExecuteScript(WebBrowser1.Document as IHTMLDocument2, 'finalizar()', 'javascript');
      end;

      if Trim(Tr.text) = '9' then
      begin
        SBtAplicar.Enabled := False;
        SBtRecarregar.Enabled := True;
        { ???????????????????? }
      end;

      if Pos('SUCESSO:', Trim(Tr.text)) > 0 then
      begin
        SBtAplicar.Enabled := True;
        Timer1.Enabled := False;
        ExecuteScript(WebBrowser1.Document as IHTMLDocument2, 'finalizar()', 'javascript');

        if TelaExameBiometriaFoto then
          SBtAplicarClick(Self);

      end;
    end;
  except
    on E: Exception do
    begin
      ArquivoLog.GravaArquivoLog('Applet - Exeção - ' + E.Message);
    end;
  End;

end;

procedure TFrm_Biometria.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  WebBrowser1.OleObject.Document.body.Style.OverflowX := 'hidden';
  WebBrowser1.OleObject.Document.body.Style.OverflowY := 'hidden';
  SBtRecarregar.Enabled := True;
  Timer1.Enabled := True;
end;

end.
