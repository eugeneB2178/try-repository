unit Unit1;

interface

uses
  Winapi.Windows, System.AnsiStrings, Winapi.Messages, System.SysUtils, System.UITypes, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ShlObj, System.Odbc, Odbc32, winXP;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    TestMysqlDriverButton: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TestMysqlDriverButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  oemres: array[0..1] of word;


implementation
{$R *.dfm}
uses dataunit;
const
    GlassDepth = 99;
    ses1Addr = 5;
    VirtAddress: LPCSTR = '15009rg';
    ExchangeAccountMaxsize = 255;
    invalidROW = -1;
    CrSecSpinCount = 4000;
         DSN_name = 'gap';
         Op20 = 'select sell, price, buy from gap.gazpglass order by price';
         P_49 = 'Ошибка ';
         M_7 = P_49 + 'создания дескриптора окружения';
         M_8 = P_49 + 'закрытия дескриптора окружения';
         M_9 = 'Версия ODBC ниже 3.8!';
         M_10 = P_49 + 'создания дескриптора соединения';
         M_11 = P_49 + 'закрытия дескриптора соединения';
         M_12 = P_49 + 'соединения с DSN';
         M_13 = P_49 + 'разъединения с DSN';
         M_14 = P_49 + 'задания атрибутов соединения';
         M_15 = P_49 + 'создания дескриптора оператора';
         M_16 = P_49 + 'закрытия дескриптора оператора';
         M_31 = P_49 + 'создания критической секции';
         M_43 = ' и ошибка SQLGetDiagRec';
         M_44 = '. Код SQLState ';
         M_52 = 'чтения SQLFetch';
         M_61 = P_49 + M_52 + ', gap.gazpglass table is empty';
         M_132 = P_49 + 'компиляции SQLPrepare';
         M_133 = P_49 + 'запроса SQLExecute к таблице';
         M_134 = P_49 + 'связывания SQLBindCol';
type
     TConfigDSN = function(hwndParent: HWND; fRequest: WORD; lpszDriver, lpszAttributes: PWideChar):BOOL;

     TGlassquote = record
      sell, buy: cardinal;    {[rax+0] [rax+4]}
      price: double           {[rax+8]}
              end;

     Tglass = array[0..GlassDepth] of TGlassquote;

     TStructureUDF = record
      rowsNumber,              {[rax+0]}
      bidrow,                  {[rax+4]}
      askrow: integer;         {[rax+8]}
        theybuy: double;       {[rax+16]}
        howmuchbuy: integer;   {[rax+24]}
        theysell: double;      {[rax+32]}
        howmuchsell: integer;  {[rax+40]}
      glass: Tglass      {offset of glass[0] = 48 record field alignment is quad-word}
                     end;

     PInternalStructure = ^TInternalStructure;  //sizeof(TInternalStructure)= 1712
     TInternalStructure = record       {if mov rax, qword ptr PInternalStructure or mov rax, PInternalStructure then}
      Phstmt: SQLHANDLEPTR;            {[rax+0]}
      Pquote: ^TGlassquote;            {[rax+8]}
      PStructureUDF: ^TStructureUDF;   {[rax+16]}
      rowid: integer;                  {[rax+24], }
      nextdwData: ULONG_PTR;           {[rax+32] record field alignment is quad-word}
      tmp_retcode: SQLRETURN;          {[rax+40]}
      ptrtoCriticalSection: PRTLCriticalSection; {[rax+48]      40 record field alignment is quad-word]}
      PThread7Handle: PHandle;         {[rax+56]}
      tmp_StructureUDF: TStructureUDF; {[rax+64]}
      flag: boolean;
                          end;

