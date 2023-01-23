object frm_Flash: Tfrm_Flash
  Left = 1039
  Top = 310
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'e-Prova XE'
  ClientHeight = 392
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ShockwaveFlash1: TShockwaveFlash
    Left = 0
    Top = -5
    Width = 313
    Height = 389
    TabOrder = 0
    OnReadyStateChange = ShockwaveFlash1ReadyStateChange
    OnFSCommand = ShockwaveFlash1FSCommand
    ControlData = {
      67556655000E0000592000003428000008000200000000000800000000000800
      0000000008000E000000570069006E0064006F00770000000800060000002D00
      310000000800060000002D003100000008000A00000048006900670068000000
      08000200000000000800060000002D0031000000080000000000080002000000
      0000080010000000530068006F00770041006C006C0000000800040000003000
      0000080004000000300000000800020000000000080000000000080002000000
      00000D0000000000000000000000000000000000080004000000310000000800
      0400000030000000080000000000080004000000300000000800080000006100
      6C006C00000008000C000000660061006C0073006500000008000C0000006600
      61006C007300650000000800040000003000000008000C000000730063006100
      6C0065000000}
  end
  object Panel1: TPanel
    Left = 367
    Top = 0
    Width = 283
    Height = 35
    TabOrder = 1
    object LblStatus: TLabel
      Left = 2
      Top = 2
      Width = 35
      Height = 13
      Caption = 'Status:'
    end
    object LblRetorno: TLabel
      Left = 2
      Top = 18
      Width = 43
      Height = 13
      Caption = 'Retorno:'
    end
  end
  object Memo1: TMemo
    Left = 367
    Top = 37
    Width = 266
    Height = 380
    TabOrder = 2
  end
  object TmrMinimiza: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TmrMinimizaTimer
    Left = 24
    Top = 8
  end
end
