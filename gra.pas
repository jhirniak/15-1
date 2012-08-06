unit gra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg, Buttons, XiButton;

type
  TGM = class(TForm)
    GameBoard: TPanel;
    LabelA: TPanel;
    LabelB: TPanel;
    LabelC: TPanel;
    LabelD: TPanel;
    Label1: TPanel;
    Label2: TPanel;
    Label3: TPanel;
    Label4: TPanel;
    LoadImageFolder: TOpenDialog;
    LoadD4: TOpenDialog;
    GroupBox1: TGroupBox;
    helperMain: TGroupBox;
    posControl: TMemo;
    posDescription: TMemo;
    GroupBox3: TGroupBox;
    lImgLocal: TComboBox;
    iImgFolder: TEdit;
    showHelper: TCheckBox;
    showGrid: TCheckBox;
    iD4: TEdit;
    Up: TXiButton;
    Down: TXiButton;
    Left: TXiButton;
    Right: TXiButton;
    bNewGame: TXiButton;
    bHowTo: TXiButton;
    bAuthor: TXiButton;
    bClose: TXiButton;
    bLoadMosaic: TXiButton;
    bD4: TXiButton;
    XiButton4: TXiButton;
    XiButton3: TXiButton;
    LookLikeMe: TXiButton;
    reverseArrows: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure posShowClick(Sender: TObject);
    procedure XbNewGameClick(Sender: TObject);
    procedure XUpClick(Sender: TObject);
    procedure XLeftClick(Sender: TObject);
    procedure XRightClick(Sender: TObject);
    procedure XDownClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure posCheatingClick(Sender: TObject);
    procedure XbCloseClick(Sender: TObject);
    procedure showGridClick(Sender: TObject);
    procedure showHelperClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bD4Click(Sender: TObject);
    procedure lImgLocalChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure XbHowToClick(Sender: TObject);
    procedure XbAuthorClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure LeftClick(Sender: TObject);
    procedure UpClick(Sender: TObject);
    procedure RightClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    procedure bNewGameClick(Sender: TObject);
    procedure bHowToClick(Sender: TObject);
    procedure bAuthorClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bLoadMosaicClick(Sender: TObject);
    procedure XiButton2Click(Sender: TObject);
    procedure XiButton3Click(Sender: TObject);
    procedure XiButton4Click(Sender: TObject);
    procedure reverseArrowsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GM: TGM;
  field : array[1..4] of array[1..4] of integer;
  Img : array[1..4] of array[1..4] of TImage;
  keyBan : boolean;
  ImgWidth, ImgHeight : integer;
  ImgFolder, D4 : string;
  pPath : string;
  info : TLabel;

implementation

uses howToPlay_unit, author_unit;

{$R *.DFM}

procedure MixUpPuzzles;
var
    i, j : integer;
    a, e : integer;
    x, y : integer;
    unic : boolean;
begin
Randomize;
    for i := 1 to 4 do begin
        for j := 1 to 4 do
            begin
                repeat
                //'zerowanie' wartosci unic
                unic := TRUE;
                //losowanie wartosci
                    a := 10*(Random(4)+1);
                    e := Random(4)+1;
                //sprawdzanie czy zadne inne pole nie ma takiej samej wartosci
                    for x := 1 to 4 do
                        for y := 1 to 4 do
                            if (field[x][y] = a+e) then unic := FALSE;
                //jesli wartosc  jest unikalna, wtedy przypisac wartosc do pola
                    if unic = TRUE then field[i][j] := a + e;
                until(field[i][j] <> 0)
    end; end;
end;

//Czy wygrana?
procedure victory;
var
    i, j : integer;
    vict : boolean;
begin
//'zerowanie' zwyciestwa
vict := TRUE;
//sprawdzenie czy wszystkie pola sa na swoim miejscu
//jesli nie to brak zwyciestwa
    for i := 1 to 4 do
        for j := 1 to 4 do begin
            if (i + j*10) <> field[i][j] then
                begin
                    vict := FALSE;
                end;
        end;

