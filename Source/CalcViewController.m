//
//  CalcViewController.m
//  Calculadora
//
//  Created by Ricardo Pereira on 10/7/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "CalcViewController.h"

@interface CalcViewController () {
    int operand;
    BOOL newNumber;
    UIColor *selectedColor, *defaultColor;
    UIButton *lastClick;
    NSMutableArray *array;
}

@end

@implementation CalcViewController

@synthesize calc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    array = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], nil];
	[self btnClearClick:nil];
    
    lastClick = nil;
    defaultColor = self.btnSum.backgroundColor;
    selectedColor = [UIColor colorWithRed:148/255.0f green:161/255.0f blue:255/255.0f alpha:1.0f];
    
    newNumber = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSNumber *)getResultDisplay {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    return [formatter numberFromString:self.resultLabel.text];
}

- (BOOL)isDisplayEmpty {
    return [[self getResultDisplay] intValue] == 0;
}

- (void)putNumber:(int)value {
    if ([self isDisplayEmpty] || newNumber == YES)
    {
        self.resultLabel.text = [NSString stringWithFormat:@"%d",value];
        newNumber = NO;
    }
    else
        self.resultLabel.text = [NSString stringWithFormat:@"%@%d",self.resultLabel.text,value];
}

- (IBAction)numberZero:(id)sender {
    [self putNumber:0];
}
- (IBAction)numberOne:(id)sender {
    [self putNumber:1];
}
- (IBAction)numberTwo:(id)sender {
    [self putNumber:2];
}
- (IBAction)numberThree:(id)sender {
    [self putNumber:3];
}
- (IBAction)numberFour:(id)sender {
    [self putNumber:4];
}
- (IBAction)numberFive:(id)sender {
    [self putNumber:5];
}
- (IBAction)numberSix:(id)sender {
    [self putNumber:6];
}
- (IBAction)numberSeven:(id)sender {
    [self putNumber:7];
}
- (IBAction)numberHeight:(id)sender {
    [self putNumber:8];
}
- (IBAction)numberNine:(id)sender {
    [self putNumber:9];
}

- (IBAction)btnDotClick:(id)sender {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    
    if (![self.resultLabel.text hasSuffix:numberFormatter.decimalSeparator])
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,numberFormatter.decimalSeparator];
}

- (IBAction)btnClearClick:(id)sender {
    self.resultLabel.text = @"0";
    operand = 0;
    newNumber = YES;
    [array removeAllObjects];
    
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    lastClick = nil;
}

- (IBAction)btnResultClick:(id)sender {
    
    double total = 0;
    
    //Adicionar o último número
    [array addObject:[self getResultDisplay]];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    
    switch (operand) {
        case 1:
            self.resultLabel.text = [NSString stringWithFormat:@"%@",[array valueForKeyPath: @"@sum.self"]];
            break;
        case 2:
            total = [(NSNumber *)[array objectAtIndex:0] doubleValue] - [(NSNumber *)[array objectAtIndex:1] doubleValue];
            self.resultLabel.text = [numberFormatter stringForObjectValue:[NSNumber numberWithDouble:total]];
            
            break;
        case 3:
            total = [(NSNumber *)[array objectAtIndex:0] doubleValue] * [(NSNumber *)[array objectAtIndex:1] doubleValue];
            self.resultLabel.text = [numberFormatter stringForObjectValue:[NSNumber numberWithDouble:total]];
            
            break;
        case 4:
            total = [(NSNumber *)[array objectAtIndex:0] doubleValue] / [(NSNumber *)[array objectAtIndex:1] doubleValue];
            self.resultLabel.text = [numberFormatter stringForObjectValue:[NSNumber numberWithDouble:total]];

            break;
        default:
            break;
    }
    
    //btnClear
    newNumber = YES;
    [array removeAllObjects];
    
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    lastClick = nil;
}

- (IBAction)btnSumClick:(id)sender {
    //Remover redundância
    operand = 1;
    newNumber = YES;
    
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    [(UIButton *)sender setBackgroundColor:selectedColor];
    lastClick = (UIButton *)sender;
    
    [array addObject:[self getResultDisplay]];
}
- (IBAction)btnSubtractClick:(id)sender {
    operand = 2;
    newNumber = YES;
    
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    [(UIButton *)sender setBackgroundColor:selectedColor];
    lastClick = (UIButton *)sender;
    
    [array addObject:[self getResultDisplay]];
}
- (IBAction)btnMultiplyClick:(id)sender {
    operand = 3;
    newNumber = YES;
    
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    [(UIButton *)sender setBackgroundColor:selectedColor];
    lastClick = (UIButton *)sender;
    
    [array addObject:[self getResultDisplay]];
}
- (IBAction)btnDivideClick:(id)sender {
    operand = 4;
    newNumber = YES;
    
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    [(UIButton *)sender setBackgroundColor:selectedColor];
    lastClick = (UIButton *)sender;

    [array addObject:[self getResultDisplay]];
}

- (IBAction)togglePositiveNegative:(id)sender {
    if ([self getResultDisplay].doubleValue != 0)
        self.resultLabel.text = [NSNumber numberWithDouble:[self getResultDisplay].doubleValue * (-1)].stringValue;
}

- (IBAction)btnPercentClick:(id)sender {
    
}

@end
