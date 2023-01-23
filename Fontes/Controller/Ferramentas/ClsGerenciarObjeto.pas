unit ClsGerenciarObjeto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons, PNGImage, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  ClsResourceSP, ClsResourceMG, ClsResourceAL, ClsResourceBA, ClsResourceSE,
  ClsResourceETE;

type

  Gerenciador = class(TComponent)
    XMLObjetct: TXMLDocument;
  protected
    function ComponentToStringProc(Component: TComponent): string;
    function StringToComponentProc(Value: string): TComponent;
  public
    procedure CarregaImagem(Componente: TControl; Imagem: string;
      ID_Sistema: Integer);
    procedure FormToXMLDocument(ParForm: TForm);
    procedure XMLDocumentToForm(ParForm: TForm; ID_Sistema: Integer);
    procedure SalvarForm(Caminho: String);
    procedure AbrirForm(Caminho: String);

    Constructor Create; overload;
  end;

var
  GerComp: Gerenciador;

implementation

uses ClsFuncoes;

constructor Gerenciador.Create;
begin
  XMLObjetct := TXMLDocument.Create(self);
end;

procedure Gerenciador.CarregaImagem(Componente: TControl; Imagem: string;
  ID_Sistema: Integer);
var
  png: TPngImage;
  ResourceStream: TResourceStream;
begin

  try
    png := TPngImage.Create;

    ResourceStream := TResourceStream.Create(Hinstance, Imagem, RT_RCDATA);
    png.LoadFromStream(ResourceStream);

    if (Componente is TImage) then
      (Componente as TImage).Picture.Assign(png);

  finally
    FreeANDNIL(png);
    FreeANDNIL(ResourceStream);
  end;

end;

procedure Gerenciador.XMLDocumentToForm(ParForm: TForm; ID_Sistema: Integer);
var
  I: Integer;
  NoRetornoForm: IXMLNode;
  NoRetornoComponentes: IXMLNode;
