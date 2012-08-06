unit howToPlay_unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  THowToPlay = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HowToPlay: THowToPlay;

implementation

{$R *.DFM}

procedure THowToPlay.Button1Click(Sender: TObject);
begin
    Close;
end;

end.
