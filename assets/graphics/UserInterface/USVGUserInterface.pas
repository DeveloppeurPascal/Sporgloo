unit USVGUserInterface;

// ****************************************
// * SVG from folder :
// * C:\Users\patrickpremartin\Documents\Embarcadero\Studio\Projets\Sporgloo\assets\graphics\UserInterface\USVGUserInterface.pas
// ****************************************
//
// This file contains a list of contants and 
// an enumeration to access to SVG source codes 
// from the generated array of strings.
//
// ****************************************
// File generator : SVG Folder to Delphi Unit (1.0)
// Website : https://svgfolder2delphiunit.olfsoftware.fr/
// Generation date : 23/07/2024 14:04:40
//
// Don't do any change on this file.
// They will be erased by next generation !
// ****************************************

interface

const
  CSVGMusicOff = 0;
  CSVGMusicOn = 1;
  CSVGPause = 2;
  CSVGTargetRoundB = 3;

type
{$SCOPEDENUMS ON}
  TSVGUserInterfaceIndex = (
    MusicOff = CSVGMusicOff,
    MusicOn = CSVGMusicOn,
    Pause = CSVGPause,
    TargetRoundB = CSVGTargetRoundB);

  TSVGUserInterface = class
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
    MusicOff = CSVGMusicOff;
    MusicOn = CSVGMusicOn;
    Pause = CSVGPause;
    TargetRoundB = CSVGTargetRoundB;
    class property Tag: integer read FTag write SetTag;
    class property TagBool: Boolean read FTagBool write SetTagBool;
    class property TagFloat: Single read FTagFloat write SetTagFloat;
    class property TagObject: TObject read FTagObject write SetTagObject;
    class property TagString: string read FTagString write SetTagString;
    class function SVG(const Index: Integer): string; overload;
    class function SVG(const Index: TSVGUserInterfaceIndex) : string; overload;
    class constructor Create;
  end;

var
  SVGUserInterface : array of String;

implementation

uses
  System.SysUtils;

{ TSVGUserInterface }

class constructor TSVGUserInterface.Create;
begin
  inherited;
  FTag := 0;
  FTagBool := false;
  FTagFloat := 0;
  FTagObject := nil;
  FTagString := '';
end;

class procedure TSVGUserInterface.SetTag(const Value: integer);
begin
  FTag := Value;
end;

class procedure TSVGUserInterface.SetTagBool(const Value: Boolean);
begin
  FTagBool := Value;
end;

class procedure TSVGUserInterface.SetTagFloat(const Value: Single);
begin
  FTagFloat := Value;
end;

class procedure TSVGUserInterface.SetTagObject(const Value: TObject);
begin
  FTagObject := Value;
end;

class procedure TSVGUserInterface.SetTagString(const Value: string);
begin
  FTagString := Value;
end;

class function TSVGUserInterface.SVG(const Index: Integer): string;
begin
  if (index < length(SVGUserInterface)) then
    result := SVGUserInterface[index]
  else
    raise Exception.Create('SVG not found. Index out of range.');
end;

class function TSVGUserInterface.SVG(const Index : TSVGUserInterfaceIndex): string;
begin
  result := SVG(ord(index));
end;

initialization

SetLength(SVGUserInterface, 4);

