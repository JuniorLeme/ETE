unit frmTecladoVirtual;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Touch.Keyboard, ClsParametros;

type
  Tfrm_TecladoVirtual = class(TForm)
    TouchKeyboard1: TTouchKeyboard;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_TecladoVirtual: Tfrm_TecladoVirtual;

implementation

{$R *.dfm}

procedure Tfrm_TecladoVirtual.FormShow(Sender: TObject);
begin
  Self.Caption := Self.Caption + ' - '+ParCFC.nome_fantasia;
end;

end.
