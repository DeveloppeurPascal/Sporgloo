unit USVGItems;

// ****************************************
// * SVG from folder :
// * C:\Users\patrickpremartin\Documents\Embarcadero\Studio\Projets\Sporgloo\assets\graphics\Items\USVGItems.pas
// ****************************************
//
// This file contains a list of contants and 
// an enumeration to access to SVG source codes 
// from the generated array of strings.
//
// ****************************************
// File generator : SVG Folder to Delphi Unit (1.0)
// Website : https://svgfolder2delphiunit.olfsoftware.fr/
// Generation date : 23/07/2024 14:04:04
//
// Don't do any change on this file.
// They will be erased by next generation !
// ****************************************

interface

const
  CSVGCoeur = 0;
  CSVGJeton1 = 1;
  CSVGStar = 2;

type
{$SCOPEDENUMS ON}
  TSVGItemsIndex = (
    Coeur = CSVGCoeur,
    Jeton1 = CSVGJeton1,
    Star = CSVGStar);

  TSVGItems = class
  private
  class var
    FTag: integer;
    FTagBool: Boolean;
    FTagFloat: Single;
    FTagObject: TObject;
    FTagString: string;
    class procedure SetTag(const Value: integer); static;
    class procedure SetTagBool(const Value: Boolean); static;
    class procedure SetTagFloat(const Value: Single); static;
    class procedure SetTagObject(const Value: TObject); static;
    class procedure SetTagString(const Value: string); static;
  public const
    Coeur = CSVGCoeur;
    Jeton1 = CSVGJeton1;
    Star = CSVGStar;
    class property Tag: integer read FTag write SetTag;
    class property TagBool: Boolean read FTagBool write SetTagBool;
    class property TagFloat: Single read FTagFloat write SetTagFloat;
    class property TagObject: TObject read FTagObject write SetTagObject;
    class property TagString: string read FTagString write SetTagString;
    class function SVG(const Index: Integer): string; overload;
    class function SVG(const Index: TSVGItemsIndex) : string; overload;
    class constructor Create;
  end;

var
  SVGItems : array of String;

implementation

uses
  System.SysUtils;

{ TSVGItems }

class constructor TSVGItems.Create;
begin
  inherited;
  FTag := 0;
  FTagBool := false;
  FTagFloat := 0;
  FTagObject := nil;
  FTagString := '';
end;

class procedure TSVGItems.SetTag(const Value: integer);
begin
  FTag := Value;
end;

class procedure TSVGItems.SetTagBool(const Value: Boolean);
begin
  FTagBool := Value;
end;

class procedure TSVGItems.SetTagFloat(const Value: Single);
begin
  FTagFloat := Value;
end;

class procedure TSVGItems.SetTagObject(const Value: TObject);
begin
  FTagObject := Value;
end;

class procedure TSVGItems.SetTagString(const Value: string);
begin
  FTagString := Value;
end;

class function TSVGItems.SVG(const Index: Integer): string;
begin
  if (index < length(SVGItems)) then
    result := SVGItems[index]
  else
    raise Exception.Create('SVG not found. Index out of range.');
end;

class function TSVGItems.SVG(const Index : TSVGItemsIndex): string;
begin
  result := SVG(ord(index));
end;

initialization

SetLength(SVGItems, 3);

{$TEXTBLOCK NATIVE XML}
SVGItems[CSVGCoeur] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 65 59">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <path d="M24.7,40.35l-13.85-14.75-.15-.15-.05-.05-.05-.05c-1.73-1.97-2.6-4.3-2.6-7v-.05c0-2.87.97-5.3,2.9-7.3h.05c1.8-2,4.02-3,6.65-3h.1c2.6,0,4.83.98,6.7,2.95l.05.05,1.35,1.75c1,1.57,2.38,2.65,4.15,3.25l2.55.45,2.75-.5c1.73-.67,3.1-1.78,4.1-3.35l1.15-1.5-.15.1.05-.05.25-.2c1.8-1.97,4.02-2.95,6.65-2.95h.1c2.6,0,4.83.98,6.7,2.95l.05.05c1.9,2,2.85,4.43,2.85,7.3v.05c0,2.7-.87,5.03-2.6,7l-.05.05-.15.2-21.7,23.05-7.8-8.3" fill="#c83e3e" stroke-width="0"/>
    <path d="M54.1,10.95c-1.87-1.97-4.1-2.95-6.7-2.95h-.1c-2.63,0-4.85.98-6.65,2.95l-.25.2-.05.05.15-.1-1.15,1.5c-1,1.57-2.37,2.68-4.1,3.35l-2.75.5-2.55-.45c-1.77-.6-3.15-1.68-4.15-3.25l-1.35-1.75-.05-.05c-1.87-1.97-4.1-2.95-6.7-2.95h-.1c-2.63,0-4.85,1-6.65,3h-.05c-1.93,2-2.9,4.43-2.9,7.3v.05c0,2.7.87,5.03,2.6,7l.05.05.05.05.15.15,13.85,14.75-5.65,5.65-14.05-14.95-.2-.2-.2-.2C1.53,27.18,0,23.07,0,18.3c.03-5,1.72-9.27,5.05-12.8l.2-.2C8.68,1.73,12.82-.03,17.65,0c4.9-.03,9.1,1.8,12.6,5.5l2.25,2.9c.63-1.03,1.37-1.98,2.2-2.85l.05-.05C38.15,1.8,42.35-.03,47.35,0c4.8-.03,8.93,1.73,12.4,5.3l-5.65,5.65" fill="#d44c4c" stroke-width="0"/>
    <path d="M54.1,10.95l5.65-5.65.2.2c3.33,3.53,5.02,7.8,5.05,12.8,0,4.43-1.32,8.3-3.95,11.6l-.65.75-.2.2-.2.2-25.4,27-1.35.8-.75.15-.8-.15-1.3-.8-11.35-12.05,5.65-5.65,7.8,8.3,21.7-23.05.15-.2.05-.05c1.73-1.97,2.6-4.3,2.6-7v-.05c0-2.87-.95-5.3-2.85-7.3l-.05-.05" fill="#aa3030" stroke-width="0"/>
  </g>
