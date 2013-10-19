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

@property (strong, nonatomic) NSNumberFormatter *format;

@end
