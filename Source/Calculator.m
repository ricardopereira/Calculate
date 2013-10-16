//
//  Calculator.m
//  Calculadora
//
//  Created by Ricardo Pereira on 10/8/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

@synthesize total;

- (void)add: (int)value {
    total += value;
}

@end
