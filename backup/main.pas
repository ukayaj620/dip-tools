unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls, windows;

type

  { TDIPTools }

  TDIPTools = class(TForm)
    blueGSButton: TButton;
    binaryButton: TButton;
    binaryOptionsPanel: TPanel;
    brightnessGroup: TGroupBox;
    redBinaryButton: TButton;
    greenBinaryButton: TButton;
    blueBinaryButton: TButton;
    grayscaleGroup: TGroupBox;
    grayscaleButton: TButton;
    binaryGroup: TGroupBox;
    greenGSButton: TButton;
    resetButton: TButton;
    redGSButton: TButton;
    colorControlPanel: TTabControl;
    OpenPictureDialog: TOpenPictureDialog;
    saveFileButton: TButton;
    openFileButton: TButton;
    colorGroup: TGroupBox;
    fileGroup: TGroupBox;
    redButton: TButton;
    greenButton: TButton;
    blueButton: TButton;
    originalImage: TImage;
    SavePictureDialog: TSavePictureDialog;
    enhancementControlPanel: TTabControl;
    targetImage: TImage;
    colorToggle: TToggleBox;
    enhanceToggle: TToggleBox;
    thresholdIndicator: TEdit;
    thresholdLabel: TLabel;
    thresholdTrackbar: TTrackBar;
    procedure enhanceToggleChange(Sender: TObject);
    procedure colorToggleChange(Sender: TObject);
    procedure openFileButtonClick(Sender: TObject);
    procedure resetButtonClick(Sender: TObject);
    procedure saveFileButtonClick(Sender: TObject);
    procedure thresholdTrackbarChange(Sender: TObject);
  private

  public

  end;

var
  DIPTools: TDIPTools;
  bitmapR: array [0..1000, 0..1000] of Byte;
  bitmapG: array [0..1000, 0..1000] of Byte;
  bitmapB: array [0..1000, 0..1000] of Byte;

  bitmapTempR: array [0..1000, 0..1000] of Byte;
  bitmapTempG: array [0..1000, 0..1000] of Byte;
  bitmapTempB: array [0..1000, 0..1000] of Byte;

  bitmapInversR : array [0..1000, 0..1000] of Byte;
  bitmapInversG : array [0..1000, 0..1000] of Byte;
  bitmapInversB : array [0..1000, 0..1000] of Byte;

  bitmapBiner: array[0..1000, 0..1000] of Boolean;

implementation

{$R *.lfm}

{ TDIPTools }

//Open file
procedure TDIPTools.openFileButtonClick(Sender: TObject);
var
  x: Integer;
  y: Integer;

begin
  if OpenPictureDialog.Execute then
  begin
    originalImage.Picture.LoadFromFile(OpenPictureDialog.FileName);
    targetImage.Picture.LoadFromFile(OpenPictureDialog.FileName);

    for y := 0 to originalImage.Height - 1 do
    begin
      for x := 0 to originalImage.Width - 1 do
      begin
        bitmapTempR[x,y] := GetRValue(originalImage.Canvas.Pixels[x,y]);
        bitmapTempG[x,y] := GetGValue(originalImage.Canvas.Pixels[x,y]);
        bitmapTempB[x,y] := GetBValue(originalImage.Canvas.Pixels[x,y]);

        bitmapR[x,y] := GetRValue(originalImage.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(originalImage.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(originalImage.Canvas.Pixels[x,y]);

        bitmapR[x,y] := GetRValue(targetImage.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(targetImage.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(targetImage.Canvas.Pixels[x,y]);
      end;
    end;

    for y:=0 to originalImage.Height-1 do
    begin
      for x:=0 to originalImage.Width-1 do
      begin
        originalImage.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
      end;
    end;
  end;
end;

//Save file
procedure TDIPTools.saveFileButtonClick(Sender: TObject);
begin
  if SavePictureDialog.Execute then;
  begin
    targetImage.Picture.SaveToFile(SavePictureDialog.FileName);
  end;
end;

//Reset image
procedure TDIPTools.resetButtonClick(Sender: TObject);
var
  x: Integer;
  y: Integer;

begin
  for y:=0 to originalImage.Height-1 do
  begin
    for x:=0 to originalImage.Width-1 do
    begin
      originalImage.Canvas.Pixels[x,y] := RGB(bitmapTempR[x,y], bitmapTempG[x,y], bitmapTempB[x,y]);
    end;
  end;
end;

//Color Options
procedure TDIPTools.colorToggleChange(Sender: TObject);
begin
  if colorControlPanel.Visible = true then
  begin
    colorControlPanel.Visible:= false;
    enhancementControlPanel.Visible:= false;
  end
     else
     begin
       colorControlPanel.Visible:= true;
     end;
end;

//Alteration Options
procedure TDIPTools.enhanceToggleChange(Sender: TObject);
begin
  if enhancementControlPanel.Visible = true then
  begin
    enhancementControlPanel.Visible:= false;
  end
     else
     begin
       colorControlPanel.Visible:= false;
       enhancementControlPanel.Visible:= true;
     end;
end;

//Binary Trackbar
procedure TDIPTools.thresholdTrackbarChange(Sender: TObject);
begin
  thresholdIndicator.Text:= IntToStr(thresholdTrackbar.Position);
end;
end.

