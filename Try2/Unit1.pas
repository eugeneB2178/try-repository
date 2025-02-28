unit Unit1;

interface

uses
  Windows, Messages, System.AnsiStrings, SysUtils, System.UITypes, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, Registry, TabControlEnhanced, shlobj, winXP, cryptoapi;

type
  TarblaunchArray = array[0..1{8}] of boolean; {size = 9}

  TForm1 = class(TForm)
    TabControl1: TTabControlEnhanced;
    specialComboBoxMaxQty: TComboBox;
    specialLabel1: TLabel;
    specialUseMaxQtyGoldCheckBox: TCheckBox;
    specialLabel3: TLabel;
    Edit_specialRange: TEdit;
    specialLabel4: TLabel;
    Edit_specialOffset: TEdit;
    specialLabel5: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  arblaunchArray1, arblaunchArray2: TarblaunchArray;

implementation
{$R *.dfm}

const lpFileSearchCriteriaDCIM: LPCTSTR = 'C:\Users\Eugene\Desktop\Tuya Smart\DCIM\';
      lpplus: LPCTSTR = '*';
      lpplus1: LPCTSTR = '\';
      lpplus2: LPCTSTR = '*.media';

var hFindYear, hFindMonth,hFindDay, hFindSubDirofDay, hFindFileName: THandle;
    WIN32FINDDATA_Year, WIN32FINDDATA_Month, WIN32FINDDATA_Day, WIN32FINDDATA_SubDirofDay, WIN32FINDDATA_FileName: TWin32FindDataW;
    lpFileSearchCriteria, lpPathToFile_Year, lpPathToFile_Month, lpPathToFile_Day, lpPathToFile_SubDirofDay: LPCTSTR;
    count: DWORD = 0;
    strcount: string;

