//
//  Calculator.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator
{
    NSMutableArray *statement;
}

@synthesize format;

- (id)init {
    if (self = [super init]) {
        format = [[NSNumberFormatter alloc] init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setGroupingSeparator:@""];
        [format setAlwaysShowsDecimalSeparator:NO];
        [format setLocale:[NSLocale currentLocale]];
        
        statement = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (void)clear {
    [statement removeAllObjects];
}

- (BOOL)isEmpty {
    if (statement.count == 0)
        return YES;
    else
        return NO;
}

- (void)add:(NSObject *)value {
    [statement addObject:value];
}

- (BOOL)isReadyForNewNumber {
    if ([statement lastObject] != nil)
        return [(NSObject *)[statement lastObject] isKindOfClass:[NSString class]];
    else
        return YES;
}

- (int)countStatements {
    return statement.count;
}

- (double)getTotal {
    
    // ToDo
    if ([(NSString *)[statement objectAtIndex:1] isEqualToString:@"+"])
        return [(NSNumber *)[statement objectAtIndex:0] doubleValue] + [(NSNumber *)[statement objectAtIndex:2] doubleValue];
    else if ([(NSString *)[statement objectAtIndex:1] isEqualToString:@"-"])
        return [(NSNumber *)[statement objectAtIndex:0] doubleValue] - [(NSNumber *)[statement objectAtIndex:2] doubleValue];
    else if ([(NSString *)[statement objectAtIndex:1] isEqualToString:@"/"])
        return [(NSNumber *)[statement objectAtIndex:0] doubleValue] + [(NSNumber *)[statement objectAtIndex:2] doubleValue];
    else if ([(NSString *)[statement objectAtIndex:1] isEqualToString:@"*"])
        return [(NSNumber *)[statement objectAtIndex:0] doubleValue] * [(NSNumber *)[statement objectAtIndex:2] doubleValue];
    else
        return 0;
}

@end
