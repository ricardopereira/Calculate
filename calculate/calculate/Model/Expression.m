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

@implementation Expression
{
    // Private variables
    NSMutableArray *calculus;
}

- (id)init
{
    if (self = [super init])
    {
        calculus = [[NSMutableArray alloc] init];
        return self;
    }
    else
        return nil;
}

- (void)addFraction: (Fraction*)fraction
{
    if (!fraction) return;
    [calculus addObject:fraction];
}

- (void)addOperator: (Operator*)operand
{
    if (!operand) return;
    if (calculus.count == 0) return;
    
    // Check the last object: Operator
    if ([[calculus lastObject] isKindOfClass:[Operator class]])
    {
        // ?
        ((Operator*)[calculus lastObject]).type = operand.type;
    }
    else
        [calculus addObject:operand];
}

- (void)addOperatorWithType: (NSString*)value
{
    [self addOperator:[Operator operatorWithType:value]];
}

- (void)clear
{
    [calculus removeAllObjects];
}

- (BOOL)isEmpty
{
    if (calculus.count == 0)
        return YES;
    else
        return NO;
}

- (double)calculate
{
    Fraction* f = [Fraction fractionWithValue:0];
    
    // Calculate the all expression
    for (id item in calculus)
    {
        if ([item isKindOfClass:[Fraction class]])
        {
            [f addWith:(Fraction*)item];

        }
    }
    return [f getAsDouble];
}

- (void)createExpressionTest
{
    
}

@end