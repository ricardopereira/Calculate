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
    return [self initWithType:@"+"];
}

- (id)initWithType: (NSString*)value
{
    if ((self = [super init]))
    {
        // ?
        self.type = [NSString stringWithString:value];
    }
    return self;
}

+ (id)operatorWithType: (NSString*) value
{
    return [[Operator alloc] initWithType:value];
}

@end
