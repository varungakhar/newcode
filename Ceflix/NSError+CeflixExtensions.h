//
//  NSError+CeflixExtensions.h
//  Ceflix
//
//  Created by Tobi Omotayo on 16/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CeflixExtensions)

/**
 * Indicates if the underlying error represents an intentional cancelation
 * on the part of the user.
 * @return BOOL
 */
- (BOOL)isCancelationError;

@end
