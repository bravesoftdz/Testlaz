unit frm_TestEnvironmentOptionsMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons,
  // lazarus
  EnvironmentOpts;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnLoadEnv: TButton;
    btnSaveEnv: TButton;
    btnNewDT: TButton;
    btnDeleteDT: TButton;
    edtDesktopName: TEdit;
    edtDirectory: TEdit;
    btnSelectDir: TSpeedButton;
    ListBox1: TListBox;
    procedure btnDeleteDTClick(Sender: TObject);
    procedure btnLoadEnvClick(Sender: TObject);
    procedure btnSaveEnvClick(Sender: TObject);
    procedure btnNewDTClick(Sender: TObject);
    procedure edtDesktopNameExit(Sender: TObject);
    procedure edtDesktopNameKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: char);
  private
     FDataPath: String;
     FEnvironmentOptions:TEnvironmentOptions;
     procedure ActivateInplaceEditor;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FEnvironmentOptions:=TEnvironmentOptions.Create;
  FDataPath:='Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:= '..'+DirectorySeparator+FDataPath;
  FDataPath:=FDataPath+DirectorySeparator+'TestEnvironment';
end;

procedure TForm1.btnLoadEnvClick(Sender: TObject);
var
  p: TDesktopOpt;
begin
  FEnvironmentOptions.Filename:=FDataPath+DirectorySeparator+'environmentoptions_new.xml';
  FEnvironmentOptions.load(false);
  ListBox1.clear;
  for pointer(p) in FEnvironmentOptions.Desktops do
    ListBox1.AddItem(p.Name,p);
end;

procedure TForm1.btnDeleteDTClick(Sender: TObject);
var
  lnd: TDesktopOpt;
  lidx: Integer;
begin
  if ListBox1.ItemIndex >=0 then
    begin;
      lnd := TDesktopOpt(ListBox1.Items.Objects[ListBox1.ItemIndex]);
      lidx := FEnvironmentOptions.Desktops.IndexOf(ListBox1.Items[ListBox1.ItemIndex]);
      FEnvironmentOptions.Desktops.Delete(lidx);
     // freeandnil(lnd);
      ListBox1.DeleteSelected;
    end;
end;

procedure TForm1.btnSaveEnvClick(Sender: TObject);
begin
  FEnvironmentOptions.Filename:=FDataPath+DirectorySeparator+'environmentoptions_new.xml';
  FEnvironmentOptions.Save(false);
end;

procedure TForm1.btnNewDTClick(Sender: TObject);
begin
  edtDesktopName.Text:='';
  edtDesktopName.Tag:=0;
  edtDesktopName.TextHint:='Enter new Name';
  edtDesktopName.visible := true;
end;

procedure TForm1.edtDesktopNameExit(Sender: TObject);
begin
  edtDesktopName.Visible:=false;
end;

procedure TForm1.edtDesktopNameKeyPress(Sender: TObject; var Key: char);
var
  lnd: TDesktopOpt;
  lix: Integer;
begin
  if key = #27 then
    begin
    edtDesktopName.Visible:=false;
     ActiveControl:= ListBox1;
    end;
  if key = #13 then
    begin
      // Check if Name is OK
      if edtDesktopName.tag = 0 then
        begin
          lnd:= TDesktopOpt.Create(edtDesktopName.Text);
          FEnvironmentOptions.Desktops.Add(lnd);
          ListBox1.AddItem(edtDesktopName.Text,lnd);
        end
      else
        begin
          lnd := TDesktopOpt(edtDesktopName.tag);
          lnd.Name:= edtDesktopName.text;
          lix := listbox1.Items.IndexOfObject(lnd);
          if lix>-1 then
            listbox1.Items[lix]:=edtDesktopName.text;
        end;
      edtDesktopName.Visible:=false;
     ActiveControl:= ListBox1;
    end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEnvironmentOptions);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  ActivateInplaceEditor;
end;

procedure TForm1.ListBox1KeyPress(Sender: TObject; var Key: char);
begin
  if key = #29 then
    begin
      ActivateInplaceEditor;
    end;
end;

procedure TForm1.ActivateInplaceEditor;
begin
  edtDesktopName.top := ListBox1.ItemRect(ListBox1.ItemIndex).top+ListBox1.top-1;
  edtDesktopName.Text:=ListBox1.Items[ListBox1.ItemIndex];
  edtDesktopName.tag:=ptrint(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  edtDesktopName.visible := true;
end;

end.

