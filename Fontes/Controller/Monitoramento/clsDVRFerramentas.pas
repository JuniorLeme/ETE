unit clsDVRFerramentas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ShellApi, Vcl.Graphics,
  System.Generics.Collections,
  Vcl.StdCtrls, System.Types;

type
  TDVRFerramentas = class(TObject)
    Id: Integer;
    Verificar: String;
    Tempo: Integer;
    Endereco: string;
    Porta: Integer;
    Usuario: string;
    Senha: string;
    Status: string;
    cfcliveSituacao: Integer;
    cfcliveTipo: string;
    cfcliveMensagem: string;
    cfcliveHint: string;
  private
    function RunDosInMemo(Programa, Parametro: String): String;
  public
    function DVRStatus: string;

    constructor Create;
  end;

var
  DVRFerramentas: TDVRFerramentas;

implementation

constructor TDVRFerramentas.Create;
begin
  Id := 0;
  Verificar := 'N';
  Tempo := 0;
  Endereco := '';
  Porta := 0;
  Usuario := '';
  Senha := '';
end;

function TDVRFerramentas.DVRStatus: string;
begin
  Status := 'Desligado';

  // Para Teste
  // Endereco := 'testecfcanet.ddns.net';
  // Porta := 37777;
  // Porta := 0;
  // Usuario := 'admin';
  // Senha := 'admin';
  //   Verificar := 'S';

  if Porta = 0 then
  begin
    Status := 'Ligado';
    Result := Status;
    Exit;
  end;

  if Endereco.IsEmpty then
  begin
    Status := 'Ligado';
    Result := Status;
    Exit;
  end;

  Status := RunDosInMemo(ExtractFilePath(ParamStr(0)) + 'eStatusDVRSharp.exe ',
    Endereco + ' ' + Porta.ToString + ' ' + Usuario + ' ' + Senha + ' ' +    Verificar);

  Result := Status;

end;

function TDVRFerramentas.RunDosInMemo(Programa, Parametro: String): String;
var
  tmp: TFileStream;
  B: TBytes;
begin

  if FileExists(ExtractFilePath(ParamStr(0)) + 'eDVRStatus.sts') then
    DeleteFile(ExtractFilePath(ParamStr(0)) + 'eDVRStatus.sts');

  ShellExecute(Application.Handle, PChar('open'), PChar(Programa),
    PChar(Parametro), PChar(ExtractFilePath(ParamStr(0))), SW_HIDE);

  Sleep(10000);

  repeat
    // eDVRStatus.sts
    if FileExists(ExtractFilePath(ParamStr(0)) + 'eDVRStatus.sts') then
    begin

      try
        tmp := TFileStream.Create( Pchar(ExtractFilePath(ParamStr(0)) + 'eDVRStatus.sts'), fmOpenRead);
      except
      BEGIN
        tmp.Free;
        Continue;
      END;

      end;

      try
        if tmp.Size > 0 then
        begin
          SetLength(B, tmp.Size);
          tmp.Read(B[0], Length(B));
          Result := Trim(TEncoding.ANSI.GetString(B));
        end;

      finally
        tmp.Free;
      end;
    end;
  until (Result <> '' );

end;

end.
