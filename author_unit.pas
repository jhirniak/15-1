unit author_unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls;

type
  TAuthor = class(TForm)
    bClose: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure bCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Author: TAuthor;

implementation

{$R *.DFM}

procedure TAuthor.bCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TAuthor.FormCreate(Sender: TObject);
begin
    bClose.Width := Author.ClientWidth;
    bClose.Top := Author.ClientHeight - bClose.Height;
end;

end.
