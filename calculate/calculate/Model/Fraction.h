//
//  Fraction.h
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Operator.h"

@interface Fraction : Common
{
    // Public variables
}

// Public properties and methods
- (id)init;
- (id)initWithValue: (double)value;
- (id)initWithNumber: (NSNumber*)numerator;
- (id)initWithFraction: (Fraction*)fraction;

+ (Fraction*)fractionWithValue: (double)value;

- (Fraction*)getCopy;

- (void)addWith: (Fraction*)value;
- (void)subtractWith: (Fraction*)value;
- (void)multiplyWith: (Fraction*)value;
- (void)divideWith: (Fraction*)value;
- (void)perform: (Operator*)operand With: (Fraction*)value;

- (void)reset;
- (void)reduce;
- (BOOL)numeratorIsZero;
- (BOOL)denominatorIsZero;

- (double)getAsDouble;
- (NSString*)getAsString;

@property (nonatomic) double numerator;
@property (nonatomic) double denominator;

@end
