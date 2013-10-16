//
//  Calculator.h
//  Calculadora
//
//  Created by Ricardo Pereira on 10/8/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject {
    int number;
}

@property int total;

- (void)add: (int)value;

@end
