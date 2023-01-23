unit FrmInformacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  ClsCandidatoControl, ClsServidorControl, Vcl.Imaging.jpeg, Vcl.Buttons;

type
  TFrm_Informacoes = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    SBtCancelar: TSpeedButton;
    SBtAplicar: TSpeedButton;
    Image2: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBtCancelarClick(Sender: TObject);
    procedure SBtAplicarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Informacoes: TFrm_Informacoes;
  Reinicia: Boolean;

implementation

uses clsParametros, FrmPrincipal;
{$R *.dfm}

procedure TFrm_Informacoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if not Reinicia then
  begin
    TelaTerminarAplicacao := True;
    Frm_Menu.AbreTela;
  end;

  Action := caFree;
end;

procedure TFrm_Informacoes.FormCreate(Sender: TObject);
begin
  Reinicia := False;
end;

procedure TFrm_Informacoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_RIGHT then
    SBtAplicarClick(Self);

  if Key = VK_HOME then
    SBtAplicarClick(Self);

  if Key = VK_ESCAPE then
    SBtCancelarClick(Self);

end;

procedure TFrm_Informacoes.FormShow(Sender: TObject);
begin

  Memo1.Lines.Clear;
  if ParServidor.ID_Sistema = 532997 then // BA
  begin
    Memo1.Alignment := taCenter;
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Instru��es');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Este exame possui 40 (quarenta) quest�es e dura��o de 50 (cinquenta) minutos. A ');
    Memo1.Lines.Add
      ('contagem do tempo come�ar� a ser feita ap�s a sele��o do bot�o  "INICIAR". Em seguida ');

    if ParCandidato.TipoProva = 'S' then
      Memo1.Lines.Add
        ('realize a confirma��o da opera��o. O sistema ir� gerar e exibir seu teste simulado. ')
    else
      Memo1.Lines.Add
        ('realize a confirma��o da opera��o. O sistema ir� gerar e exibir sua prova. ');

    Memo1.Lines.Add('Leia com aten��o as quest�es apresentadas. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para selecionar uma alternativa clique sobre ela ou digite a letra correspondente. A ');
    Memo1.Lines.Add
      ('alternativa escolhida ficar� com cor avermelhada, destacando-se das demais. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para navegar entre as quest�es use as setas direcionais para direita ou para esquerda, ou ');
    Memo1.Lines.Add
      ('se preferir utilize a barra de navega��o do sistema representado por quadrados pequenos, ');
    Memo1.Lines.Add
      ('cada quadrado � equivalente a uma quest�o, ou pelo bot�o anterior e pr�ximo. O quadro ');
    Memo1.Lines.Add
      ('na cor azul representa a quest�o que est� sendo exibida. As quest�es que j� foram ');
    Memo1.Lines.Add('respondidas ficam com o n�mero na cor preta. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Caso o seu tempo de resposta ultrapasse 50 (cinquenta) minutos, seu exame � ');
    Memo1.Lines.Add
      ('automaticamente finalizado, suas respostas preservadas e seu resultado apresentado. ');
    Memo1.Lines.Add(' ');
  end
  else if ParServidor.ID_Sistema = 591804 then // SP
  begin
    Memo1.Alignment := taLeftJustify;
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Instru��es');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Bem-vindo a Prova Eletr�nica!');
    Memo1.Lines.Add
      ('Para fazer a prova leia atentamente as instru��es abaixo:');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Este exame � composto por trinta quest�es. Uma vez iniciada a avalia��o, voc� ter� quarenta minutos para conclui-la.');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Indique a alternativa correta utilizando as op��es correspondentes de seu teclado.');
    Memo1.Lines.Add(' ');

    if ParCandidato.TipoProva = 'S' then
      Memo1.Lines.Add
        ('Utilize as teclas ANTERIOR e PR�XIMO do teclado para voltar ou avan�ar, caso queira modificar alguma resposta, mas ATEN��O as respostas s� poder�o ser modificadas durante os quarenta minutos de execu��o do teste simulado.')
    else
      Memo1.Lines.Add
        ('Utilize as teclas ANTERIOR e PR�XIMO do teclado para voltar ou avan�ar, caso queira modificar alguma resposta, mas ATEN��O as respostas s� poder�o ser modificadas durante os quarenta minutos de execu��o da prova.');

    Memo1.Lines.Add(' ');
    // Memo1.Lines.Add(  'Para gerar sua prova e armazen�-la com seguran�a em nosso banco de dados pressione o bot�o INICIAR do teclado.');
    // Memo1.Lines.Add(  ' ');
    Memo1.Lines.Add('Clique no bot�o "Pr�ximo" para continuar. ');

  end
  else
  // if (ParServidor.ID_Sistema = 872461) or (ParServidor.ID_Sistema = 806076) then // MG
  begin
    Memo1.Alignment := taCenter;
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Instru��es');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Este exame possui 30 (trinta) quest�es e dura��o de 60 (sessenta) minutos. A ');
    Memo1.Lines.Add
      ('contagem do tempo come�ar� a ser feita ap�s a sele��o do bot�o  "INICIAR". Em seguida ');

    if ParCandidato.TipoProva = 'S' then
      Memo1.Lines.Add
        ('realize a confirma��o da opera��o. O sistema ir� gerar e exibir seu teste simulado. ')
    else
      Memo1.Lines.Add
        ('realize a confirma��o da opera��o. O sistema ir� gerar e exibir sua prova. ');

    Memo1.Lines.Add('Leia com aten��o as quest�es apresentadas. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para selecionar uma alternativa clique sobre ela ou digite a letra correspondente. A ');
    Memo1.Lines.Add
      ('alternativa escolhida ficar� com cor avermelhada, destacando-se das demais. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para navegar entre as quest�es use as setas direcionais para direita ou para esquerda, ou ');
    Memo1.Lines.Add
      ('se preferir utilize a barra de navega��o do sistema representado por quadrados pequenos, ');
    Memo1.Lines.Add
      ('cada quadrado � equivalente a uma quest�o, ou pelo bot�o anterior e pr�ximo. O quadro ');
    Memo1.Lines.Add
      ('na cor azul representa a quest�o que est� sendo exibida. As quest�es que j� foram ');
    Memo1.Lines.Add('respondidas ficam com o n�mero na cor preta. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Caso o seu tempo de resposta ultrapasse 60 (sessenta) minutos, seu exame � ');
    Memo1.Lines.Add
      ('automaticamente finalizado, suas respostas preservadas e seu resultado apresentado. ');
    Memo1.Lines.Add(' ');
  end;

end;

procedure TFrm_Informacoes.SBtAplicarClick(Sender: TObject);
begin
  TelaIdentificaCandidato := False;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := False;
  TelaTeclado := False;
  TelaConfirmacao := True;
  Frm_Menu.AbreTela;
  Close;
end;

procedure TFrm_Informacoes.SBtCancelarClick(Sender: TObject);
begin

  TelaIdentificaCandidato := True;
  TelaFoto := False;
  TelaBiometria := False;
  Reinicia := True;
  TelaInformacoes := False;
  TelaTeclado := False;
  Frm_Menu.AbreTela;
  Close;

end;

end.
