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

@property (strong, nonatomic) Calculator *calculator;

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *togglePosNegButton;
@property (strong, nonatomic) IBOutlet UIButton *percentButton;
@property (strong, nonatomic) IBOutlet UIButton *divisionButton;
@property (strong, nonatomic) IBOutlet UIButton *multiplyButton;
@property (strong, nonatomic) IBOutlet UIButton *subtractButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *totalButton;

@end
