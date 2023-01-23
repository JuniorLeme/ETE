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
    Memo1.Lines.Add('Instruções');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Este exame possui 40 (quarenta) questões e duração de 50 (cinquenta) minutos. A ');
    Memo1.Lines.Add
      ('contagem do tempo começará a ser feita após a seleção do botão  "INICIAR". Em seguida ');

    if ParCandidato.TipoProva = 'S' then
      Memo1.Lines.Add
        ('realize a confirmação da operação. O sistema irá gerar e exibir seu teste simulado. ')
    else
      Memo1.Lines.Add
        ('realize a confirmação da operação. O sistema irá gerar e exibir sua prova. ');

    Memo1.Lines.Add('Leia com atenção as questões apresentadas. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para selecionar uma alternativa clique sobre ela ou digite a letra correspondente. A ');
    Memo1.Lines.Add
      ('alternativa escolhida ficará com cor avermelhada, destacando-se das demais. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para navegar entre as questões use as setas direcionais para direita ou para esquerda, ou ');
    Memo1.Lines.Add
      ('se preferir utilize a barra de navegação do sistema representado por quadrados pequenos, ');
    Memo1.Lines.Add
      ('cada quadrado é equivalente a uma questão, ou pelo botão anterior e próximo. O quadro ');
    Memo1.Lines.Add
      ('na cor azul representa a questão que está sendo exibida. As questões que já foram ');
    Memo1.Lines.Add('respondidas ficam com o número na cor preta. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Caso o seu tempo de resposta ultrapasse 50 (cinquenta) minutos, seu exame é ');
    Memo1.Lines.Add
      ('automaticamente finalizado, suas respostas preservadas e seu resultado apresentado. ');
    Memo1.Lines.Add(' ');
  end
  else if ParServidor.ID_Sistema = 591804 then // SP
  begin
    Memo1.Alignment := taLeftJustify;
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Instruções');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Bem-vindo a Prova Eletrônica!');
    Memo1.Lines.Add
      ('Para fazer a prova leia atentamente as instruções abaixo:');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Este exame é composto por trinta questões. Uma vez iniciada a avaliação, você terá quarenta minutos para conclui-la.');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Indique a alternativa correta utilizando as opções correspondentes de seu teclado.');
    Memo1.Lines.Add(' ');

    if ParCandidato.TipoProva = 'S' then
      Memo1.Lines.Add
        ('Utilize as teclas ANTERIOR e PRÓXIMO do teclado para voltar ou avançar, caso queira modificar alguma resposta, mas ATENÇÃO as respostas só poderão ser modificadas durante os quarenta minutos de execução do teste simulado.')
    else
      Memo1.Lines.Add
        ('Utilize as teclas ANTERIOR e PRÓXIMO do teclado para voltar ou avançar, caso queira modificar alguma resposta, mas ATENÇÃO as respostas só poderão ser modificadas durante os quarenta minutos de execução da prova.');

    Memo1.Lines.Add(' ');
    // Memo1.Lines.Add(  'Para gerar sua prova e armazená-la com segurança em nosso banco de dados pressione o botão INICIAR do teclado.');
    // Memo1.Lines.Add(  ' ');
    Memo1.Lines.Add('Clique no botão "Próximo" para continuar. ');

  end
  else
  // if (ParServidor.ID_Sistema = 872461) or (ParServidor.ID_Sistema = 806076) then // MG
  begin
    Memo1.Alignment := taCenter;
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Instruções');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Este exame possui 30 (trinta) questões e duração de 60 (sessenta) minutos. A ');
    Memo1.Lines.Add
      ('contagem do tempo começará a ser feita após a seleção do botão  "INICIAR". Em seguida ');

    if ParCandidato.TipoProva = 'S' then
      Memo1.Lines.Add
        ('realize a confirmação da operação. O sistema irá gerar e exibir seu teste simulado. ')
    else
      Memo1.Lines.Add
        ('realize a confirmação da operação. O sistema irá gerar e exibir sua prova. ');

    Memo1.Lines.Add('Leia com atenção as questões apresentadas. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para selecionar uma alternativa clique sobre ela ou digite a letra correspondente. A ');
    Memo1.Lines.Add
      ('alternativa escolhida ficará com cor avermelhada, destacando-se das demais. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Para navegar entre as questões use as setas direcionais para direita ou para esquerda, ou ');
    Memo1.Lines.Add
      ('se preferir utilize a barra de navegação do sistema representado por quadrados pequenos, ');
    Memo1.Lines.Add
      ('cada quadrado é equivalente a uma questão, ou pelo botão anterior e próximo. O quadro ');
    Memo1.Lines.Add
      ('na cor azul representa a questão que está sendo exibida. As questões que já foram ');
    Memo1.Lines.Add('respondidas ficam com o número na cor preta. ');
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add
      ('Caso o seu tempo de resposta ultrapasse 60 (sessenta) minutos, seu exame é ');
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
