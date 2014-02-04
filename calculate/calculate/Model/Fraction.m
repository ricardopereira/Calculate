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
    return self.numerator / self.denominator;
}

- (void)addWith: (Fraction*)value {
    if (self.denominator == value.denominator) {
        self.numerator += value.numerator;
    }
    else {
        // Put in the same denominator, add both and reduce
        
        [self reduce];
    }
}

- (void)subtractWith: (Fraction*)value {
    if (self.denominator == value.denominator) {
        self.numerator -= value.numerator;
    }
    else {
        // Put in the same denominator, add both and reduce

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
    /**/ if ([operand.type isEqualToString:@"+"]) {
        [self addWith:value];
    }
    else if ([operand.type isEqualToString:@"-"]) {
        [self subtractWith:value];
    }
    else if ([operand.type isEqualToString:@"*"]) {
        [self multiplyWith:value];
    }
    else if ([operand.type isEqualToString:@"/"]) {
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

@end