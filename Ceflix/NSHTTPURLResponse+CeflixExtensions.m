//
//  NSHTTPURLResponse+CeflixExtensions.m
//  Ceflix
//
//  Created by Tobi Omotayo on 26/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "NSHTTPURLResponse+CeflixExtensions.h"

@implementation NSHTTPURLResponse (CeflixExtensions)

- (NSString *)errorMessageWithData:(NSData *)data {
    NSString *message = [NSString stringWithFormat:@"Unexpected response code: %li", (long)self.statusCode];
    
    if (data) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (json && [json isKindOfClass:[NSDictionary class]]) {
            NSString *errorMessage = [(NSDictionary *)json valueForKey:@"error"];
            if (errorMessage) {
                message = errorMessage;
            }
        }
    }
    
    return message;
}

@end
