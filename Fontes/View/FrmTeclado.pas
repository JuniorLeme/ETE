unit FrmTeclado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons,
  Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, ClsParametros, Vcl.StdCtrls;

type
  TFrm_Teclado = class(TForm)
    Image1: TImage;
    SBtAplicar: TSpeedButton;
    SBtCancelar: TSpeedButton;
    Image_E_Over: TImage;
    Image_Finalizar_Over: TImage;
    Image_Proximo_Over: TImage;
    Image_D_Over: TImage;
    Image_C_Over: TImage;
    Image_Anterior_Over: TImage;
    Image_Limpar_Over: TImage;
    Image_B_Over: TImage;
    Image_A_Over: TImage;
    Image_Iniciar_Over: TImage;
    Image_A: TImage;
    Image_B: TImage;
    Image_C: TImage;
    Image_D: TImage;
    Image_E: TImage;
    Image_Finalizar: TImage;
    Image_Proximo: TImage;
    Image_Anterior: TImage;
    Image_Limpar: TImage;
    Image_Iniciar: TImage;
    Label105: TLabel;
    Label107: TLabel;
    Image2: TImage;
    procedure SBtCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBtAplicarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    Reinicia: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Teclado: TFrm_Teclado;

implementation

{$R *.dfm}

uses FrmPrincipal;

procedure TFrm_Teclado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;
end;

procedure TFrm_Teclado.FormCreate(Sender: TObject);
begin
  Reinicia := True;
end;

procedure TFrm_Teclado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_HOME then
    Image_Iniciar_Over.Visible := True;

  if Key = VK_DELETE then
    Image_Limpar_Over.Visible := True;

  if Key = VK_LEFT then
    Image_Anterior_Over.Visible := True;

  if Key = VK_RIGHT then
    if SBtAplicar.Enabled then
      SBtAplicarClick(self)
    else
      Image_Proximo_Over.Visible := True;

  if Key = VK_END then
    Image_Finalizar_Over.Visible := True;

  if Key = 65 then
    Image_A_Over.Visible := True;

  if Key = 66 then
    Image_B_Over.Visible := True;

  if Key = 67 then
    Image_C_Over.Visible := True;

  if Key = 68 then
    Image_D_Over.Visible := True;

  if Key = 69 then
    Image_E_Over.Visible := True;

  if (Image_Iniciar_Over.Visible) and (Image_Limpar_Over.Visible) and
    (Image_Anterior_Over.Visible) and (Image_Proximo_Over.Visible) and
    (Image_Finalizar_Over.Visible) and (Image_A_Over.Visible) and
    (Image_B_Over.Visible) and (Image_C_Over.Visible) and (Image_D_Over.Visible)
    and (Image_E_Over.Visible) then
    SBtAplicar.Enabled := True;

end;

procedure TFrm_Teclado.FormShow(Sender: TObject);
begin
  self.SetFocus;
end;

procedure TFrm_Teclado.SBtAplicarClick(Sender: TObject);
begin
  TelaIdentificaCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := False;
  TelaTeclado := False;
  TelaConfirmacao := True;
  TelaQuestionario := False;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Teclado.SBtCancelarClick(Sender: TObject);
begin
  TelaIdentificaCandidato := True;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := False;
  TelaTeclado := False;
  TelaQuestionario := False;
  Frm_Menu.AbreTela;
  Close;
end;

end.
