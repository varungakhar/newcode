//
//  CeflixService.m
//  Ceflix
//
//  Created by Tobi Omotayo on 02/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCeflixService.h"

#import "CFUser.h"
#import "CFCeflixRemoteVideo.h"
#import "NSArray+Enumerable.h"
#import "CFCeflixService_NSURLConnection.h"
#import "CFCeflixService_NSURLSession.h"
#import "CFChannel.h"
#import "CFComment.h"
#import "CFReply.h"
#import "CFConnectTimelineItem.h"
#import "CFConnectVideo.h"

NSString *const CFCeflixServiceAuthRequiredNotification = @"CFCeflixServiceAuthRequiredNotification";

/**
 * The user-defaults key for the URL of the last server the user authenticated
 * with
 */
static NSString *const CFLastServerURLKey = @"LastServerURL";

/**
 * The user-defaults key for the user identifier
 */
static NSString *const CFUserIdentifierKey = @"UserIdentifier";

/**
 * The user-defaults key for the current user
 */
static NSString *const CFCurrentUserKey = @"CurrentUser";

/**
 * The user-defaults key for the current user data
 */
static NSString *const CFCurrentUserDataKey = @"CurrentUserDataKey";

/**
 * The user-defaults key for the current user's token
 */
static NSString *const CFCurrentUserTokenKey = @"CurrentUserToken";

/**
 * The HTTP Basic Authentication realm for the Ceflix Server
 */
static NSString *const CFAuthorizationRealm = @"Ceflix Server";

static CFCeflixService *SharedInstance;

@interface CFCeflixService ()

@property (nonatomic, strong) CFUser *currentUser;
@property (nonatomic, strong) NSString *encID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSURL *tempServerRoot;
@property (nonatomic, strong) NSURL *serverRoot;
@property (nonatomic, strong) NSMutableDictionary *requests;

@end

@implementation CFCeflixService

+ (CFCeflixService *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
        
        // clear any cookie caches
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
            [cookieStorage deleteCookie:cookie];
        }
        
        SharedInstance = [[CFCeflixService_NSURLSession alloc] init];
        
    });
    return SharedInstance;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.requests = [NSMutableDictionary dictionary];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *serverRootString = [defaults stringForKey:CFLastServerURLKey];
        if (serverRootString) {
            self.serverRoot = [NSURL URLWithString:serverRootString];
        }
        
        NSDictionary *userDict = [defaults objectForKey:CFCurrentUserKey];
        if (userDict) {
            self.currentUser = [[CFUser alloc] initWithDictionary:userDict];
        }
    }
    return self;
}

#pragma mark - Users

- (NSString *)signInWithEmail:(NSString *)email
                     password:(NSString *)password
                      success:(void (^)(CFUser *))success
                      failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    
    NSUserDefaults *tokenId = [NSUserDefaults standardUserDefaults];
    NSData *tokenGet = [tokenId objectForKey:@"CFDeviceToken"];
    NSString *deviceToken = [self stringWithDeviceToken:tokenGet];
    NSDictionary *params = @{
                             @"email": email,
                             @"password": password,
                             @"deviceToken": deviceToken,
                             @"deviceType": @"ios"
                             };
    return [self submitPOSTPath:@"/user/login"
                           body:params
                 expectedStatus:200
                        success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *userDictionary = resultDictionary[@"data"][@"0"];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            
            if (userDictionary && [userDictionary isKindOfClass:[NSDictionary class]]) {
                self.currentUser = [[CFUser alloc] initWithDictionary:userDictionary];
                NSLog(@"%@", self.currentUser);
            }
            
            self.tempServerRoot = nil;
            // self.serverRoot = serverURL;
            
            self.encID = resultDictionary[@"data"][@"encID"];
            self.token = resultDictionary[@"auth"][@"token"];
            
            NSLog(@"%@", self.encID);
            NSLog(@"%@", self.token);
            
            [self persistEncID:self.encID andToken:self.token];
            
            // code to save credentials from successful sign in to keychain
            [self persistAuthenticationCredentials];
            
            if (success != NULL) {
                success(self.currentUser);
            }
            [self resendRequestsPendingAuthentication];
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
        
    } failure:^(NSError *error) {
        self.tempServerRoot = nil;
        if (failure != NULL) {
            failure(error);
        }
    }];
    
}