begin

  XMLObjetct.Active := False;
  XMLObjetct.Xml.Clear;

  if ParForm.Name + '_XML' = 'Frm_Login_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_Login_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_Login_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_Login_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_Login_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_Login_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_Login_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_Login_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_IdentificaCandidato_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_IdentificaCandidato_XML532997);
    end;

  if ParForm.Name + '_XML' = 'frm_CadastroCandidato_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML591804);
      872461:
        XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML872461);
      806076:
        XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML806076);
      532997:
        XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML532997);
      726851:
        XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML726851);
      529756:
        XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML529756);

    else
      XMLObjetct.LoadFromXML(frm_CadastroCandidato_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_Foto_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_Foto_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_Foto_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_Foto_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_Foto_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_Foto_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_Foto_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_Foto_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_BiometriaFotos_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_BiometriaFotos_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_Informacoes_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_Informacoes_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_Informacoes_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_Informacoes_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_Informacoes_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_Informacoes_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_Informacoes_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_Informacoes_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_Confirmacao_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_Confirmacao_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_Confirmacao_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_Confirmacao_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_Confirmacao_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_Confirmacao_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_Confirmacao_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_Confirmacao_XML532997);
    end;

  if ParForm.Name + '_XML' = 'frm_Flash_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(frm_Flash_XML591804);
      872461:
        XMLObjetct.LoadFromXML(frm_Flash_XML872461);
      806076:
        XMLObjetct.LoadFromXML(frm_Flash_XML806076);
      532997:
        XMLObjetct.LoadFromXML(frm_Flash_XML532997);
      726851:
        XMLObjetct.LoadFromXML(frm_Flash_XML726851);
      529756:
        XMLObjetct.LoadFromXML(frm_Flash_XML529756);
    else
      XMLObjetct.LoadFromXML(frm_Flash_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_Questionario_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_Questionario_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_Questionario_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_Questionario_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_Questionario_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_Questionario_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_Questionario_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_Questionario_XML532997);
    end;

  if ParForm.Name + '_XML' = 'Frm_Resultado_XML' then
    case ID_Sistema of
      591804:
        XMLObjetct.LoadFromXML(Frm_Resultado_XML591804);
      872461:
        XMLObjetct.LoadFromXML(Frm_Resultado_XML872461);
      806076:
        XMLObjetct.LoadFromXML(Frm_Resultado_XML806076);
      532997:
        XMLObjetct.LoadFromXML(Frm_Resultado_XML532997);
      726851:
        XMLObjetct.LoadFromXML(Frm_Resultado_XML726851);
      529756:
        XMLObjetct.LoadFromXML(Frm_Resultado_XML529756);
    else
      XMLObjetct.LoadFromXML(Frm_Resultado_XML532997);
    end;

  if Trim(XMLObjetct.Xml.Text) <> '' then
  begin
    XMLObjetct.Active := True;
    if XMLObjetct.Xml.Text <> '' then
    begin
      NoRetornoForm := XMLObjetct.ChildNodes.FindNode(ParForm.Name);
      if NoRetornoForm <> nil then
      begin
        // ParForm.ClientHeight := NoRetornoForm.Attributes['ClientHeight'];
        // ParForm.ClientWidth := NoRetornoForm.Attributes['ClientWidth'];
        ParForm.Caption := NoRetornoForm.Attributes['Caption'];

        for I := 0 to ParForm.ComponentCount - 1 do
        begin
          if (ParForm.Components[I] is TControl) then
          begin
            NoRetornoComponentes := NoRetornoForm.ChildNodes.FindNode
              (ParForm.Components[I].Name);
            if NoRetornoComponentes <> nil then
            begin
              {
                if NoRetornoComponentes.Attributes['Left'] <> '' then
                (ParForm.Components[I] as TControl).Left := NoRetornoComponentes.Attributes['Left'];

                if NoRetornoComponentes.Attributes['Top'] <> '' then
                (ParForm.Components[I] as TControl).Top := NoRetornoComponentes.Attributes['Top'];

                if NoRetornoComponentes.Attributes['ClientHeight'] <> '' then
                (ParForm.Components[I] as TControl).ClientHeight := NoRetornoComponentes.Attributes['ClientHeight'];

                if NoRetornoComponentes.Attributes['ClientWidth'] <> '' then
                (ParForm.Components[I] as TControl).ClientWidth := NoRetornoComponentes.Attributes['ClientWidth'];
              }
              if NoRetornoComponentes.HasAttribute('ImageResource') then
                CarregaImagem((ParForm.Components[I] as TControl),
                  NoRetornoComponentes.Attributes['ImageResource'], ID_Sistema);

              if (NoRetornoComponentes.HasAttribute('MaxLength')) then
                if (NoRetornoComponentes.Attributes['MaxLength'] <> '') and
                  (ParForm.Components[I] is TEdit) then
                  (ParForm.Components[I] as TEdit).MaxLength :=
                    NoRetornoComponentes.Attributes['MaxLength'];

              if (NoRetornoComponentes.HasAttribute('MaxLength')) then
                if (NoRetornoComponentes.Attributes['MaxLength'] <> '') and
                  (ParForm.Components[I] is TEdit) then
                  (ParForm.Components[I] as TEdit).MaxLength :=
                    NoRetornoComponentes.Attributes['MaxLength'];

              if (NoRetornoComponentes.HasAttribute('MaxLength')) then
                if (NoRetornoComponentes.Attributes['MaxLength'] <> '') and
                  (ParForm.Components[I] is TButtonedEdit) then
                  (ParForm.Components[I] as TButtonedEdit).MaxLength :=
                    NoRetornoComponentes.Attributes['MaxLength'];

              if (NoRetornoComponentes.HasAttribute('Caption')) then
                if (NoRetornoComponentes.Attributes['Caption'] <> '') and
                  (ParForm.Components[I] is TCustomLabel) then
                  (ParForm.Components[I] as TCustomLabel).Caption :=
                    NoRetornoComponentes.Attributes['Caption'];

            end;
          end;
        end;
      end;
    end;
  end;
  XMLObjetct.Active := False;
