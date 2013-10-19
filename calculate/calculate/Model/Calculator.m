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
    if ( self = [super init] ) {
        format = [[NSNumberFormatter alloc] init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
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

@end
