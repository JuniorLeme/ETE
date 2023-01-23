unit FrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Buttons, System.UITypes, Vcl.ImgList,
  ClsServidorControl,
  System.ImageList, ClsCFCControl, ClsParametros, ClsOper100100, ClsOperacoes,
  ClsListaProdutoID, ClsOper100110, IdBaseComponent, IdCoder, IdCoder3to4,
  IdCoderMIME;

type
  TFrm_Login = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    ImageList1: TImageList;
    EdUsuario: TButtonedEdit;
    EdSenha: TButtonedEdit;
    EdComputador: TButtonedEdit;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton2: TSpeedButton;
    IdEncoderMIME1: TIdEncoderMIME;
    Label6: TLabel;
    CmbBxEstado: TComboBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure EdUsuarioRightButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CmbBxEstadoChange(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Login: TFrm_Login;

implementation

{$R *.dfm}

uses FrmAvisoOperacoes, ClsFuncoes, FrmPrincipal, clsDialogos;

procedure TFrm_Login.CmbBxEstadoChange(Sender: TObject);
var
  ProdutoID: TProdutoID;
begin

  if ListaProdutoID.IndexOf(CmbBxEstado.Text) > -1 then
  begin
    ProdutoID := TProdutoID(ListaProdutoID.Objects
      [ListaProdutoID.IndexOf(CmbBxEstado.Text)]);
    ParServidor.ID_Sistema := StrToIntDef(ProdutoID.servidor, 0);
  end;

  if ParServidor.ID_Sistema > 0 then
    AtualizarForm(Self, ParServidor.ID_Sistema);

end;

procedure TFrm_Login.EdUsuarioRightButtonClick(Sender: TObject);
begin
  (Sender as TButtonedEdit).Clear;
end;

procedure TFrm_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  ParCFC := ParCFC;

  if not TelaLogin then
    Application.Terminate;

  Action := caFree;
end;

procedure TFrm_Login.FormCreate(Sender: TObject);
begin

  ArquivoLog.GravaArquivoLog('# ' + Self.Caption);

end;

procedure TFrm_Login.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #27 then
    Application.Terminate;

  if Key = #13 then
  begin
    if (Trim(EdUsuario.Text) <> '') and (Trim(EdSenha.Text) <> '') and
      (Trim(EdComputador.Text) <> '') then
      SpeedButton1Click(Self);
  end;

end;

procedure TFrm_Login.FormShow(Sender: TObject);
var
  ProdutoID: TProdutoID;
begin

  CmbBxEstado.Items.Assign(ListaProdutoID);

  CmbBxEstado.ItemIndex := CmbBxEstado.Items.IndexOf
    (Copy(Parametros.NomeSistema, length(Parametros.NomeSistema) - 1, 2));

  if CmbBxEstado.ItemIndex = -1 then
  begin
    CmbBxEstado.SetFocus;
    CmbBxEstado.ItemIndex := CmbBxEstado.Items.Count - 1;

    //Andre
    CmbBxEstado.Enabled := False;

    ProdutoID := TProdutoID(ListaProdutoID.Objects
      [ListaProdutoID.IndexOf(CmbBxEstado.Text)]);
    ParServidor.ID_Sistema := StrToIntDef(ProdutoID.servidor, 0);

    AtualizarForm(Self, ParServidor.ID_Sistema);
  end
  else
    EdUsuario.SetFocus;

  if Trim(EdUsuario.Text) = '' then
    if Not Parametros.Usuario.IsEmpty then
      EdUsuario.Text := Parametros.Usuario;

end;

procedure TFrm_Login.Image1DblClick(Sender: TObject);
begin

  Debug := True;

end;

procedure TFrm_Login.SpeedButton1Click(Sender: TObject);
var
  Consulta: MainOperacao;
  Oper100Env: T100100Envio;
  Oper100Ret: T100100Retorno;
  ProdutoID : TProdutoID;
begin

  if (EdComputador.Text = '') or (EdUsuario.Text = '') or (EdSenha.Text = '') or
    (CmbBxEstado.Text = '') then
  begin
    DialogoMensagem
      ('Os dados digitados são insuficientes para utilizar o sistema!',
      mtWarning);
    Exit;
  end;

  // Parametros.Free;
  // Parametros := TParametros.Create;
  Parametros.NumeroAviso := 0;
  Parametros.NomeSistema := ReplaceStr(ReplaceStr(LowerCase(CmbBxEstado.Text),
    ' ', '-'), 'cfcanet', 'prova');
  Parametros.CriarParametros;

  if (EdComputador.Text <> '') and (EdUsuario.Text <> '') and
    (EdSenha.Text <> '') then
  begin

    Parametros.Computador := EdComputador.Text;
    Parametros.Usuario := EdUsuario.Text;
    Parametros.Senha := EdSenha.Text;

    Oper100Env := T100100Envio.Create;
    Oper100Ret := T100100Retorno.Create;

    if ListaProdutoID.IndexOf(CmbBxEstado.Text) > -1 then
    begin
      ProdutoID := TProdutoID(ListaProdutoID.Objects
        [ListaProdutoID.IndexOf(CmbBxEstado.Text)]);
      ParServidor.ID_Sistema := StrToIntDef(ProdutoID.servidor, 0);
    end;
    if ParServidor.ID_Sistema > 0 then
      AtualizarForm(Self, ParServidor.ID_Sistema);

    Consulta := MainOperacao.Create(Self, '100100');
    Oper100Ret.MontaRetorno(Consulta.consultar(IntToStr(ParServidor.ID_Sistema),
      Oper100Env.MontaXMLEnvio(EdUsuario.Text, EdSenha.Text,
      Parametros.Identificacao)));

    if Oper100Ret.IsValid then
    begin

      TelaLogin := True;
      Parametros.GravarParametrosCRC;

      ParCFC := ParCFC;
      TelaLogin := True;
      TelaIdentificaCandidato := True;
      Frm_Menu.AbreTela;
      Close;
    end
    else
    begin
      TelaLogin := False;
      DialogoMensagem(Oper100Ret.mensagem, mtWarning);
      SpeedButton1.Repaint;

      if Oper100Ret.codigo = 'D998' then
        Application.Terminate;
    end;

  end;
end;

procedure TFrm_Login.SpeedButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
