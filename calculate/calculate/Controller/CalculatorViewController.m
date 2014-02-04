//
//  CalculatorViewController.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "CalculatorViewController.h"

#import <math.h>

#import "AppConfig.h"

@interface CalculatorViewController ()

// Private properties and methods
- (void)configure;
- (void)reset;
- (void)setEvents;
// Layout
- (void)initLayout;
- (void)loadVerticalLayout;
- (void)loadHorizontalLayout;
// Work
- (void)clearResult;
- (void)clearResult: (BOOL)new;
- (BOOL)isResultEmpty;
- (BOOL)hasNumber;
- (void)prepareNewNumber;
- (void)selectOperation:(NSString*)op;
// Events
- (void)onBeforeAddOperator: (id)sender;
- (void)onAfterAddOperator: (id)sender;

@end

@implementation CalculatorViewController
{
    Expression *expr, *lastExpr;
    int countDecimals;
    BOOL startCountingDecimals;
    BOOL newNumber;
    
    // Private variables
    UIColor *selectedColor, *defaultColor;
    UIButton *lastOperator;
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
    // Config
    [self configure];
    // Init
    [self reset];
    // Events
    [self setEvents];
    // Layout
    [self initLayout];
    // Orientation event
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didOrientationDeviceChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // Default notification style
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didOrientationDeviceChanged
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        [self loadHorizontalLayout];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.viewBill.alpha = 1.0f;
        }];
    }
    else if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown)
    {
        
    }
    else
    {
        [self loadVerticalLayout];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.viewBill.alpha = 0.0f;
        }];
    }
}

- (void)configure
{
    // Configuration
    if (Feature005_ViewBill)
    {
        // Hide
        self.viewBill.hidden = false;
    }
    else
    {
        // Hide
        self.viewBill.hidden = true;
    }
}

- (void)reset
{
    lastOperator = nil;
    lastExpr = nil;
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

- (void)setSelectButtonColor:(UIButton *)button {
    if (lastOperator)
        [lastOperator setBackgroundColor:defaultColor];
    [button setBackgroundColor:selectedColor];
    lastOperator = button;
}

- (void)setDefaultButtonColor {
    if (lastOperator)
        [lastOperator setBackgroundColor:defaultColor];
    lastOperator = nil;
}

- (void)clearResult {
    [self clearResult: YES];
}

- (void)clearResult: (BOOL)new {
    lastExpr = expr;
    expr = [calculator newExpression];
    [self prepareNewNumber];
    [self setDefaultButtonColor];
    if (new) {
        self.resultLabel.text = @"0";
        lastExpr = nil;
    }
}

- (void)prepareNewNumber {
    newNumber = YES;
    countDecimals = 0;
    startCountingDecimals = NO;
}

- (void)addToResult:(NSString*)value {
    [self addToResult:value WithForce:NO];
    [self setDefaultButtonColor];
}

- (BOOL)canAdd {
    BOOL result;
    result = ![self isResultEmpty];
    result = result && !newNumber;
    return result;
}

- (void)addToResult:(NSString*)value WithForce:(BOOL)forceAdd
{
    if (startCountingDecimals && countDecimals == DECIMALS)
        return;
    
    if (forceAdd || [self canAdd])
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
    else
        self.resultLabel.text = value;
    
    newNumber = NO;
    if (startCountingDecimals)
        countDecimals++;
}

- (double)getResult {
    double r = [[NSDecimalNumber decimalNumberWithString:self.resultLabel.text locale:calculator.format.locale] doubleValue];
    // Debug
    return r;
}

- (BOOL)hasNumber {
    if ([self getResult] == ZERO)
        return NO;
    else
        return YES;
    
}

- (BOOL)isResultEmpty {
    return [self.resultLabel.text isEqualToString:@"0"];
}

- (void)onBeforeAddOperator: (id)sender {
    lastExpr = nil;
}

- (void)onAfterAddOperator: (id)sender {
    
}

- (IBAction)dotButtonClick:(id)sender {
    if ([self.resultLabel.text rangeOfString:calculator.format.decimalSeparator].location == NSNotFound) {
        [self addToResult:calculator.format.decimalSeparator WithForce:YES];
        startCountingDecimals = YES;
    }
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

- (IBAction)clearButtonClick:(id)sender {
    [self clearResult];
}

- (IBAction)togglePosNegButtonClick:(id)sender {
    if ([self isResultEmpty])
        return;
    // Oposite number
    double r = [self getResult] * -1;
    // Put on screen
    self.resultLabel.text = [calculator.format stringFromNumber:[NSDecimalNumber numberWithDouble:r]];
}

- (IBAction)percentButtonClick:(id)sender {
    if ([self isResultEmpty])
        return;
    // Oposite number
    double r = [self getResult] / 100;
    // Put on screen
    self.resultLabel.text = [calculator.format stringFromNumber:[NSDecimalNumber numberWithDouble:r]];
}

- (IBAction)divisionButtonClick:(id)sender {
    [self onBeforeAddOperator: sender];
    
    if ([self isResultEmpty] || (lastOperator == sender))
        return;
    
    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"/"];
    
    [self onAfterAddOperator: sender];
}

- (IBAction)multiplyButtonClick:(id)sender {
    [self onBeforeAddOperator: sender];
    
    if ([self isResultEmpty] || (lastOperator == sender))
        return;

    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"*"];
    
    [self onAfterAddOperator: sender];
}