//wyswietlenie komunikatu o zwyciestwie
if vict = TRUE then
    begin
    //wyswietlenie brakujacego elementu
    Img[4][4].Picture.LoadFromFile(ImgFolder + 'D4.jpg');

    info := TLabel.Create(GM);
    info.Parent := GM.GameBoard;
    info.font.color := clRed;
    info.font.size := 18;
    info.left := 120;
    info.top := Round((400 - info.height)/2);
    info.Caption := 'ZWYCIÊSTWO!';
    info.Transparent := TRUE;
    info.Name := 'info';

    GM.Up.Visible := FALSE;
    GM.Up.Enabled := FALSE;
    GM.Left.Visible := FALSE;
    GM.Left.Enabled := FALSE;
    GM.Down.Enabled := FALSE;
    GM.Right.Enabled := FALSE;

    keyBan := TRUE;

    if (ImgWidth = 99) AND (ImgHeight = 99) then
    begin
    for i := 1 to 4 do
        for j := 1 to 4 do
            begin
                Img[i][j].Width := 100;
                Img[i][j].Height := 100;
            end;
    GM.showGrid.checked := FALSE;
    end;

    ShowMessage('Congratulations, you solved it!');
end;

end;

//odswieza pole
procedure refreshField;
var
    i, j : integer;
begin
for i := 1 to 4 do begin
    for j := 1 to 4 do begin
        Img[i][j].Top := ((field[i][j] div 10) - 1) * 100;
        Img[i][j].Left := (field[i][j] - 10*(field[i][j] div 10) - 1) * 100;
    end; end;

//polozenie przyciskow
//wszystkie przyciski widzalne
GM.Up.Visible := TRUE;
GM.Down.Visible := TRUE;
GM.Left.Visible := TRUE;
GM.Right.Visible := TRUE;
//kontrola czy nie dotyka gornej krawedzi (przycisk w gore)
if (field[4][4] div 10) <= 1 then GM.Up.Visible := FALSE;
//kontrola czy nie dotyka dolnej krawedzi (przycisk w dol)
if (field[4][4] div 10) >= 4 then GM.Down.Visible := FALSE;
//kontrola czy nie dotyka lewej krawedzi (przycisk w lewo)
if (field[4][4] - 10*(field[4][4] div 10)) <= 1 then GM.Left.Visible := FALSE;
//kontrola czy nie dotyka prawej krawedzi (przcycisk w prawo)
if (field[4][4] - 10*(field[4][4] div 10)) >= 4 then GM.Right.Visible := FALSE;

//polozenie przyciskow
//Up
GM.Up.Top := (field[4][4] div 10 - 1) * 100 - 20;
GM.Up.Left := Round((field[4][4] - 10*(field[4][4] div 10) - 0.9) * 100);
//Down
GM.Down.Top := (field[4][4] div 10) * 100;
GM.Down.Left := Round((field[4][4] - 10*(field[4][4] div 10) - 0.9) * 100);
//Left
GM.Left.Top := Round(((field[4][4] div 10) - 0.9) * 100);
GM.Left.Left := Round((field[4][4] - 10*(field[4][4] div 10) - 1.2) * 100);
//Right
GM.Right.Top := Round(((field[4][4] div 10) - 0.9) * 100);
GM.Right.Left := Round((field[4][4] - 10*(field[4][4] div 10)) * 100);

//sprawdz czy wygrana
victory;
end;

//RWC = Replace With Char, zamienia liczbe na litere
//1=A, 2=B, 3=C, 4=D
//ulatwia odczytywanie polozenia w okienku
function RWC(i : integer) : char;
begin
    if i = 0 then Result := '0';
    if i = 1 then Result := 'A';
    if i = 2 then Result := 'B';
    if i = 3 then Result := 'C';
    if i = 4 then Result := 'D';
end;

function NameOfMosaic(s : string) : string;
var
    i, ePosII, ePosI : integer;
begin
for i := 0 to Length(s) do
    if s[i] = '\' then
        begin
            ePosII := ePosI; //polozenie backslasha przed nazwa folderu
            ePosI := i; //polozenie backslasha po nazwie foleru
        end;

Result := Copy(s, ePosII + 1, ePosI - ePosII - 1); //ePosII+1 = polozenie pierwszej litery folderu ;; ePosI - ePosII - 1 = polozenie ostatniej litery folderu
end;

//STEROWANIE********************************************************************
procedure Move(c : char);
var
    i, j : integer;
    hm : integer; //how much>?
begin
case c of
    'U':
    begin
        hm := 10;
    end;

    'D':
    begin
        hm := - 10;
    end;

    'L':
    begin
        hm := 1;
    end;

    'R':
    begin
        hm := -1;
    end;
end;

for i := 1 to 4 do
    for j := 1 to 4 do
        if (field[i][j] = field[4][4] - hm) then field[i][j] := field[4][4];

//przesuniecie pustej kratki do gory
    field[4][4] := field[4][4] - hm;

//odswiezenie pola
    refreshField;
