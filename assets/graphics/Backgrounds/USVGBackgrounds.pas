unit USVGBackgrounds;

// ****************************************
// * SVG from folder :
// * C:\Users\patrickpremartin\Documents\Embarcadero\Studio\Projets\Sporgloo\assets\graphics\Backgrounds\USVGBackgrounds.pas
// ****************************************
//
// This file contains a list of contants and 
// an enumeration to access to SVG source codes 
// from the generated array of strings.
//
// ****************************************
// File generator : SVG Folder to Delphi Unit (1.0)
// Website : https://svgfolder2delphiunit.olfsoftware.fr/
// Generation date : 23/07/2024 14:03:53
//
// Don't do any change on this file.
// They will be erased by next generation !
// ****************************************

interface

const
  CSVGCheminB = 0;
  CSVGCheminBD = 1;
  CSVGCheminBGD = 2;
  CSVGCheminD = 3;
  CSVGCheminG = 4;
  CSVGCheminGB = 5;
  CSVGCheminGD = 6;
  CSVGCheminH = 7;
  CSVGCheminHB = 8;
  CSVGCheminHBD = 9;
  CSVGCheminHBG = 10;
  CSVGCheminHBGD = 11;
  CSVGCheminHD = 12;
  CSVGCheminHG = 13;
  CSVGCheminHGD = 14;
  CSVGFond1 = 15;
  CSVGFond2 = 16;

type
{$SCOPEDENUMS ON}
  TSVGBackgroundsIndex = (
    CheminB = CSVGCheminB,
    CheminBD = CSVGCheminBD,
    CheminBGD = CSVGCheminBGD,
    CheminD = CSVGCheminD,
    CheminG = CSVGCheminG,
    CheminGB = CSVGCheminGB,
    CheminGD = CSVGCheminGD,
    CheminH = CSVGCheminH,
    CheminHB = CSVGCheminHB,
    CheminHBD = CSVGCheminHBD,
    CheminHBG = CSVGCheminHBG,
    CheminHBGD = CSVGCheminHBGD,
    CheminHD = CSVGCheminHD,
    CheminHG = CSVGCheminHG,
    CheminHGD = CSVGCheminHGD,
    Fond1 = CSVGFond1,
    Fond2 = CSVGFond2);

  TSVGBackgrounds = class
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
    CheminB = CSVGCheminB;
    CheminBD = CSVGCheminBD;
    CheminBGD = CSVGCheminBGD;
    CheminD = CSVGCheminD;
    CheminG = CSVGCheminG;
    CheminGB = CSVGCheminGB;
    CheminGD = CSVGCheminGD;
    CheminH = CSVGCheminH;
    CheminHB = CSVGCheminHB;
    CheminHBD = CSVGCheminHBD;
    CheminHBG = CSVGCheminHBG;
    CheminHBGD = CSVGCheminHBGD;
    CheminHD = CSVGCheminHD;
    CheminHG = CSVGCheminHG;
    CheminHGD = CSVGCheminHGD;
    Fond1 = CSVGFond1;
    Fond2 = CSVGFond2;
    class property Tag: integer read FTag write SetTag;
    class property TagBool: Boolean read FTagBool write SetTagBool;
    class property TagFloat: Single read FTagFloat write SetTagFloat;
    class property TagObject: TObject read FTagObject write SetTagObject;
    class property TagString: string read FTagString write SetTagString;
    class function SVG(const Index: Integer): string; overload;
    class function SVG(const Index: TSVGBackgroundsIndex) : string; overload;
    class constructor Create;
  end;

var
  SVGBackgrounds : array of String;

implementation

uses
  System.SysUtils;

{ TSVGBackgrounds }

class constructor TSVGBackgrounds.Create;
begin
  inherited;
  FTag := 0;
  FTagBool := false;
  FTagFloat := 0;
  FTagObject := nil;
  FTagString := '';
end;

class procedure TSVGBackgrounds.SetTag(const Value: integer);
begin
  FTag := Value;
end;

class procedure TSVGBackgrounds.SetTagBool(const Value: Boolean);
begin
  FTagBool := Value;
end;

class procedure TSVGBackgrounds.SetTagFloat(const Value: Single);
begin
  FTagFloat := Value;
end;

class procedure TSVGBackgrounds.SetTagObject(const Value: TObject);
begin
  FTagObject := Value;
end;

class procedure TSVGBackgrounds.SetTagString(const Value: string);
begin
  FTagString := Value;
end;

class function TSVGBackgrounds.SVG(const Index: Integer): string;
begin
  if (index < length(SVGBackgrounds)) then
    result := SVGBackgrounds[index]
  else
    raise Exception.Create('SVG not found. Index out of range.');
end;

class function TSVGBackgrounds.SVG(const Index : TSVGBackgroundsIndex): string;
begin
  result := SVG(ord(index));
end;

initialization

SetLength(SVGBackgrounds, 17);