{$TEXTBLOCK NATIVE XML}
SVGUserInterface[CSVGMusicOff] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 29.95 30.98">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g>
      <path d="M8.2,1.5C8.5.47,9.25-.03,10.45,0h13.55C26,0,27,.97,27,2.9v15.45l-.3,1.65-6.8-6.8.75-.2h1.35v-5h-7.3L8.2,1.5" fill="#fff" stroke-width="0"/>
      <path d="M3.5,2.55c.4-.4.88-.6,1.45-.6s1.03.2,1.4.6l23,23c.4.37.6.83.6,1.4s-.2,1.05-.6,1.45c-.37.37-.83.55-1.4.55s-1.05-.18-1.45-.55L3.5,5.4c-.37-.4-.55-.88-.55-1.45s.18-1.03.55-1.4" fill="#fff" stroke-width="0"/>
      <path d="M2,20.95l.1-.05c1.1-1.07,2.3-1.73,3.6-2h.05l2.25.1v-6.3l4,4v8.3c.07,1.27-.62,2.53-2.05,3.8l-.05.15c-1.2,1.17-2.58,1.83-4.15,2h-.05c-1.73.17-3.15-.32-4.25-1.45C.31,28.4-.15,27,.04,25.3c.13-1.67.78-3.12,1.95-4.35" fill="#fff" stroke-width="0"/>
      <path d="M14.95,19.65l5.45,5.45c-1.63.07-2.98-.47-4.05-1.6-1-.97-1.47-2.25-1.4-3.85" fill="#fff" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGUserInterface[CSVGMusicOn] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 27 30.99">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <path d="M27,2.9v15.45c-.2,1.83-.87,3.33-2,4.5h-.1c-1.2,1.33-2.62,2.07-4.25,2.2h-.05c-1.7.17-3.12-.35-4.25-1.55-1.1-1.07-1.57-2.5-1.4-4.3.17-1.6.83-3,2-4.2,1.13-1.13,2.37-1.8,3.7-2h1.35v-5h-10v17c.07,1.27-.62,2.53-2.05,3.8l-.05.15c-1.2,1.17-2.58,1.83-4.15,2h-.05c-1.73.17-3.15-.32-4.25-1.45C.31,28.4-.16,27,.05,25.3c.13-1.67.78-3.12,1.95-4.35l.1-.05c1.1-1.07,2.3-1.73,3.6-2h.05l2.25.1V3C7.93.94,8.75-.06,10.44,0h13.55C25.99,0,26.99.97,26.99,2.9" fill="#fff" stroke-width="0"/>
  </g>
</svg>
''';
SVGUserInterface[CSVGPause] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_2" data-name="Calque 2" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 28 32">
  <g id="Calque_1-2" data-name="Calque 1-2">
    <g>
      <path d="M28,2v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-8c-.57,0-1.05-.18-1.45-.55-.37-.4-.55-.88-.55-1.45V2.05c0-.57.18-1.05.55-1.45C16.95.2,17.43,0,18,0h8C26.53,0,27,.2,27.4.6c.4.4.6.87.6,1.4" fill="#fff" stroke-width="0"/>
      <path d="M11.4.6c.4.4.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55H2c-.57,0-1.05-.18-1.45-.55C.18,31.05,0,30.57,0,30V2.05c0-.57.18-1.05.55-1.45C.95.2,1.43,0,2,0h8C10.53,0,11,.2,11.4.6" fill="#fff" stroke-width="0"/>
    </g>
  </g>
</svg>
''';
SVGUserInterface[CSVGTargetRoundB] := '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="Calque_1" data-name="Calque 1" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 32 32">
  <path d="M21.65,10.35v-.05c-1.33-1.3-2.88-2.05-4.65-2.25v.95l-.3.7-.7.3-.7-.3c-.2-.2-.3-.43-.3-.7v-.95c-1.77.2-3.32.95-4.65,2.25l-.05.05c-1.3,1.33-2.05,2.88-2.25,4.65h.95c.27,0,.5.1.7.3l.3.7-.3.7c-.2.2-.43.3-.7.3h-.95c.2,1.77.95,3.32,2.25,4.65h.05c1.33,1.33,2.88,2.1,4.65,2.3v-.95c0-.27.1-.5.3-.7.2-.2.43-.3.7-.3s.5.1.7.3l.3.7v.95c1.77-.2,3.32-.97,4.65-2.3,1.33-1.33,2.1-2.88,2.3-4.65h-.95c-.27,0-.5-.1-.7-.3-.2-.2-.3-.43-.3-.7s.1-.5.3-.7c.2-.2.43-.3.7-.3h.95c-.2-1.77-.97-3.32-2.3-4.65M23.05,8.9h.05c1.7,1.73,2.65,3.77,2.85,6.1h1.05c.27,0,.5.1.7.3l.3.7-.3.7c-.2.2-.43.3-.7.3h-1.05c-.2,2.3-1.17,4.32-2.9,6.05-1.73,1.73-3.75,2.7-6.05,2.9v1.05l-.3.7-.7.3-.7-.3c-.2-.2-.3-.43-.3-.7v-1.05c-2.33-.2-4.37-1.15-6.1-2.85v-.05c-1.7-1.73-2.65-3.75-2.85-6.05h-1.05c-.27,0-.5-.1-.7-.3-.2-.2-.3-.43-.3-.7s.1-.5.3-.7c.2-.2.43-.3.7-.3h1.05c.2-2.33,1.15-4.37,2.85-6.1,1.73-1.7,3.77-2.65,6.1-2.85v-1.05c0-.27.1-.5.3-.7.2-.2.43-.3.7-.3s.5.1.7.3l.3.7v1.05c2.3.2,4.32,1.15,6.05,2.85" fill="#fff" stroke-width="0"/>