end;

procedure Gerenciador.FormToXMLDocument(ParForm: TForm);
var
  I: Integer;
  XmlTexto: string;
  Xml: TXMLDocument;
  XMLElementoForm: IXMLNode;
  XMLComponentes: IXMLNode;
begin
  { #Tag's#
    1 = Logo
    2 = Fundo
  }

  Xml := TXMLDocument.Create(nil);
  Xml.Active := False;
  Xml.Active := True;

  XMLElementoForm := Xml.AddChild(ParForm.Name);
  XMLElementoForm.Text := '';

  XMLElementoForm.Attributes['ClientHeight'] := ParForm.ClientHeight;
  XMLElementoForm.Attributes['ClientWidth'] := ParForm.ClientWidth;
  XMLElementoForm.Attributes['Caption'] := ParForm.Caption;

  for I := 0 to ParForm.ComponentCount - 1 do
  begin
    if (ParForm.Components[I] is TControl) then
    begin
      XMLComponentes := XMLElementoForm.AddChild(ParForm.Components[I].Name);
      XMLComponentes.Attributes['tipo'] := ParForm.Components[I].ClassName;
      XMLComponentes.Attributes['Left'] :=
        (ParForm.Components[I] as TControl).Left;
      XMLComponentes.Attributes['Top'] :=
        (ParForm.Components[I] as TControl).Top;
      XMLComponentes.Attributes['ClientHeight'] :=
        (ParForm.Components[I] as TControl).ClientHeight;
      XMLComponentes.Attributes['ClientWidth'] :=
        (ParForm.Components[I] as TControl).ClientWidth;

      if (ParForm.Components[I] is TLabel) then
        XMLComponentes.Attributes['Caption'] :=
          (ParForm.Components[I] as TCustomLabel).Caption;

      if (ParForm.Components[I] is TButtonedEdit) then
        XMLComponentes.Attributes['MaxLength'] :=
          (ParForm.Components[I] as TButtonedEdit).MaxLength;

      if (ParForm.Components[I] is TEdit) then
        XMLComponentes.Attributes['MaxLength'] :=
          (ParForm.Components[I] as TEdit).MaxLength;

      if (ParForm.Components[I] is TImage) AND
        ((ParForm.Components[I] as TControl).Tag = 1) then
        XMLComponentes.Attributes['ImageResource'] := 'Logo';
    end;
  end;

  Xml.SaveToXML(XmlTexto);
  Xml.Active := False;

  XMLObjetct.Active := False;
  XMLObjetct.Active := True;
  XMLObjetct.Xml.Add('<?xml version="1.0" encoding="UTF-8"?>' + XmlTexto);
end;

procedure Gerenciador.AbrirForm(Caminho: String);
var
  DialogoAbrir: TOpenDialog;
begin
  if Trim(Caminho) = '' then
  begin
    DialogoAbrir := TOpenDialog.Create(nil);
    if DialogoAbrir.Execute then
    begin
      XMLObjetct.LoadFromFile(DialogoAbrir.FileName);
    end;
    DialogoAbrir.Free;
  end
  else
  begin
    XMLObjetct.LoadFromFile(Caminho);
  end;
end;

procedure Gerenciador.SalvarForm(Caminho: String);
var
  DialogoSalvar: TSaveDialog;
begin
  if Trim(Caminho) = '' then
  begin
    DialogoSalvar := TSaveDialog.Create(nil);
    if DialogoSalvar.Execute then
      XMLObjetct.SaveToFile(DialogoSalvar.FileName);
    DialogoSalvar.Free;
  end
  else
  begin
    XMLObjetct.Active := False;
    XMLObjetct.Active := True;
    XMLObjetct.SaveToFile(Caminho);
  end;
end;

function Gerenciador.ComponentToStringProc(Component: TComponent): string;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function Gerenciador.StringToComponentProc(Value: string): TComponent;
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(nil);
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

end.
