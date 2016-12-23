//
//  CFCeflixService_NSURLSessionRequest.m
//  Ceflix
//
//  Created by Tobi Omotayo on 25/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCeflixService_NSURLSessionRequest.h"

#import "NSHTTPURLResponse+CeflixExtensions.h"

@interface CFCeflixService_NSURLSessionRequest ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, readwrite) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSString *requestIdentifier;

@end

@implementation CFCeflixService_NSURLSessionRequest

- (instancetype)initWithRequest:(NSURLRequest *)request
                   usingSession:(NSURLSession *)session
                 expectedStatus:(NSInteger)expectedStatus
                        success:(CFCeflixServiceSuccess)success
                        failure:(CFCeflixServiceFailure)failure
                       delegate:(id<CFCeflixService_NSURLSessionRequestDelegate>)delegate {
    
    if ((self = [super init])) {
        self.URLRequest = request;
        self.session = session;
        self.expectedStatus = expectedStatus;
        self.successBlock = success;
        self.failureBlock = failure;
        self.delegate = delegate;
        
        self.requestIdentifier = [[NSUUID UUID] UUIDString];
        self.task = [self createDataTask];
        [self.task resume];
    }
    return self;
}

- (void)cancel {
    [self.task cancel];
    self.task = nil;
}

- (void)restart {
    [self cancel];
    self.task = [self createDataTask];
    [self.task resume];
}

#pragma mark - Private Helpers

- (NSURLSessionDataTask *)createDataTask {
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSMutableURLRequest *mutableRequest = (NSMutableURLRequest *)weakSelf.URLRequest;
        
        if (HTTPResponse.statusCode == weakSelf.expectedStatus) {
            NSLog(@"%@ %@ %li SUCCESS", [mutableRequest HTTPMethod], [mutableRequest URL], (long)weakSelf.expectedStatus);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.successBlock(data);
                [weakSelf.delegate sessionRequestDidComplete:weakSelf];
            });
        }
        
        // this code to trigger auth mechanism if 401:
        // TODO: replace it with a valid check for user authentication based on the state of the Ceflix service that doesn't have authentication now. say do a check if credentials exist in keychain.
        else if (HTTPResponse.statusCode == 401) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.delegate sessionRequestRequiresAuthentication:weakSelf];
            });
        }
        else if (response) {
            NSLog(@"%@ %@ %li INVALID STATUS CODE", [mutableRequest HTTPMethod], [mutableRequest URL], (long)HTTPResponse.statusCode);
            
            NSString *message = [HTTPResponse errorMessageWithData:data];
            
            NSError *error = [NSError errorWithDomain:@"CeflixService"
                                                 code:HTTPResponse.statusCode
                                             userInfo:@{ NSLocalizedDescriptionKey: message }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.failureBlock(error);
                [weakSelf.delegate sessionRequestFailed:weakSelf error:error];
            });
        }
        else if (! ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)) {
            weakSelf.failureBlock(error);
        }
    }];
    
    return task;
}



@end