<path
d="M23.05,8.9c-1.73-1.7-3.75-2.65-6.05-2.85v-1.05l-.3-.7c-.2-.2-.43-.3-.7-.3s-.5.1-.7.3c-.2.2-.3.43-.3.7v1.05c-2.33.2-4.37,1.15-6.1,2.85-1.7,1.73-2.65,3.77-2.85,6.1h-1.05c-.27,0-.5.1-.7.3-.2.2-.3.43-.3.7s.1.5.3.7c.2.2.43.3.7.3h1.05c.2,2.3,1.15,4.32,2.85,6.05v.05c1.73,1.7,3.77,2.65,6.1,2.85v1.05c0,.27.1.5.3.7l.7.3.7-.3.3-.7v-1.05c2.3-.2,4.32-1.17,6.05-2.9,1.73-1.73,2.7-3.75,2.9-6.05h1.05c.27,0,.5-.1.7-.3l.3-.7-.3-.7c-.2-.2-.43-.3-.7-.3h-1.05c-.2-2.33-1.15-4.37-2.85-6.1h-.05M21.65,10.35c1.33,1.33,2.1,2.88,2.3,4.65h-.95c-.27,0-.5.1-.7.3-.2.2-.3.43-.3.7s.1.5.3.7c.2.2.43.3.7.3h.95c-.2,1.77-.97,3.32-2.3,4.65-1.33,1.33-2.88,2.1-4.65,2.3v-.95l-.3-.7c-.2-.2-.43-.3-.7-.3s-.5.1-.7.3c-.2.2-.3.43-.3.7v.95c-1.77-.2-3.32-.97-4.65-2.3h-.05c-1.3-1.33-2.05-2.88-2.25-4.65h.95c.27,0,.5-.1.7-.3l.3-.7-.3-.7c-.2-.2-.43-.3-.7-.3h-.95c.2-1.77.95-3.32,2.25-4.65l.05-.05c1.33-1.3,2.88-2.05,4.65-2.25v.95c0,.27.1.5.3.7l.7.3.7-.3.3-.7v-.95c1.77.2,3.32.95,4.65,2.25v.05M24.5,7.45v.05c1.6,1.63,2.67,3.5,3.2,5.6.53.1,1,
.37,1.4.8h.05c.57.57.85,1.27.85,2.1v.05c0,.8-.28,1.48-.85,2.05l-.05.05c-.4.4-.87.67-1.4.8-.53,2.07-1.6,3.92-3.2,5.55-1.63,1.6-3.48,2.67-5.55,3.2-.13.53-.4,1-.8,1.4l-.05.05c-.57.57-1.25.85-2.05.85h-.05c-.83,0-1.53-.28-2.1-.85v-.05c-.43-.4-.7-.87-.8-1.4-2.1-.53-3.97-1.6-5.6-3.2h-.05v-.05c-1.6-1.63-2.63-3.47-3.1-5.5l-1.45-.8v-.05c-.6-.57-.9-1.25-.9-2.05v-.05c0-.83.3-1.53.9-2.1.4-.43.88-.7,1.45-.8.47-2.07,1.5-3.92,3.1-5.55v-.05l.05-.05h.05c1.63-1.6,3.48-2.63,5.55-3.1.1-.57.37-1.05.8-1.45.57-.6,1.27-.9,2.1-.9h.05c.8,0,1.48.3,2.05.9h.05c.4.4.67.88.8,1.45,2.03.47,3.87,1.5,5.5,3.1h.05M20.25,11.75l-1.65-1.2-.45.55-.05.05c-.57.57-1.25.85-2.05.85h-.05c-.83,0-1.53-.28-2.1-.85v-.05l-.45-.55c-.6.27-1.17.65-1.7,1.15v.05h-.05c-.5.53-.88,1.1-1.15,1.7l.55.45h.05c.57.57.85,1.27.85,2.1v.05c0,.8-.28,1.48-.85,2.05l-.05.05-.55.45,1.2,1.65,1.7,1.2.45-.55c.57-.6,1.27-.9,2.1-.9h.05c.8,0,1.48.3,2.05.9h.05l.45.55,1.65-1.2,
1.2-1.65-.55-.45v-.05c-.6-.57-.9-1.25-.9-2.05v-.05c0-.83.3-1.53.9-2.1l.55-.45-1.2-1.7" fill="#000" stroke-width="0"/>
</svg>
''';

end.
