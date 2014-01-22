//
//  CalculatorViewController.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

// Private properties and methods
- (void)reset;
- (void)setEvents;
- (void)loadLayout;

- (void)selectOperation:(NSString*)op;

@end

@implementation CalculatorViewController
{
    Expression* expr;
    int countDecimals;
    BOOL startCountingDecimals;
    BOOL newNumber;
    
    // Private variables
    UIColor *selectedColor, *defaultColor;
    UIButton *lastClick;
}

@synthesize calculator;


#pragma mark - Implementation


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Init
    [self reset];
    // Events
    [self setEvents];
    // Layout
    [self loadLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reset
{
    lastClick = nil;
    // Init calculator
    [calculator clearHistory];
    // Decimal Separator
    [self.dotButton setTitle:calculator.format.decimalSeparator forState:UIControlStateNormal];
    
    defaultColor = self.addButton.backgroundColor;
    selectedColor = [UIColor colorWithRed:214/255.0f green:53/255.0f blue:71/255.0f alpha:1.0f];
    
    // Prepare for expressions
    [self clearResult];
}

- (void)setEvents
{
    // Clearing history
    calculator.eventBeforeClear = ^(NSObject* sender)
    {
        NSLog(@"%@",[(Calculator*)sender getAsString]);
    };
}

- (void)setSelectButtonColor:(UIButton *)button
{
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    [button setBackgroundColor:selectedColor];
    lastClick = button;
}

- (void)setDefaultButtonColor
{
    if (lastClick)
        [lastClick setBackgroundColor:defaultColor];
    lastClick = nil;
}

- (void)clearResult
{
    [self clearResult: YES];
}

- (void)clearResult: (BOOL)new
{
    expr = [calculator newExpression];
    countDecimals = 0;
    startCountingDecimals = NO;
    newNumber = YES;
    [self setDefaultButtonColor];
    if (new)
        self.resultLabel.text = @"0";
}

- (void)addToResult:(NSString*)value
{
    [self addToResult:value WithForce:NO];
    [self setDefaultButtonColor];
}

- (BOOL)canAdd
{
    BOOL result;
    result = ![self isResultEmpty];
    result = result && !newNumber;
    return result;
}

- (void)addToResult:(NSString*)value WithForce:(BOOL)forceAdd
{
    if (startCountingDecimals && countDecimals == 12)
        return;
    
    if (forceAdd || [self canAdd])
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
    else
        self.resultLabel.text = value;
    
    newNumber = NO;
    if (startCountingDecimals)
        countDecimals++;
}

- (double)getResult
{
    double r = [[NSDecimalNumber decimalNumberWithString:self.resultLabel.text locale:calculator.format.locale] doubleValue];
    // Debug
    return r;
}

- (BOOL)isResultEmpty
{
    return [self.resultLabel.text isEqualToString:@"0"];
}

- (IBAction)dotButtonClick:(id)sender
{
    if ([self.resultLabel.text rangeOfString:calculator.format.decimalSeparator].location == NSNotFound)
    {
        [self addToResult:calculator.format.decimalSeparator WithForce:YES];
        startCountingDecimals = YES;
    }
}

- (IBAction)zeroButtonClick:(id)sender
{
    [self addToResult:@"0"];
}

- (IBAction)oneButtonClick:(id)sender
{
    [self addToResult:@"1"];
}

- (IBAction)twoButtonClick:(id)sender
{
    [self addToResult:@"2"];
}

- (IBAction)threeButtonClick:(id)sender
{
    [self addToResult:@"3"];
}

- (IBAction)fourButtonClick:(id)sender
{
    [self addToResult:@"4"];
}

- (IBAction)fiveButtonClick:(id)sender
{
    [self addToResult:@"5"];
}

- (IBAction)sixButtonClick:(id)sender
{
    [self addToResult:@"6"];
}

- (IBAction)sevenButtonClick:(id)sender
{
    [self addToResult:@"7"];
}

- (IBAction)eightButtonClick:(id)sender
{
    [self addToResult:@"8"];
}

- (IBAction)nineButtonClick:(id)sender
{
    [self addToResult:@"9"];
}

- (IBAction)clearButtonClick:(id)sender
{
    [self clearResult];
}

- (IBAction)togglePosNegButtonClick:(id)sender
{
    if ([self isResultEmpty])
        return;
    // Oposite number
    double r = [self getResult] * -1;
    // Put on screen
    self.resultLabel.text = [calculator.format stringFromNumber:[NSDecimalNumber numberWithDouble:r]];
}

- (IBAction)percentButtonClick:(id)sender
{
    
}

- (IBAction)divisionButtonClick:(id)sender
{
    if ([self isResultEmpty] || (lastClick == sender))
        return;
    
    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"/"];
}

- (IBAction)multiplyButtonClick:(id)sender
{
    if ([self isResultEmpty] || (lastClick == sender))
        return;

    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"*"];
}

- (IBAction)subtractButtonClick:(id)sender
{
    if ([self isResultEmpty] || (lastClick == sender))
        return;

    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"-"];
}

- (IBAction)addButtonClick:(id)sender
{
    if ([self isResultEmpty] || (lastClick == sender))
        return;

    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"+"];
}

- (void)selectOperation:(NSString*)op
{
    [expr addFraction:[Fraction fractionWithValue:[self getResult]]];
    [expr addOperator:[Operator operatorWithType:op]];
    
    newNumber = YES;
    startCountingDecimals = NO;
}

- (IBAction)totalButtonClick:(id)sender
{
    if ([expr isEmpty])
        return;
    
    // Add the last number
    [expr addFraction:[Fraction fractionWithValue:[self getResult]]];
    
    // Do some math!
    double r = [expr calculate];
    // Put on screen
    self.resultLabel.text = [calculator.format stringFromNumber:[NSDecimalNumber numberWithDouble:r]];
    
    // Add to history
    [calculator add:expr];

    // Clear
    [self clearResult: NO];
}

- (void)loadLayout
{
    [self.resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.clearButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.togglePosNegButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.percentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.divisionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonSeven setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonEight setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonNine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.multiplyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonFour setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonFive setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonSix setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subtractButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonOne setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonTwo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonThree setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonZero setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dotButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.totalButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultLabel, _clearButton, _togglePosNegButton, _percentButton, _divisionButton, _buttonSeven, _buttonEight, _buttonNine, _multiplyButton, _buttonFour, _buttonFive, _buttonSix, _subtractButton, _buttonOne, _buttonTwo, _buttonThree, _addButton, _buttonZero, _dotButton, _totalButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_resultLabel]-20-|" options:0 metrics:0 views:viewsDictionary]];
    
    //Horizontal
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_clearButton][_togglePosNegButton(==_clearButton)][_percentButton(==_togglePosNegButton)][_divisionButton(==_percentButton)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_multiplyButton(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_subtractButton(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_addButton(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonZero][_dotButton(==_buttonTwo)][_totalButton(==_dotButton)]|" options:0 metrics:0 views:viewsDictionary]];
    
    //Vertical
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultLabel][_clearButton(==_resultLabel)][_buttonSeven(==_clearButton)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultLabel][_togglePosNegButton(==_clearButton)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultLabel][_percentButton(==_clearButton)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_dotButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultLabel][_divisionButton(==_clearButton)][_multiplyButton(==_buttonSeven)][_subtractButton(==_buttonFour)][_addButton(==_buttonOne)][_totalButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
}

@end
