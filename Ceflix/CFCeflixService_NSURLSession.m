//
//  CFCeflixService_NSURLSession.m
//  Ceflix
//
//  Created by Tobi Omotayo on 21/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCeflixService_NSURLSession.h"

#import "CFCeflixService_NSURLSessionRequest.h"
#import "CFCeflixService_SubclassMethods.h"
#import "NSArray+Enumerable.h"

@interface CFCeflixService_NSURLSession () <CFCeflixService_NSURLSessionRequestDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *requests;
@property (nonatomic, strong) NSMutableArray *requestsPendingAuthentication;

@end

@implementation CFCeflixService_NSURLSession

- (id)init {
    if (self = [super init]) {
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever;
        sessionConfig.HTTPCookieStorage = NULL;
        sessionConfig.HTTPShouldSetCookies = NO;
        sessionConfig.URLCredentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                     delegate:self
                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        self.requests = [NSMutableDictionary dictionary];
        self.requestsPendingAuthentication = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Subclass methods


- (NSString *)submitRequestWithURL:(NSURL *)URL
                            method:(NSString *)httpMethod
                              body:(NSDictionary *)bodyDict
                    expectedStatus:(NSInteger)expectedStatus
                           success:(CFCeflixServiceSuccess)success
                           failure:(CFCeflixServiceFailure)failure {
    
    NSMutableURLRequest *request = [self requestForURL:URL
                                                method:httpMethod
                                              bodyDict:bodyDict];
    
    CFCeflixService_NSURLSessionRequest *sessionRequest;
    sessionRequest = [[CFCeflixService_NSURLSessionRequest alloc] initWithRequest:request
                                                                     usingSession:self.session expectedStatus:expectedStatus success:success failure:failure delegate:self];
    self.requests[sessionRequest.requestIdentifier] = sessionRequest;
    return sessionRequest.requestIdentifier;
    
}

#pragma mark - Cancellation

- (void)cancelRequestWithIdentifier:(NSString *)identifier {
    CFCeflixService_NSURLSessionRequest *request = self.requests[identifier];
    if (request) {
        [request cancel];
        [self.requests removeObjectForKey:identifier];
    }
}

#pragma mark - Resend Requests Pending Authentication

- (void)resendRequestsPendingAuthentication {
    for (CFCeflixService_NSURLSessionRequest *request in self.requestsPendingAuthentication) {
        [request restart];
    }
    
    // [self.requestsPendingAuthentication removeAllObjects];
}

#pragma mark - CFCeflixService_NSURLSessionRequestDelegate

- (void)sessionRequestDidComplete:(CFCeflixService_NSURLSessionRequest *)request {
    [self.requests removeObjectForKey:request.requestIdentifier];
    [self.requestsPendingAuthentication removeObject:request];
}

- (void)sessionRequestFailed:(CFCeflixService_NSURLSessionRequest *)request error:(NSError *)error {
    [self.requests removeObjectForKey:request.requestIdentifier];
    [self.requestsPendingAuthentication removeObject:request];
}

- (void)sessionRequestRequiresAuthentication:(CFCeflixService_NSURLSessionRequest *)request {
    [self.requestsPendingAuthentication addObject:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:CFCeflixServiceAuthRequiredNotification object:nil]; // this will trigger the app authentication mechanism and prompt the user for credentials.
}

// Pretty much for Basic Authentication
#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if (challenge.previousFailureCount == 0) {
        NSURLProtectionSpace *space = [challenge protectionSpace];
        NSURLCredential *credential = [[NSURLCredentialStorage sharedCredentialStorage] defaultCredentialForProtectionSpace:space];
        if (credential) {
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            return;
        }
    }
    
    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    
    // we can't prompt user to login if auth fails so this wont be necessary.
    // [[NSNotificationCenter defaultCenter] postNotificationName:CFCeflixServiceAuthRequiredNotification object:nil];
    for (CFCeflixService_NSURLSessionRequest *request in self.requests.allValues) {
        if (request.task.taskIdentifier == task.taskIdentifier) {
            [self.requestsPendingAuthentication addObject:request];
            break;
        }
    }
}


@end
