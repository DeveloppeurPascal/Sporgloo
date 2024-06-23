unit cGrayBox;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts;

type
  TcadGrayBox = class(TFrame)
    rOutside: TRectangle;
    rBackground: TRectangle;
    sContent: TVertScrollBox;
  private
  public
    procedure AutoHeight;
  end;

implementation

{$R *.fmx}
{ TcadGrayBox }

procedure TcadGrayBox.AutoHeight;
var
  i: integer;
  h: single;
  c: tcontrol;
begin
  h := rOutside.Margins.Top + rOutside.Margins.Bottom + rBackground.Margins.Top
    + rBackground.Margins.Bottom;

  for i := 0 to rBackground.ChildrenCount - 1 do
    if (rBackground.Children[i] is tcontrol) then
    begin
      c := rBackground.Children[i] as tcontrol;
      if c = sContent then
        h := h + c.Margins.Top + c.Margins.Bottom
      else
        h := h + c.Margins.Top + c.Height + c.Margins.Bottom;
    end;

  for i := 0 to sContent.Content.ChildrenCount - 1 do
    if (sContent.Content.Children[i] is tcontrol) then
    begin
      c := sContent.Content.Children[i] as tcontrol;
      h := h + c.Margins.Top + c.Height + c.Margins.Bottom;
    end;

  if parent is tcustomform then
  begin
    if h > (parent as tcustomform).ClientHeight then
      h := (parent as tcustomform).ClientHeight;
  end
  else if parent is tcontrol then
  begin
    if h > (parent as tcontrol).Height then
      h := (parent as tcontrol).Height;
  end;
  Height := h;

  if parent is tcustomform then
  begin
    if width > (parent as tcustomform).ClientWidth then
      width := (parent as tcustomform).ClientWidth;
  end
  else if parent is tcontrol then
  begin
    if width > (parent as tcontrol).width then
      width := (parent as tcontrol).width;
  end;
end;

end.
