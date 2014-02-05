//
//  CalculatorViewController.h
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"

@interface CalculatorViewController : UIViewController
{
    // Public variables
}

// Public methods
- (void)configure;
- (void)reset;

- (BOOL)hasNumber;
- (BOOL)isZero;
- (double)getResult;

// Touch buttons
- (void)touchClear;
- (void)touchBackspace;
- (void)touchDivision;
- (void)touchMultiply;
- (void)touchSubtract;
- (void)touchAdd;
- (void)touchTotal;
- (void)touchDot;
- (void)touchTogglePosNeg;

- (void)touchOne;
- (void)touchTwo;
- (void)touchThree;
- (void)touchFour;
- (void)touchFive;
- (void)touchSix;
- (void)touchSeven;
- (void)touchEight;
- (void)touchNine;
- (void)touchZero;

// Public properties
@property (strong, nonatomic) Calculator *calculator;

// Layout
@property (strong, nonatomic) IBOutlet UIView *viewBill;

@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *togglePosNegButton;
@property (strong, nonatomic) IBOutlet UIButton *percentButton;
@property (strong, nonatomic) IBOutlet UIButton *divisionButton;
@property (strong, nonatomic) IBOutlet UIButton *multiplyButton;
@property (strong, nonatomic) IBOutlet UIButton *subtractButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *totalButton;
@property (strong, nonatomic) IBOutlet UIButton *dotButton;

@property (strong, nonatomic) IBOutlet UIButton *buttonNine;
@property (strong, nonatomic) IBOutlet UIButton *buttonEight;
@property (strong, nonatomic) IBOutlet UIButton *buttonSeven;
@property (strong, nonatomic) IBOutlet UIButton *buttonSix;
@property (strong, nonatomic) IBOutlet UIButton *buttonFive;
@property (strong, nonatomic) IBOutlet UIButton *buttonFour;
@property (strong, nonatomic) IBOutlet UIButton *buttonThree;
@property (strong, nonatomic) IBOutlet UIButton *buttonTwo;
@property (strong, nonatomic) IBOutlet UIButton *buttonOne;
@property (strong, nonatomic) IBOutlet UIButton *buttonZero;

@end