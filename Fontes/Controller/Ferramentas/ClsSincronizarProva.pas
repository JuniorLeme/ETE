unit ClsSincronizarProva;

interface

uses System.Classes, Vcl.Graphics, System.SysUtils, System.Generics.Collections;

type

  TListaProvasPendente = Class(TStringList)
    procedure ListarArquivos(Diretorio: string; Sub: Boolean);
  end;

implementation

procedure TListaProvasPendente.ListarArquivos(Diretorio: string; Sub: Boolean);
var
  F: TSearchRec;
  Ret: Integer;
begin

  Self.Clear;

  Ret := FindFirst(Diretorio + '\*.ep', faAnyFile, F);

  try

    while Ret = 0 do
    begin

      Self.Add(Diretorio + '\' + F.Name);
      Ret := FindNext(F);

    end;

  finally
    begin
      FindClose(F);
    end;
  end;

end;

end.
