//
//  Calculator.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "Calculator.h"

@interface Calculator ()
// Private properties and methods
@end

@implementation Calculator
{
    // Private variables
    NSMutableArray *history;
}

@synthesize format;

- (instancetype)init
{
    if (self = [super init])
    {
        // Create formatter
        format = [[NSNumberFormatter alloc] init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setGroupingSeparator:@""];
        [format setAlwaysShowsDecimalSeparator:NO];
        [format setMaximumFractionDigits:DECIMALS];
        [format setLocale:[NSLocale currentLocale]];
        
        // Expression
        history = [[NSMutableArray alloc] init];
        return self;
    }
    else
        return nil;
}

- (void)add: (Expression*)expr
{
    [history addObject:expr];
}

- (Expression*)newExpression
{
    return [[Expression alloc] init];
}

- (NSString*)getAsString
{
    // Inherited
    //[super getHasString];
    
    NSString* result = @"Expression: ";
    
    for (id item in history)
    {
        if ([item isKindOfClass:[Fraction class]])
            result = [result stringByAppendingFormat:@"%@",[(Fraction*)item getAsString]];
    }
    return result;
}

- (void)clearHistory
{
    if (self.eventBeforeClear) self.eventBeforeClear(self);
    [history removeAllObjects];
    if (self.eventAfterClear) self.eventAfterClear(self);
}

- (int)countHistory
{
    return (int)history.count;
}

- (double)getTotal: (int)index
{
    if (history.count != 0)
        return ((Expression*)[history objectAtIndex:index]).calculate;
    else
        return 0;
}

@end
