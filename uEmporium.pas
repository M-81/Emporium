unit uEmporium;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Math;

const
  cVATRate = 0.1;
  cImportRate = 0.05;

type
  TGood = class(TObject)
  private
    fDescription: string;
    fShelfPrice: Currency;
    fVATExempt: Boolean;
    fImported: Boolean;
    procedure SetDescription(Value: string);
    procedure SetShelfPrice(Value: Currency);
    procedure SetVATExempt(Value: Boolean);
    procedure SetImported(Value: Boolean);
    function GetTaxRate: Double;
    function GetTaxAmount: Currency;
    function PrintInput: string;
    function PrintOutput(var ASalexTaxes, ATotalAmount: Double): string;
    function GetImportTaxAmount: Currency;
    function GetVATTaxAmount: Currency;
    function GetImportTaxRate: Double;
    function GetVATTaxRate: Double;
    function CalcTaxAmount(ATaxRate: Double): Currency;
  public
    property Description: string read fDescription write SetDescription;
    property ShelfPrice: Currency read fShelfPrice write SetShelfPrice;
    property VATExempt: Boolean read fVATExempt write SetVATExempt;
    property Imported: Boolean read fImported write SetImported;
    property TaxAmount: Currency read GetTaxAmount;
    property VATTaxAmount: Currency read GetVATTaxAmount;
    property ImportTaxAmount: Currency read GetImportTaxAmount;
    property TaxRate: Double read GetTaxRate;
    constructor Create(ADescription: string; AShelfPrice: Double; AVATExempt, AImported: Boolean);
  end;

  TEmporium = class(TForm)
    BCheckOut: TButton;
    Memo1: TMemo;
    rgExamples: TRadioGroup;
    bGenerateExample: TButton;
    procedure bGenerateExampleClick(Sender: TObject);
    procedure BCheckOutClick(Sender: TObject);
  private
    fGoodList: TList;
    fNewGood: TGood;
    constructor Create(AOwner: TComponent); override;
    procedure ImportExample;
    procedure PrintCart;
  public
    { Public declarations }
  end;

var
  Form1: TEmporium;

implementation

uses uUtils;

{$R *.dfm}
{ TGood }

constructor TGood.Create(ADescription: string; AShelfPrice: Double; AVATExempt, AImported: Boolean);
begin
  Description := ADescription;
  ShelfPrice := AShelfPrice;
  VATExempt := AVATExempt;
  Imported := AImported;
end;

procedure TGood.SetVATExempt(Value: Boolean);
begin
  fVATExempt := Value;
end;

procedure TGood.SetImported(Value: Boolean);
begin
  fImported := Value;
end;

function TGood.PrintInput: string;
begin
  Result := '1 ';
  if Imported then
    Result := Result + 'imported ';
  Result := Result + Description + ' at ' + GetDouble2Str(ShelfPrice);
end;

function TGood.PrintOutput(var ASalexTaxes: Double; var ATotalAmount: Double): string;
begin
  if (not VATExempt) or Imported then
    ASalexTaxes := ASalexTaxes + TaxAmount;
  ATotalAmount := ATotalAmount + ShelfPrice + TaxAmount;
  Result := '1 ';
  if Imported then
    Result := Result + 'imported ';
  Result := Result + Description + ': ' + GetDouble2Str(ShelfPrice + TaxAmount);
end;

function TGood.GetVATTaxAmount: Currency;
begin
  Result := CalcTaxAmount(GetVATTaxRate);
end;

function TGood.GetImportTaxAmount: Currency;
begin
  Result := CalcTaxAmount(GetImportTaxRate);
end;

function TGood.GetTaxAmount: Currency;
begin
  Result := GetImportTaxAmount + GetVATTaxAmount;
end;

function TGood.CalcTaxAmount(ATaxRate: Double): Currency;
const
  CoinValue = 0.05;
var
  lAmount: Currency;
  lCoefficient: Double;
begin
  Result := 0;
  if TaxRate = 0 then
    Exit;

  // Rount up to near 5 cent formula: (Round (Amount / CoinValue) ) * CoinValue
  lAmount := ShelfPrice * ATaxRate;
  lCoefficient := lAmount / CoinValue; // ie number of coins of 5 cent needed to equal lAmount
  { // round to near 5 cent
  if Frac(lCoefficient) >= 0.5 then
    lCoefficient := Trunc(lCoefficient) + 1
  else
    lCoefficient := Trunc(lCoefficient);
  }
  // round up to next 5 cent
  if Frac(lCoefficient) > 0 then
    lCoefficient := Trunc(lCoefficient) + 1;
  Result := lCoefficient * CoinValue;
end;

function TGood.GetVATTaxRate: Double;
begin
  Result := 0;
  if not fVATExempt then
    Result := Result + cVATRate;
end;

function TGood.GetImportTaxRate: Double;
begin
  Result := 0;
  if fImported then
    Result := Result + cImportRate;
end;

function TGood.GetTaxRate: Double;
begin
  Result := GetVATTaxRate + GetImportTaxRate;
end;

procedure TGood.SetDescription(Value: String);
begin
  fDescription := Value;
end;

procedure TGood.SetShelfPrice(Value: Currency);
begin
  fShelfPrice := Value;
end;

{ TEmporium }

procedure TEmporium.ImportExample;
begin
  fGoodList.Clear;
  case rgExamples.ItemIndex of
    0:
      begin
        fGoodList.Add(TGood.Create('book', 12.49, True, False));
        fGoodList.Add(TGood.Create('music CD', 14.99, False, False));
        fGoodList.Add(TGood.Create('chocolate', 0.85, True, False));
      end;
    1:
      begin
        fGoodList.Add(TGood.Create('box of chocolates', 10.00, True, True));
        fGoodList.Add(TGood.Create('bottle of perfume', 47.50, False, True));
      end;
    2:
      begin
        fGoodList.Add(TGood.Create('bottle of perfume', 27.99, False, True));
        fGoodList.Add(TGood.Create('bottle of perfume', 18.99, False, False));
        fGoodList.Add(TGood.Create('packet of headache pills', 9.75, True, False));
        fGoodList.Add(TGood.Create('box of chocolates', 11.25, True, True));
      end;
  end;
end;

procedure TEmporium.PrintCart;
var
  I: Integer;
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Input');
  for I := 0 to fGoodList.Count - 1 do
    Memo1.Lines.Add(TGood(fGoodList[I]).PrintInput);
end;

procedure TEmporium.BCheckOutClick(Sender: TObject);
var
  I: Integer;
  lSalesTaxes, lTotalAmount: Double;
begin
  lSalesTaxes := 0;
  lTotalAmount := 0;
  Memo1.Lines.Add('Output');
  for I := 0 to fGoodList.Count - 1 do
    Memo1.Lines.Add(TGood(fGoodList[I]).PrintOutput(lSalesTaxes, lTotalAmount));
  Memo1.Lines.Add('Sales Taxes: ' + GetDouble2Str(lSalesTaxes));
  Memo1.Lines.Add('Total: ' + GetDouble2Str(lTotalAmount));
end;

procedure TEmporium.bGenerateExampleClick(Sender: TObject);
begin
  ImportExample;
  PrintCart;
  BCheckOut.Enabled := True;
end;

constructor TEmporium.Create;
begin
  inherited;

  fGoodList := TList.Create;

  rgExamples.Items.Add('Input1');
  rgExamples.Items.Add('Input2');
  rgExamples.Items.Add('Input3');

  rgExamples.ItemIndex := 0;
end;

end.