var //hhh: TInternalStructure;
    hhh: TInternalStructure;
    teststr: LPCSTR;
    oemhigh: PWord = @oemres[0];
    oemlow: PWord = @oemres[1];
    oemdword: PDWORD = @oemres[0];
    {avh: THandle;} av{, av1}: cardinal; {фигня}
    Msg: TMessage;

    //ODBCInstallerFunctionName: LPCSTR = 'ConfigDSNW';
    //InternalLogFileHandle: THandle;

  retcode: SQLRETURN; {код возврата}
  str1: Ansistring;
  StrLenorInd:SQLLEN;
  henv: SQLHENV;
  hdbc1: SQLHDBC;
  ErrorMes, ResultMes: LPCSTR;

        {RemoteProcessAccess UDF}
    GazpCriticalSection: TRTLCriticalSection;
    GazpStructureUDFRemote: TStructureUDF;
   {Internal}
  gazpinternalhstmt: SQLHSTMT;
  gazpinternalglassquote: TGlassquote;   {use to bind glass}
  GazpInternalStructure: TInternalStructure;


procedure MyZM(Destination: pointer; Length, Length1, Length2: Cardinal); assembler;
var tmpDestination: pointer; tmpLength2: Cardinal;
asm  {параметры в глобальную asm-процедуру передаются в след. порядке: rcx, rdx, r8, r9, далее через стек;
      если в начале кода обнулить такой регистр, то дальнейшее прямое обращение к параметру станет недействительным}
  .PUSHNV rsi
  mov tmpDestination, rcx
  mov tmpLength2, r9d

  mov rax, tmpDestination
  xor rcx, rcx
  mov ecx, tmpLength2
 @@zzz:
  mov byte ptr [rax], 5
  inc rax
  loop @@zzz

  mov rsi, 21
end;

procedure MyZM_1(Destination: pointer; Length, Length1, Length2: Cardinal);
var l_Destination: pointer;
  procedure asmcode_10(asmDestination: pointer; asmLength, asmLength1, asmLength2: cardinal); assembler;
  var tmpDestination: pointer; tmpLength: Cardinal;
  asm {параметры в локальную asm-процедуру передаются в след. порядке: rdx, r8, r9, далее через стек;
       если в начале кода обнулить такой регистр, то дальнейшее прямое обращение к параметру станет недействительным}
  { xor rdx, rdx
   xor r8, r8 !!!}
     .PUSHNV rbx
     .PUSHNV rdi
     .PUSHNV rsi
   // probe code
     .PUSHNV r13  // end of probe code
  mov rax, [rsp+56]        //probe code

  mov tmpDestination, rdx
  mov tmpLength, r8d

   mov rax, tmpDestination
   xor rcx, rcx
   mov ecx, tmpLength
  @@zzz:
   mov byte ptr [rax], 64
   inc rax
   loop @@zzz
{   mov rcx, 0
   mov rdx, tmpDestination
   mov r8, 0
   mov r9, 0
   call MessageBoxA  }

   mov rax, [rsp+56]       // probe code
   mov [rsp+56], 0
   mov [rsp+56], rax
  end;
begin
  l_Destination:= Destination;
  asmcode_10(l_Destination, Length, Length1, Length2);
end;

function TestWriteFile(t1,t2,t3,t4: Int64;
           thFile: THandle;
           tlpBuffer: pointer;
           tnNumberOfBytesToWrite: DWORD;
           tlpNumberOfBytesWritten: PDWORD;
           tlpOverlapped: POverlapped): BOOL; winapi;
begin
 Result:= WriteFileWinApi(thFile, tlpBuffer, tnNumberOfBytesToWrite, tlpNumberOfBytesWritten, tlpOverlapped)
