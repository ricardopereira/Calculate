//
//  Fraction.m
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "Fraction.h"

@interface Fraction ()
// Private properties and methods
@end

@implementation Fraction
{
    // Private variables
}

- (id)init {
    return [self initWithNumber:0];
}

- (id)initWithValue: (double)value {
    // Designated
    if ((self = [super init])) {
        self.numerator = value;
        self.denominator = 1;
    }
    return self;
}

- (id)initWithNumber: (NSNumber*)numerator {
    return [self initWithValue:numerator.doubleValue];
}

- (id)initWithFraction: (Fraction*)fraction {
    Fraction* aux = [self initWithValue:fraction.numerator];
    if ([fraction numeratorIsZero] && [fraction denominatorIsZero])
        aux.denominator = 1;
    else
        aux.denominator = fraction.denominator;
    return aux;
}

+ (Fraction*)fractionWithValue: (double)value {
    return [[Fraction alloc] initWithValue:value];
}

- (Fraction*)getCopy {
    return [[Fraction alloc] initWithFraction:self];
}

- (NSString*)getAsString {
    return [NSString stringWithFormat:@"%f/%f",self.numerator,self.denominator];
}

- (double)getAsDouble {
    // Check Division by Zero
    if ([self denominatorIsZero])
        return 0;
    else
        return self.numerator / self.denominator;
}

- (void)addWith: (Fraction*)value {
    if (self.denominator == value.denominator) {
        // Add
        self.numerator += value.numerator;
    }
    else {
        // Put in the same denominator, add both and reduce
        self.numerator *= value.denominator;
        self.denominator *= value.denominator;
        value.numerator *= self.denominator;
        value.denominator *= self.denominator;
        // Add
        self.numerator += value.numerator;
        // Reduce
        [self reduce];
    }
}

- (void)subtractWith: (Fraction*)value {
    if (self.denominator == value.denominator) {
        // Subtract
        self.numerator -= value.numerator;
    }
    else {
        // Put in the same denominator, add both and reduce
        self.numerator *= value.denominator;
        self.denominator *= value.denominator;
        value.numerator *= self.denominator;
        value.denominator *= self.denominator;
        // Subtract
        self.numerator -= value.numerator;
        // Reduce
        [self reduce];
    }
}

- (void)multiplyWith: (Fraction*)value {
    self.numerator *= value.numerator;
    self.denominator *= value.denominator;
}

- (void)divideWith: (Fraction*)value {
    self.numerator *= value.denominator;
    self.denominator *= value.numerator;
}

- (void)perform: (Operator*)operand With: (Fraction*)value {
    /**/ if ([operand isAdd]) {
        [self addWith:value];
    }
    else if ([operand isSubtract]) {
        [self subtractWith:value];
    }
    else if ([operand isMultiply]) {
        [self multiplyWith:value];
    }
    else if ([operand isDivision]) {
        [self divideWith:value];
    }
}

- (int)getGreatestCommonDivisorWithNum:(int)n andDen:(int)d {
	int aux;
	n = abs(n);
	d = abs(d);
	while (n > 0) {
		aux = n;
		n = d % n;
		d = aux;
	}
	return d;
}

- (void)reduce {
	int gcd = [self getGreatestCommonDivisorWithNum:self.numerator andDen:self.denominator];
	self.numerator /= gcd;
	self.denominator /= gcd;
}

- (void)reset {
    _numerator = 0;
    _denominator = 1;
}

- (BOOL)numeratorIsZero {
    return _numerator == ZERO;
}

- (BOOL)denominatorIsZero {
    return _denominator == ZERO;
}

@end