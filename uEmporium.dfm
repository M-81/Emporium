object Emporium: TEmporium
  Left = 0
  Top = 0
  Caption = 'Mario'#39's emporium'
  ClientHeight = 339
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    463
    339)
  PixelsPerInch = 96
  TextHeight = 13
  object BCheckOut: TButton
    Left = 348
    Top = 280
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'CheckOut'
    Enabled = False
    TabOrder = 0
    OnClick = BCheckOutClick
    ExplicitLeft = 520
    ExplicitTop = 240
  end
  object Memo1: TMemo
    Left = 8
    Top = 128
    Width = 289
    Height = 177
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object rgExamples: TRadioGroup
    Left = 8
    Top = 8
    Width = 105
    Height = 105
    Caption = 'Examples'
    TabOrder = 2
  end
  object bGenerateExample: TButton
    Left = 136
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Fill up'
    TabOrder = 3
    OnClick = bGenerateExampleClick
  end
end
