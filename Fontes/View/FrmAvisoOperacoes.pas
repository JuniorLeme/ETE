unit FrmAvisoOperacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ImgList,
  System.ImageList;

type
  TFrm_AvisoOperacoes = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ImageList1: TImageList;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    TipoModal: Boolean;
    { Public declarations }
  end;

var
  Frm_AvisoOperacoes: TFrm_AvisoOperacoes;

implementation

{$R *.dfm}

procedure TFrm_AvisoOperacoes.Button1Click(Sender: TObject);
begin
  if TipoModal then
    ModalResult := mrOk
  else
    Close;
end;

procedure TFrm_AvisoOperacoes.Button2Click(Sender: TObject);
begin
  if TipoModal then
    ModalResult := mrYes
  else
    Close;
end;

procedure TFrm_AvisoOperacoes.Button3Click(Sender: TObject);
begin
  if TipoModal then
    ModalResult := mrNo
  else
    Close;
end;

procedure TFrm_AvisoOperacoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_AvisoOperacoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_HOME then
  begin
    if Button1.Visible then
      Button1Click(Self);

    if Button2.Visible then
      Button2Click(Self);
  end;

  if Key = VK_END then
  begin
    if Button1.Visible then
      Button1Click(Self);

    if Button3.Visible then
      Button3Click(Self);
  end;
end;

end.