end;
procedure asmcode_1; assembler;
asm
 {
  mov rcx,0; mov rdx,0; mov r8,0; mov r9,0
  mov rax, InternalLogFileHandle; mov [rsp+32], rax
  lea rax, av; mov [rsp+40], rax
  mov [rsp+48], 4
  lea rax, av1; mov [rsp+56], rax
  mov [rsp+64], 0
  call TestWriteFile                     НЕ работает - меняет адрес возврата в стеке       }
 {
 mov rcx, InternalLogFileHandle
 lea rdx, av
 mov r8, 4
 lea r9, av1
 mov [rsp+32], 0
 call WriteFileWinApi      }            //Да работает
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    trace_pass: string;
    i: integer;
    iii: HKL;
    LW: PWord;
    //MySqldriverName,
    //MySqlODBCInstallerdll: string;
    //InstallerDLLHandle: HModule;
    //ConfigDSN: TConfigDSN;

 procedure SendKeyToEdit;
 begin
   SendMessage(Edit1.Handle, WM_KEYDOWN, Msg.WParam, Msg.LParam);
   SendMessage(Edit1.Handle, WM_CHAR, Msg.WParam, Msg.LParam);
   SendMessage(Edit1.Handle, WM_KEYUP, Msg.WParam, Msg.LParam);
 end;
  procedure asmcode_4; assembler;
    asm      //Msg.WParamLo:= av = ord(ASCIItrace_pass[i]); Msg.LParamHi:= oemhigh^;
    .NOFRAME

     mov EAX, av
     mov word ptr Msg.WParam, AX
     mov r10, oemhigh
     mov AX, [r10]
     mov word ptr Msg.LParam + 2, AX
    end;
begin
 hhh.rowid:= 1;

 teststr:= System.AnsiStrings.AnsiStrAlloc(ExchangeAccountMaxsize);
 MyZM_1(teststr, ExchangeAccountMaxsize, ExchangeAccountMaxsize-1, ExchangeAccountMaxsize-2);

   trace_pass:= 'Ф@-+\CeЫюЯ7ZKn';           //'Ф^Ы@ВАz1@ПРОЛэ';            //
   Msg.WParam:= 0; Msg.LParam:= 0;
   for i:= 1 to length(trace_pass) do begin
    oemdword^:= OemKeyScan(ord(trace_pass[i]));
    if oemdword^ = INVALID_SET_FILE_POINTER then
    begin
     iii:= GetKeyboardLayout(0);
     LW:= @iii;
     Label1.Caption:= IntToStr(LW^);
    end;
    av:= ord(trace_pass[i]);
    asmcode_4;
    SendKeyToEdit
                                      end;
 System.AnsiStrings.StrDispose(teststr);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 System.AnsiStrings.StrDispose(ErrorMes);
 System.AnsiStrings.StrDispose(ResultMes);
 retcode:= SQLFreeHandle(SQL_HANDLE_STMT, gazpinternalhstmt);
 if not(retcode = SQL_SUCCESS) then MessageDlg(M_16, mtInformation, [mbOk], 0);
 retcode:= SQLDisconnect(hdbc1);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then MessageDlg(M_13, mtInformation, [mbOk], 0);
 retcode:= SQLFreeHandle(SQL_HANDLE_DBC, hdbc1);
 if not(retcode = SQL_SUCCESS) then MessageDlg(M_11, mtInformation, [mbOk], 0);
 retcode:= SQLFreeHandle(SQL_HANDLE_ENV, henv);
 if not (retcode = SQL_SUCCESS) then MessageDlg(M_8, mtInformation, [mbOk], 0);
 Action:= caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
var //tempstr1: AnsiString;
        {internal}
    NativeError: integer;
    TextLength: SmallInt;
