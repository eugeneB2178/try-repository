unit dataunit;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.VCLUI.Wait, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script, FireDAC.Comp.Client, Data.DB,

  System.UITypes, Vcl.Dialogs;

type
  TDataModule1 = class(TDataModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;
    FDTransaction1: TFDTransaction;
    FDScript1: TFDScript;
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure FDConnection1Error(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure FDConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  DataModule1: TDataModule1;}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.FDConnection1AfterConnect(Sender: TObject);
begin
 MessageDlg('Connection established', mtInformation, [mbOk], 0);
end;

procedure TDataModule1.FDConnection1BeforeConnect(Sender: TObject);
begin
 MessageDlg('Connection Before event', mtInformation, [mbOk], 0);
end;

procedure TDataModule1.FDConnection1Error(ASender, AInitiator: TObject;
  var AException: Exception);
begin
 MessageDlg('ConnectionError', mtInformation, [mbOk], 0);
end;

end.
