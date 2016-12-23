//
//  CFCeflixService_NSURLConnection.m
//  Ceflix
//
//  Created by Tobi Omotayo on 12/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCeflixService_NSURLConnection.h"

#import "CFCeflixService_SubclassMethods.h"
#import "CFUser.h"
#import "CFVideo.h"
#import "CFBanner.h"
#import "CFCeflixService_NSURLConnectionRequest.h"
#import "NSArray+Enumerable.h"

@interface CFCeflixService_NSURLConnection () <CFCeflixService_NSURLConnectionRequestDelegate>

@property (nonatomic, strong) NSMutableArray *requestsPendingAuthentication;

@end

@implementation CFCeflixService_NSURLConnection

- (id)init {
    if ((self = [super init])) {
        self.requestsPendingAuthentication = [NSMutableArray array];
    }
    
    return self;
}

- (NSString *)submitRequestWithURL:(NSURL *)URL
                            method:(NSString *)httpMethod
                              body:(NSDictionary *)bodyDict
                    expectedStatus:(NSInteger)expectedStatus
                           success:(CFCeflixServiceSuccess)success
                           failure:(CFCeflixServiceFailure)failure {
    
    NSMutableURLRequest *request = [self requestForURL:URL method:httpMethod bodyDict:bodyDict];
    
    CFCeflixService_NSURLConnectionRequest *connectionRequest;
    connectionRequest = [[CFCeflixService_NSURLConnectionRequest alloc] initWithRequest:request expectedStatusCode:expectedStatus success:success failure:failure delegate:self];
    
    NSString *connectionID = [connectionRequest uniqueIdentifier];
    [self.requests setObject:connectionRequest forKey:connectionID];
    return connectionID;
    
}

- (void)resendRequestsPendingAuthentication {
    for (CFCeflixService_NSURLConnectionRequest *request in self.requestsPendingAuthentication) {
        [request restart];
    }
}

#pragma mark - Private Helpers

- (NSData *)formEncodedParameters:(NSDictionary *)parameters {
    
    NSArray *pairs = [parameters.allKeys mappedArrayWithBlock:^id(id obj){
        return [NSString stringWithFormat:@"%@=%@", [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [parameters[obj] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }];
    NSString *formBody = [pairs componentsJoinedByString:@"&"];
    return [formBody dataUsingEncoding:NSUTF8StringEncoding];
    
}

#pragma mark - Cancellation

- (void)cancelRequestWithIdentifier:(NSString *)identifier {
    CFCeflixService_NSURLConnectionRequest *request = [self.requests objectForKey:identifier];
    if (request) {
        [request cancel];
        [self.requests removeObjectForKey:identifier];
    }
}

#pragma mark - CFCeflixService_NSURLConnectionRequestDelegate 

- (void)requestDidComplete:(CFCeflixService_NSURLConnectionRequest *)request {
    [self.requests removeObjectForKey:[request uniqueIdentifier]];
    [self.requestsPendingAuthentication removeObject:request];
}

- (void)requestRequiresAuthentication:(CFCeflixService_NSURLConnectionRequest *)request {
    [self.requestsPendingAuthentication addObject:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:CFCeflixServiceAuthRequiredNotification object:nil];
}

@end
















