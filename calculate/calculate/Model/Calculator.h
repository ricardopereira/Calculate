//
//  Calculator.h
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject
{

}

- (id)init;
- (void)clear;
- (BOOL)isEmpty;
- (void)add:(NSObject*)value;
- (BOOL)isReadyForNewNumber;
- (int)countStatements;
- (double)getTotal;

@property (strong, nonatomic) NSNumberFormatter *format;

@end
