unit ClsStatusInternet;

interface

type
  TStatusInternet = class

    private
      FFalha : Integer ; //  de 0 a 5.
      FFalhaQtde : Integer;
      FFalhaDescricao : string;
    Public
      property Falha : Integer read FFalha write FFalha;
      property FalhaQtde : Integer read FFalhaQtde write FFalhaQtde;
      property FalhaDescricao : string read FFalhaDescricao write FFalhaDescricao;
  end;

var
  ParStatusInternet : TStatusInternet;

implementation

end.
