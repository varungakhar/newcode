//
//  NSArray+Enumerable.m
//  Ceflix
//
//  Created by Tobi Omotayo on 02/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "NSArray+Enumerable.h"

@implementation NSArray (Enumerable)

- (NSArray *)mappedArrayWithBlock:(id (^)(id))block {
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [temp addObject:block(obj)];
    }
    
    return temp;
    
}

@end