</svg>
''';
SVGItems[CSVGJeton1] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g>
      <path d="M56,32c0-6.63-2.35-12.3-7.05-17-4.67-4.67-10.32-7-16.95-7s-12.3,2.33-17,7c-4.67,4.7-7,10.37-7,17s2.33,12.33,7,17c4.7,4.67,10.37,7,17,7s12.28-2.33,16.95-7c4.7-4.67,7.05-10.33,7.05-17M31.9,18.5c1.4,0,2.58.53,3.55,1.6s1.45,2.37,1.45,3.9v16c0,1.53-.48,2.83-1.45,3.9s-2.15,1.6-3.55,1.6-2.58-.53-3.55-1.6-1.45-2.37-1.45-3.9v-16c0-1.53.48-2.83,1.45-3.9.97-1.07,2.15-1.6,3.55-1.6M64,32c0,8.87-3.13,16.42-9.4,22.65-6.23,6.23-13.77,9.35-22.6,9.35s-16.42-3.12-22.65-9.35C3.12,48.42,0,40.87,0,32S3.12,15.62,9.35,9.35C15.58,3.12,23.13,0,32,0s16.37,3.12,22.6,9.35c6.27,6.27,9.4,13.82,9.4,22.65" fill="#fc0" stroke-width="0"/>
      <path d="M31.9,18.5c-1.4,0-2.58.53-3.55,1.6s-1.45,2.37-1.45,3.9v16c0,1.53.48,2.83,1.45,3.9.97,1.07,2.15,1.6,3.55,1.6s2.58-.53,3.55-1.6,1.45-2.37,1.45-3.9v-16c0-1.53-.48-2.83-1.45-3.9s-2.15-1.6-3.55-1.6M56,32c0,6.67-2.35,12.33-7.05,17-4.67,4.67-10.32,7-16.95,7s-12.3-2.33-17-7c-4.67-4.67-7-10.33-7-17s2.33-12.3,7-17c4.7-4.67,10.37-7,17-7s12.28,2.33,16.95,7c4.7,4.7,7.05,10.37,7.05,17" fill="#d7ac00" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGItems[CSVGStar] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 113 113">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <path d="M30.15,30.2c1.2-1.2,4.78.37,10.75,4.7l6.95,5.45c.4-8.87,1.15-16.8,2.25-23.8C51.87,5.52,54,0,56.5,0s4.68,5.52,6.45,16.55c1.1,7,1.87,14.93,2.3,23.8,2.4-2.03,4.7-3.85,6.9-5.45,5.97-4.33,9.55-5.92,10.75-4.75,1.17,1.17-.42,4.73-4.75,10.7l-5.45,6.95c8.83.43,16.75,1.2,23.75,2.3,11.03,1.77,16.55,3.9,16.55,6.4s-5.52,4.63-16.55,6.4c-7,1.13-14.92,1.92-23.75,2.35l5.45,6.9c4.33,5.97,5.9,9.53,4.7,10.7-1.17,1.17-4.73-.4-10.7-4.7-2.2-1.63-4.5-3.45-6.9-5.45-.43,8.83-1.2,16.75-2.3,23.75-1.77,11.03-3.92,16.55-6.45,16.55s-4.63-5.52-6.4-16.55c-1.1-7-1.85-14.92-2.25-23.75l-6.95,5.45c-5.97,4.3-9.53,5.87-10.7,4.7-1.2-1.17.37-4.73,4.7-10.7,1.63-2.23,3.45-4.53,5.45-6.9-8.83-.43-16.77-1.22-23.8-2.35C5.52,61.13,0,59,0,56.5s5.52-4.63,16.55-6.4c7.03-1.1,14.97-1.87,23.8-2.3l-5.45-6.95c-4.33-5.97-5.92-9.52-4.75-10.65" fill="#fc0" stroke-width="0"/>
  </g>
</svg>
''';

end.