{$TEXTBLOCK NATIVE XML}
SVGBackgrounds[CSVGCheminB] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_37_FILL" data-name="Layer0 37 FILL">
      <path d="M36,60v4h4v-4h-4M64,8v-4h-4v4h4M48,48v8h8v-8h-8M28,48v-4h-4v4h4M36,36h-4v4h4v-4M36,20h-4v4h4v-4M8,12v4h4v-4h-4Z" fill="#24a159" stroke-width="0"/>
      <path d="M0,0v64h36v-4h4v4h24V8h-4v-4h4V0H0M8,16v-4h4v4h-4M8,52h-4v-4h4v4M60,12v4h-4v-4h4M16,16h8v8h-8v-8M32,12h-4v-4h4v4M32,20h4v4h-4v-4M32,36h4v4h-4v-4M40,48v-4h4v4h-4M12,28h4v4h-4v-4M28,44v4h-4v-4h4M48,56v-8h8v8h-8Z" fill="#27ae60" stroke-width="0"/>
      <path d="M16,28h-4v4h4v-4M40,44v4h4v-4h-4M28,12h4v-4h-4v4M24,16h-8v8h8v-8M60,16v-4h-4v4h4M4,52h4v-4h-4v4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_37_MEMBER_0_FILL" data-name="Layer0 37 MEMBER 0 FILL">
      <path d="M32,16c-4.43,0-8.22,1.55-11.35,4.65-3.1,3.13-4.65,6.92-4.65,11.35,0,3.87.15,7.39.45,10.55.7,7,2.9,14.15,6.6,21.45h17.9c-2.84-5.57-3.32-10.72-1.45-15.45.64-1.59,1.91-3.34,3.8-5.25,3.13-3.1,4.7-6.87,4.7-11.3s-1.57-8.22-4.7-11.35c-3.1-3.1-6.87-4.65-11.3-4.65Z" fill="#d9a24d" stroke-width="0"/>
      <path d="M20.65,20.65c3.13-3.1,6.92-4.65,11.35-4.65s8.2,1.55,11.3,4.65c3.13,3.13,4.7,6.92,4.7,11.35s-1.57,8.2-4.7,11.3c-1.89,1.91-3.16,3.66-3.8,5.25-1.87,4.73-1.39,9.88,1.45,15.45h2c0-.31-.09-.61-.25-.9-2.52-4.99-2.97-9.6-1.35-13.85v.05c.58-1.38,1.7-2.91,3.35-4.6h0c3.53-3.49,5.3-7.72,5.3-12.7s-1.76-9.26-5.3-12.8c-3.48-3.47-7.71-5.2-12.7-5.2s-9.23,1.73-12.75,5.2l-.05.05c-3.47,3.52-5.2,7.77-5.2,12.75,0,3.95.15,7.53.45,10.75.7,6.94,2.81,14.02,6.35,21.25h2.25c-3.7-7.3-5.9-14.45-6.6-21.45-.3-3.16-.45-6.68-.45-10.55,0-4.43,1.55-8.22,4.65-11.35Z" fill="#219853" stroke-width="0"/>
    </g>
    <g id="Layer0_37_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 37 MEMBER 0 MEMBER 0 FILL">
      <path d="M35,28h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_37_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 37 MEMBER 0 MEMBER 1 FILL">
      <path d="M43,36v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_37_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 37 MEMBER 0 MEMBER 2 FILL">
      <path d="M30,30v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_37_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 37 MEMBER 0 MEMBER 3 FILL">
      <path d="M24,53h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminBD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_30_FILL" data-name="Layer0 30 FILL">
      <path d="M36,64h4v-4h-4v4M48,48v8h8v-8h-8M32,40h4v-4h-4v4M28,44h-4v4h4v-4M12,16v-4h-4v4h4M36,20h-4v4h4v-4M64,8v-4h-4v4h4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,4V0H0v64h36v-4h4v4h24V8h-4v-4h4M32,20h4v4h-4v-4M32,8v4h-4v-4h4M56,16v-4h4v4h-4M16,16h8v8h-8v-8M12,12v4h-4v-4h4M24,44h4v4h-4v-4M16,28v4h-4v-4h4M8,48v4h-4v-4h4M40,44h4v4h-4v-4M36,40h-4v-4h4v4M48,56v-8h8v8h-8Z" fill="#27ae60" stroke-width="0"/>
      <path d="M44,44h-4v4h4v-4M8,52v-4h-4v4h4M16,32v-4h-4v4h4M24,16h-8v8h8v-8M56,12v4h4v-4h-4M32,12v-4h-4v4h4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_30_MEMBER_0_FILL" data-name="Layer0 30 MEMBER 0 FILL">
      <path d="M64,43.15v-2.2c-6.83,3.47-13.67,4.72-20.5,3.75-4.7-.6-6.88,1.12-6.55,5.15.27,4.73,1.6,9.45,4,14.15h2c0-.31-.09-.61-.25-.9-2.25-4.44-3.5-8.89-3.75-13.35v-.1c-.1-1.16.1-2.01.6-2.55.8-.49,2.02-.64,3.65-.45h.05c6.92,1,13.83-.16,20.75-3.5M20.8,64h2.25c-4.5-8.93-5.23-17.85-2.2-26.75,4.37-9.2,11.82-12.7,22.35-10.5,6.93,1.07,13.87-.17,20.8-3.7v-2c-.31,0-.61.07-.9.2-6.53,3.34-13.07,4.51-19.6,3.5-11.53-2.36-19.68,1.53-24.45,11.65-.04.07-.07.13-.1.2-3.11,9.12-2.5,18.25,1.85,27.4Z" fill="#219853" stroke-width="0"/>
      <path d="M20.85,37.25c-3.03,8.9-2.3,17.82,2.2,26.75h17.9c-2.4-4.7-3.73-9.42-4-14.15-.33-4.03,1.85-5.75,6.55-5.15,6.83.97,13.67-.28,20.5-3.75v-17.9c-6.93,3.53-13.87,4.77-20.8,3.7-10.53-2.2-17.98,1.3-22.35,10.5Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_30_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 30 MEMBER 0 MEMBER 0 FILL">
      <path d="M34,41h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_30_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 30 MEMBER 0 MEMBER 1 FILL">
      <path d="M46,35v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_30_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 30 MEMBER 0 MEMBER 2 FILL">
      <path d="M22,56h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminBGD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_26_FILL" data-name="Layer0 26 FILL">
      <path d="M36,60v4h4v-4h-4M64,4h-4v4h4v-4M8,16h4v-4h-4v4M56,56v-8h-8v8h8M28,48v-4h-4v4h4M36,36h-4v4h4v-4M36,20h-4v4h4v-4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,4V0H0v64h36v-4h4v4h24V8h-4v-4h4M28,12v-4h4v4h-4M60,12v4h-4v-4h4M32,20h4v4h-4v-4M32,36h4v4h-4v-4M40,44h4v4h-4v-4M28,44v4h-4v-4h4M56,48v8h-8v-8h8M12,16h-4v-4h4v4M16,16h8v8h-8v-8M16,28v4h-4v-4h4M4,52v-4h4v4h-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M4,48v4h4v-4h-4M16,32v-4h-4v4h4M24,16h-8v8h8v-8M44,44h-4v4h4v-4M60,16v-4h-4v4h4M28,8v4h4v-4h-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_FILL" data-name="Layer0 26 MEMBER 0 FILL">
      <path d="M15.5,38.9c.62.08,1.06.44,1.3,1.1.46,1.28.56,3.14.3,5.6v.05c-.44,6.12.79,12.23,3.7,18.35h2.25c-3.07-6.07-4.38-12.13-3.95-18.2.6-5.73-.55-8.7-3.45-8.9C10.42,36.93,5.2,38.28,0,40.95v2c.32,0,.62-.08.9-.25,4.86-2.47,9.73-3.73,14.6-3.8M43.4,44.7c-4.27-1.2-6.43.35-6.5,4.65.2,4.87,1.55,9.75,4.05,14.65h2c0-.31-.09-.61-.25-.9-2.32-4.59-3.59-9.17-3.8-13.75v-.1c.04-1.26.32-2.14.85-2.65.7-.37,1.73-.37,3.1,0,.09.04.18.06.25.05,6.98,1.01,13.94-.16,20.9-3.5v-2.2c-6.87,3.47-13.73,4.72-20.6,3.75M64,23.05v-2c-.31,0-.61.07-.9.2-10.07,5.14-20.13,5.14-30.2,0C21.93,15.71,10.97,15.56,0,20.8v2.25c10.67-5.4,21.33-5.4,32,0,10.67,5.43,21.33,5.43,32,0Z" fill="#219853" stroke-width="0"/>
      <path d="M64,40.95v-17.9c-10.67,5.43-21.33,5.43-32,0-10.67-5.4-21.33-5.4-32,0v17.9c5.2-2.67,10.42-4.02,15.65-4.05,2.9.2,4.05,3.17,3.45,8.9-.43,6.07.88,12.13,3.95,18.2h17.9c-2.5-4.9-3.85-9.78-4.05-14.65.07-4.3,2.23-5.85,6.5-4.65,6.87.97,13.73-.28,20.6-3.75Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 26 MEMBER 0 MEMBER 0 FILL">
      <path d="M36,54h-4v4h4v-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 26 MEMBER 0 MEMBER 1 FILL">
      <path d="M26,49v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 26 MEMBER 0 MEMBER 2 FILL">
      <path d="M50,33v-4h-4v4h4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 26 MEMBER 0 MEMBER 3 FILL">
      <path d="M8,34h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_MEMBER_4_FILL" data-name="Layer0 26 MEMBER 0 MEMBER 4 FILL">
      <path d="M14,28v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_26_MEMBER_0_MEMBER_5_FILL" data-name="Layer0 26 MEMBER 0 MEMBER 5 FILL">
      <path d="M60,36h-4v4h4v-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_35_FILL" data-name="Layer0 35 FILL">
      <path d="M40,64v-4h-4v4h4M60,4v4h4v-4h-4M32,40h4v-4h-4v4M24,48h4v-4h-4v4M36,20h-4v4h4v-4M12,12h-4v4h4v-4M56,48h-8v8h8v-8Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,8v-4h4V0H0v64h36v-4h4v4h24V8h-4M56,12h4v4h-4v-4M44,48h-4v-4h4v4M48,48h8v8h-8v-8M8,12h4v4h-4v-4M32,20h4v4h-4v-4M28,8h4v4h-4v-4M16,16h8v8h-8v-8M28,48h-4v-4h4v4M36,40h-4v-4h4v4M16,28v4h-4v-4h4M4,48h4v4h-4v-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M8,48h-4v4h4v-4M16,32v-4h-4v4h4M24,16h-8v8h8v-8M32,8h-4v4h4v-4M40,48h4v-4h-4v4M60,12h-4v4h4v-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_35_MEMBER_0_FILL" data-name="Layer0 35 MEMBER 0 FILL">
      <path d="M42.05,47.6c7.32-.73,14.64-2.95,21.95-6.65v-17.9c-5.52,2.81-10.79,3.28-15.8,1.4-1.23-.5-2.86-1.76-4.9-3.8-3.1-3.1-6.87-4.65-11.3-4.65s-8.22,1.55-11.35,4.65c-3.1,3.13-4.65,6.92-4.65,11.35s1.55,8.2,4.65,11.3c3.13,3.13,6.92,4.7,11.35,4.7,3.86,0,7.21-.13,10.05-.4Z" fill="#d9a24d" stroke-width="0"/>
      <path d="M64,23.05v-2c-.31,0-.61.07-.9.2-4.97,2.54-9.7,2.97-14.2,1.3-1.04-.46-2.44-1.58-4.2-3.35-3.48-3.47-7.71-5.2-12.7-5.2s-9.23,1.73-12.75,5.2l-.05.05c-3.47,3.52-5.2,7.77-5.2,12.75s1.73,9.22,5.2,12.7c3.54,3.54,7.81,5.3,12.8,5.3,3.93,0,7.33-.13,10.2-.4h.05c7.25-.73,14.5-2.88,21.75-6.45v-2.2c-7.31,3.7-14.63,5.92-21.95,6.65-2.84.27-6.19.4-10.05.4-4.43,0-8.22-1.57-11.35-4.7-3.1-3.1-4.65-6.87-4.65-11.3s1.55-8.22,4.65-11.35c3.13-3.1,6.92-4.65,11.35-4.65s8.2,1.55,11.3,4.65c2.04,2.04,3.67,3.3,4.9,3.8,5.01,1.88,10.28,1.41,15.8-1.4Z" fill="#219853" stroke-width="0"/>
    </g>
    <g id="Layer0_35_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 35 MEMBER 0 MEMBER 0 FILL">
      <path d="M22,39h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_35_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 35 MEMBER 0 MEMBER 1 FILL">
      <path d="M36,46v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_35_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 35 MEMBER 0 MEMBER 2 FILL">
      <path d="M42,26v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_35_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 35 MEMBER 0 MEMBER 3 FILL">
      <path d="M56,36h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminG] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_34_FILL" data-name="Layer0 34 FILL">
      <path d="M40,64v-4h-4v4h4M60,4v4h4v-4h-4M28,44h-4v4h4v-4M36,40v-4h-4v4h4M36,20h-4v4h4v-4M12,12h-4v4h4v-4M48,48v8h8v-8h-8Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,8v-4h4V0H0v64h36v-4h4v4h24V8h-4M60,12v4h-4v-4h4M40,44h4v4h-4v-4M48,56v-8h8v8h-8M8,12h4v4h-4v-4M32,20h4v4h-4v-4M28,8h4v4h-4v-4M16,16h8v8h-8v-8M36,36v4h-4v-4h4M24,44h4v4h-4v-4M16,32h-4v-4h4v4M4,48h4v4h-4v-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M8,48h-4v4h4v-4M12,32h4v-4h-4v4M24,16h-8v8h8v-8M32,8h-4v4h4v-4M44,44h-4v4h4v-4M60,16v-4h-4v4h4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_34_MEMBER_0_FILL" data-name="Layer0 34 MEMBER 0 FILL">
      <path d="M48,32c0-4.43-1.57-8.22-4.7-11.35-3.1-3.1-6.87-4.65-11.3-4.65-3.87,0-7.5.1-10.9.3-6.78.81-13.81,3.06-21.1,6.75v17.9c5.57-2.84,10.37-3.44,14.4-1.8,2.28.88,4.36,2.26,6.25,4.15,3.13,3.13,6.92,4.7,11.35,4.7s8.2-1.57,11.3-4.7c3.13-3.1,4.7-6.87,4.7-11.3Z" fill="#d9a24d" stroke-width="0"/>
      <path d="M43.3,20.65c3.13,3.13,4.7,6.92,4.7,11.35s-1.57,8.2-4.7,11.3c-3.1,3.13-6.87,4.7-11.3,4.7s-8.22-1.57-11.35-4.7c-1.89-1.89-3.97-3.27-6.25-4.15-4.03-1.64-8.83-1.04-14.4,1.8v2c.31,0,.61-.09.9-.25,4.94-2.5,9.19-3.06,12.75-1.7h0c2.04.8,3.89,2.03,5.55,3.7,3.54,3.54,7.81,5.3,12.8,5.3s9.21-1.77,12.7-5.3h0c3.53-3.49,5.3-7.72,5.3-12.7s-1.76-9.26-5.3-12.8c-3.48-3.47-7.71-5.2-12.7-5.2-3.92,0-7.6.1-11.05.3h-.1c-6.7.81-13.65,2.98-20.85,6.5v2.25c7.29-3.69,14.32-5.94,21.1-6.75,3.4-.2,7.03-.3,10.9-.3,4.43,0,8.2,1.55,11.3,4.65Z" fill="#219853" stroke-width="0"/>
    </g>
    <g id="Layer0_34_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 34 MEMBER 0 MEMBER 0 FILL">
      <path d="M21,40h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_34_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 34 MEMBER 0 MEMBER 1 FILL">
      <path d="M32,45v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_34_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 34 MEMBER 0 MEMBER 2 FILL">
      <path d="M36,19h-4v4h4v-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_34_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 34 MEMBER 0 MEMBER 3 FILL">
      <path d="M4,30h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminGB] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_31_FILL" data-name="Layer0 31 FILL">
      <path d="M64,8v-4h-4v4h4M48,48v8h8v-8h-8M28,44h-4v4h4v-4M36,40v-4h-4v4h4M8,12v4h4v-4h-4M36,20h-4v4h4v-4M36,64h4v-4h-4v4Z" fill="#24a159" stroke-width="0"/>
      <path d="M36,64v-4h4v4h24V8h-4v-4h4V0H0v64h36M32,20h4v4h-4v-4M28,8h4v4h-4v-4M16,16h8v8h-8v-8M8,16v-4h4v4h-4M4,52v-4h4v4h-4M12,32v-4h4v4h-4M36,36v4h-4v-4h4M40,44h4v4h-4v-4M24,44h4v4h-4v-4M48,56v-8h8v8h-8M56,12h4v4h-4v-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M60,12h-4v4h4v-4M44,44h-4v4h4v-4M12,28v4h4v-4h-4M4,48v4h4v-4h-4M24,16h-8v8h8v-8M32,8h-4v4h4v-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_31_MEMBER_0_FILL" data-name="Layer0 31 MEMBER 0 FILL">
      <path d="M0,23.05v17.9c5.07-2.57,10.13-3.92,15.2-4.05,3.1.07,4.45,2.53,4.05,7.4-.8,6.57.47,13.13,3.8,19.7h17.9c-4.2-8.23-5.15-16.47-2.85-24.7,2.3-8.63-1.48-14.78-11.35-18.45-8.9-3.03-17.82-2.3-26.75,2.2Z" fill="#d9a24d" stroke-width="0"/>
      <path d="M0,42.95c.31,0,.61-.09.9-.25,4.78-2.4,9.57-3.67,14.35-3.8.71,0,1.21.29,1.5.85.49.99.66,2.44.5,4.35v-.05c-.81,6.65.38,13.3,3.55,19.95h2.25c-3.33-6.57-4.6-13.13-3.8-19.7.4-4.87-.95-7.33-4.05-7.4-5.07.13-10.13,1.48-15.2,4.05v2M27.45,18.95h-.05C18.28,15.84,9.15,16.45,0,20.8v2.25c8.93-4.5,17.85-5.23,26.75-2.2,9.87,3.67,13.65,9.82,11.35,18.45-2.3,8.23-1.35,16.47,2.85,24.7h2c0-.31-.09-.61-.25-.9-3.94-7.75-4.84-15.5-2.7-23.25v-.05c2.72-9.76-1.46-16.71-12.55-20.85Z" fill="#219853" stroke-width="0"/>
    </g>
    <g id="Layer0_31_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 31 MEMBER 0 MEMBER 0 FILL">
      <path d="M29,50h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_31_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 31 MEMBER 0 MEMBER 1 FILL">
      <path d="M28,58v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_31_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 31 MEMBER 0 MEMBER 2 FILL">
      <path d="M15,22v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_31_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 31 MEMBER 0 MEMBER 3 FILL">
      <path d="M5,33h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminGD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_38_FILL" data-name="Layer0 38 FILL">
      <path d="M36,60v4h4v-4h-4M64,4h-4v4h4v-4M24,48h4v-4h-4v4M36,40v-4h-4v4h4M36,24v-4h-4v4h4M12,16v-4h-4v4h4M56,56v-8h-8v8h8Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,4h4V0H0v64h36v-4h4v4h24V8h-4v-4M60,16h-4v-4h4v4M56,48v8h-8v-8h8M28,8h4v4h-4v-4M16,16h8v8h-8v-8M12,12v4h-4v-4h4M12,32v-4h4v4h-4M8,48v4h-4v-4h4M36,20v4h-4v-4h4M36,36v4h-4v-4h4M28,48h-4v-4h4v4M40,44h4v4h-4v-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M44,44h-4v4h4v-4M8,52v-4h-4v4h4M12,28v4h4v-4h-4M24,16h-8v8h8v-8M32,8h-4v4h4v-4M56,16h4v-4h-4v4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_38_MEMBER_0_FILL" data-name="Layer0 38 MEMBER 0 FILL">
      <path d="M64,21.05c-.3,0-.6.08-.9.25-10.07,5.1-20.13,5.1-30.2,0C21.93,15.73,10.97,15.58,0,20.85v2.2c10.67-5.4,21.33-5.4,32,0,10.67,5.43,21.33,5.43,32,0v-2M64,43.2v-2.25c-10.67,5.4-21.33,5.4-32,0-9.33-4.77-18.67-5.35-28-1.75l-2,.8c-.67.3-1.33.62-2,.95v2c.3,0,.6-.07.9-.2.63-.33,1.27-.63,1.9-.9h-.05l1.95-.8h.05c8.8-3.37,17.58-2.8,26.35,1.7,10.97,5.53,21.93,5.68,32.9.45Z" fill="#219853" stroke-width="0"/>
      <path d="M64,40.95v-17.9c-10.67,5.43-21.33,5.43-32,0-10.67-5.4-21.33-5.4-32,0v17.9c.67-.33,1.33-.65,2-.95l2-.8c9.33-3.6,18.67-3.02,28,1.75,10.67,5.4,21.33,5.4,32,0Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_38_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 38 MEMBER 0 MEMBER 0 FILL">
      <path d="M10,30v-4h-4v4h4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_38_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 38 MEMBER 0 MEMBER 1 FILL">
      <path d="M12,22v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_38_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 38 MEMBER 0 MEMBER 2 FILL">
      <path d="M34,40h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_38_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 38 MEMBER 0 MEMBER 3 FILL">
      <path d="M56,40v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminH] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_36_FILL" data-name="Layer0 36 FILL">
      <path d="M36,60v4h4v-4h-4M60,8h4v-4h-4v4M8,16h4v-4h-4v4M28,48v-4h-4v4h4M32,36v4h4v-4h-4M56,48h-8v8h8v-8M36,20h-4v4h4v-4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,8h-4v-4h4V0H0v64h36v-4h4v4h24V8M32,20h4v4h-4v-4M28,8h4v4h-4v-4M56,12h4v4h-4v-4M48,48h8v8h-8v-8M32,40v-4h4v4h-4M28,44v4h-4v-4h4M40,48v-4h4v4h-4M12,16h-4v-4h4v4M16,16h8v8h-8v-8M16,28v4h-4v-4h4M4,48h4v4h-4v-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M8,48h-4v4h4v-4M16,32v-4h-4v4h4M24,16h-8v8h8v-8M40,44v4h4v-4h-4M60,12h-4v4h4v-4M32,8h-4v4h4v-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_36_MEMBER_0_FILL" data-name="Layer0 36 MEMBER 0 FILL">
      <path d="M47.55,21.85C46.85,14.59,44.65,7.3,40.95,0h-17.9c2.84,5.57,3.39,10.52,1.65,14.85-.79,1.97-2.14,3.91-4.05,5.8-3.1,3.13-4.65,6.92-4.65,11.35s1.55,8.2,4.65,11.3c3.13,3.13,6.92,4.7,11.35,4.7s8.2-1.57,11.3-4.7c3.13-3.1,4.7-6.87,4.7-11.3,0-3.85-.15-7.24-.45-10.15Z" fill="#d9a24d" stroke-width="0"/>
      <path d="M43.15,0h-2.2c3.7,7.3,5.9,14.59,6.6,21.85.3,2.91.45,6.3.45,10.15,0,4.43-1.57,8.2-4.7,11.3-3.1,3.13-6.87,4.7-11.3,4.7s-8.22-1.57-11.35-4.7c-3.1-3.1-4.65-6.87-4.65-11.3s1.55-8.22,4.65-11.35c1.91-1.89,3.26-3.83,4.05-5.8C26.44,10.52,25.89,5.57,23.05,0h-2c0,.31.07.61.2.9,2.54,4.95,3.07,9.35,1.6,13.2-.71,1.74-1.91,3.44-3.6,5.1l-.05.05c-3.47,3.52-5.2,7.77-5.2,12.75s1.73,9.22,5.2,12.7c3.54,3.54,7.81,5.3,12.8,5.3s9.21-1.77,12.7-5.3h0c3.53-3.49,5.3-7.72,5.3-12.7,0-3.93-.15-7.38-.45-10.35C48.85,14.45,46.72,7.24,43.15,0Z" fill="#219853" stroke-width="0"/>
    </g>
    <g id="Layer0_36_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 36 MEMBER 0 MEMBER 0 FILL">
      <path d="M26,37v-4h-4v4h4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_36_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 36 MEMBER 0 MEMBER 1 FILL">
      <path d="M32,44v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_36_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 36 MEMBER 0 MEMBER 2 FILL">
      <path d="M38,17h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_36_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 36 MEMBER 0 MEMBER 3 FILL">
      <path d="M36,9h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHB] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_24_FILL" data-name="Layer0 24 FILL">
      <path d="M36,60v4h4v-4h-4M64,4h-4v4h4v-4M48,48v8h8v-8h-8M36,36h-4v4h4v-4M36,20h-4v4h4v-4M28,48v-4h-4v4h4M12,12h-4v4h4v-4Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,4h4V0H0v64h36v-4h4v4h24V8h-4v-4M32,8v4h-4v-4h4M56,16v-4h4v4h-4M16,16h8v8h-8v-8M8,12h4v4h-4v-4M12,28h4v4h-4v-4M4,48h4v4h-4v-4M28,44v4h-4v-4h4M32,20h4v4h-4v-4M32,36h4v4h-4v-4M40,48v-4h4v4h-4M48,56v-8h8v8h-8Z" fill="#27ae60" stroke-width="0"/>
      <path d="M40,44v4h4v-4h-4M8,48h-4v4h4v-4M16,28h-4v4h4v-4M24,16h-8v8h8v-8M56,12v4h4v-4h-4M32,12v-4h-4v4h4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_24_MEMBER_0_FILL" data-name="Layer0 24 MEMBER 0 FILL">
      <path d="M23.05,32c-5.4,10.67-5.4,21.33,0,32h17.9c-.34-.66-.65-1.33-.95-2l-.85-2c-3.56-9.33-2.96-18.66,1.8-28C46.35,21.33,46.35,10.67,40.95,0h-17.9c5.43,10.67,5.43,21.33,0,32Z" fill="#d9a24d" stroke-width="0"/>
      <path d="M21.05,0c0,.31.07.61.2.9,5.14,10.07,5.14,20.13,0,30.2-5.54,10.97-5.69,21.93-.45,32.9h2.25c-5.4-10.67-5.4-21.33,0-32C28.48,21.33,28.48,10.67,23.05,0h-2M43.15,0h-2.2c5.4,10.67,5.4,21.33,0,32-4.76,9.34-5.36,18.67-1.8,28l.85,2c.3.67.61,1.34.95,2h2c0-.31-.09-.61-.25-.9-.3-.63-.6-1.26-.9-1.9h.05l-.8-1.95-.05-.05c-3.32-8.76-2.75-17.52,1.7-26.3C48.27,21.93,48.42,10.97,43.15,0Z" fill="#219853" stroke-width="0"/>
    </g>
    <g id="Layer0_24_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 24 MEMBER 0 MEMBER 0 FILL">
      <path d="M38,6v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_24_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 24 MEMBER 0 MEMBER 1 FILL">
      <path d="M34,13v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_24_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 24 MEMBER 0 MEMBER 2 FILL">
      <path d="M26,35v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_24_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 24 MEMBER 0 MEMBER 3 FILL">
      <path d="M26,41h-4v4h4v-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_24_MEMBER_0_MEMBER_4_FILL" data-name="Layer0 24 MEMBER 0 MEMBER 4 FILL">
      <path d="M28,51h-4v4h4v-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHBD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_29_FILL" data-name="Layer0 29 FILL">
      <path d="M36,60v4h4v-4h-4M64,8v-4h-4v4h4M48,48v8h8v-8h-8M28,44h-4v4h4v-4M32,36v4h4v-4h-4M12,16v-4h-4v4h4M36,20h-4v4h4v-4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,4V0H0v64h36v-4h4v4h24V8h-4v-4h4M60,12v4h-4v-4h4M16,16h8v8h-8v-8M32,12h-4v-4h4v4M32,20h4v4h-4v-4M12,12v4h-4v-4h4M32,40v-4h4v4h-4M40,44h4v4h-4v-4M12,32v-4h4v4h-4M24,44h4v4h-4v-4M48,56v-8h8v8h-8M4,52v-4h4v4h-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M4,48v4h4v-4h-4M12,28v4h4v-4h-4M44,44h-4v4h4v-4M28,12h4v-4h-4v4M24,16h-8v8h8v-8M60,16v-4h-4v4h4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_29_MEMBER_0_FILL" data-name="Layer0 29 MEMBER 0 FILL">
      <path d="M38.9,48.85v-.1c.06-1.2.31-2.07.75-2.6.54-.3,1.31-.33,2.3-.1,7.22,1.65,14.57.68,22.05-2.9v-2.2c-7.33,3.7-14.53,4.75-21.6,3.15-3.53-.83-5.37.73-5.5,4.7.1,5.07,1.45,10.13,4.05,15.2h2c0-.32-.08-.63-.25-.95-2.41-4.72-3.68-9.45-3.8-14.2M43.15,0h-2.2c3.83,7.57,4.95,15.13,3.35,22.7-1.07,3.13.2,4.67,3.8,4.6,5.27-.1,10.57-1.52,15.9-4.25v-2c-.31,0-.61.07-.9.2-5.05,2.6-10.07,3.95-15.05,4.05-.98.02-1.67-.12-2.05-.4-.11-.32-.04-.84.2-1.55.02-.08.04-.16.05-.25C47.89,15.41,46.86,7.71,43.15,0M21.05,0c0,.31.07.61.2.9,5.14,10.07,5.14,20.13,0,30.2-5.54,10.97-5.69,21.93-.45,32.9h2.25c-5.4-10.67-5.4-21.33,0-32C28.48,21.33,28.48,10.67,23.05,0,23.05,0,21.05,0,21.05,0Z" fill="#219853" stroke-width="0"/>
      <path d="M40.95,0h-17.9c5.43,10.67,5.43,21.33,0,32-5.4,10.67-5.4,21.33,0,32h17.9c-2.6-5.07-3.95-10.13-4.05-15.2.13-3.97,1.97-5.53,5.5-4.7,7.07,1.6,14.27.55,21.6-3.15v-17.9c-5.33,2.73-10.63,4.15-15.9,4.25-3.6.07-4.87-1.47-3.8-4.6C45.9,15.13,44.78,7.57,40.95,0Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_29_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 29 MEMBER 0 MEMBER 0 FILL">
      <path d="M38,38h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_29_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 29 MEMBER 0 MEMBER 1 FILL">
      <path d="M50,42v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_29_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 29 MEMBER 0 MEMBER 2 FILL">
      <path d="M24,58h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_29_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 29 MEMBER 0 MEMBER 3 FILL">
      <path d="M36,5v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHBG] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_28_FILL" data-name="Layer0 28 FILL">
      <path d="M36,60v4h4v-4h-4M60,8h4v-4h-4v4M56,56v-8h-8v8h8M36,40v-4h-4v4h4M36,20h-4v4h4v-4M24,44v4h4v-4h-4M8,16h4v-4h-4v4Z" fill="#24a159" stroke-width="0"/>
      <path d="M0,0v64h36v-4h4v4h24V8h-4v-4h4V0H0M12,16h-4v-4h4v4M16,16h8v8h-8v-8M16,32h-4v-4h4v4M4,52v-4h4v4h-4M24,48v-4h4v4h-4M28,12v-4h4v4h-4M32,20h4v4h-4v-4M60,12v4h-4v-4h4M36,36v4h-4v-4h4M40,44h4v4h-4v-4M56,48v8h-8v-8h8Z" fill="#27ae60" stroke-width="0"/>
      <path d="M44,44h-4v4h4v-4M60,16v-4h-4v4h4M28,8v4h4v-4h-4M4,48v4h4v-4h-4M12,32h4v-4h-4v4M24,16h-8v8h8v-8Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_28_MEMBER_0_FILL" data-name="Layer0 28 MEMBER 0 FILL">
      <path d="M43.15,0h-2.2c5.4,10.67,5.4,21.33,0,32-3.27,6.42-4.57,12.83-3.9,19.25.44,4.25,1.74,8.5,3.9,12.75h2c0-.31-.09-.61-.25-.9-1.99-3.95-3.21-7.9-3.65-11.85-.66-6.12.55-12.23,3.65-18.35C48.27,21.93,48.42,10.97,43.15,0M19.25,44.2c1-4.3-.17-6.73-3.5-7.3C10.48,36.93,5.23,38.28,0,40.95v2c.31,0,.61-.09.9-.25,4.88-2.46,9.76-3.73,14.65-3.8.85.17,1.43.54,1.75,1.1.37.91.37,2.16,0,3.75-.01.07-.03.14-.05.2-.28,2.43-.32,4.87-.1,7.3.42,4.25,1.64,8.5,3.65,12.75h2.25c-2.15-4.25-3.45-8.5-3.9-12.75-.22-2.35-.18-4.7.1-7.05M23.05,0h-2c0,.31.07.61.2.9,2.59,5.07,3.89,10.12,3.9,15.15,0,.76-.13,1.31-.4,1.65-.34.18-.85.19-1.55.05l.05.05c-7.76-1.71-15.51-.71-23.25,3v2.25c7.6-3.87,15.22-4.97,22.85-3.3,2.87.53,4.3-.7,4.3-3.7C27.15,10.72,25.78,5.37,23.05,0Z" fill="#219853" stroke-width="0"/>
      <path d="M15.75,36.9c3.33.57,4.5,3,3.5,7.3-.28,2.35-.32,4.7-.1,7.05.45,4.25,1.75,8.5,3.9,12.75h17.9c-2.16-4.25-3.46-8.5-3.9-12.75-.67-6.42.63-12.83,3.9-19.25C46.35,21.33,46.35,10.67,40.95,0h-17.9c2.73,5.37,4.1,10.72,4.1,16.05,0,3-1.43,4.23-4.3,3.7C15.22,18.08,7.6,19.18,0,23.05v17.9c5.23-2.67,10.48-4.02,15.75-4.05Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_28_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 28 MEMBER 0 MEMBER 0 FILL">
      <path d="M21,22v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_28_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 28 MEMBER 0 MEMBER 1 FILL">
      <path d="M24,28v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_28_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 28 MEMBER 0 MEMBER 2 FILL">
      <path d="M34,9v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_28_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 28 MEMBER 0 MEMBER 3 FILL">
      <path d="M24,50v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_28_MEMBER_0_MEMBER_4_FILL" data-name="Layer0 28 MEMBER 0 MEMBER 4 FILL">
      <path d="M6,31H2v4h4v-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHBGD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_25_FILL" data-name="Layer0 25 FILL">
      <path d="M40,64v-4h-4v4h4M60,4v4h4v-4h-4M24,44v4h4v-4h-4M36,20h-4v4h4v-4M32,36v4h4v-4h-4M12,16v-4h-4v4h4M48,56h8v-8h-8v8Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,8v-4h4V0H0v64h36v-4h4v4h24V8h-4M56,12h4v4h-4v-4M40,48v-4h4v4h-4M56,56h-8v-8h8v8M12,12v4h-4v-4h4M28,8h4v4h-4v-4M16,16h8v8h-8v-8M32,40v-4h4v4h-4M32,20h4v4h-4v-4M16,28v4h-4v-4h4M4,52v-4h4v4h-4M24,48v-4h4v4h-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M4,48v4h4v-4h-4M16,32v-4h-4v4h4M24,16h-8v8h8v-8M32,8h-4v4h4v-4M40,44v4h4v-4h-4M60,12h-4v4h4v-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_FILL" data-name="Layer0 25 MEMBER 0 FILL">
