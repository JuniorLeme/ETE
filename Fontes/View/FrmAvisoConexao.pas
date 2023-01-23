unit FrmAvisoConexao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ImgList,
  System.ImageList,
  ClsParametros;

type
  TFrm_AvisoConexao = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    BtnTentarNovamente: TButton;
    BtnFechar: TButton;
    ImageList1: TImageList;
    procedure BtnTentarNovamenteClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    TipoModal: Boolean;
    { Public declarations }
  end;

var
  Frm_AvisoConexao: TFrm_AvisoConexao;

implementation

{$R *.dfm}

procedure TFrm_AvisoConexao.BtnTentarNovamenteClick(Sender: TObject);
begin
  ModalResult := mrYes;
  Parametros.AguardarAviso := False;
  Parametros.NumeroAviso := Parametros.NumeroAviso + 1;
end;

procedure TFrm_AvisoConexao.BtnFecharClick(Sender: TObject);
begin
  Parametros.TerminarProva := True;
  ModalResult := mrNo;
end;

procedure TFrm_AvisoConexao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_AvisoConexao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_HOME then
  begin
    BtnTentarNovamenteClick(Self);
  end;

  if Key = VK_END then
  begin
    BtnFecharClick(Self);
  end;
end;

procedure TFrm_AvisoConexao.FormShow(Sender: TObject);
begin

  if Parametros.NumeroAviso >= 5 then
  begin
    Label1.Caption :=
      'Excedeu o número de tentativas. Verifique sua conexão e inicie a prova novamente.';
    BtnTentarNovamente.Enabled := False;
  end;

end;

end.
