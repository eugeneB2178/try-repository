object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 282
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControlEnhanced
    Left = 0
    Top = 0
    Width = 279
    Height = 282
    Align = alClient
    OwnerDraw = True
    TabOrder = 0
    Tabs.Strings = (
      #1054#1073#1097#1080#1077
      #1048#1085#1089#1090#1088#1091#1084#1077#1085#1090#1099
      #1055#1088#1086#1095#1077#1077
      'Special')
    TabIndex = 0
    object specialLabel1: TLabel
      Left = 80
      Top = 88
      Width = 36
      Height = 13
      Caption = 'MaxQty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object specialLabel3: TLabel
      Left = 71
      Top = 123
      Width = 65
      Height = 13
      Caption = 'specialRange'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object specialLabel4: TLabel
      Left = 10
      Top = 123
      Width = 5
      Height = 13
      Caption = 's'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object specialLabel5: TLabel
      Left = 71
      Top = 153
      Width = 61
      Height = 13
      Caption = 'specialOffset'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object specialComboBoxMaxQty: TComboBox
      Left = 24
      Top = 83
      Width = 50
      Height = 22
      BevelKind = bkTile
      Style = csOwnerDrawFixed
      Color = clBtnFace
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      StyleElements = [seClient, seBorder]
    end
    object specialUseMaxQtyGoldCheckBox: TCheckBox
      Left = 127
      Top = 79
      Width = 150
      Height = 33
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1076#1083#1103' '#1074#1089#1077#1093' '#1089#1076#1077#1083#1086#1082' '#1087#1086' '#1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1091
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      WordWrap = True
    end
    object Edit_specialRange: TEdit
      Left = 24
      Top = 120
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Edit_specialOffset: TEdit
      Left = 24
      Top = 150
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
end
