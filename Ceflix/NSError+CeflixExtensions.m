//
//  NSError+CeflixExtensions.m
//  Ceflix
//
//  Created by Tobi Omotayo on 16/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "NSError+CeflixExtensions.h"

@implementation NSError (CeflixExtensions)

- (BOOL)isCancelationError
{
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorCancelled;
}

@end
