unit FrmAviso2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFrm_MensagemBiblica = class(TForm)
    PageControl1: TPageControl;
    TSAplicativos: TTabSheet;
    LstBxAplicativos: TListBox;
    TSProcessos: TTabSheet;
    LstBxProcessos: TListBox;
    TSServicos: TTabSheet;
    LstBxServicos: TListBox;
    TSHardwares: TTabSheet;
    LstBxHardwares: TListBox;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_MensagemBiblica: TFrm_MensagemBiblica;

implementation

{$R *.dfm}

procedure TFrm_MensagemBiblica.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_MensagemBiblica.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_MensagemBiblica.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_HOME then
  begin
    if Button1.Visible then
      Button1Click(Self);

//    if Button2.Visible then
//      Button2Click(Self);
  end;

  if Key = VK_END then
  begin
    if Button1.Visible then
      Button1Click(Self);

//    if Button3.Visible then
//      Button3Click(Self);
  end;
end;

end.
