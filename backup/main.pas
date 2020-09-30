unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls, windows;

type

  { TDIPTools }

  TDIPTools = class(TForm)
    blueButton: TButton;
    binaryExecuteButton: TButton;
    binarySettingsPanel: TPanel;
    brightnessGroup: TGroupBox;
    grayscaleExecuteButton: TButton;
    inverseButton: TButton;
    inverseGroup: TGroupBox;
    binaryRadioGroup: TRadioGroup;
    grayscaleRadioGroup: TRadioGroup;
    brightnessIndicator: TLabel;
    contrastIndicator: TLabel;
    gValueIndicator: TLabel;
    colorModeRadioGroup: TRadioGroup;
    thresholdIndicator: TLabel;
    sketchButton: TButton;
    executeButton: TButton;
    HPL0Radio: TRadioButton;
    HPL1Radio: TRadioButton;
    kernelValue: TEdit;
    kernelLabel: TLabel;
    brightnessOptionsPanel: TPanel;
    brightnessLabel: TLabel;
    brightnessButton: TButton;
    contrastButton: TButton;
    colorGroup: TGroupBox;
    colorPanel: TPanel;
    imagealterGroup: TGroupBox;
    gValueLabel: TLabel;
    greenButton: TButton;
    enhancementPanel: TPanel;
    contrastGroup: TGroupBox;
    colorRadioGroup: TRadioGroup;
    colormodeRadioButton: TRadioButton;
    grayscalemodeRadioButton: TRadioButton;
    filterRadioGroup: TRadioGroup;
    LPLRadio: TRadioButton;
    methodRadioGroup: TRadioGroup;
    correlationRadio: TRadioButton;
    convolutionRadio: TRadioButton;
    grayscaleGroup: TGroupBox;
    binarySettingsGroup: TGroupBox;
    redButton: TButton;
    resetButton: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    saveFileButton: TButton;
    openFileButton: TButton;
    fileGroup: TGroupBox;
    originalImage: TImage;
    SavePictureDialog: TSavePictureDialog;
    targetImage: TImage;
    colorToggle: TToggleBox;
    enhanceToggle: TToggleBox;
    thresholdLabel: TLabel;
    contrastLabel: TLabel;
    thresholdTrackbar: TTrackBar;
    brightnessTrackbar: TTrackBar;
    contrastTrackbar: TTrackBar;
    gValueTrackbar: TTrackBar;
    procedure binaryExecuteButtonClick(Sender: TObject);
    procedure blueButtonClick(Sender: TObject);
    procedure brightnessButtonClick(Sender: TObject);
    procedure contrastButtonClick(Sender: TObject);
    procedure enhanceToggleChange(Sender: TObject);
    procedure colorToggleChange(Sender: TObject);
    procedure grayscaleExecuteButtonClick(Sender: TObject);
    procedure greenButtonClick(Sender: TObject);
    procedure gValueTrackbarChange(Sender: TObject);
    procedure inverseButtonClick(Sender: TObject);
    procedure openFileButtonClick(Sender: TObject);
    procedure redButtonClick(Sender: TObject);
    procedure resetButtonClick(Sender: TObject);
    procedure saveFileButtonClick(Sender: TObject);
    procedure thresholdTrackbarChange(Sender: TObject);
    procedure brightnessTrackbarChange(Sender: TObject);
    procedure contrastTrackbarChange(Sender: TObject);
  private
    function pixelBoundariesChecker(value: Integer): Integer;
  public

  end;

