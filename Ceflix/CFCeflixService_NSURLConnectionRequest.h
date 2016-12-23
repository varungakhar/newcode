//
//  CFCeflixService_NSURLConnectionRequest.h
//  Ceflix
//
//  Created by Tobi Omotayo on 12/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFCeflixService.h"

@protocol CFCeflixService_NSURLConnectionRequestDelegate;

/**
 * A class that wraps NSURLConnection for easier use and state-tracking
 */
@interface CFCeflixService_NSURLConnectionRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


/**
 * Initialize a new instance
 * @param request A NSURLRequest for the underlying connection to execute
 * @param statusCode The expected HTTP status code signaling successful execution
 * @param success The callback block to execute upon successful completion
 * @param failure The faiure block to execute if the connection fails for any reason
 */
- (instancetype)initWithRequest:(NSURLRequest *)request
             expectedStatusCode:(NSInteger)statusCode
                        success:(CFCeflixServiceSuccess)success
                        failure:(CFCeflixServiceFailure)failure
                       delegate:(id<CFCeflixService_NSURLConnectionRequestDelegate>)delegate;

/**
 * Cancel the underlying connection
 */
- (void)cancel;

/**
 * Restart the request
 */
- (void)restart;

/**
 * The unique identifier for the request, used to track instances separately
 */
- (NSString *)uniqueIdentifier;

@end

@protocol CFCeflixService_NSURLConnectionRequestDelegate <NSObject>

- (void)requestDidComplete:(CFCeflixService_NSURLConnectionRequest *)request;
- (void)requestRequiresAuthentication:(CFCeflixService_NSURLConnectionRequest *)request;

@end
