//
//  CalcViewController.h
//  Calculadora
//
//  Created by Ricardo Pereira on 10/7/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"

@interface CalcViewController : UIViewController

@property (strong, nonatomic) Calculator *calc;

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *btnDivide;
@property (strong, nonatomic) IBOutlet UIButton *btnMultiply;
@property (strong, nonatomic) IBOutlet UIButton *btnSubtract;
@property (strong, nonatomic) IBOutlet UIButton *btnSum;

@end
