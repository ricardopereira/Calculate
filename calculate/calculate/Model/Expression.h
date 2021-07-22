//
//  Expression.h
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

#import "Fraction.h"
#import "Operator.h"

@interface Expression : Common
{
    // Public variables
}

// Public properties and methods
- (instancetype)init;

- (void)addFraction: (Fraction*)fraction;
- (void)addOperator: (Operator*)operand;
- (void)addOperatorWithType: (char)value;
- (void)addLastFraction;
- (void)addLastOperator;

- (void)validate;
- (void)clear;
- (BOOL)isEmpty;
- (BOOL)isLastOperator;
- (BOOL)isLastNumber;

- (double)calculate;

// Events
@property (nonatomic, copy) void (^eventDivisionByZero)(void);

@end
