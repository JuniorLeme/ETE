unit ClsServidorControl;

interface

uses
  System.SysUtils, System.IniFiles, System.Win.Registry, Winapi.Windows,
  System.Classes, vcl.Dialogs, Xml.XMLIntf, Xml.XMLDoc, Datasnap.DSClientRest,
  System.JSON, ClsFuncoes, ClseProvaConst;

type
  Servidor = class(TObject)
  protected
    FTempoProva: Integer;
    FTempoProvaExtra: Integer;
    FNumeroQuestoes: Integer;
    FSecao: string;
    FID_Sistema: Integer;
    FAvancoAutomatico: string;
  public
    property ID_Sistema: Integer read FID_Sistema write FID_Sistema;
    property Secao: String read FSecao write FSecao;
    property AvancoAutomatico: string read FAvancoAutomatico
      write FAvancoAutomatico;
  end;

var
  ParServidor: Servidor;

implementation

end.
