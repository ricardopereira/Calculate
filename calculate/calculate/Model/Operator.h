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
- (id)init;
- (id)initWithType: (NSString*)value;

+ (id)operatorWithType: (NSString*) value;

@property (nonatomic, copy) NSString* type;

@end