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
@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *buttonClear;
@property (strong, nonatomic) IBOutlet UIButton *buttonBackspace;
@property (strong, nonatomic) IBOutlet UIButton *buttonTotal;

@property (strong, nonatomic) IBOutlet UIButton *buttonPosNeg;
@property (strong, nonatomic) IBOutlet UIButton *buttonDot;

@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;
@property (strong, nonatomic) IBOutlet UIButton *buttonSubtract;
@property (strong, nonatomic) IBOutlet UIButton *buttonMultiply;
@property (strong, nonatomic) IBOutlet UIButton *buttonDivision;

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

@property (strong, nonatomic) IBOutlet UIView *viewBill;

@end