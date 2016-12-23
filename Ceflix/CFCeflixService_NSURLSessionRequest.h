//
//  CFCeflixService_NSURLSessionRequest.h
//  Ceflix
//
//  Created by Tobi Omotayo on 25/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFCeflixService.h"

@protocol CFCeflixService_NSURLSessionRequestDelegate;

/**
 * An instance or this class models a request encapsulated in a
 * NSURLSessionDataTask. It also tracks its unique identifier as well
 * as the expected HTTP status codes, and the appropriate dispatch blocks
 * for the success and failure cases.
 */
@interface CFCeflixService_NSURLSessionRequest : NSObject

@property (nonatomic, weak) id<CFCeflixService_NSURLSessionRequestDelegate> delegate;
@property (nonatomic, strong) NSURLRequest *URLRequest;
@property (nonatomic, assign) NSInteger expectedStatus;
@property (nonatomic, copy) CFCeflixServiceSuccess successBlock;
@property (nonatomic, copy) CFCeflixServiceFailure failureBlock;
@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

/**
 * Initialize a new instance which will immediately schedule the request. Delegate
 * methods will be invoked depending on the final response.
 */
- (instancetype)initWithRequest:(NSURLRequest *)request
                   usingSession:(NSURLSession *)session
                 expectedStatus:(NSInteger)expectedStatus
                        success:(CFCeflixServiceSuccess)success
                        failure:(CFCeflixServiceFailure)failure
                       delegate:(id<CFCeflixService_NSURLSessionRequestDelegate>)delegate;

/**
 * Cancel this request
 */
- (void)cancel;

/**
 * Restart this request. Delegate methods should be invoked depending on the final response
 */
- (void)restart;

/**
 * The unique identifier of the request
 */
- (NSString *)requestIdentifier;

@end

@protocol CFCeflixService_NSURLSessionRequestDelegate <NSObject>

/**
 * Indicates that the request completed successfully with the response
 * returned the expected status code
 */
- (void)sessionRequestDidComplete:(CFCeflixService_NSURLSessionRequest *)request;

/**
 * Indicates that the request failed for some reason, described in the given error
 */
- (void)sessionRequestFailed:(CFCeflixService_NSURLSessionRequest *)request error:(NSError *)error;

/**
 * Indicates that the request failed authentication (401 response) and requires
 * authentication before proceeding
 */
- (void)sessionRequestRequiresAuthentication:(CFCeflixService_NSURLSessionRequest *)request;

@end