var
  DIPTools: TDIPTools;

  imageWidth: Integer;
  imageHeight: Integer;

  bitmapR: array [0..1000, 0..1000] of Byte;
  bitmapG: array [0..1000, 0..1000] of Byte;
  bitmapB: array [0..1000, 0..1000] of Byte;

  bitmapTempR: array [0..1000, 0..1000] of Byte;
  bitmapTempG: array [0..1000, 0..1000] of Byte;
  bitmapTempB: array [0..1000, 0..1000] of Byte;

  bitmapInversR: array [0..1000, 0..1000] of Byte;
  bitmapInversG: array [0..1000, 0..1000] of Byte;
  bitmapInversB: array [0..1000, 0..1000] of Byte;

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

    imageWidth:= originalImage.Width;
    imageHeight:= originalImage.Height;

    targetImage.Width:= imageWidth;
    targetImage.Height:= imageHeight;

    for y := 0 to originalImage.Height - 1 do
    begin
      for x := 0 to originalImage.Width - 1 do
      begin
        bitmapR[x,y] := GetRValue(originalImage.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(originalImage.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(originalImage.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TDIPTools.redButtonClick(Sender: TObject);
var
  x, y: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      targetImage.Canvas.Pixels[x, y]:= RGB(bitmapR[x, y], 0, 0);
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
      originalImage.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
    end;
  end;
end;

//Color Options
procedure TDIPTools.colorToggleChange(Sender: TObject);
begin
  enhanceToggle.Checked:= false;

  if colorPanel.Visible = true then
  begin
    colorPanel.Visible:= false;
    enhancementPanel.Visible:= false;
  end
     else
     begin
       colorPanel.Visible:= true;
       enhancementPanel.Visible:= false;
       thresholdIndicator.Caption:= IntToStr(thresholdTrackbar.Position);
     end;
end;

procedure TDIPTools.grayscaleExecuteButtonClick(Sender: TObject);
var
  x, y: Integer;
  gray: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      gray:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      case (grayscaleRadioGroup.ItemIndex) of
      0: targetImage.Canvas.Pixels[x, y]:= RGB(gray, 0, 0);
      1: targetImage.Canvas.Pixels[x, y]:= RGB(0, gray, 0);
      2: targetImage.Canvas.Pixels[x, y]:= RGB(0, 0, gray);
      3: targetImage.Canvas.Pixels[x, y]:= RGB(gray, gray, gray);
      end;
    end;
  end;
end;

procedure TDIPTools.greenButtonClick(Sender: TObject);
var
  x, y: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      targetImage.Canvas.Pixels[x, y]:= RGB(0, bitmapG[x, y], 0);
    end;
  end;
end;

//Enhancement Options
procedure TDIPTools.enhanceToggleChange(Sender: TObject);
begin
  colorToggle.Checked:= false;

  if enhancementPanel.Visible = true then
  begin
    colorPanel.Visible:= false;
    enhancementPanel.Visible:= false;
  end
     else
     begin
       colorPanel.Visible:= false;
       enhancementPanel.Visible:= true;
       brightnessIndicator.Caption:= IntToStr(brightnessTrackbar.Position);
       contrastIndicator.Caption:= IntToStr(contrastTrackbar.Position);
       gValueIndicator.Caption:= IntToStr(gValueTrackbar.Position);
     end;
end;

procedure TDIPTools.blueButtonClick(Sender: TObject);
var
  x, y: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      targetImage.Canvas.Pixels[x, y]:= RGB(0, 0, bitmapB[x, y]);
    end;
  end;
end;

procedure TDIPTools.brightnessButtonClick(Sender: TObject);
var
  x, y: Integer;
  brightnessCoef: Integer;
  brightnessR, brightnessG, brightnessB: Integer;
  brightnessGray: Integer;
  gray: Integer;
begin
  brightnessCoef:= brightnessTrackbar.Position;
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      if colorModeRadioGroup.ItemIndex = 0 then
      begin
        brightnessR:= pixelBoundariesChecker(bitmapR[x, y] + brightnessCoef);
        brightnessG:= pixelBoundariesChecker(bitmapG[x, y] + brightnessCoef);
        brightnessB:= pixelBoundariesChecker(bitmapB[x, y] + brightnessCoef);

        targetImage.Canvas.Pixels[x, y]:= RGB(brightnessR, brightnessG, brightnessB);
      end
      else if colorModeRadioGroup.ItemIndex = 1 then
      begin
        gray:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
        brightnessGray:= pixelBoundariesChecker(gray + brightnessCoef);

        targetImage.Canvas.Pixels[x, y]:= RGB(brightnessGray, brightnessGray, brightnessGray);
      end;
    end;
  end;
end;

procedure TDIPTools.contrastButtonClick(Sender: TObject);
var
  x, y: Integer;
  contrastR, contrastG, contrastB: Integer;
  contrastGray, gray: Integer;
  gCoef: Integer;
  contrastCoef: Integer;
begin
  contrastCoef:= contrastTrackbar.Position;
  gCoef:= gValueTrackbar.Position;
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      if colorModeRadioGroup.ItemIndex = 0 then
      begin
        contrastR:= pixelBoundariesChecker(gCoef * (bitmapR[x, y] - contrastCoef) + contrastCoef);
        contrastG:= pixelBoundariesChecker(gCoef * (bitmapG[x, y] - contrastCoef) + contrastCoef);
        contrastB:= pixelBoundariesChecker(gCoef * (bitmapB[x, y] - contrastCoef) + contrastCoef);

        targetImage.Canvas.Pixels[x, y]:= RGB(contrastR, contrastG, contrastB);
      end
      else if colorModeRadioGroup.ItemIndex = 1 then
      begin
        gray:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
        contrastGray:= pixelBoundariesChecker(gCoef * (gray - contrastCoef) + contrastCoef);

        targetImage.Canvas.Pixels[x, y]:= RGB(contrastGray, contrastGray, contrastGray);
      end;
    end;
  end;
end;

procedure TDIPTools.binaryExecuteButtonClick(Sender: TObject);
var
  x, y: Integer;
  gray: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      gray:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      if gray <= thresholdTrackbar.Position then
      case (binaryRadioGroup.ItemIndex) of
        0: targetImage.Canvas.Pixels[x, y]:= RGB(255, 0, 0);
        1: targetImage.Canvas.Pixels[x, y]:= RGB(0, 255, 0);
        2: targetImage.Canvas.Pixels[x, y]:= RGB(0, 0, 255);
        3: targetImage.Canvas.Pixels[x, y]:= RGB(0, 0, 0);
      end
      else
        targetImage.Canvas.Pixels[x, y]:= RGB(255, 255, 255);
    end;
  end;
end;

//Trackbars
procedure TDIPTools.thresholdTrackbarChange(Sender: TObject);
begin
  thresholdIndicator.Caption:= IntToStr(thresholdTrackbar.Position);
end;

procedure TDIPTools.brightnessTrackbarChange(Sender: TObject);
begin
  brightnessIndicator.Caption:= IntToStr(brightnessTrackbar.Position);
end;

procedure TDIPTools.contrastTrackbarChange(Sender: TObject);
begin
  contrastIndicator.Caption:= IntToStr(contrastTrackbar.Position);
end;

function TDIPTools.pixelBoundariesChecker(value: Integer): Integer;
begin
  if value < 0 then pixelBoundariesChecker:= 0
  else if value > 255 then pixelBoundariesChecker:= 255
  else pixelBoundariesChecker:= value;
end;

procedure TDIPTools.gValueTrackbarChange(Sender: TObject);
begin
  gValueIndicator.Caption:= IntToStr(gValueTrackbar.Position);
end;

procedure TDIPTools.inverseButtonClick(Sender: TObject);
var
  x, y: Integer;
  gray: Integer;
begin
  for y:= 0 to imageHeight-1 do
  begin
    for x:= 0 to imageWidth-1 do
    begin
      if colorModeRadioGroup.ItemIndex = 0 then
        targetImage.Canvas.Pixels[x, y]:= RGB(255-bitmapR[x, y], 255-bitmapG[x, y], 255-bitmapB[x, y])
      else
        gray:= (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
        targetImage.Canvas.Pixels[x, y]:= RGB(255-gray, 255-gray, 255-gray);
    end;
  end;
end;

end.

