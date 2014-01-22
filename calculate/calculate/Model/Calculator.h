//
//  Calculator.h
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Expression.h"

@interface Calculator : Common
{
    //Public variables
}

// Public properties and methods
- (id)init;

- (Expression*)newExpression;
- (void)add: (Expression*)expr;

- (void)clearHistory;
- (int)countHistory;

- (double)getTotal: (int)index;

- (NSString*)getAsString;

@property (strong, nonatomic) NSNumberFormatter *format;

// Events
@property (nonatomic, copy) void (^eventBeforeClear)(NSObject*);
@property (nonatomic, copy) void (^eventAfterClear)(NSObject*);

@end