//
//  CalculatorViewController.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
  // For private properties
@end

@implementation CalculatorViewController
{
    UIColor *selectedColor, *defaultColor;
    UIButton *lastClick;
}

@synthesize calculator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [calculator clear];
    
    lastClick = nil;
    defaultColor = self.addButton.backgroundColor;
    selectedColor = [UIColor colorWithRed:214/255.0f green:53/255.0f blue:71/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectButtonColor:(UIButton *)button {
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    [button setBackgroundColor:selectedColor];
    lastClick = button;
}

- (void)setDefaultButtonColor {
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    lastClick = nil;
}

- (void)clearResult {
    // ToDo
    self.resultLabel.text = @"0";
    [calculator clear];
    [self setDefaultButtonColor];
}

- (void)addToResult:(NSString*)value {
    if (calculator.isEmpty)
        self.resultLabel.text = value;
    else
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
}

- (IBAction)dotButtonClick:(id)sender {
    if (![self.resultLabel.text hasSuffix:calculator.format.decimalSeparator])
      [self addToResult:calculator.format.decimalSeparator];
}
- (IBAction)zeroButtonClick:(id)sender {
    [self addToResult:@"0"];
}
- (IBAction)oneButtonClick:(id)sender {
    [self addToResult:@"1"];
}
- (IBAction)twoButtonClick:(id)sender {
    [self addToResult:@"2"];
}
- (IBAction)threeButtonClick:(id)sender {
    [self addToResult:@"3"];
}
- (IBAction)fourButtonClick:(id)sender {
    [self addToResult:@"4"];
}
- (IBAction)fiveButtonClick:(id)sender {
    [self addToResult:@"5"];
}
- (IBAction)sixButtonClick:(id)sender {
    [self addToResult:@"6"];
}
- (IBAction)sevenButtonClick:(id)sender {
    [self addToResult:@"7"];
}
- (IBAction)eightButtonClick:(id)sender {
    [self addToResult:@"8"];
}
- (IBAction)nineButtonClick:(id)sender {
    [self addToResult:@"9"];
}

- (IBAction)divisionButtonClick:(id)sender {
    [self setSelectButtonColor:(UIButton *)sender];
}
- (IBAction)multiplyButtonClick:(id)sender {
    [self setSelectButtonColor:(UIButton *)sender];
}
- (IBAction)subtractButtonClick:(id)sender {
    [self setSelectButtonColor:(UIButton *)sender];
}
- (IBAction)addButtonClick:(id)sender {
    [self setSelectButtonColor:(UIButton *)sender];
}
- (IBAction)totalButtonClick:(id)sender {
    [self setDefaultButtonColor];
}

- (IBAction)clearButtonClick:(id)sender {
    [self clearResult];
}
- (IBAction)togglePosNegButtonClick:(id)sender {
}
- (IBAction)percentButtonClick:(id)sender {
}

@end
