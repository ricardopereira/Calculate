//
//  Common.m
//  Calculate
//
//  Created by Ricardo Pereira on 22/01/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "Common.h"

@interface Common()
// Private properties and methods
@end

@implementation Common
{
    // Private variables
}

- (NSString*)getAsString
{
    // Override
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
