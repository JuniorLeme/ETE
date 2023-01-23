object Frm_MensagemBiblica: TFrm_MensagemBiblica
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'eCFCAnet'
  ClientHeight = 453
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 6
    Width = 563
    Height = 408
    ActivePage = TSAplicativos
    Style = tsFlatButtons
    TabOrder = 0
    object TSAplicativos: TTabSheet
      Caption = 'Aplicativos'
      ExplicitWidth = 556
      object LstBxAplicativos: TListBox
        Left = 0
        Top = 0
        Width = 555
        Height = 377
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 556
      end
    end
    object TSProcessos: TTabSheet
      Caption = 'Processos'
      ImageIndex = 1
      ExplicitWidth = 556
      object LstBxProcessos: TListBox
        Left = 0
        Top = 0
        Width = 555
        Height = 377
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 556
      end
    end
    object TSServicos: TTabSheet
      Caption = 'Servi'#231'os'
      ImageIndex = 2
      ExplicitWidth = 556
      object LstBxServicos: TListBox
        Left = 0
        Top = 0
        Width = 555
        Height = 377
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 556
      end
    end
    object TSHardwares: TTabSheet
      Caption = 'Hardwares'
      ImageIndex = 3
      ExplicitWidth = 556
      object LstBxHardwares: TListBox
        Left = 0
        Top = 0
        Width = 555
        Height = 377
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 556
      end
    end
  end
  object Button1: TButton
    Left = 252
    Top = 420
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button1Click
  end
end
