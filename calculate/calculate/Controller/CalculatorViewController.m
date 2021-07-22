//
//  CalculatorViewController.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "CalculatorViewController.h"

#import "AppConfig.h"
#import "Common.h"

@interface CalculatorViewController ()

// Private properties and methods
- (void)setEvents;
// Layout
- (void)initLayout;
- (void)loadVerticalLayout;
- (void)loadHorizontalLayout;
// Actions
- (IBAction)resultLongPressed:(id)sender;
// Calculator
- (void)clearResult;
- (void)clearResult:(BOOL)new;
- (BOOL)isResultEmpty;
- (void)addToResult:(NSString*)value;
- (void)addToResult:(NSString*)value WithForce:(BOOL)forceAdd;
- (void)removeLast;
- (void)checkDecimals;
- (void)prepareNewNumber;
- (void)selectOperation:(char)op;
// Events
- (BOOL)onBeforeAddOperator:(id)sender;
- (BOOL)onAfterAddOperator:(id)sender;

@end

@implementation CalculatorViewController
{
    Expression *expr, *lastExpr;
    unsigned int countDecimals;
    BOOL startCountingDecimals;
    BOOL newNumber;
    
    // Private variables
    UIColor *selectedColor, *defaultColor;
    UIButton *lastOperator;
    UIDeviceOrientation lastOrientation;
}

@synthesize calculator;


#pragma mark - Implementation


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
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
    if (lastOrientation == orientation) return;
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        [self loadHorizontalLayout];
        
        if (Feature005_ViewBill == 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.viewBill.alpha = 1.0f;
            }];
        }
        
        lastOrientation = orientation;
    }
    else if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [self loadVerticalLayout];
        
        if (Feature005_ViewBill == 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.viewBill.alpha = 0.0f;
            }];
        }
        
        lastOrientation = orientation;
    }
}

- (void)configure
{
    // Result: Long press options
    if (Feature007_ResultLongPressOptions == 1)
	{
        self.resultLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *resultLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(resultLongPressed:)];
        resultLongPress.minimumPressDuration = 0.2; //Seconds
        resultLongPress.numberOfTapsRequired = 0;
        [self.resultLabel addGestureRecognizer:resultLongPress];
    }
    
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
    [self.buttonDot setTitle:calculator.format.decimalSeparator forState:UIControlStateNormal];
    
    defaultColor = self.buttonAdd.backgroundColor;
    selectedColor = [UIColor colorWithRed:214/255.0f green:53/255.0f blue:71/255.0f alpha:1.0f];
    
    // Prepare for expressions
    [self clearResult];
}