- (IBAction)subtractButtonClick:(id)sender {
    [self onBeforeAddOperator: sender];
    
    if ([self isResultEmpty] || (lastOperator == sender))
        return;

    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"-"];
    
    [self onAfterAddOperator: sender];
}

- (IBAction)addButtonClick:(id)sender {
    [self onBeforeAddOperator: sender];
    
    if ([self isResultEmpty] || (lastOperator == sender))
        return;

    [self setSelectButtonColor:(UIButton *)sender];
    [self selectOperation:@"+"];
    
    [self onAfterAddOperator: sender];
}

- (void)selectOperation:(NSString*)op {
    [expr addFraction:[Fraction fractionWithValue:[self getResult]]];
    [expr addOperator:[Operator operatorWithType:op]];

    [self prepareNewNumber];
}

- (IBAction)totalButtonClick:(id)sender {
    // Check input
    if ([expr isEmpty] && [self hasNumber] == NO)
        return;
    
    // Check if an operator is selected
    if (!lastOperator)
    {
        // If empty then add the last one
        if ([expr isEmpty] && lastExpr) {
            expr = lastExpr;
            [expr addLastFraction];
        }
        else
            // Add the last number
            [expr addFraction:[Fraction fractionWithValue:[self getResult]]];
    }
    
    // Do some math!
    double r = [expr calculate];
    // Put on screen
    self.resultLabel.text = [calculator.format stringFromNumber:[NSDecimalNumber numberWithDouble:r]];
    
    // Add to history
    [calculator add:expr];

    // Clear
    [self clearResult: NO];
}

#pragma mark - Layout

- (void)initLayout {
    // Visual Format Language (no Autolayout)
    
    [self.resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.resultView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewBill setTranslatesAutoresizingMaskIntoConstraints:NO];
    
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
    
    // Constraints
    // Dictionary with instances of components for Visual Format
    NSDictionary *dic = NSDictionaryOfVariableBindings(_resultLabel);
    [self.resultView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_resultLabel]-15-|" options:0 metrics:0 views:dic]];
    [self.resultView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_resultLabel]-20-|" options:0 metrics:0 views:dic]];
    
    if (Feature005_ViewBill) {
        // Instantiate the nib content without any reference to it
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CalculatorBill" owner:self.viewBill options:nil];
        // Find the view among nib contents (not too hard assuming there is only one view in it)
        UIView *plainView = [nibContents lastObject];
        // Size it
        plainView.frame = self.viewBill.bounds;
        // Add to the view hierarchy (thus retain)
        [self.viewBill addSubview:plainView];
    }
}

