//
//  CFAPIRequest.m
//  Ceflix
//
//  Created by Tobi Omotayo on 15/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFAPIRequest.h"

@interface CFAPIRequest ()

@property (nonatomic, assign, readwrite) NSUInteger expectedStatusCode;
@property (nonatomic, copy, readwrite) CFAPIRequestSuccess success;
@property (nonatomic, copy, readwrite) CFAPIRequestFailure failure;
@property (nonatomic, strong) NSMutableData *mutableData;

@end

@implementation CFAPIRequest

#pragma mark - Instance methods

- (instancetype)initWithExpectedStatusCode:(NSUInteger)expectedStatusCode success:(CFAPIRequestSuccess)success failure:(CFAPIRequestFailure)failure {
    if (self = [super init]) {
        self.expectedStatusCode = expectedStatusCode;
        self.success = success;
        self.failure = failure;
        
        self.mutableData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)appendData:(NSData *)data {
    [self.mutableData appendData:data];
}

- (NSData *)responseData {
    return [NSData dataWithData:self.mutableData];
}

@end
