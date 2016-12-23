//
//  NSHTTPURLResponse+CeflixExtensions.h
//  Ceflix
//
//  Created by Tobi Omotayo on 26/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (CeflixExtensions)

/**
 * Attempt to extract an error message from the given data object
 * (assumes JSON payload), otherwise return default error message
 */
- (NSString *)errorMessageWithData:(NSData *)data;

@end
