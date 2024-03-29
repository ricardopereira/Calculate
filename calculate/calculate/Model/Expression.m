//
//  Expression.m
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "Expression.h"

@interface Expression()
// Private properties and methods
@end

@implementation Expression {
    // Private variables
    NSMutableArray *calculus;
}

- (instancetype)init {
    if (self = [super init]) {
        calculus = [[NSMutableArray alloc] init];
        return self;
    }
    else
        return nil;
}

- (void)addFraction: (Fraction*)fraction {
    if (!fraction) return;
    [calculus addObject:fraction];
}

- (void)addLastOperator {
    if ([self isEmpty]) return;
    // Add a copy of the last operator
    NSUInteger i = calculus.count-1;
    for (; i>=0; i--) {
        if ([[calculus objectAtIndex:i] isKindOfClass:[Operator class]] ) {
            [calculus addObject:(Operator*)[calculus objectAtIndex:i]];
            break;
        }
    }
}

- (void)addLastFraction {
    if ([self isEmpty]) return;
    // Add a copy of the last number
    NSUInteger i = calculus.count-1;
    for (; i>=0; i--) {
        if ([[calculus objectAtIndex:i] isKindOfClass:[Fraction class]] ) {
            [calculus addObject:(Fraction*)[calculus objectAtIndex:i]];
            break;
        }
    }
}

- (void)validate {
    if ([self isEmpty]) return;
    // Check if has a operator on last cell of calculus
    if ([self isLastOperator]) {
        [calculus removeLastObject];
    }
}

- (void)addOperator: (Operator*)operand {
    if (!operand) return;
    if ([self isEmpty]) return;
    
    // Check the last object: Operator
    if ([[calculus lastObject] isKindOfClass:[Operator class]]) {
        ((Operator*)[calculus lastObject]).type = operand.type;
    }
    else
        [calculus addObject:operand];
}

- (void)addOperatorWithType: (char)value {
    [self addOperator:[Operator operatorWithType:value]];
}

- (void)clear {
    [calculus removeAllObjects];
}

- (BOOL)isEmpty {
    return calculus.count == 0;
}

- (BOOL)isLastOperator {
    if ([[calculus lastObject] isKindOfClass:[Operator class]]) {
        return YES;
    }
    else
        return NO;
}

- (BOOL)isLastNumber {
    if ([[calculus lastObject] isKindOfClass:[Fraction class]]) {
        return YES;
    }
    else
        return NO;
}

- (double)calculate {
    Fraction* f = [Fraction fractionWithValue:0];
    Operator* op = nil;

    [self validate];
    
    // Calculate the complete expression
    for (id item in calculus) {
        if (op != nil) {
            // Check Division by Zero
            if ([op isDivision] && [(Fraction*)item numeratorIsZero]) {
                // Cancel
                [f reset];
                // Perform event
                if (self.eventDivisionByZero) self.eventDivisionByZero();
                break;
            }
            else
                [f perform:op With:(Fraction*)item];
            // Force getting the next operand
            op = nil;
        }
        else if ([item isKindOfClass:[Fraction class]]) {
            // First fraction / First element
            [f addWith:(Fraction*)item];
        }
        else if ([item isKindOfClass:[Operator class]]) {
            // Operator to use on next
            op = (Operator*)item;
        }
    }
    return [f getAsDouble];
}

# pragma mark Events

@end
