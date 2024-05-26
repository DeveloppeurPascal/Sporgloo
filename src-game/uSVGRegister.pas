unit uSVGRegister;

interface

var
  /// <summary>
  /// List index of registered SVG backgrounds in TOlfSVGBitmapList
  /// </summary>
  SVGBackgroundsListIndex,
  /// <summary>
  /// List index of registered SVG items in TOlfSVGBitmapList
  /// </summary>
  SVGItemsListIndex,
  /// <summary>
  /// List index of registered SVG characters in TOlfSVGBitmapList
  /// </summary>
  SVGPersosListIndex,
  /// <summary>
  /// List index of registered SVG trees in TOlfSVGBitmapList
  /// </summary>
  SVGTreesListIndex,
  /// <summary>
  /// List index of registered SVG user interface items in TOlfSVGBitmapList
  /// </summary>
  SVGUserInterfaceListIndex: word;

implementation

uses
  Olf.Skia.SVGToBitmap,
  USVGBackgrounds,
  USVGItems,
  USVGPersos,
  USVGTrees,
  USVGUserInterface;

procedure Register;
begin
  SVGBackgroundsListIndex := TOlfSVGBitmapList.AddAList;
  for var i := 0 to length(SVGBackgrounds) - 1 do
    TOlfSVGBitmapList.AddItemAt(SVGBackgroundsListIndex, i, SVGBackgrounds[i]);

  SVGItemsListIndex := TOlfSVGBitmapList.AddAList;
  for var i := 0 to length(SVGitems) - 1 do
    TOlfSVGBitmapList.AddItemAt(SVGItemsListIndex, i, SVGitems[i]);

  SVGPersosListIndex := TOlfSVGBitmapList.AddAList;
  for var i := 0 to length(SVGPersos) - 1 do
    TOlfSVGBitmapList.AddItemAt(SVGPersosListIndex, i, SVGPersos[i]);

  SVGTreesListIndex := TOlfSVGBitmapList.AddAList;
  for var i := 0 to length(SVGtrees) - 1 do
    TOlfSVGBitmapList.AddItemAt(SVGTreesListIndex, i, SVGtrees[i]);

  SVGUserInterfaceListIndex := TOlfSVGBitmapList.AddAList;
  for var i := 0 to length(SVGUserInterface) - 1 do
    TOlfSVGBitmapList.AddItemAt(SVGUserInterfaceListIndex, i,
      SVGUserInterface[i]);
end;

initialization

Register;

end.
