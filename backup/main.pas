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
    gValueIndicator: TEdit;
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
    thresholdIndicator: TEdit;
    brightnessIndicator: TEdit;
    contrastIndicator: TEdit;
    thresholdLabel: TLabel;
    contrastLabel: TLabel;
    thresholdTrackbar: TTrackBar;
    brightnessTrackbar: TTrackBar;
    contrastTrackbar: TTrackBar;
    gValueTrackbar: TTrackBar;
    procedure blueButtonClick(Sender: TObject);
    procedure blueGSButtonClick(Sender: TObject);
    procedure enhanceToggleChange(Sender: TObject);
    procedure colorToggleChange(Sender: TObject);
    procedure grayscaleButtonClick(Sender: TObject);
    procedure grayscaleExecuteButtonClick(Sender: TObject);
    procedure greenButtonClick(Sender: TObject);
    procedure greenGSButtonClick(Sender: TObject);
    procedure gValueTrackbarChange(Sender: TObject);
    procedure openFileButtonClick(Sender: TObject);
    procedure redButtonClick(Sender: TObject);
    procedure redGSButtonClick(Sender: TObject);
    procedure resetButtonClick(Sender: TObject);
    procedure saveFileButtonClick(Sender: TObject);
    procedure thresholdTrackbarChange(Sender: TObject);
    procedure brightnessTrackbarChange(Sender: TObject);
    procedure contrastTrackbarChange(Sender: TObject);
  private

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

procedure TDIPTools.redGSButtonClick(Sender: TObject);
begin

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
       thresholdIndicator.Text:= IntToStr(thresholdTrackbar.Position);
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

procedure TDIPTools.greenGSButtonClick(Sender: TObject);
begin

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
       brightnessIndicator.Text:= IntToStr(brightnessTrackbar.Position);
       contrastIndicator.Text:= IntToStr(contrastTrackbar.Position);
       gValueIndicator.Text:= IntToStr(gValueTrackbar.Position);
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

procedure TDIPTools.blueGSButtonClick(Sender: TObject);
begin

end;

//Trackbars
procedure TDIPTools.thresholdTrackbarChange(Sender: TObject);
begin
  thresholdIndicator.Text:= IntToStr(thresholdTrackbar.Position);
end;

procedure TDIPTools.brightnessTrackbarChange(Sender: TObject);
begin
  brightnessIndicator.Text:= IntToStr(brightnessTrackbar.Position);
end;

procedure TDIPTools.contrastTrackbarChange(Sender: TObject);
begin
  contrastIndicator.Text:= IntToStr(contrastTrackbar.Position);
end;

procedure TDIPTools.gValueTrackbarChange(Sender: TObject);
begin
  gValueIndicator.Text:= IntToStr(gValueTrackbar.Position);
end;
end.

