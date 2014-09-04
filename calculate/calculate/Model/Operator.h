//
//  Operator.h
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "Common.h"

@interface Operator : Common
{
    // Public variables
}

// Public properties and methods
- (instancetype)init;
- (instancetype)initWithType: (char)value;

+ (id)operatorWithType: (char)value;

- (BOOL)isAdd;
- (BOOL)isSubtract;
- (BOOL)isMultiply;
- (BOOL)isDivision;

@property (nonatomic) char type;

@end