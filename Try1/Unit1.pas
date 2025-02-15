unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  mmSystem, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  Registry, System.UITypes, Vcl.Menus,
  winXP, Vcl.ComCtrls;
type
  TForm1 = class(TForm)
    Button1: TButton;
    IdFTP1: TIdFTP;
    Memo1: TMemo;
    Button2: TButton;
    SV2Label7: TLabel;
    SV2Label8: TLabel;
    GoldPriceControlBuyComboBox: TComboBox;
    specialGoldOperationComboBox: TComboBox;
    GoldMaxQtyComboBox: TComboBox;
    PopupMenu1: TPopupMenu;
    ClearMemoMenuItem: TMenuItem;
    specialChooseComboBox: TComboBox;
    DateTimePicker1: TDateTimePicker;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ClearMemoMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DateTimePicker1Exit(Sender: TObject);
  private
    { Private declarations }
    procedure OnHotKey(var Msg: TMessage); message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
{$R sounds.res}
var specialspread: {integer} currency = 75832;
    keyid: integer;


procedure TForm1.FormCreate(Sender: TObject);
begin
keyid:=GlobalAddAtom('Hotkey of mine'); //создаем атом
	RegisterHotKey(handle,// сообщение о HotKey будет получать форма
	keyid, // регистрируем атом как id
	MOD_ALT,// модификатор у нас - клавиша Alt
	VK_F11 // вирт. клавиша - F10
	);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UnregisterHotKey(handle, keyid);
GlobalDeleteAtom(keyid);
end;

procedure TForm1.OnHotKey(var Msg: TMessage);
  var
	    idHotKey: integer; //идентификатор, но об этом - позже
	    //fuModifiers: word; //модификатор MOD_XX
	    //uVirtKey: word; //код виртуальной клавиши VK_XX
	begin
	  // параметры сообщения получаем так:
	  idHotkey:= Msg.wParam;
	  //fuModifiers:= LOWORD(Msg.lParam);
	  //uVirtKey:= HIWORD(Msg.lParam);

	  //теперь - небольшая проверочка:
	  //if (fuModifiers = MOD_ALT) AND (uVirtKey = VK_F10) then
    if idHotKey = keyid then
     begin
	    caption:='Alt-F11 нажата';
      Memo1.Lines.Add('Горячая клавиша');
     end;
	  inherited;
end;

procedure TForm1.Button1Click(Sender: TObject);
{var rst: string;
    WinHandle: HWND; }
begin
{
   With TRegistry.Create do
   try
    if not(OpenKey('Software\Eugene private programs\specialSpreadTrading', false)) then MessageDlg('Ошибка открытия ключа реестра ' + 'Software\Eugene private programs\specialSpreadTrading', mtWarning, [mbOk], 0);
    try
     ReadBinaryData('specialUsdBasespread', specialspread, sizeof(integer));
     CloseKey;
    except
     on ERegistryException do MessageDlg('Ошибка ERegistryException', mtWarning, [mbOk], 0);
    end;
   finally
  Free
   end;
}

 SV2Label7.Caption:= FloatToStrF(specialspread, ffFixed, 6, 0);
{ SV2Label7.Caption:= FloatToStrF(  Int(..../1E1)/1E2, ffFixed, 5, 3); }
                                 {  (Int(..../1E1)+1)/1E2    }
  Memo1.Lines.Add('Верификация прошла');
  Memo1.Lines.Add('Соединились');
   //'solnce-_zoshlo-z_uk-dlja-sms.mp3'
 //PlaySound('connect', 0, SND_FILENAME)
{
 rst:= 'sell';
 PlaySound(@rst[1], hInstance, SND_RESOURCE or SND_ASYNC);
}
(*
  try
   With IdFtp1 do begin
    Connect;
    if Connected then Memo1.Lines.Add('Соединились');
    ChangeDir('/eug-trading-technologies.ru/docs/distributives');
    MakeDir('Client9991');
    ChangeDir('Client9991');
    Put('C:\Program Files (x86)\Inno Setup 6\MySetUps\1300 version\Spreadtrading\Output/SpreadTrading_setup.exe', 'SpreadTrading_setup.exe', false);
    Memo1.Lines.Add('Передача файла завершена');
    if SupportsVerification then   {НЕ поддерживает!}
     begin
      Memo1.Lines.Add('Верификация поддерживается сервером...');
      if VerifyFile('C:\Program Files (x86)\Inno Setup 6\MySetUps\1300 version\Spreadtrading\Output/SpreadTrading_setup.exe', 'SpreadTrading_setup.exe', 0, 0)
       then Memo1.Lines.Add('Верификация прошла')
       else Memo1.Lines.Add('Верификация НЕ прошла');
     end;

                  end
  except
   Memo1.Lines.Add('Ошибка')
  end;

     WinHandle:= FindWindow('#32770', 'Идентификация пользователя');
     if not(WinHandle = 0) then
     begin
       SwitchToThisWindow(WinHandle, false);
     end;
*)
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

{
  try
   With IdFtp1 do begin
    Delete('SpreadTrading_setup.exe');
    ChangeDirUp;
    RemoveDir('Client9991');
    Disconnect;
    if not Connected then Memo1.Lines.Add('Разъединились')
                  end;
  except
   Memo1.Lines.Add('Ошибка разъединения')
  end;
}
end;

procedure TForm1.ClearMemoMenuItemClick(Sender: TObject);
begin
 Memo1.Lines.Clear
end;

procedure TForm1.DateTimePicker1Exit(Sender: TObject);
begin
 Memo1.Lines.Add(TimeToStr(DateTimePicker1.Time));
 SV2Label7.Caption:= FloatToStrF(TDateTime(Frac(DateTimePicker1.Time)), ffFixed, 14, 7);
end;

end.
