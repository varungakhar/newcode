//
//  CFCeflixService_SubclassMethods.h
//  Ceflix
//
//  Created by Tobi Omotayo on 12/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFCeflixService.h"

/**
 * A way for subclasses to "see" into the parent CFCeflixService class 
 * without exposing all of the properties to the world.
 */

@interface CFCeflixService (SubclassMethods)

@property (nonatomic, strong) NSURL *tempServerRoot;
@property (nonatomic, strong, readonly) NSMutableDictionary *requests;
@property (nonatomic, strong, readonly) NSMutableArray *requestsPendingAuthentication;

/**
 * Creates a NSMutableRequest for the given URL and HTTP method. if the
 * body is non-nil, it will be encoded using -formEncodedParameters method.
 * This method also sets important HTTP headers.
 * @param URL
 * @param httpMethod
 * @param bodyDict
 * @param NSMutableURLRequest
 */
- (NSMutableURLRequest*)requestForURL: (NSURL*)URL method: (NSString*)httpMethod bodyDict: (NSDictionary*)bodyDict;


@end
