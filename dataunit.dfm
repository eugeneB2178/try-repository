object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 139
  Width = 265
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 56
    Top = 8
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'UseSSL=False'
      'DriverID=MySQL')
    FetchOptions.AssignedValues = [evItems]
    LoginPrompt = False
    Transaction = FDTransaction1
    OnError = FDConnection1Error
    AfterConnect = FDConnection1AfterConnect
    BeforeConnect = FDConnection1BeforeConnect
    Left = 184
    Top = 8
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 56
    Top = 64
  end
  object FDScript1: TFDScript
    SQLScripts = <>
    Connection = FDConnection1
    Transaction = FDTransaction1
    Params = <>
    Macros = <>
    Left = 184
    Top = 64
  end
end
