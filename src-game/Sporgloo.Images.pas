unit Sporgloo.Images;

interface

uses
  System.SysUtils,
  System.Classes,
  System.ImageList,
  FMX.ImgList;

type
  TdmSporglooImages = class(TDataModule)
    ButtonsImages: TImageList;
    MapImages: TImageList;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  dmSporglooImages: TdmSporglooImages;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

end.