<path d="M17.75,40.7v.15c-1.64,7.73-.63,15.44,3.05,23.15h2.25c-3.83-7.57-4.95-15.13-3.35-22.7.87-2.87-.25-4.33-3.35-4.4C10.88,36.83,5.43,38.18,0,40.95v2c.31,0,.61-.09.9-.25,5.12-2.59,10.25-3.85,15.4-3.8h0c.77,0,1.3.13,1.6.35.12.33.07.82-.15,1.45M21.05,0c0,.31.07.61.2.9,2.84,5.54,4.13,11.09,3.85,16.65v.65c-.22.01-.57-.05-1.05-.2-.04-.02-.09-.03-.15-.05C15.96,16.04,7.99,16.99,0,20.8v2.25c7.83-3.97,15.65-5.02,23.45-3.15,2.4.77,3.62.02,3.65-2.25C27.4,11.75,26.05,5.87,23.05,0h-2M41.25,45.9l.1.05c7.49,1.78,15.04.85,22.65-2.8v-2.2c-7.47,3.77-14.87,4.78-22.2,3.05-3.13-.83-4.77.13-4.9,2.9-.2,5.7,1.15,11.4,4.05,17.1h2c0-.31-.09-.61-.25-.9-2.71-5.37-3.98-10.73-3.8-16.1v-.05c.03-.52.15-.9.35-1.15.46-.15,1.13-.12,2,.1M43.15,0h-2.2c4.03,7.97,5.07,15.93,3.1,23.9-.77,1.97,0,3.03,2.3,3.2,5.87.3,11.75-1.05,17.65-4.05v-2c-.31,0-.61.07-.9.2-5.55,2.83-11.08,4.12-16.6,3.85h-.05c-.36-.03-.63-.06-.8-.1.1-.06.19-.19.25-.4.05-.07.08-.15.1-.25C48.01,16.24,47.06,8.12,43.15,0Z" fill="#219853" stroke-width="0"/>
      <path d="M64,40.95v-17.9c-5.9,3-11.78,4.35-17.65,4.05-2.3-.17-3.07-1.23-2.3-3.2C46.02,15.93,44.98,7.97,40.95,0h-17.9c3,5.87,4.35,11.75,4.05,17.65-.03,2.27-1.25,3.02-3.65,2.25C15.65,18.03,7.83,19.08,0,23.05v17.9c5.43-2.77,10.88-4.12,16.35-4.05,3.1.07,4.22,1.53,3.35,4.4-1.6,7.57-.48,15.13,3.35,22.7h17.9c-2.9-5.7-4.25-11.4-4.05-17.1.13-2.77,1.77-3.73,4.9-2.9,7.33,1.73,14.73.72,22.2-3.05Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 0 FILL">
      <path d="M22,48h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 1 FILL">
      <path d="M30,36h-4v4h4v-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 2 FILL">
      <path d="M41,21v-4h-4v4h4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 3 FILL">
      <path d="M28,6h4V2h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_4_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 4 FILL">
      <path d="M52,38v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_5_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 5 FILL">
      <path d="M48,33v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_6_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 6 FILL">
      <path d="M26,62h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_25_MEMBER_0_MEMBER_7_FILL" data-name="Layer0 25 MEMBER 0 MEMBER 7 FILL">
      <path d="M6,24v4h4v-4h-4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_32_FILL" data-name="Layer0 32 FILL">
      <path d="M36,60v4h4v-4h-4M60,8h4v-4h-4v4M56,48h-8v8h8v-8M32,36v4h4v-4h-4M28,48v-4h-4v4h4M12,12h-4v4h4v-4M36,20h-4v4h4v-4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,8h-4v-4h4V0H0v64h36v-4h4v4h24V8M32,20h4v4h-4v-4M32,8v4h-4v-4h4M56,16v-4h4v4h-4M16,16h8v8h-8v-8M8,12h4v4h-4v-4M12,32v-4h4v4h-4M28,44v4h-4v-4h4M4,48h4v4h-4v-4M32,40v-4h4v4h-4M40,44h4v4h-4v-4M48,48h8v8h-8v-8Z" fill="#27ae60" stroke-width="0"/>
      <path d="M44,44h-4v4h4v-4M8,48h-4v4h4v-4M12,28v4h4v-4h-4M24,16h-8v8h8v-8M56,12v4h4v-4h-4M32,12v-4h-4v4h4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_32_MEMBER_0_FILL" data-name="Layer0 32 MEMBER 0 FILL">
      <path d="M21.05,0c0,.31.07.61.2.9,3.94,7.73,4.86,15.44,2.75,23.15v.1c-2.3,10.73,1.9,17.71,12.6,20.95h.05c9.11,3.07,18.23,2.42,27.35-1.95v-2.2c-8.93,4.5-17.85,5.25-26.75,2.25-9.57-2.87-13.33-9.07-11.3-18.6C28.18,16.4,27.22,8.2,23.05,0h-2M40.95,0c3.17,6.23,4.48,12.47,3.95,18.7-.87,5.33.75,8.13,4.85,8.4,4.73-.27,9.48-1.62,14.25-4.05v-2c-.31,0-.61.07-.9.2-4.43,2.28-8.85,3.56-13.25,3.85h-.1c-1.19-.1-2.04-.54-2.55-1.3-.55-1.1-.67-2.7-.35-4.8.03-.03.04-.08.05-.15C47.44,12.57,46.19,6.29,43.15,0h-2.2Z" fill="#219853" stroke-width="0"/>
      <path d="M44.9,18.7C45.43,12.47,44.12,6.23,40.95,0h-17.9c4.17,8.2,5.13,16.4,2.9,24.6-2.03,9.53,1.73,15.73,11.3,18.6,8.9,3,17.82,2.25,26.75-2.25v-17.9c-4.77,2.43-9.52,3.78-14.25,4.05-4.1-.27-5.72-3.07-4.85-8.4Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_32_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 32 MEMBER 0 MEMBER 0 FILL">
      <path d="M28,26v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_32_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 32 MEMBER 0 MEMBER 1 FILL">
      <path d="M39,38v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_32_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 32 MEMBER 0 MEMBER 2 FILL">
      <path d="M42,5h-4v4h4v-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_32_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 32 MEMBER 0 MEMBER 3 FILL">
      <path d="M57,34h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHG] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_33_FILL" data-name="Layer0 33 FILL">
      <path d="M36,64h4v-4h-4v4M24,44v4h4v-4h-4M36,40v-4h-4v4h4M12,16v-4h-4v4h4M36,20h-4v4h4v-4M56,56v-8h-8v8h8M64,8v-4h-4v4h4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,4V0H0v64h36v-4h4v4h24V8h-4v-4h4M56,16v-4h4v4h-4M56,48v8h-8v-8h8M28,8h4v4h-4v-4M32,20h4v4h-4v-4M16,16h8v8h-8v-8M12,12v4h-4v-4h4M12,32v-4h4v4h-4M8,48v4h-4v-4h4M40,44h4v4h-4v-4M36,36v4h-4v-4h4M24,48v-4h4v4h-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M44,44h-4v4h4v-4M8,52v-4h-4v4h4M12,28v4h4v-4h-4M24,16h-8v8h8v-8M32,8h-4v4h4v-4M56,12v4h4v-4h-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_33_MEMBER_0_FILL" data-name="Layer0 33 MEMBER 0 FILL">
      <path d="M43.15,0h-2.2c4.5,8.93,5.25,17.85,2.25,26.75-3.5,9.3-9.32,13.18-17.45,11.65-8.6-2.67-17.18-1.82-25.75,2.55v2c.31,0,.61-.09.9-.25,8.07-4.1,16.15-4.9,24.25-2.4.08.03.14.05.2.05,9.22,1.84,15.79-2.46,19.7-12.9l.05-.05C48.18,18.28,47.53,9.15,43.15,0M23.05,0h-2c0,.31.07.61.2.9,1.91,3.76,3.11,7.49,3.6,11.2v.05c.38,2.17.19,3.7-.55,4.6-.96.71-2.58.85-4.85.4h-.15C12.87,16.5,6.43,17.72,0,20.8v2.25c6.37-3.23,12.73-4.53,19.1-3.9,6.17,1.17,8.75-1.27,7.75-7.3C26.32,7.92,25.05,3.97,23.05,0Z" fill="#219853" stroke-width="0"/>
      <path d="M26.85,11.85c1,6.03-1.58,8.47-7.75,7.3-6.37-.63-12.73.67-19.1,3.9v17.9c8.57-4.37,17.15-5.22,25.75-2.55,8.13,1.53,13.95-2.35,17.45-11.65C46.2,17.85,45.45,8.93,40.95,0h-17.9c2,3.97,3.27,7.92,3.8,11.85Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_33_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 33 MEMBER 0 MEMBER 0 FILL">
      <path d="M16,34h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_33_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 33 MEMBER 0 MEMBER 1 FILL">
      <path d="M28,36v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_33_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 33 MEMBER 0 MEMBER 2 FILL">
      <path d="M30,2v4h4V2h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_33_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 33 MEMBER 0 MEMBER 3 FILL">
      <path d="M38,18h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGCheminHGD] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_27_FILL" data-name="Layer0 27 FILL">
      <path d="M36,60v4h4v-4h-4M60,8h4v-4h-4v4M48,48v8h8v-8h-8M24,44v4h4v-4h-4M32,40h4v-4h-4v4M36,20h-4v4h4v-4M12,16v-4h-4v4h4Z" fill="#24a159" stroke-width="0"/>
      <path d="M64,4V0H0v64h36v-4h4v4h24V8h-4v-4h4M56,12h4v4h-4v-4M16,16h8v8h-8v-8M32,12h-4v-4h4v4M12,12v4h-4v-4h4M32,20h4v4h-4v-4M36,40h-4v-4h4v4M12,28h4v4h-4v-4M24,48v-4h4v4h-4M44,44v4h-4v-4h4M48,56v-8h8v8h-8M4,52v-4h4v4h-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M4,48v4h4v-4h-4M44,48v-4h-4v4h4M16,28h-4v4h4v-4M28,12h4v-4h-4v4M24,16h-8v8h8v-8M60,12h-4v4h4v-4Z" fill="#29b865" stroke-width="0"/>
    </g>
    <g id="Layer0_27_MEMBER_0_FILL" data-name="Layer0 27 MEMBER 0 FILL">
      <path d="M64,43.15v-2.2c-10.67,5.4-21.33,5.4-32,0-7.43-3.79-14.87-4.94-22.3-3.45C6.47,38.15,3.23,39.3,0,40.95v2c.31,0,.61-.09.9-.25,2.93-1.48,5.87-2.53,8.8-3.15,7.13-1.51,14.27-.46,21.4,3.15,10.97,5.57,21.93,5.72,32.9.45M43.15,0h-2.2c3.53,6.97,4.77,13.95,3.7,20.95-.73,3.97.45,6.03,3.55,6.2,5.27-.03,10.53-1.4,15.8-4.1v-2c-.31,0-.61.07-.9.2-4.92,2.53-9.87,3.83-14.85,3.9-.7-.04-1.22-.28-1.55-.7-.31-.7-.34-1.75-.1-3.15.02,0,.02-.03,0-.05C47.71,14.15,46.56,7.07,43.15,0M25.15,15.6c.01.71-.19,1.23-.6,1.55-.76.38-1.93.44-3.5.2-3.79-.55-7.57-.47-11.35.25C6.46,18.2,3.23,19.27,0,20.8v2.25c3.23-1.64,6.46-2.79,9.7-3.45,3.68-.72,7.36-.8,11.05-.25,4.33.63,6.47-.63,6.4-3.8C27.05,10.38,25.68,5.2,23.05,0h-2c0,.31.07.61.2.9,2.5,4.92,3.8,9.82,3.9,14.7Z" fill="#219853" stroke-width="0"/>
      <path d="M40.95,0h-17.9c2.63,5.2,4,10.38,4.1,15.55.07,3.17-2.07,4.43-6.4,3.8-3.69-.55-7.37-.47-11.05.25C6.46,20.26,3.23,21.41,0,23.05v17.9c3.23-1.65,6.47-2.8,9.7-3.45,7.43-1.49,14.87-.34,22.3,3.45,10.67,5.4,21.33,5.4,32,0v-17.9c-5.27,2.7-10.53,4.07-15.8,4.1-3.1-.17-4.28-2.23-3.55-6.2C45.72,13.95,44.48,6.97,40.95,0Z" fill="#d9a24d" stroke-width="0"/>
    </g>
    <g id="Layer0_27_MEMBER_0_MEMBER_0_FILL" data-name="Layer0 27 MEMBER 0 MEMBER 0 FILL">
      <path d="M18,30h4v-4h-4v4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_27_MEMBER_0_MEMBER_1_FILL" data-name="Layer0 27 MEMBER 0 MEMBER 1 FILL">
      <path d="M50,36v-4h-4v4h4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_27_MEMBER_0_MEMBER_2_FILL" data-name="Layer0 27 MEMBER 0 MEMBER 2 FILL">
      <path d="M10,26h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
    <g id="Layer0_27_MEMBER_0_MEMBER_3_FILL" data-name="Layer0 27 MEMBER 0 MEMBER 3 FILL">
      <path d="M35,6v4h4v-4h-4Z" fill="#e2a94f" stroke-width="0"/>
    </g>
    <g id="Layer0_27_MEMBER_0_MEMBER_4_FILL" data-name="Layer0 27 MEMBER 0 MEMBER 4 FILL">
      <path d="M54,41h4v-4h-4v4Z" fill="#cd9948" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGFond1] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_9_FILL" data-name="Layer0 9 FILL">
      <path d="M36,60v4h4v-4h-4M64,4h-4v4h4v-4M24,48h4v-4h-4v4M36,40v-4h-4v4h4M32,20v4h4v-4h-4M12,16v-4h-4v4h4M56,56v-8h-8v8h8Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,4h4V0H0v64h36v-4h4v4h24V8h-4v-4M56,16v-4h4v4h-4M56,48v8h-8v-8h8M16,16h8v8h-8v-8M12,12v4h-4v-4h4M32,12h-4v-4h4v4M4,52v-4h4v4h-4M32,24v-4h4v4h-4M36,36v4h-4v-4h4M12,32v-4h4v4h-4M28,48h-4v-4h4v4M40,48v-4h4v4h-4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M40,44v4h4v-4h-4M12,28v4h4v-4h-4M4,48v4h4v-4h-4M28,12h4v-4h-4v4M24,16h-8v8h8v-8M56,12v4h4v-4h-4Z" fill="#29b865" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGBackgrounds[CSVGFond2] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 64 64">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g id="Layer0_10_FILL" data-name="Layer0 10 FILL">
      <path d="M4,12H0v8h4v-8M64,12h-4v8h4v-8M28,60v-4h-4v4h4M12,24h-4v4h4v-4M32,24h-4v4h4v-4M40,40h-4v4h4v-4M44,12h4v-4h-4v4Z" fill="#24a159" stroke-width="0"/>
      <path d="M60,12h4V0H0v12h4v8H0v44h64V20h-4v-8M48,16h4v4h-4v-4M48,12h-4v-4h4v4M36,40h4v4h-4v-4M48,28v8h-8v-8h8M52,52v-4h4v4h-4M16,8h-4v-4h4v4M28,24h4v4h-4v-4M8,24h4v4h-4v-4M8,52h4v4h-4v-4M20,48h-4v-4h4v4M28,56v4h-4v-4h4Z" fill="#27ae60" stroke-width="0"/>
      <path d="M16,48h4v-4h-4v4M12,52h-4v4h4v-4M12,8h4v-4h-4v4M52,48v4h4v-4h-4M48,36v-8h-8v8h8M52,16h-4v4h4v-4Z" fill="#29b865" stroke-width="0"/>
    </g>
  </g>
</svg>
''';

end.
