//
//  CFAPIRequest.h
//  Ceflix
//
//  Created by Tobi Omotayo on 15/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * A simple state-capturing object used by the CFAPIClient for matching
 * various NSURLSessionTask to callback blocks (where applicable) and 
 * determining what a successful response looks like.
 */
@interface CFAPIRequest : NSObject

typedef void (^CFAPIRequestSuccess)(NSHTTPURLResponse *response, NSData *data);
typedef void (^CFAPIRequestFailure)(NSError *error);

@property (nonatomic, assign, readonly) NSUInteger expectedStatusCode;
@property (nonatomic, copy, readonly) CFAPIRequestSuccess success;
@property (nonatomic, copy, readonly) CFAPIRequestFailure failure;

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, assign) BOOL followRedirects; // don't think I need this

/**
 * Designated Initialized
 */
- (instancetype)initWithExpectedStatusCode:(NSUInteger)expectedStatusCode
                                   success:(CFAPIRequestSuccess)success
                                   failure:(CFAPIRequestFailure)failure;

/**
 * Calls to this method append to the final NSData object returned
 * via the `-responseData` method
 * @param data
 */
- (void)appendData:(NSData *)data;

/**
 * Returns all of the data accumulated via the `-appendData:` method
 * @return NSData
 */
- (NSData *)responseData;

@end
