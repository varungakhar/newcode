//
//  NSArray+Enumerable.h
//  Ceflix
//
//  Created by Tobi Omotayo on 02/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Enumerable)

- (NSArray *)mappedArrayWithBlock:(id(^)(id obj))block;

@end