- (NSString *)registerNewUserWithUsername:(NSString *)userName
                                 password:(NSString *)password
                                firstName:(NSString *)firstName
                                 lastName:(NSString *)lastName
                                    email:(NSString *)email
                                   gender:(NSString *)gender
                              phoneNumber:(NSString *)phoneNumber
                                  country:(NSString *)country
                                  success:(void (^)(CFUser *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://api.ceflix.org"];
    
    NSUserDefaults *tokenId = [NSUserDefaults standardUserDefaults];
    NSString *tokenGet = [tokenId objectForKey:@"token"];
    NSDictionary *params = @{
                             @"username": userName,
                             @"password": password,
                             @"firstname": firstName,
                             @"lasname": lastName,
                             @"email": email,
                             @"gender": gender,
                             @"phone": phoneNumber,
                             @"country": country,
                             @"deviceToken": tokenGet,
                             @"deviceType": @"ios",
                             @"appID": tokenGet
                             };
    return [self submitPOSTPath:@"/user/register"
                           body:params
                 expectedStatus:201
                        success:^(NSData *data) {
        self.tempServerRoot = nil;
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *userDictionary = resultDictionary[@"data"][@"0"];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            // self.serverRoot = serverURL;
            
            if (userDictionary && [userDictionary isKindOfClass:[NSDictionary class]]) {
                self.currentUser = [[CFUser alloc] initWithDictionary:userDictionary];
            }
            self.tempServerRoot = nil;
            
            self.encID = resultDictionary[@"data"][@"encID"];
            self.token = resultDictionary[@"auth"][@"token"];
            
            [self persistEncID:self.encID andToken:self.token];
            
            [self persistAuthenticationCredentials];
            
            if (success != nil) {
                success(self.currentUser);
            }
            [self resendRequestsPendingAuthentication];
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        self.tempServerRoot = nil;
        if (failure != NULL) {
            failure(error);
        }
    }];
    
}

- (NSString *)signoutUserWithSuccess:(void (^)())success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    
    NSString *encID = [[NSUserDefaults standardUserDefaults] objectForKey:CFUserIdentifierKey];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:CFCurrentUserTokenKey];
    
    NSDictionary *params = @{
                             @"encID": encID,
                             @"token": token
                             };
    return [self submitPOSTPath:@"/user/signout" body:params expectedStatus:200 success:^(NSData *data) {
        self.serverRoot = nil;
        self.currentUser = nil;
        
        [self persistAuthenticationCredentials];
        [self removePersistedCredentials];
        
        if (success != NULL) {
            success();
        }
    } failure:failure];
}


