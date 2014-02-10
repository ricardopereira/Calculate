//
//  Operator.m
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "Operator.h"

@interface Operator()
// Private properties and methods
@end

@implementation Operator
{
    // Private variables
}

- (id)init
{
    // Default
    return [self initWithType:'+'];
}

- (id)initWithType: (char)value
{
    if ((self = [super init]))
        self.type = value;
    return self;
}

+ (id)operatorWithType: (char)value
{
    return [[Operator alloc] initWithType:value];
}

- (BOOL)isAdd {
    return _type == '+';
}

- (BOOL)isSubtract {
    return _type == '-';
}

- (BOOL)isMultiply {
    return _type == '*';
}

- (BOOL)isDivision {
    return _type == '/';
}

@end