begin
 {}
 GazpStructureUDFRemote.bidrow:= invalidROW; GazpStructureUDFRemote.askrow:= invalidROW;
 henv:= nil; hdbc1:= nil; gazpinternalhstmt:= nil;
 ErrorMes:= System.AnsiStrings.AnsiStrAlloc(100);
 ResultMes:= System.AnsiStrings.AnsiStrAlloc(100);
  // Allocate the environment handle
 retcode := SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, henv);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_7, mtError, [mbOk], 0); ExitProcess(5) end;
 retcode := SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, SQL_OV_ODBC3_80, 0);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_9, mtError, [mbOk], 0); ExitProcess(5) end;
  // Allocate the connection handle
 retcode := SQLAllocHandle(SQL_HANDLE_DBC, henv, hdbc1);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_10, mtError, [mbOk], 0); ExitProcess(5) end;
 retcode:= SQLSetConnectAttr(hdbc1, SQL_ATTR_ACCESS_MODE, SQL_MODE_READ_ONLY, 0);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_14, mtError, [mbOk], 0); ExitProcess(5) end;
 str1:= DSN_name;
 retcode:= SQLConnectA(hdbc1, @str1[1], SQL_NTS, nil, SQL_NTS, nil, SQL_NTS);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin
  retcode:= SQLGetDiagRecA(SQL_HANDLE_DBC, hdbc1, 1, ResultMes, NativeError, ErrorMes, 100, TextLength);
   if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_12 + M_43, mtError, [mbOk], 0); end
                                                          else begin MessageDlg(M_12 + M_44 + ResultMes, mtError, [mbOk], 0); end;
      ExitProcess(5);
                                                             end;
   //Allocate the internal statement handles for future contract glass of gap schema
 retcode:= SQLAllocHandle(SQL_HANDLE_STMT, hdbc1, gazpinternalhstmt);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_15, mtError, [mbOk], 0); ExitProcess(5) end;
 {инициализируем критические секции}
  if not (
   InitializeCriticalSectionAndSpinCount(GazpCriticalSection, CrSecSpinCount)
         ) then begin MessageDlg(M_31, mtWarning, [mbOK], 0); ExitProcess(5) end;
 {инициализировали}
       {Internal}
  With GazpInternalStructure do
  begin
    Phstmt:= @gazpinternalhstmt;
    Pquote:= @gazpinternalglassquote;
    ptrtoCriticalSection:= @GazpCriticalSection;
    PStructureUDF:= @GazpStructureUDFRemote;
    PThread7Handle:= nil;
    nextdwData:= 1;
    flag:= false;
  end;
    {считываем gazpglass}
 str1:= Op20;
 retcode:= SQLPrepareA(gazpinternalhstmt, @str1[1], SQL_NTS);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_132, mtError, [mbOk], 0); ExitProcess(5) end;
 retcode:= SQLExecute(gazpinternalhstmt);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin
  retcode:= SQLGetDiagRecA(SQL_HANDLE_STMT, gazpinternalhstmt, 1, ResultMes, NativeError, ErrorMes, 100, TextLength);
   if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_133 + M_43, mtError, [mbOk], 0); ExitProcess(5) end
                                                          else begin MessageDlg(M_133 + M_44 + ResultMes, mtError, [mbOk], 0); ExitProcess(5) end
                                                             end;
 retcode:= SQLBindCol(gazpinternalhstmt, 1, SQL_C_LONG, @gazpinternalglassquote.sell, sizeof(integer), @StrLenorInd);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_134, mtError, [mbOk], 0); ExitProcess(5) end;
 retcode:= SQLBindCol(gazpinternalhstmt, 2, SQL_C_DOUBLE, @gazpinternalglassquote.price, sizeof(double), @StrLenorInd);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_134, mtError, [mbOk], 0); ExitProcess(5) end;
 retcode:= SQLBindCol(gazpinternalhstmt, 3, SQL_C_LONG, @gazpinternalglassquote.buy, sizeof(integer), @StrLenorInd);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_134, mtError, [mbOk], 0); ExitProcess(5) end;
 retcode:= SQLFetch(gazpinternalhstmt);
 if not(retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin MessageDlg(M_61, mtError, [mbOk], 0); ExitProcess(5) end;

end;
procedure TForm1.FormDestroy(Sender: TObject);
begin
 DeleteCriticalSection(GazpCriticalSection);;
end;

{tempstr1:= 'C:\masm32\Applications\mytest.log';
  InternalLogFileHandle:= CreateFileA(@tempstr1[1], GENERIC_WRITE, FILE_SHARE_READ, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, 0);

  av:= 5;
  asmcode_1;
  if not(asmcode_1)
           then MessageDlg('Error', mtWarning, [mbOk], 0);

  FlushFileBuffers(InternalLogFileHandle);
  CloseHandle(InternalLogFileHandle);

   a:= SetSecurityInfo(GetCurrentProcess, ord(SE_KERNEL_OBJECT), DACL_SECURITY_INFORMATION, nil,nil,nil,nil);
   MessageDlg(IntToStr(a), mtWarning, [mbOk], 0);

 MySqldriverName:= 'MySQL ODBC 8.0 ANSI Driver';
 MySqlODBCInstallerdll:= 'C:\Program Files\MySQL\Connector ODBC 8.0\myodbc8S.dll';
 InstallerDLLHandle:= LoadLibrary(@MySqlODBCInstallerdll[1]);
 if InstallerDLLHandle = 0 then MessageDlg('InstallerDLLHandle = 0', mtInformation, [mbOk], 0);
 @ConfigDSN:= GetProcAddress(InstallerDLLHandle, ODBCInstallerFunctionName);
 if (@ConfigDSN = nil) then MessageDlg('@ConfigDSN = nil', mtInformation, [mbOk], 0);
 MySqlODBCInstallerdll:= 'DSN=Eug_trading_technologies';
 if not ConfigDSN(0, ODBC_REMOVE_DSN, @MySqldriverName[1], @MySqlODBCInstallerdll[1]) then
     MessageDlg('not', mtInformation, [mbOk], 0)                                      else
     MessageDlg('configured', mtInformation, [mbOk], 0);
 FreeLibrary(InstallerDLLHandle);
}
{
  with TDataModule1.Create(nil) do
     try
 FDPhysMySQLDriverLink1.VendorLib:= 'C:\Program Files\MySQL\MySQL Server 8.0\lib\libmysql.dll';  //mysqllibfile;
 FDConnection1.Params.UserName:= 'eugene';
 FDConnection1.Params.Password:= '688158201';
 FDConnection1.Connected:= true;
 if FDConnection1.Connected then MessageDlg('Connected', mtInformation, [mbOk], 0)
                            else MessageDlg('Not Connected', mtInformation, [mbOk], 0);
     finally
 Free
    end;

 MySqlODBCInstallerdll:= 'C:\Program Files\MySQL\MySQL Server 8.0\lib\libmysql.dll';
 InstallerDLLHandle:= LoadLibrary(@MySqlODBCInstallerdll[1]);
 if InstallerDLLHandle = 0 then MessageDlg('LoadLibrary error code ' + IntToStr(GetLastError), mtInformation, [mbOk], 0)
                           else MessageDlg('Mysql library loaded', mtInformation, [mbOk], 0);
 FreeLibrary(InstallerDLLHandle);
}

procedure TForm1.TestMysqlDriverButtonClick(Sender: TObject);
 var InternalStructurePTR: PInternalStructure;

  procedure asmcode_2(tmpInternalStructurePTR: PInternalStructure); assembler;
    asm
     .PUSHNV rbx
     .PUSHNV rdi
     .PUSHNV rsi
{      .PUSHNV r12   // extra secret code
      .PUSHNV r13
      .PUSHNV r14
      .PUSHNV r15
      enter 160,0

      mov rax, rsp
      push [rax+144]   //probe code
}
      mov rbx, rdx          {first parameter in rdx, because this is local assembler procedure}
                                        //With InternalStructurePTR^ do                                begin

  {   mov r13, [rsp+40]
     mov rdi, [rsp+32]
     mov rcx, InternalLogFileHandle; mov avh, r13; lea rdx, avh; mov r8, 8; lea r9, av1; mov [rsp+32], 0; call WriteFileWinApi
     mov rcx, InternalLogFileHandle; call FlushFileBuffers
     mov [rsp+32], rdi     }
   //end of probe code

      mov dword ptr [rbx+24], 0         //rowid:= 0;
      mov rsi, [rbx+0]            // Phstmt
      mov rcx, [rsi]; mov rdx, SQL_CLOSE              //Phstmt^
      call SQLFreeStmt
      cmp AX, SQL_SUCCESS    //if not(tmp_retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin PostMessage(MainHandle, Eug_Inform, 0, 2); goto 1 end;
      je @@label43
      cmp AX, SQL_SUCCESS_WITH_INFO
      je @@label43
    //  mov rcx, MainHandle; mov rdx, Eug_Inform; mov r8, 0; mov r9, 2; call PostMessage
      jmp @@label42
     @@label43:
      mov rcx, [rsi]              //Phstmt^
      call SQLExecute        //SQLExecute(Phstmt^); result in AX register
      cmp AX, SQL_SUCCESS    //if not(tmp_retcode in [SQL_SUCCESS,SQL_SUCCESS_WITH_INFO]) then begin PostMessage(MainHandle, Eug_Inform, 0, 0); goto 1 end;
      je @@label37
      cmp AX, SQL_SUCCESS_WITH_INFO
      je @@label37
    //  mov rcx, MainHandle; mov rdx, Eug_Inform; mov r8, 0; mov r9, 0; call PostMessage
      jmp @@label42
     @@label37:             //Repeat
      mov rsi, [rbx+0]            // Phstmt
      mov rcx, [rsi]              //Phstmt^
      call SQLFetch           //result in AX register
   //probe code
    { mov r13, rax
     mov rdi, [rsp+32]
     mov rcx, InternalLogFileHandle; mov av, r13d; lea rdx, av; mov r8, 4; lea r9, av1; mov [rsp+32], 0; call WriteFileWinApi
     mov rcx, InternalLogFileHandle; call FlushFileBuffers
     mov [rsp+32], rdi
     mov rax, r13   }
   //end of probe code
      mov word ptr [rbx+40],AX     //fill tmp_retcode  InternalStructurePTR.tmp_retcode:= SQLFetch(InternalStructurePTR.Phstmt^);
      mov r10d, dword ptr [rbx+24]                  // r10d = rowid
      cmp AX, SQL_NO_DATA        //if ((InternalStructurePTR.tmp_retcode = SQL_NO_DATA) or (InternalStructurePTR.tmp_retcode = SQL_Error) or (InternalStructurePTR.rowid > GlassDepth)) then Break;
      je @@label38
      cmp r10d, GlassDepth
      ja  @@label38
      cmp AX, SQL_ERROR
      je @@label38
      mov rsi, rbx
      add rsi, 64         //not yet result this is to fill StructureUDF: offset tmp_StructureUDF  mov rsi, rbx+64
      mov dword ptr [rsi+0], r10d                     //rowsNumber:= rowid   rsi+0
      test r10d,r10d
      jnz @@label33
      mov dword ptr [rsi+4], invalidROW  //bidrow
      mov dword ptr [rsi+8], invalidROW  //askrow
     @@label33:
      mov rcx, [rbx+8]               //Pquote = sell, buy, price
      mov edi, dword ptr [rcx+0]    //<sell> = rcx+0 => edi
      mov edx, dword ptr [rcx+4]   // EDX now not points to **args!!! It is <buy> = rcx+4 => edx
      mov r11, [rcx+8]             // double value <price> = rcx+8  old code fld qword ptr [ecx+8]
      test edi,edi
      jnz @@label34                 // buy row
      mov dword ptr [rsi+4], r10d  // bidrow:= rowid
      mov [rsi+16], r11            // theybuy:= price   old code  fst qword ptr [esi+12]
      mov dword ptr [rsi+24], edx // howmuchbuy:= buy
      jmp @@label35
     @@label34:                     // sell row
      test r10d,r10d
      jz @@label36
      mov ecx, r10d
      dec ecx                     // CL = rowid-1
      xor rax,rax
      mov AL, 16                  // sizeof(TGlassquote) = 16
      mul CL                      // rax = sizeof(TGlassquote)*(rowid-1) all operands are bytes
      add rax, rsi
      cmp dword ptr [rax+48+0],0  // rax = rax + rsi + 48+0. Is previous row <sell> = 0?
      jne @@label35
     @@label36:
      mov dword ptr [rsi+8], r10d  // askrow:= rowid
      mov [rsi+32], r11            // theysell:= price   old code   fst qword ptr [esi+24]
      mov dword ptr [rsi+40], edi // howmuchsell:= sell
     @@label35:                     // copy TGlassquote
      xor rax,rax
      mov AL, 16                    // sizeof(TGlassquote) = 16
      mul r10b                      // rax = sizeof(TGlassquote)*rowid, all operands are bytes
      add rax,rsi
      mov dword ptr [rax+48+0], edi  // fill <sell>
      mov dword ptr [rax+48+4], edx  // fill <buy>
      mov [rax+48+8], r11            // fill <price>   old code  fstp qword ptr [eax+36+8] ,clear fpu stack
      inc dword ptr [rbx+24]             // inc(InternalStructurePTR.rowid)
      jmp @@label37                 //Until (InternalStructurePTR.tmp_retcode = SQL_NO_DATA);
     @@label38:                     // Break
      test r10d,r10d                  // With InternalStructurePTR^ do                                    begin
      jnz @@label39                  // if rowid = 0 then begin tmp_StructureUDF.bidrow:= invalidROW; tmp_StructureUDF.askrow:= invalidROW end;  //**23-12-2017
      mov rsi, rbx
      add rsi, 64         //not yet result this is to fill StructureUDF: offset tmp_StructureUDF  mov rsi, rbx+64
      mov dword ptr [rsi+4], invalidROW  //bidrow
      mov dword ptr [rsi+8], invalidROW  //askrow
     @@label39:
      cmp word ptr [rbx+40], SQL_Error   // if tmp_retcode = SQL_Error then PostMessage(MainHandle, Eug_Inform, 0, 4);
      jne @@label40
   //   mov rcx, MainHandle; mov rdx, Eug_Inform; mov r8, 0; mov r9, 4; call PostMessage
     @@label40:
      mov rcx, [rbx+48]            //ptrtoCriticalSection
      call EnterCriticalSectionWinApi    //EnterCriticalSection(ptrtoCriticalSection^);
      mov rsi, rbx
      mov rdi, [rsi+16]            //PStructureUDF
      add rsi, 64                  // to tmp_StructureUDF
      mov rcx, 1648                // sizeOf TStructureUDF = 1648
      rep movsb                   //PStructureUDF^:= tmp_StructureUDF;
      mov rcx, [rbx+48]            //ptrtoCriticalSection
      call LeaveCriticalSectionWinApi    //LeaveCriticalSection(ptrtoCriticalSection^);
      mov r8, [rbx+32]                  // nextdwData
    ///  mov rcx, MainHandle; mov rdx, Eug_UpdateForm; mov r9, 0; call SendNotifyMessage
     @@label42:     // same as label 1 in pascal code
(*
   //probe code
     pop rax
     cmp rax, [rsp+144]
     je @@probe1
     mov rdi, [rsp+32]
     mov rcx, InternalLogFileHandle; lea rdx, av; mov r8, 1; lea r9, av1; mov [rsp+32], 0; call WriteFileWinApi
     mov rcx, InternalLogFileHandle; call FlushFileBuffers
     mov [rsp+32], rdi
     @@probe1:
*)
   //end of probe code
{     leave }
    end;
begin
      InternalStructurePTR:= @GAZPInternalStructure;
        if not InternalStructurePTR.flag then      begin
      EnterCriticalSectionWinApi(InternalStructurePTR.ptrtoCriticalSection);
      InternalStructurePTR.flag:= true;
      LeaveCriticalSectionWinApi(InternalStructurePTR.ptrtoCriticalSection);
                                                   end;
      asmcode_2(InternalStructurePTR);
end;

end.
