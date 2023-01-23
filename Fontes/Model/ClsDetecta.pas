unit ClsDetecta;

interface

type
  TDetecta = class
  protected

  public

    Enviar_Processos: string;
    Verifica_Processos_Quantidade_simulado: Integer;
    Verifica_Processos_tempo_simulado: Integer;

    Verifica_Processos_Quantidade_Prova: Integer;
    Verifica_Processos_tempo_Prova: Integer;

    MensagemTipo: string;
    MensagemDetecta: WideString;

    Prova_Tempo: Integer;
    Prova_Ativo: Boolean;

    Simulado_Tempo: Integer;
    Simulado_Ativo: Boolean;
  end;

var
  ParDetecta: TDetecta;

implementation

end.