- (NSString *)loadUserProfileSuccess:(void (^)(CFUser *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    
    NSString *encID = [[NSUserDefaults standardUserDefaults] objectForKey:CFUserIdentifierKey];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:CFCurrentUserTokenKey];
    
    NSDictionary *params = @{
                             @"encID": encID,
                             @"token": token
                             };
    return [self submitPOSTPath:@"/user/profile" body:params expectedStatus:200 success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *userDictionary = resultDictionary[@"data"][@"0"];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            if (userDictionary && [userDictionary isKindOfClass:[NSDictionary class]]) {
                CFUser *user = [[CFUser alloc] initWithDictionary:userDictionary];
                if (success != NULL) {
                    success(user);
                }
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)loadUserProfileWithUserID:(NSString *)userID success:(void (^)(CFUser *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    
    NSString *encID = [[NSUserDefaults standardUserDefaults] objectForKey:CFUserIdentifierKey];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:CFCurrentUserTokenKey];
    NSLog(@"TOKEN: %@", token);
    NSDictionary *params = @{
                             @"encID": userID,
                             @"token": token,
                             @"alt_user_id": encID
                             };
    return [self submitPOSTPath:@"/user/profile" body:params expectedStatus:200 success:^(NSData *data) {
        
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *userDictionary = resultDictionary[@"data"][@"0"];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            if (userDictionary && [userDictionary isKindOfClass:[NSDictionary class]]) {
                CFUser *user = [[CFUser alloc] initWithDictionary:userDictionary];
                if (success != NULL) {
                    success(user);
                }
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
    
}

- (BOOL)isUserSignedIn {
    // return self.serverRoot != nil;
    return [[NSUserDefaults standardUserDefaults] objectForKey:CFUserIdentifierKey] != nil;
}

- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

#pragma mark - People made of Users

- (NSString *)fetchFollowersForUser:(NSString *)userID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"/connect/get_followers/%@", userID];
    return [self submitGETPath:path success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *followers = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFUser alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(followers);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)fetchFollowingUsersForUser:(NSString *)userID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"/connect/get_followees/%@", userID];
    return [self submitGETPath:path success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *followingUsers = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFUser alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(followingUsers);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
    
}

/*
- (NSString *)fetchPeopleFromSearchTerm:(NSString *)searchTerm success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"/people/search?searchItem=%@", searchTerm];
    return [self submitGETPath:path success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"][@"people"];
        if (results && [resultDictionary isKindOfClass:[NSArray class]]) {
            NSArray *videos = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFUser alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(videos);
            }
        }
    } failure:failure];
}
*/

#pragma mark - Videos

- (NSString *)fetchLiveVideosSuccess:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    return [self submitGETPath:@"/videos/watchlivecatalog" success:^(NSData *data) {
        NSError *error = nil;
        
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *results = [resultDictionary objectForKey:CFDataVideosKey];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *liveVideos = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(liveVideos);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)fetchHomeScreenContentSuccess:(void (^)(NSDictionary *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    return [self submitPOSTPath:@"/videos/homescreen" body:nil expectedStatus:200 success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *homeScreenContent = [[NSDictionary alloc] initWithDictionary:dict];
            if (success != NULL) {
                success(homeScreenContent);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)fetchRelatedVideosForVideo:(NSString *)videoID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://api.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"/api/related_videos/%@", videoID];
    return [self submitGETPath:path success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"videos"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *relatedVideos = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(relatedVideos);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)getVideoDetailsWithID:(NSString *)videoID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    return [self submitPOSTPath:@"videos/getvideodetail" body:@{ @"videoID": videoID} expectedStatus:200 success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = dict[@"data"][@"video"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            
            NSArray *videos = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(videos);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)fetchVideosFromSearchTerm:(NSString *)searchTerm success:(void (^)(NSDictionary *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"/videos/search?searchItem=%@", searchTerm];
    return [self submitGETPath:path success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            if (success != NULL) {
                success(resultDictionary);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
    
}

// TODO: Add code for other video API related tasks, like upload video, save download video, fetch recent videos,  etc.


#pragma mark - Connect Videos

- (NSString *)fetchVideosByUser:(NSString *)userID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"connect/user_videos/%@", userID];
    return [self submitGETPath:path success:^(NSData *data) {
        NSError *error = nil;
        
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *userTimelineItems = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFConnectTimelineItem alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(userTimelineItems);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
        
    } failure:failure];
    
}


#pragma mark - Channels

- (NSString *)fetchChannelWithID:(NSString *)channelID success:(void (^)(NSDictionary *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    return [self submitPOSTPath:@"/channel/profile" body:@{ @"channelID": channelID } expectedStatus:200 success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *channel = [[NSDictionary alloc] initWithDictionary:dict];
            if (success != NULL) {
                success(channel);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)fetchChannelVideosWithChannelID:(NSString *)channelID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    return [self submitPOSTPath:@"/channel/loadvideos" body:@{ @"channelID": channelID } expectedStatus:200 success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"][@"videos"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *channelVideos = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(channelVideos);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}

- (NSString *)fetchChannelsFromSearchTerm:(NSString *)searchTerm success:(void (^)(NSDictionary *))success failure:(CFCeflixServiceFailure)failure {
    
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSString *path = [NSString stringWithFormat:@"/channel/search?searchItem=%@", searchTerm];
    return [self submitGETPath:path success:^(NSData *data) {
        NSLog(@"PATH-%@", path);
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            if (success != NULL) {
                success(resultDictionary);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
    
}

#pragma mark - Comments

- (NSString *)addComment:(NSString *)comment withRadomNumber:(NSString *)randomNumber forVideo:(NSString *)videoID byUser:(NSString *)userID success:(void (^)())success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    NSDictionary *params = @{
                             @"videoID": videoID,
                             @"comment": comment,
                             @"randNumber": randomNumber,
                             @"userID": userID
                             };
    return [self submitPOSTPath:@"/comments/addcomment" body:params expectedStatus:200 success:^(NSData *data) {
        
    } failure:^(NSError *error) {
        if (failure != NULL) {
            failure(error);
        }
    }];
}

/*
- (NSString *)deleteComment:(NSString *)commentID byUser:(NSString *)userID success:(void (^)())success failure:(CFCeflixServiceFailure)failure {
    
}
*/

- (NSString *)fetchCommentsForVideo:(NSString *)videoID success:(void (^)(NSArray *))success failure:(CFCeflixServiceFailure)failure {
    self.serverRoot = [NSURL URLWithString:@"http://apix3x9.ceflix.org"];
    return [self submitPOSTPath:@"/comments/getVideoComments" body:@{ @"videoID": videoID } expectedStatus:200 success:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"];
        if (results && [results isKindOfClass:[NSArray class]]) {
            NSArray *comments = [results mappedArrayWithBlock:^id(id obj) {
                return [[CFComment alloc] initWithDictionary:obj];
            }];
            if (success != NULL) {
                success(comments);
            }
        }
        else {
            if (failure != NULL) {
                failure(error);
            }
        }
    } failure:failure];
}


#pragma mark - Abstract Methods

- (NSString *)submitRequestWithURL:(NSURL *)URL
                            method:(NSString *)httpMethod
                              body:(NSDictionary *)bodyDict
                    expectedStatus:(NSInteger)expectedStatus
                           success:(CFCeflixServiceSuccess)success failure:(CFCeflixServiceFailure)failure {
    
    NSAssert(NO, @"%s must be implemented in a sub-class!", __PRETTY_FUNCTION__);
    return nil;
    
}

- (void)cancelRequestWithIdentifier:(NSString *)identifier {
    NSAssert(NO, @"%s must be implemented in a sub-class!", __PRETTY_FUNCTION__);
}

- (void)resendRequestsPendingAuthentication {
    NSAssert(NO, @"%s must be implemented in a sub-class!", __PRETTY_FUNCTION__);
}


#pragma mark - Request Helpers

- (NSURL *)URLWithPath:(NSString *)path {
    NSURL *root = self.serverRoot ?: self.tempServerRoot;
    NSAssert(root != nil, @"Cannot make requests if neither serverRoot or tempServerRoot are nil");
    return [NSURL URLWithString:path relativeToURL:root];
}

- (NSString *)submitGETPath:(NSString *)path
                    success:(CFCeflixServiceSuccess)success
                    failure:(CFCeflixServiceFailure)failure {
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"GET"
                                 body:nil
                       expectedStatus:200
                              success:success
                              failure:failure];
}

- (NSString *)submitDELETPath:(NSString *)path success:(CFCeflixServiceSuccess)success failure:(CFCeflixServiceFailure)failure {
    
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"DELETE"
                                 body:nil
                       expectedStatus:200
                              success:success
                              failure:failure];
}

- (NSString *)submitPOSTPath:(NSString *)path body:(NSDictionary *)bodyDict expectedStatus:(NSInteger)expectedStatus success:(CFCeflixServiceSuccess)success failure:(CFCeflixServiceFailure)failure {
    
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"POST"
                                 body:bodyDict
                       expectedStatus:expectedStatus
                              success:success
                              failure:failure];
    
}

- (NSString *)submitPUTPath:(NSString *)path
                       body:(NSDictionary *)bodyDict
             expectedStatus:(NSInteger)expectedStatus
                    success:(CFCeflixServiceSuccess)success
                    failure:(CFCeflixServiceFailure)failure {
    
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"PUT"
                                 body:bodyDict
                       expectedStatus:expectedStatus
                              success:success
                              failure:failure];
    
}

- (NSMutableURLRequest *)requestForURL:(NSURL *)URL method:(NSString *)httpMethod bodyDict:(NSDictionary *)bodyDict
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:httpMethod];
    
    // For now, assume body content is always form-urlencoded
    if (bodyDict) {
        [request setHTTPBody:[self formEncodedParameters:bodyDict]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return request;
}

- (NSData *)formEncodedParameters:(NSDictionary *)parameters {
    
    NSArray *pairs = [parameters.allKeys mappedArrayWithBlock:^id(id obj){
        return [NSString stringWithFormat:@"%@=%@", [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [parameters[obj] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }];
    NSString *formBody = [pairs componentsJoinedByString:@"&"];
    return [formBody dataUsingEncoding:NSUTF8StringEncoding];
    
}

#pragma mark - Credential Storage & Authentication

// persist the encID and token returned from successful login. Don't bother about the persisting of serverRoot
- (void)persistEncID:(NSString *)encID andToken:(NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serverRoot.absoluteString forKey:CFLastServerURLKey];
    [defaults setObject:encID forKey:CFUserIdentifierKey];
    [defaults setObject:token forKey:CFCurrentUserTokenKey];
    // [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.currentUser dictionaryRepresentation]] forKey:CFCurrentUserDataKey];
    // [defaults setObject:[self.currentUser dictionaryRepresentation] forKey:CFCurrentUserKey];
    [defaults synchronize];
}

- (void)persistAuthenticationCredentials {
    
    NSString *userName = @"key";
    NSString *password = @"2026839B3680CD35EEA404103889B66989EA5DC960855E7075747763F0BF0848";
    NSURLCredential *defaultCred = [NSURLCredential credentialWithUser:userName password:password persistence:NSURLCredentialPersistencePermanent];

    NSURLProtectionSpace *protectionSpace = [self protectionSpace];
    [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:defaultCred forProtectionSpace:protectionSpace];
}

- (NSURLProtectionSpace *)protectionSpace {
    return [[NSURLProtectionSpace alloc] initWithHost:self.serverRoot.host port:self.serverRoot.port.intValue protocol:self.serverRoot.scheme realm:nil authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
}

- (void)removePersistedCredentials {
    NSURLProtectionSpace *protectionSpace = [self protectionSpace];
    NSURLCredential *defaulCred = [[NSURLCredentialStorage sharedCredentialStorage] defaultCredentialForProtectionSpace:protectionSpace];
    // I assume this check is to check if there is a defaultCred available
    if (defaulCred) {
        [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:defaulCred forProtectionSpace:protectionSpace];
    }
}

@end


