procedure TForm1.FormCreate(Sender: TObject);
begin

 lpFileSearchCriteria:= StrAlloc(1024); lpPathToFile_Year:= StrAlloc(1024); lpPathToFile_Month:= StrAlloc(1024); lpPathToFile_Day:= StrAlloc(1024); lpPathToFile_SubDirofDay:= StrAlloc(1024);

 StrCopy(lpFileSearchCriteria, lpFileSearchCriteriaDCIM);
 StrCat(lpFileSearchCriteria, lpplus);
 hFindYear:= FindFirstFile(lpFileSearchCriteria, WIN32FINDDATA_Year);
 if hFindYear = INVALID_HANDLE_VALUE then begin MessageDlg('Ошибка поиска FindFirstFile_Year', mtWarning, [mbOK], 0); ExitProcess(5) end;
 Repeat
   if not(WIN32FINDDATA_Year.cFileName[0] = '.') then
   begin
    StrCopy(lpFileSearchCriteria, lpFileSearchCriteriaDCIM);
    StrCat(lpFileSearchCriteria, @WIN32FINDDATA_Year.cFileName[0]);
    StrCat(lpFileSearchCriteria, lpplus1);
    StrCopy(lpPathToFile_Year, lpFileSearchCriteria);
    StrCat(lpFileSearchCriteria, lpplus);
    hFindMonth:= FindFirstFile(lpFileSearchCriteria, WIN32FINDDATA_Month);
    if hFindMonth = INVALID_HANDLE_VALUE then begin MessageDlg('Ошибка поиска FindFirstFile_Month', mtWarning, [mbOK], 0); ExitProcess(5) end;
    Repeat
     if not(WIN32FINDDATA_Month.cFileName[0] = '.') then
     begin
      StrCopy(lpFileSearchCriteria, lpPathToFile_Year);
      StrCat(lpFileSearchCriteria, @WIN32FINDDATA_Month.cFileName[0]);
      StrCat(lpFileSearchCriteria, lpplus1);
      StrCopy(lpPathToFile_Month, lpFileSearchCriteria);
      StrCat(lpFileSearchCriteria, lpplus);
      hFindDay:= FindFirstFile(lpFileSearchCriteria, WIN32FINDDATA_Day);
      if hFindDay = INVALID_HANDLE_VALUE then begin MessageDlg('Ошибка поиска FindFirstFile_Day', mtWarning, [mbOK], 0); ExitProcess(5) end;
      Repeat
       if not(WIN32FINDDATA_Day.cFileName[0] = '.') then
       begin
        StrCopy(lpFileSearchCriteria, lpPathToFile_Month);
        StrCat(lpFileSearchCriteria, @WIN32FINDDATA_Day.cFileName[0]);
        StrCat(lpFileSearchCriteria, lpplus1);
        StrCopy(lpPathToFile_Day, lpFileSearchCriteria);
        StrCat(lpFileSearchCriteria, lpplus);
        hFindSubDirofDay:= FindFirstFile(lpFileSearchCriteria, WIN32FINDDATA_SubDirofDay);
        if hFindSubDirofDay = INVALID_HANDLE_VALUE then begin MessageDlg('Ошибка поиска FindFirstFile_SubDirofDay', mtWarning, [mbOK], 0); ExitProcess(5) end;
        Repeat
         if not(WIN32FINDDATA_SubDirofDay.cFileName[0] = '.') then
         begin
          StrCopy(lpFileSearchCriteria, lpPathToFile_Day);
          StrCat(lpFileSearchCriteria, @WIN32FINDDATA_SubDirofDay.cFileName[0]);
          StrCat(lpFileSearchCriteria, lpplus1);
          StrCopy(lpPathToFile_SubDirofDay, lpFileSearchCriteria);
          StrCat(lpFileSearchCriteria, lpplus2);
          hFindFileName:= FindFirstFile(lpFileSearchCriteria, WIN32FINDDATA_FileName);
          if hFindFileName = INVALID_HANDLE_VALUE then begin MessageDlg('Ошибка поиска FindFirstFile_FileName', mtWarning, [mbOK], 0); ExitProcess(5) end;
          Repeat
           StrCopy(lpFileSearchCriteria, lpPathToFile_SubDirofDay);
           StrCat(lpFileSearchCriteria, @WIN32FINDDATA_FileName.cFileName[0]);  {existing file name}
           inc(count); strcount:= 'C:\VboxShared\Tuya Smart\' + IntToStr(count) + '.mp4'; {new file name}
           if not(CopyFile(lpFileSearchCriteria, @strcount[1], true)) then MessageDlg('Ошибка CopyFile', mtWarning, [mbOK], 0);
          Until not(FindNextFile(hFindFileName, WIN32FINDDATA_FileName));
          if not(GetLastError = ERROR_NO_MORE_FILES) then begin MessageDlg('Ошибка поиска FindNextFile_FileName', mtWarning, [mbOK], 0); ExitProcess(5) end;
          if not(FindCloseWinApi(hFindFileName)) then MessageDlg('Ошибка FindClose_FileName', mtWarning, [mbOK], 0);
         end;
        Until not(FindNextFile(hFindSubDirofDay, WIN32FINDDATA_SubDirofDay));
        if not(GetLastError = ERROR_NO_MORE_FILES) then begin MessageDlg('Ошибка поиска FindNextFile_SubDirofDay', mtWarning, [mbOK], 0); ExitProcess(5) end;
        if not(FindCloseWinApi(hFindSubDirofDay)) then MessageDlg('Ошибка FindClose_SubDirofDay', mtWarning, [mbOK], 0);
       end;
      Until not(FindNextFile(hFindDay, WIN32FINDDATA_Day));
      if not(GetLastError = ERROR_NO_MORE_FILES) then begin MessageDlg('Ошибка поиска FindNextFile_Day', mtWarning, [mbOK], 0); ExitProcess(5) end;
      if not(FindCloseWinApi(hFindDay)) then MessageDlg('Ошибка FindClose_Day', mtWarning, [mbOK], 0);
     end;
    Until not(FindNextFile(hFindMonth, WIN32FINDDATA_Month));
    if not(GetLastError = ERROR_NO_MORE_FILES) then begin MessageDlg('Ошибка поиска FindNextFile_Month', mtWarning, [mbOK], 0); ExitProcess(5) end;
    if not(FindCloseWinApi(hFindMonth)) then MessageDlg('Ошибка FindClose_Month', mtWarning, [mbOK], 0);
   end;
 Until not(FindNextFile(hFindYear, WIN32FINDDATA_Year));
  if not(GetLastError = ERROR_NO_MORE_FILES) then begin MessageDlg('Ошибка поиска FindNextFile_Year', mtWarning, [mbOK], 0); ExitProcess(5) end;
  if not(FindCloseWinApi(hFindYear)) then MessageDlg('Ошибка FindClose_Year', mtWarning, [mbOK], 0);

 StrDispose(lpFileSearchCriteria); StrDispose(lpPathToFile_Year); StrDispose(lpPathToFile_Month); StrDispose(lpPathToFile_Day); StrDispose(lpPathToFile_SubDirofDay);

end;

end.
