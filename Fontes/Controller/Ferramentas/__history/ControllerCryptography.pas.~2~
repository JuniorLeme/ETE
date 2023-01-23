unit ControllerCryptography;

interface

uses
  Winapi.Windows, idHashMessageDigest, System.SysUtils, System.IOUtils,
  System.Classes,
  MiscObj, AESObj;

function AESEncrypt(Texto: String): String;
function AESDecrypt(Texto: String): String;

function MD5_Arquivo(CaminhoCompletoArquivo: String): String;

implementation

function AESEncrypt(Texto: String): String;
var
  AES: TAESEncryption;
begin

  AES := TAESEncryption.Create(nil);
  AES.Key := '1234567890123456';
  AES.AType := atECB;
  AES.outputFormat := TConvertType.base64;
  AES.Unicode := yesUni;

  Result := AES.Encrypt(Texto);

end;

function AESDecrypt(Texto: String): String;
var
  AES: TAESEncryption;
begin

  AES := TAESEncryption.Create(nil);
  AES.Key := '1234567890123456';
  AES.AType := atECB;
  AES.outputFormat := TConvertType.base64;
  AES.Unicode := yesUni;

  Result := AES.Decrypt(Texto);

end;

function MD5_Arquivo(CaminhoCompletoArquivo: String): String;
var
  fs: TFileStream;
  DestinoCompleto: WideString;
begin

  with TIdHashMessageDigest5.Create do
  begin

    try

      // Verifica se o arquivo está sendo usado
      if OpenMutex(MUTEX_ALL_ACCESS, False, PWideChar(CaminhoCompletoArquivo)
        ) <> 0 then
      begin
        DestinoCompleto := ExtractFilePath(CaminhoCompletoArquivo) +
          ExtractFileName(CaminhoCompletoArquivo);

        if FileExists(DestinoCompleto + '.Hash') then
          DeleteFile(DestinoCompleto + '.Hash');

        // TFile.Replace( CaminhoCompletoArquivo, DestinoCompleto+'.excluir', CaminhoCompletoArquivo);
        TFile.Copy(CaminhoCompletoArquivo, DestinoCompleto + '.Hash', True);

        fs := TFileStream.Create(DestinoCompleto + '.Hash', fmOpenRead);
      end
      else
      begin
        fs := TFileStream.Create(CaminhoCompletoArquivo, fmOpenRead);
      end;

    except
      on E: Exception do
      begin
        DestinoCompleto := ExtractFilePath(CaminhoCompletoArquivo) +
          ExtractFileName(CaminhoCompletoArquivo);

        if FileExists(DestinoCompleto + '.Hash') then
          DeleteFile(DestinoCompleto + '.Hash');

        // TFile.Replace( CaminhoCompletoArquivo, DestinoCompleto+'.excluir', CaminhoCompletoArquivo);
        TFile.Copy(CaminhoCompletoArquivo, DestinoCompleto + '.Hash', True);

        fs := TFileStream.Create(DestinoCompleto + '.Hash', fmOpenRead);
      end;
    end;

    try
      Result := LowerCase(HashStreamAsHex(fs));
    finally
      fs.Free;
    end;

    Free;

    if FileExists(DestinoCompleto + '.Hash') then
      DeleteFile(DestinoCompleto + '.Hash');

  end;
end;

end.
