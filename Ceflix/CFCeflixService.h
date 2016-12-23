//
//  CeflixService.h
//  Ceflix
//
//  Created by Tobi Omotayo on 02/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CFVideo;
@class CFUser;
@class CFBanner;
@class CFChannel;

#import "CFComment.h"

/**
 * The notification name posted when an attempt has been made to retrieve
 * an authenticated resource and either no stored credentials were found,
 * or the current credentials are invalid
 */
extern NSString *const CFCeflixServiceAuthRequiredNotification;

typedef void(^CFCeflixServiceSuccess)(NSData *data);

/**
 * The common callback block signature for remote calls that fail
 */
typedef void(^CFCeflixServiceFailure)(NSError *error);

typedef void(^ServiceCall)(NSData *data,NSError *error);

/**
 *  A base class defining a service that encapsulates access to the backend REST
 * server. All methods return immediately and the callback blocks are invoked
 * asynchronously (on the main thread) depending on success or failure of the operation
 * Each operation returns a unique identifier for that operation that can later
 * be canceled with a call to -cancelRequestWithIdentifier:
 */
@interface CFCeflixService : NSObject

#pragma mark - Singleton access

+ (CFCeflixService *)sharedInstance;

#pragma mark - User Creation, Profile Editing & Authentication

/**
 * Sign up as a new user for a given service
 * @param userName The screen handle for the new user
 * @param serverURL The URL for the service to add the user to. Note that this sets
 * the root URL for all subsequent requests for a CeflixService instance until
 * -signoutUserWithSuccess:failure: is invoked
 * @param success The callback block for a successful sign-up
 * @param failure The callback block for a failed sign-up attempt
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */


- (NSString *)registerNewUserWithUsername:(NSString *)userName
                                 password:(NSString *)password
                                firstName:(NSString *)firstName
                                 lastName:(NSString *)lastName
                                    email:(NSString *)email
                                   gender:(NSString *)gender
                              phoneNumber:(NSString *)phoneNumber
                                  country:(NSString *)country
                              deviceToken:(NSString *)deviceToken
                               deviceType:(NSString *)deviceType
                                    appID:(NSString *)appID
                              success:(void(^)(CFUser *user))success
                              failure:(CFCeflixServiceFailure)failure;

/**
 * Signs in as an existing user for a given service
 * @param userName The screen handle for the user
 * @param password The password for the user
 * @param deviceToken The token gotten from registering the app for notifications
 * @param deviceType This is the string "iOS"
 * @param serverURL The URL for the service to authenticate with. Note that this sets
 * the root URL for all subsequent requests for a CeflixService instance until
 * -signoutUserWithSuccess:failure: is invoked
 * @param success The callback block for a successful sign-up
 * @param failure The callback block for a failed sign-up attempt
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)signInWithEmail:(NSString *)email
                     password:(NSString *)password
                              success:(void(^)(CFUser *user))success
                              failure:(CFCeflixServiceFailure)failure;

/**
 * Signs the user out of the current server URL endpoint specified in either the 
 * -registerNewUserWithName:password:serverURL:success:failure or 
 * - signInWithUserName:password:serverURL:success:failure.
 * @return A NSString identifier for the operation, suitable for canceling with 
 * -cancelRequestWithIdentifier:
 */
- (NSString *)signoutUserSuccess:(void(^)())success
                     failure:(CFCeflixServiceFailure)failure;

/**
 * Checks to see if the username chosen by the user is available for use.
 */
- (NSString *)checkUserName:(NSString *)userName
                    success:(void(^)())success
                    failure:(CFCeflixServiceFailure)failure;

/*
 * Edit user profile based on new or old values supplied. A token is necessary for security calls to the API
 */
- (NSString *)editUserProfileWithUserName:(NSString *)userName
                              password:(NSString *)password
                             firstName:(NSString *)firstName
                              lastName:(NSString *)lastName
                                 email:(NSString *)email
                                gender:(NSString *)gender
                           phoneNumber:(NSString *)phoneNumber
                               country:(NSString *)country
                               success:(void(^)())success
                               failure:(CFCeflixServiceFailure)failure;