- (IBAction)resultLongPressed:(UILongPressGestureRecognizer *)sender
{
    if ([self isZero]) {
        return;
    }
    NSArray *itemsToShare = @[NSLocalizedString(@"Total:",nil), self.resultLabel.text];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    activityViewController.popoverPresentationController.sourceRect = sender.view.bounds;
    activityViewController.popoverPresentationController.sourceView = sender.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)setEvents {
    // Clearing history
    calculator.eventBeforeClear = ^(NSObject* sender)
    {
        if (Feature001_Log == 1)
        {
            NSLog(@"Cleared: %@",[(Calculator*)sender getAsString]);
        }
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

    // Self retain in block
    //__weak typeof(self) weakSelf = self;

    // Message for each expression - Division by Zero
    if (Feature006_ToastMessages == 1) {
        expr.eventDivisionByZero = ^{
            if (Feature001_Log == 1)
            {
                NSLog(NSLocalizedString(@"Division by zero",nil));
            }
        };
    }
    
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

- (void)addToResult:(NSString*)value WithForce:(BOOL)forceAdd {
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
    double r = [self getResult];
    if (r == ZERO)
        return NO;
    else
        return YES;
}

- (BOOL)isZero {
    return ![self hasNumber];
}

- (void)removeLast {
    NSString* aux = self.resultLabel.text;
    if ([aux length] == 1)
    {
        aux = @"0";
        countDecimals = 0;
    }
    else if ([aux length] > 0)
    {
        aux = [aux substringToIndex:[aux length] - 1];
        // Decrement decimals added
        if (startCountingDecimals)
            countDecimals--;
    }
    self.resultLabel.text = aux;
}

- (void)checkDecimals {
    if ([self hasNumber] == NO) {
        startCountingDecimals = NO;
        countDecimals = 0;
    }
    else if (startCountingDecimals) {
        NSUInteger aux = [self.resultLabel.text rangeOfString:calculator.format.decimalSeparator].location;
        if (aux != NSNotFound) {
            countDecimals = (unsigned int)(self.resultLabel.text.length - 1 - aux);
        }
    }
}

- (BOOL)isResultEmpty {
    return [self.resultLabel.text isEqualToString:@"0"];
}

- (void)selectOperation:(char)op {
    if (lastOperator) {
        [expr addOperator:[Operator operatorWithType:op]];
    }
    else {
        [expr addFraction:[Fraction fractionWithValue:[self getResult]]];
        [expr addOperator:[Operator operatorWithType:op]];
        [self prepareNewNumber];
    }
}

#pragma mark - Events

- (BOOL)onBeforeAddOperator: (id)sender {
    lastExpr = nil;
    // Not valid
    return (lastOperator == sender);
}

- (BOOL)onAfterAddOperator: (id)sender {
    return YES;
}

#pragma mark - Touch buttons

- (void)touchClear
{
    [self buttonClearTouch:self.buttonClear];
}

- (void)touchBackspace
{
    [self buttonBackspaceTouch:self.buttonBackspace];
}

- (void)touchDivision
{
    [self buttonOperatorTouch:self.buttonDivision];
}

- (void)touchMultiply
{
    [self buttonOperatorTouch:self.buttonMultiply];
}

- (void)touchSubtract
{
    [self buttonOperatorTouch:self.buttonSubtract];
}

- (void)touchAdd
{
    [self buttonOperatorTouch:self.buttonAdd];
}

- (void)touchTotal
{
    [self buttonTotalTouch:self.buttonTotal];
}

- (void)touchDot
{
    [self buttonDotTouch:self.buttonDot];
}

- (void)touchTogglePosNeg
{
    [self buttonPosNegTouch:self.buttonPosNeg];
}

- (void)touchOne
{
    [self buttonNumberTouch:self.buttonOne];
}

- (void)touchTwo
{
    [self buttonNumberTouch:self.buttonTwo];
}

- (void)touchThree
{
    [self buttonNumberTouch:self.buttonThree];
}

- (void)touchFour
{
    [self buttonNumberTouch:self.buttonFour];
}

- (void)touchFive
{
    [self buttonNumberTouch:self.buttonFive];
}

- (void)touchSix
{
    [self buttonNumberTouch:self.buttonSix];
}

- (void)touchSeven
{
    [self buttonNumberTouch:self.buttonSeven];
}

- (void)touchEight
{
    [self buttonNumberTouch:self.buttonEight];
}

- (void)touchNine
{
    [self buttonNumberTouch:self.buttonNine];
}

- (void)touchZero
{
    [self buttonNumberTouch:self.buttonZero];
}

#pragma mark - View Events

- (IBAction)buttonNumberTouch:(id)sender
{
    [self addToResult:[NSString stringWithFormat:@"%d",(int)((UIButton*)sender).tag]];
}

- (IBAction)buttonClearTouch:(id)sender
{
    [self clearResult];
}

- (IBAction)buttonPosNegTouch:(id)sender
{
    if ([self hasNumber] == NO)
        return;
    // Oposite number
    double r = [self getResult] * -1;
    // Put on screen
    self.resultLabel.text = [calculator.format stringFromNumber:[NSDecimalNumber numberWithDouble:r]];
    // Correct the decimals
    [self checkDecimals];
}

- (IBAction)buttonDotTouch:(id)sender
{
    if ([self.resultLabel.text rangeOfString:calculator.format.decimalSeparator].location == NSNotFound) {
        [self addToResult:calculator.format.decimalSeparator WithForce:YES];
        startCountingDecimals = YES;
    }
}

- (IBAction)buttonBackspaceTouch:(id)sender
{
    if ([self hasNumber] == NO)
        return;
    
    [self removeLast];
}

- (IBAction)buttonOperatorTouch:(id)sender
{
    if ([self onBeforeAddOperator:sender])
        return;
    
    // Type of operator
    switch ([(UIButton*)sender tag]) {
    case 1:
        [self selectOperation:'+'];
        break;
    case 2:
        [self selectOperation:'-'];
        break;
    case 3:
        [self selectOperation:'*'];
        break;
    case 4:
        [self selectOperation:'/'];
        break;
    }
    
    [self setSelectButtonColor:(UIButton *)sender];
    
    [self onAfterAddOperator: sender];
}

- (IBAction)buttonTotalTouch:(id)sender
{
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

- (void)initLayout
{
    // Visual Format Language (no Autolayout)
    
    [self.resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.resultView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewBill setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonClear setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonPosNeg setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonBackspace setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonDivision setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonSeven setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonEight setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonNine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonMultiply setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonFour setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonFive setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonSix setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonSubtract setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonOne setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonTwo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonThree setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonAdd setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.buttonZero setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonDot setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonTotal setTranslatesAutoresizingMaskIntoConstraints:NO];
    
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

- (void)loadHorizontalLayout
{
    // Remove current constraints
    [self.view removeConstraints:self.view.constraints];
    
    // Configuration
    if (Feature005_ViewBill)
    {
        // Font Size
        self.resultLabel.font = [self.resultLabel.font fontWithSize:60];
        
        // Constraints
        // Dictionary with instances of components for Visual Format
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultView, _buttonClear, _buttonPosNeg, _buttonBackspace, _buttonDivision, _buttonSeven, _buttonEight, _buttonNine, _buttonMultiply, _buttonFour, _buttonFive, _buttonSix, _buttonSubtract, _buttonOne, _buttonTwo, _buttonThree, _buttonAdd, _buttonZero, _buttonDot, _buttonTotal, _viewBill);
        
        // Common
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_resultView]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Horizontal
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonClear][_buttonPosNeg(==_buttonClear)][_buttonBackspace(==_buttonPosNeg)][_buttonDivision(==_buttonBackspace)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_buttonMultiply(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_buttonSubtract(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_buttonAdd(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBill][_buttonZero][_buttonDot(==_buttonTwo)][_buttonTotal(==_buttonDot)]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Vertical
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonClear(==_resultView)][_buttonSeven(==_buttonClear)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonPosNeg(==_buttonClear)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonBackspace(==_buttonClear)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_buttonDot(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonDivision(==_buttonClear)][_buttonMultiply(==_buttonSeven)][_buttonSubtract(==_buttonFour)][_buttonAdd(==_buttonOne)][_buttonTotal(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    }
    else
    {
        // Constraints
        // Dictionary with instances of components for Visual Format
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultView, _buttonClear, _buttonPosNeg, _buttonBackspace, _buttonDivision, _buttonSeven, _buttonEight, _buttonNine, _buttonMultiply, _buttonFour, _buttonFive, _buttonSix, _buttonSubtract, _buttonOne, _buttonTwo, _buttonThree, _buttonAdd, _buttonZero, _buttonDot, _buttonTotal);
        
        
        // Common
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Horizontal
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonClear][_buttonPosNeg(==_buttonClear)][_buttonBackspace(==_buttonPosNeg)][_buttonDivision(==_buttonBackspace)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_buttonMultiply(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_buttonSubtract(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_buttonAdd(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonZero][_buttonDot(==_buttonTwo)][_buttonTotal(==_buttonDot)]|" options:0 metrics:0 views:viewsDictionary]];
        
        // Vertical
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonClear(==_resultView)][_buttonSeven(==_buttonClear)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonPosNeg(==_buttonClear)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonBackspace(==_buttonClear)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_buttonDot(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonDivision(==_buttonClear)][_buttonMultiply(==_buttonSeven)][_buttonSubtract(==_buttonFour)][_buttonAdd(==_buttonOne)][_buttonTotal(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    }
}

- (void)loadVerticalLayout
{
    // Remove current constraints
    [self.view removeConstraints:self.view.constraints];
    
    if (Feature005_ViewBill)
    {
        // Font Size
        self.resultLabel.font = [self.resultLabel.font fontWithSize:100];
    }
    
    // Constraints
    // Dictionary with instances of components for Visual Format
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_resultView, _buttonClear, _buttonPosNeg, _buttonBackspace, _buttonDivision, _buttonSeven, _buttonEight, _buttonNine, _buttonMultiply, _buttonFour, _buttonFive, _buttonSix, _buttonSubtract, _buttonOne, _buttonTwo, _buttonThree, _buttonAdd, _buttonZero, _buttonDot, _buttonTotal);
    
    // Common
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|" options:0 metrics:0 views:viewsDictionary]];
    
    // Horizontal
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonClear][_buttonPosNeg(==_buttonClear)][_buttonBackspace(==_buttonPosNeg)][_buttonDivision(==_buttonBackspace)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonSeven][_buttonEight(==_buttonSeven)][_buttonNine(==_buttonEight)][_buttonMultiply(==_buttonNine)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonFour][_buttonFive(==_buttonFour)][_buttonSix(==_buttonFive)][_buttonSubtract(==_buttonSix)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonOne][_buttonTwo(==_buttonOne)][_buttonThree(==_buttonTwo)][_buttonAdd(==_buttonThree)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonZero][_buttonDot(==_buttonTwo)][_buttonTotal(==_buttonDot)]|" options:0 metrics:0 views:viewsDictionary]];
    
    // Vertical
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonClear(==_resultView)][_buttonSeven(==_buttonClear)][_buttonFour(==_buttonSeven)][_buttonOne(==_buttonFour)][_buttonZero(==_buttonOne)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonPosNeg(==_buttonClear)][_buttonEight(==_buttonSeven)][_buttonFive(==_buttonFour)][_buttonTwo(==_buttonOne)][_buttonZero(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonBackspace(==_buttonClear)][_buttonNine(==_buttonSeven)][_buttonSix(==_buttonFour)][_buttonThree(==_buttonOne)][_buttonDot(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultView][_buttonDivision(==_buttonClear)][_buttonMultiply(==_buttonSeven)][_buttonSubtract(==_buttonFour)][_buttonAdd(==_buttonOne)][_buttonTotal(==_buttonZero)]|" options:0 metrics:0 views:viewsDictionary]];
}

@end