- (void)loadHorizontalLayout {
    // Remove current constraints
    [self.view removeConstraints:self.view.constraints];
    
    // Configuration
    if (Feature005_ViewBill)
    {
        // Font Size
        self.resultLabel.font = [self.resultLabel.font fontWithSize:60];
        
        // Constraints
        // Dictionary with instances of components for Visual Format
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultView, _clearButton, _togglePosNegButton, _percentButton, _divisionButton, _buttonSeven, _buttonEight, _buttonNine, _multiplyButton, _buttonFour, _buttonFive, _buttonSix, _subtractButton, _buttonOne, _buttonTwo, _buttonThree, _addButton, _buttonZero, _dotButton, _totalButton, _viewBill);
        
        // Common
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_resultView]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Horizontal
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_clearButton][_togglePosNegButton(==_clearButton)][_percentButton(==_togglePosNegButton)][_divisionButton(==_percentButton)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_multiplyButton(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_subtractButton(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_addButton(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonZero][_dotButton(==_buttonTwo)][_totalButton(==_dotButton)]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Vertical
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_clearButton(==_resultView)][_buttonSeven(==_clearButton)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_togglePosNegButton(==_clearButton)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_percentButton(==_clearButton)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_dotButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_divisionButton(==_clearButton)][_multiplyButton(==_buttonSeven)][_subtractButton(==_buttonFour)][_addButton(==_buttonOne)][_totalButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    }
    else
    {
        // Constraints
        // Dictionary with instances of components for Visual Format
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultView, _clearButton, _togglePosNegButton, _percentButton, _divisionButton, _buttonSeven, _buttonEight, _buttonNine, _multiplyButton, _buttonFour, _buttonFive, _buttonSix, _subtractButton, _buttonOne, _buttonTwo, _buttonThree, _addButton, _buttonZero, _dotButton, _totalButton);
        
        
        // Common
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Horizontal
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_clearButton][_togglePosNegButton(==_clearButton)][_percentButton(==_togglePosNegButton)][_divisionButton(==_percentButton)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_multiplyButton(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_subtractButton(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_addButton(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonZero][_dotButton(==_buttonTwo)][_totalButton(==_dotButton)]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Vertical
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_clearButton(==_resultView)][_buttonSeven(==_clearButton)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_togglePosNegButton(==_clearButton)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_percentButton(==_clearButton)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_dotButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_divisionButton(==_clearButton)][_multiplyButton(==_buttonSeven)][_subtractButton(==_buttonFour)][_addButton(==_buttonOne)][_totalButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    }
}

- (void)loadVerticalLayout {
    // Remove current constraints
    [self.view removeConstraints:self.view.constraints];
    
    if (Feature005_ViewBill)
    {
        // Font Size
        self.resultLabel.font = [self.resultLabel.font fontWithSize:100];
    }
    
    // Constraints
    // Dictionary with instances of components for Visual Format
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultView, _clearButton, _togglePosNegButton, _percentButton, _divisionButton, _buttonSeven, _buttonEight, _buttonNine, _multiplyButton, _buttonFour, _buttonFive, _buttonSix, _subtractButton, _buttonOne, _buttonTwo, _buttonThree, _addButton, _buttonZero, _dotButton, _totalButton);
    
    // Common
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|" options:0 metrics:0 views:viewsDictionary]];
    
    // Horizontal
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_clearButton][_togglePosNegButton(==_clearButton)][_percentButton(==_togglePosNegButton)][_divisionButton(==_percentButton)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_multiplyButton(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_subtractButton(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_addButton(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonZero][_dotButton(==_buttonTwo)][_totalButton(==_dotButton)]|" options:0 metrics:0 views:viewsDictionary]];
    
    // Vertical
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_clearButton(==_resultView)][_buttonSeven(==_clearButton)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_togglePosNegButton(==_clearButton)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_percentButton(==_clearButton)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_dotButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_divisionButton(==_clearButton)][_multiplyButton(==_buttonSeven)][_subtractButton(==_buttonFour)][_addButton(==_buttonOne)][_totalButton(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
}

@end