/*
 * Upload user profile Picture.
 */
// TODO: add code for user profile picture upload
// - (NSString *)uploadProfilePictureWithToken:(NSString *)token endID:(NSString *)encID

/*
 * Load User Profile
 */
- (NSString *)loadUserProfileSuccess:(void(^)(CFUser *user))success
                               failure:(CFCeflixServiceFailure)failure;

/*
 * View User Profile for selected user
 * @param userID BASE64 Encoded userID for selected user
 */
- (NSString *)loadUserProfileWithUserID:(NSString *)userID
                                success:(void(^)(CFUser *user))success
                                failure:(CFCeflixServiceFailure)failure;

/*
 * Change Password
 */
- (NSString *)changeUserPassword:(NSString *)currentPassword
                              newPassword:(NSString *)newPassword
                                    success:(void(^)())success
                                  failure:(CFCeflixServiceFailure)failure;

/**
 * Indicates if the user is currently signed-in with the service either via 
 * sign-in or registration.
 */
- (BOOL)isUserSignedIn;

/**
 * Returns the currently signed-in user or nil if -isUserSignedIn returns NO
 */
- (CFUser *)currentUser;

/**
 * The current server this service instance is pointed at.
 */
- (NSURL *)serverRoot;

#pragma mark - Follow


/*
 * Fetch the followers of the selected user
 * @param userID The ID of the selected user
 * @param success The callback block for a successful fetch
 * @param failure The call back block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchFollowersForUser:(NSString *)userID success:(void(^)(NSArray *followers))success failure:(CFCeflixServiceFailure)failure;

/*
 * Fetch the user accounts following of the selected user
 * @param userID The ID of the selected user
 * @param success The callback block for a successful fetch
 * @param failure The call back block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchFollowingUsersForUser:(NSString *)userID success:(void(^)(NSArray *followingUsers))success failure:(CFCeflixServiceFailure)failure;



#pragma mark - Banner items

/**
 * Fetch all banner items asynchronously. If successful, the 'success' block is invoked
 * otherwise the 'failure' block is invoked
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with 
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchBannersSuccess:(void(^)(NSArray *banners))success
                          failure:(CFCeflixServiceFailure)failure;

/*
 * Fetch a specific banner with the given public ID
 * @param bannerID The public ID of the banner to fetch
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with 
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchBannerWithID:(NSString *)bannerID
                        success:(void(^)(CFBanner *banner))success
                        failure:(CFCeflixServiceFailure)failure;


#pragma mark - Video items

/**
 * Fetch all popular videos asynchronously. If successful, the 'success' block is invoked
 * otherwise the 'failure' block is invoked
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchPopularVideosSuccess:(void(^)(NSArray *popularVideos))success
                                failure:(CFCeflixServiceFailure)failure;

/**
 * Fetch all live videos asynchronously. If successful, the 'success' block is invoked
 * otherwise the 'failure' block is invoked
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchLiveVideosSuccess:(void(^)(NSArray *liveVideos))success
                             failure:(CFCeflixServiceFailure)failure;

/**
 * Asynchronously fetches all related videos for a given video
 * @param videoID The public identifier of the chatroom to fetch messages from
 * @param success The callback block if fetching succeeds
 * @param failure The callback block if fetching fails
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchRelatedVideosForVideo:(NSString *)videoID
                                 success:(void(^)(NSArray *relatedVideos))success
                                 failure:(CFCeflixServiceFailure)failure;

/**
 * Fetch the content of Home screen asynchronously. If successful, the 'success' block is invoked
 * otherwise the 'failure' block is invoked
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchHomeScreenContentSuccess:(void(^)(NSDictionary *homeScreenContent))success
                                    failure:(CFCeflixServiceFailure)failure;

/*
 * Get the details of a video based on the videoID
 * @param videoID The video ID of the video to fetch
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)getVideoDetailsWithID:(NSString *)videoID
                            success:(void (^)(NSArray *video))success
                            failure:(CFCeflixServiceFailure)failure;

/*
 * Fetch watch later videos for currently logged in user
 * @param userID The ID of the selected user
 * @param success The callback block for a successful fetch
 * @param failure The call back block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchWatchLaterVideosForUser:(NSString *)userID success:(void(^)(NSArray *watchLaterVideos))success failure:(CFCeflixServiceFailure)failure;

#pragma mark - Connect Videos

/*
 * Fetch the videos liked by the selected User
 * @param userID The ID of the selected user
 * @param success The callback block for a successful fetch
 * @param failure The call back block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchLikedVideosForUser:(NSString *)userID success:(void(^)(NSArray *likedVideos))success failure:(CFCeflixServiceFailure)failure;

/*
 * Fetch the videos posted by the selected user
 * @param userID The ID of the selected user
 * @param success The callback block for a successful fetch
 * @param failure The call back block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchVideosByUser:(NSString *)userID success:(void(^)(NSArray *userVideos))success failure:(CFCeflixServiceFailure)failure;


#pragma mark - Channel items

/*
 * Fetch a specific channel with the given channel ID
 * @param channelID The public ID of the channel to fetch
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchChannelWithID:(NSString *)channelID
                         success:(void(^)(NSDictionary *channel))success
                         failure:(CFCeflixServiceFailure)failure;

/*
 * Fetch videos in a  channel with the given channel ID
 * @param channelID The public ID of the channel to fetch
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchChannelVideosWithChannelID:(NSString *)channelID
                                      success:(void(^)(NSArray *videos))success
                                      failure:(CFCeflixServiceFailure)failure;

#pragma mark - Comments

/*
 * Fetch comments for a specfice video with the given video ID
 * @param videoID The public ID of the banner to fetch
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)fetchCommentsForVideo:(NSString *)videoID
                               success:(void(^)(NSArray *comments))success
                               failure:(CFCeflixServiceFailure)failure;



- (NSString *)fetchCommentsForLiveStreamVideo:(NSDictionary *)dict
                            success:(void(^)(NSArray *comments))success
                            failure:(CFCeflixServiceFailure)failure;

/*
 * Add a comment for a specific video with the given video ID and user's ID
 * @param userID The ID of currently logged in user
 * @param comment The message the user is adding to the video
 * @param videoID The public ID of the banner to fetch
 * @param success The callback block for a successful post
 * @param failure The callback block for a failed post
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)addComment:(NSString *)comment
         withRadomNumber:(NSString *)randomNumber
                forVideo:(NSString *)videoID
                  byUser:(NSString *)userID
                 success:(void(^)())success
                 failure:(CFCeflixServiceFailure)failure;

/*
 * Delete a comment with a given comment ID
 * @param commentID The ID of the comment to delete
 * @param userID The ID of currently logged in user
 * @param success The callback block for a successful post
 * @param failure The callback block for a failed post
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *)deleteComment:(NSString *)commentID
                     byUser:(NSString *)userID
                    success:(void(^)())success
                    failure:(CFCeflixServiceFailure)failure;


-(void)webservicescall:(NSDictionary*)bodydict action:(NSString *)action block:(ServiceCall)block;


#pragma mark - Abstract Methods

- (void)cancelRequestWithIdentifier:(NSString *)identifier;
@end

@interface CFCeflixService (SubclassRequirements)

- (NSString *)submitRequestWithURL:(NSURL *)URL
                            method:(NSString *)httpMethod
                              body:(NSDictionary *)bodyDict
                    expectedStatus:(NSInteger)expectedStatus
                           success:(CFCeflixServiceSuccess)success
                           failure:(CFCeflixServiceFailure)failure;

- (void)cancelRequestWithIdentifier:(NSString *)identifier;

- (void)resendRequestsPendingAuthentication;

@end