end;
//******************************************************************************

function NameOfBreak(s : string) : string;
var
    i, r : integer;
begin
for i := 0 to Length(s) do
    if s[i] = '\' then r := i;

Result := Copy(s, r + 1, Length(s) - r - 4);
end;

procedure ImgRefresh;
var
    i, j : integer;
begin

for i := 1 to 4 do
    for j := 1 to 4 do
        Img[i][j].Picture.LoadFromFile(ImgFolder + RWC(i) + IntToStr(j) + '.jpg');

Img[4][4].Picture.LoadFromFile(D4);
end;

procedure ImgListRefresh(s : string);
var
    i : integer;
begin
for i := 0 to GM.lImgLocal.Items.Count - 1 do
    if s = GM.lImgLocal.Items.Strings[i] then
        GM.lImgLocal.Text := GM.lImgLocal.Items.Strings[i];
end;

procedure ClearField;
var
    i, j : integer;
begin
for i := 1 to 4 do
    for j := 1 to 4 do
        field[i][j] := 0;
end;

procedure TGM.FormCreate(Sender: TObject);
var
    i, j : integer;
    SR : TSearchRec;
    cSR : integer;
    TF : TextFile;
    f, s : string;
    r : array[1..4] of string;
begin
if NOT posControl.Enabled then posControl.Font.Color := clBlack;

r[1] := '';
//sciezki
pPath := ExtractFileDir(Application.ExeName);
f := pPath + '\config.ini'; //przypisuje sciezke i nazwe pliku konfiguracyjnego

