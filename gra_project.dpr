program gra_project;

uses
  Forms,
  gra in 'gra.pas' {GM},
  howToPlay_unit in 'howToPlay_unit.pas' {HowToPlay},
  author_unit in 'author_unit.pas' {Author};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '15 + 1';
  Application.CreateForm(TGM, GM);
  Application.CreateForm(THowToPlay, HowToPlay);
  Application.CreateForm(TAuthor, Author);
  Application.Run;
end.
