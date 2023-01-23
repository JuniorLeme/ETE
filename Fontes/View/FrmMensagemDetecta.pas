unit FrmMensagemDetecta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Printers;

type
  TFrm_MensagemDetecta = class(TForm)
    Button1: TButton;
    BtnImprimir: TButton;
    MmMensagemDetecta: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_MensagemDetecta: TFrm_MensagemDetecta;

implementation

{$R *.dfm}

procedure TFrm_MensagemDetecta.BtnImprimirClick(Sender: TObject);
Var
  P: Integer;
  MemoFile: TextFile;
Begin

  AssignPrn(MemoFile);
  Rewrite(MemoFile);

  For P := 0 to MmMensagemDetecta.Lines.Count - 1 do
    Writeln(MemoFile, '      ' + MmMensagemDetecta.Lines[P]);

  CloseFile(MemoFile);

end;

procedure TFrm_MensagemDetecta.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_MensagemDetecta.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  // Application.Terminate;
end;

procedure TFrm_MensagemDetecta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_HOME then
  begin
    if Button1.Visible then
      Button1Click(Self);

    // if Button2.Visible then
    // Button2Click(Self);
  end;

  if Key = VK_END then
  begin
    if Button1.Visible then
      Button1Click(Self);

    // if Button3.Visible then
    // Button3Click(Self);
  end;
end;

end.
