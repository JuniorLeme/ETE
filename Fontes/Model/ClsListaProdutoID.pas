unit ClsListaProdutoID;

interface

uses System.Classes;

type

  TProdutoID = class
    uf: string;
    descricao: string;
    servidor: string;
    digital: Integer;
    foto: Integer;
  end;

  TListaProdutoID = class(TStringList);

  {
    <e-prova uf="SP">
    <descricao>e-CFCAnet SP</descricao>
    <servidor>591804</servidor>
    <portas>
    <digital>9292</digital>
    <foto>9393</foto>
    </portas>
    </e-prova>
  }

var
  ListaProdutoID: TListaProdutoID;

implementation

end.