//ladowanie listy lokalnych zestawow puzzli ************************************
cSr := FindFirst(pPath + '\src\' + '*.*', faAnyFile, SR);
while (cSR = 0) do
    begin
        if SR.Name <> 'D4s' then lImgLocal.Items.Add(SR.Name);
        cSr := FindNext(SR);
    end;

FindClose(SR);

lImgLocal.Items.Delete(0); //kasowanie .
lImgLocal.Items.Delete(0); //kasowanie ..
//******************************************************************************

//sprawdz czy plik konfiguracyjny istnieje, jesli nie to zaladuj ustawienia domyslne
if FileExists(f) then
    begin
        AssignFile(TF, f);
        Reset(TF);

        Readln(TF, s);
        if s = '0' then begin
            imgwidth := 100;
            imgheight := 100;
        end;
        if s = '1' then begin
            imgwidth := 99;
            imgheight := 99;
        end;

        Readln(TF, s);
        if s = '0' then begin
            helperMain.Visible := FALSE;
            showHelper.Checked := FALSE
        end else
        begin
            helperMain.Visible := TRUE;
            showHelper.Checked := TRUE
        end;

        Readln(TF, s);
        if FileExists(s + 'A1.jpg') then
        begin
            ImgFolder := s;
            iImgFolder.Text := NameOfMosaic(s);
            ImgListRefresh(NameOfMosaic(s));
        end else
        begin
            ShowMessage('There is no puzzle directory. Default one will be loaded.');
            ImgFolder := pPath + '\src\default\';
        end;

        Readln(TF, s);
        if FileExists(s) then begin
            D4 := s;
            iD4.Text := NameOfBreak(s);
        end else
        begin
            ShowMessage('There is no empty field puzzle. Default one will be loaded.');
            D4 := pPath + '\src\D4s\default.jpg';
        end;

        Readln(TF, s);
        if s = '0' then
            ReverseArrows.Checked := FALSE
        else
            ReverseArrows.Checked := TRUE;

        Readln(TF, s);
        if s = '1' then
        begin
            for i := 1 to 4 do
            begin
                Readln(TF, s);
                r[i] := s;
            end;
        end else begin
            ClearField;
            MixUpPuzzles;
        end;

        CloseFile(TF);
    end else
    begin
        ShowMessage('There is no configuration file. Default configurations will be loaded.');
        ImgWidth := 100;
        ImgHeight := 100;
        ImgFolder := pPath + '\src\default\';
        D4 := pPath + '\src\D4s\default.jpg';
        iImgFolder.Text := NameOfMosaic(ImgFolder);
        ImgListRefresh(NameOfMosaic(ImgFolder));
        iD4.Text := NameOfBreak(D4);
        ClearField;
        MixUpPuzzles;
    end;

//sterowanie strzalkami odblokowane / zablokowane
keyBan := FALSE;

//generuj kratki
for i := 1 to 4 do
    for j := 1 to 4 do begin
        Img[i][j] := TImage.Create(GM);
        Img[i][j].Left := (i-1)*100;
        Img[i][j].Top := (j-1)*100;
        Img[i][j].Width := ImgWidth;
        Img[i][j].Height := ImgHeight;
        Img[i][j].Parent := GameBoard;
        Img[i][j].Picture.LoadFromFile(ImgFolder + RWC(i) + IntToStr(j) + '.jpg');
    end;

//ladowanie tekstury pustego elementu
if D4 <> '' then Img[4][4].Picture.LoadFromFile(D4);

if ImgWidth = 99 then showGrid.Checked := TRUE;

if r[1] <> '' then begin
    for i := 1 to 4 do
        for j := 1 to 4 do
            field[i][j] := StrToInt((Copy(r[i], j * 2 - 1, 2)));
end;

RefreshField;
end;

procedure TGM.posShowClick(Sender: TObject);
var
i, j : integer;
line : string;
begin
posControl.Clear;
for i := 1 to 4 do begin
    for j := 1 to 4 do
        line := line + RWC(i) + IntToStr(j) + ' - ' + RWC(field[i][j] - 10*(field[i][j] div 10)) + IntToStr(field[i][j] div 10) + '  |  ';
    posControl.lines.Add(line);
    line := ''
end;

end;

procedure TGM.XbNewGameClick(Sender: TObject);
var
    i, j : integer;
begin
if NOT (info = NIL) then info.Destroy;
keyBan := FALSE;
Up.Enabled := TRUE;
Down.Enabled := TRUE;
Left.Enabled := TRUE;
Right.Enabled := TRUE;
Img[4][4].Picture.LoadFromFile(D4);


ClearField;
MixUpPuzzles;
refreshField;
end;

procedure TGM.XUpClick(Sender: TObject);
var
    i, j : integer;
begin
//przesuniecie kratki nad do dolu
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (field[i][j] = field[4][4] - 10) then field[i][j] := field[i][j] + 10;

//przesuniecie pustej kratki do gory
    field[4][4] := field[4][4] - 10;

//odswiezenie pola
    refreshField;
end;

procedure TGM.XLeftClick(Sender: TObject);
var
    i, j : integer;
begin
//przesuniecie kratki po lewej na prawo
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (field[i][j] = field[4][4] - 1) then field[i][j] := field[i][j] + 1;

//przesuniecie pustej kratki na lewo
    field[4][4] := field[4][4] - 1;

//odswiezenie pola
    refreshField;
end;

procedure TGM.XRightClick(Sender: TObject);
var
    i, j : integer;
begin
//przesuniecie kratki po prawej na lewo
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (field[i][j] = field[4][4] + 1) then field[i][j] := field[i][j] - 1;

//przesuniecie pustej kratki na prawo
    field[4][4] := field[4][4] + 1;

//odswiezenie pola
    refreshField;
end;

procedure TGM.XDownClick(Sender: TObject);
var
    i, j : integer;
begin
//przesuniecie kratki pod do gory
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (field[i][j] = field[4][4] + 10) then field[i][j] := field[i][j] - 10;

//przesuniecie pustej kratki do dolu
    field[4][4] := field[4][4] + 10;

//odswiezenie pola
    refreshField;
end;

procedure TGM.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//sterowanie strzalkami
if keyBan = FALSE then
    begin
        if (((KEY = vk_UP) OR (KEY = 87)) AND ((field[4][4] div 10) > 1)) then Move('U');
        if (((KEY = vk_DOWN) OR (KEY = 83)) AND ((field[4][4] div 10) < 4)) then Move('D');
        if (((KEY = vk_LEFT) OR (KEY = 65)) AND ((field[4][4] - 10*(field[4][4] div 10)) > 1)) then Move('L');
        if (((KEY = vk_RIGHT) OR (KEY = 68)) AND ((field[4][4] - 10*(field[4][4] div 10)) < 4)) then Move('R');
    end;
end;

procedure TGM.posCheatingClick(Sender: TObject);
var
i, j : integer;
begin
for i := 1 to 4 do
    for j := 1 to 4 do begin
        field[i][j] := i + j*10;
    end;
field[4][4] := 43;
field[3][4] := 44;
refreshField;
end;

procedure TGM.XbCloseClick(Sender: TObject);
begin
Close;
end;

procedure TGM.showGridClick(Sender: TObject);
var
    i, j : integer;
begin
if showGrid.Checked = TRUE then
    begin
        ImgWidth := 99;
        ImgHeight := 99
    end else
    begin
        ImgWidth := 100;
        ImgHeight := 100
    end;

for i := 1 to 4 do
    for j := 1 to 4 do
        begin
            Img[i][j].Width := ImgWidth;
            Img[i][j].Height := ImgHeight;
        end;

end;
procedure TGM.showHelperClick(Sender: TObject);
begin
if showHelper.Checked = TRUE then
        helperMain.Visible := TRUE
    else
        helperMain.Visible := FALSE;
end;

procedure TGM.Button1Click(Sender: TObject);
var
    s, e : string; //zmienna pomocniczna przy operacji na sciezce odczytanej przez OpenDialog
    i, j : integer;
begin
LoadImageFolder.InitialDir := pPath + '\src\';
if LoadImageFolder.Execute then
    begin
        s := LoadImageFolder.FileName;
        Delete(s, Length(s) - 5, 6);
        ImgFolder := s;
        e := NameOfMosaic(s); //znajdywanie nazwy folderu, w ktorym sa przechowywane elementy mozaiki


        iImgFolder.Text := e;
        if (Copy(s, 0, Length(pPath + '\src\')) = (pPath + '\src\')) then //sprawdza czy wskazany folder jest dla programu lokalny
                ImgListRefresh(e);

        //zmiana mozaiki
        ImgRefresh;
    end;
ShowMessage('Za³adowano mozaikê: ' + e);
end;

procedure TGM.bD4Click(Sender: TObject);
begin
LoadD4.InitialDir := pPath + '\src\D4s\';
if LoadD4.Execute then
    begin
        D4 := LoadD4.FileName;
        Img[4][4].Picture.LoadFromFile(D4);
        iD4.Text := LoadD4.FileName;
    end;
end;

procedure TGM.lImgLocalChange(Sender: TObject);
begin
    iImgFolder.Text := lImgLocal.Text;
    ImgFolder := pPath + '\src\' + lImgLocal.Text + '\';
    ImgRefresh;
    ShowMessage('Za³adowano mozaikê: ' + lImgLocal.Text);
end;

procedure TGM.FormClose(Sender: TObject; var Action: TCloseAction);
var
    TF : TextFile;
    f : string;
    i, j : integer;
    WantToSave : boolean;
begin
//przypisuje sciezke i nazwe pliku
f := pPath + '\config.ini';

//sprawdza czy plik istnieje, jesli tak otwiera go, jesli nie tworzy
if FileExists(f) then
    begin
        AssignFile(TF, f);
        Reset(TF)
    end else
        ReWrite(TF, f);

//operacje na pliku
try
    begin
       ReWrite(TF); //czysci zawartosc pliku

       //zapisuje informacje czy siatka ma byc wyswietlana
        if showGrid.Checked = TRUE then
            Writeln(TF, '1')
        else
            Writeln(TF, '0');

        //zapisuje informacje czy pomocnik ma byc aktywny czy ukryty
        if showHelper.Checked = TRUE then
            Writeln(TF, '1')
        else
            Writeln(TF, '0');

        //zapisuje informacje polozeniu na dysku ostatnio uzywanej mozaiki
        if iImgFolder.Text <> ' ' then
            Writeln(TF, ImgFolder)
        else Writeln(' ');

        //zapisuje informacje o polozeniu na dysku ostatnio uzywanego pustego pola (D4)
        if iD4.Text <> ' ' then
            Writeln(TF, D4)
        else Writeln(TF, ' ');

        if ReverseArrows.Checked = TRUE then
            Writeln(TF, '1')
        else
            Writeln(TF, '0');

        if field[1][1] <> 0 then WantToSave := MessageBox(Handle, 'Do you want to save current game?', 'Save?', MB_ICONQUESTION + MB_YESNO) = mrYes;

        if (field[1][1] <> 0) AND (WantToSave = TRUE) then begin
        Writeln(TF, '1');
            for i := 1 to 4 do
                begin
                    for j := 1 to 4 do
                        Write(TF, IntToStr(field[i][j]));
                Writeln(TF,'');
                end;
        end else
            Writeln(TF, '0');
end;

//zamyka plik
finally
    CloseFile(TF);
end;

end;

procedure TGM.XbHowToClick(Sender: TObject);
begin
    HowToPlay.Show;
end;

procedure TGM.XbAuthorClick(Sender: TObject);
begin
    Author.Show;
end;

procedure TGM.Image1Click(Sender: TObject);
var
    i, j : integer;
begin
//przesuniecie kratki po lewej na prawo
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (field[i][j] = field[4][4] - 1) then field[i][j] := field[i][j] + 1;

//przesuniecie pustej kratki na lewo
    field[4][4] := field[4][4] - 1;

//odswiezenie pola
    refreshField;

end;

procedure TGM.LeftClick(Sender: TObject);
begin
    Move('L');
end;

procedure TGM.UpClick(Sender: TObject);
begin
    Move('U');
end;

procedure TGM.RightClick(Sender: TObject);
begin
    Move('R');
end;

procedure TGM.DownClick(Sender: TObject);
begin
    Move('D');
end;

procedure TGM.bNewGameClick(Sender: TObject);
var
    i, j : integer;
begin
if NOT (info = NIL) then info.Destroy;
keyBan := FALSE;
Up.Enabled := TRUE;
Down.Enabled := TRUE;
Left.Enabled := TRUE;
Right.Enabled := TRUE;
Img[4][4].Picture.LoadFromFile(D4);


ClearField;
MixUpPuzzles;
refreshField;
end;

procedure TGM.bHowToClick(Sender: TObject);
begin
    HowToPlay.Show;
end;

procedure TGM.bAuthorClick(Sender: TObject);
begin
    Author.Show;
end;

procedure TGM.bCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TGM.bLoadMosaicClick(Sender: TObject);
var
    s, e : string; //zmienna pomocniczna przy operacji na sciezce odczytanej przez OpenDialog
    i, j : integer;
begin
LoadImageFolder.InitialDir := pPath + '\src\';
if LoadImageFolder.Execute then
    begin
        s := LoadImageFolder.FileName;
        Delete(s, Length(s) - 5, 6);
        ImgFolder := s;
        e := NameOfMosaic(s); //znajdywanie nazwy folderu, w ktorym sa przechowywane elementy mozaiki


        iImgFolder.Text := e;
        if (Copy(s, 0, Length(pPath + '\src\')) = (pPath + '\src\')) then //sprawdza czy wskazany folder jest dla programu lokalny
                ImgListRefresh(e);

        //zmiana mozaiki
        ImgRefresh;
    end;
ShowMessage('Za³adowano mozaikê: ' + e);
end;

procedure TGM.XiButton2Click(Sender: TObject);
begin
LoadD4.InitialDir := pPath + '\src\D4s\';
if LoadD4.Execute then
    begin
        D4 := LoadD4.FileName;
        Img[4][4].Picture.LoadFromFile(D4);
        iD4.Text := LoadD4.FileName;
    end;
end;

procedure TGM.XiButton3Click(Sender: TObject);
var
i, j : integer;
line : string;
begin
posControl.Clear;
for i := 1 to 4 do begin
    for j := 1 to 4 do
        line := line + RWC(i) + IntToStr(j) + ' - ' + RWC(field[i][j] - 10*(field[i][j] div 10)) + IntToStr(field[i][j] div 10) + '  |  ';
    posControl.lines.Add(line);
    line := ''
end;

end;

procedure TGM.XiButton4Click(Sender: TObject);
var
i, j : integer;
begin
for i := 1 to 4 do
    for j := 1 to 4 do begin
        field[i][j] := i + j*10;
    end;
field[4][4] := 43;
field[3][4] := 44;
refreshField;
end;

procedure TGM.reverseArrowsClick(Sender: TObject);
var
    aPath : string;
begin
aPath := pPath + '\img\arrows\';
if ReverseArrows.Checked = TRUE then
    begin
        if FileExists(aPath + 'U.bmp') then Up.Glyph.LoadFromFile(aPath + 'U.bmp');
        if FileExists(aPath + 'D.bmp') then Down.Glyph.LoadFromFile(aPath + 'D.bmp');
        if FileExists(aPath + 'L.bmp') then Left.Glyph.LoadFromFile(aPath + 'L.bmp');
        if FileExists(aPath + 'R.bmp') then Right.Glyph.LoadFromFile(aPath + 'R.bmp');
    end else
    begin
        if FileExists(aPath + 'D.bmp') then Up.Glyph.LoadFromFile(aPath + 'D.bmp');
        if FileExists(aPath + 'U.bmp') then Down.Glyph.LoadFromFile(aPath + 'U.bmp');
        if FileExists(aPath + 'R.bmp') then Left.Glyph.LoadFromFile(aPath + 'R.bmp');
        if FileExists(aPath + 'L.bmp') then Right.Glyph.LoadFromFile(aPath + 'L.bmp');
    end;

Up.Invalidate;
Down.Invalidate;
Left.Invalidate;
Right.Invalidate;
end;

end.
