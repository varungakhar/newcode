//
//  CFUser.h
//  Ceflix
//
//  Created by Tobi Omotayo on 02/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFSerializable.h"

/**
 * Unique identifier of the user, used to communicate with the server
 */
extern NSString *const CFUserPublicIDKey;

/**
 * A constant defining the JSON key to access the 'username' of the User
 */
extern NSString *const CFUserNameKey;

/**
 * A constant defining the JSON key to access the 'first_name' of the User
 */
extern NSString *const CFUserFirstNameKey;

/**
 * A constant defining the JSON key to access the 'last_name' of the User
 */
extern NSString *const CFUserLastNameKey;

/**
 * A constant defining the JSON key to access the 'profile picture' of the User
 */
extern NSString *const CFUserProfilePictureKey;

/**
 * A constant defining the JSON key to access the 'country' of the User
 */
extern NSString *const CFUserCountryKey;

/**
 * A constant defining the JSON key to access the 'gender' of the User
 */
extern NSString *const CFUserGenderKey;

/**
 * A constant defining the JSON key to access the 'Phone Number' of the User
 */
extern NSString *const CFUserPhoneNumberKey;

/**
 * A constant defining the JSON key to access the 'Bio' of the User
 */
extern NSString *const CFUserBioKey;

/**
 * A constant defining the JSON key to access the 'Number of Followers' of the User
 */
extern NSString *const CFUserFollowersCountKey;

/**
 * A constant defining the JSON key to access the 'Number of Followees' of the User
 */
extern NSString *const CFUserFolloweesCountKey;

/**
 * A constant defining the JSON key to access the 'Number of Video Liked' by the User
 */
extern NSString *const CFUserLikeCountKey;

/**
 * A constant defining the JSON key to access the 'Number of Videos Posted' by the User
 */
extern NSString *const CFUserVideoCountKey;

/**
 * A constant defining the JSON key to access if the user follows you
 */
extern NSString *const CFUserFollowsYouKey;

/**
 * A constant defining the JSON key to access if you're following the user
 */
extern NSString *const CFUserYouFollowKey;

@interface CFUser : NSObject <CFSerializable>

/**
 * The unique identifier of the User, used to communicate with the server
 */
@property (nonatomic, copy, readonly) NSString *userPublicID;

/**
 * The username of the User
 */
@property (nonatomic, copy, readonly) NSString *userName;

/**
 * The first name of the User
 */
@property (nonatomic, copy, readonly) NSString *userFirstName;

/**
 * The last name of the User
 */
@property (nonatomic, copy, readonly) NSString *userLastName;

/**
 * The Profile Picture of the User
 */
@property (nonatomic, copy, readonly) NSString *userProfilePicture;

/**
 * The country of the User
 */
@property (nonatomic, copy, readonly) NSString *userCountry;

/**
 * The gender of the User
 */
@property (nonatomic, copy, readonly) NSString *userGender;

/**
 * The Phone Number of the User
 */
@property (nonatomic, copy, readonly) NSString *userPhoneNumber;

/*
* The Bio of the User
*/
@property (nonatomic, copy, readonly) NSString *userBio;

/**
 * The Number of followers of the user
 */
@property (nonatomic, copy, readonly) NSString *userFollowersCount;

/**
 * The Number of followers of the user
 */
@property (nonatomic, copy, readonly) NSString *userFolloweesCount;

/**
 * The Number of videos liked by the user
 */
@property (nonatomic, copy, readonly) NSString *userLikeCount;

/**
 * The Number of videos posted by the user
 */
@property (nonatomic, copy, readonly) NSString *userVideoCount;

/**
 * The follows you boolean
 */
@property (nonatomic, copy, readonly) NSString *userFollowsYou;

/**
 * The you follow boolean
 */
@property (nonatomic, copy, readonly) NSString *userYouFollow;

/**
 * Create a new instance from constituent bits
 */
- (instancetype)initWithPublicID:(NSString *)publicID
                        userName:(NSString *)userName
                       userFirstName:(NSString *)userFirstName
                        userLastName:(NSString *)userLastName
                  userProfilePicture:(NSString *)userProfilePicture
                         userCountry:(NSString *)userCountry
                          userGender:(NSString *)userGender
                     userPhoneNumber:(NSString *)userPhoneNumber
                             userBio:(NSString *)userBio
                  userFollowersCount:(NSString *)userFollowersCount
                  userFolloweesCount:(NSString *)userFolloweesCount
                       userLikeCount:(NSString *)userLikeCount
                      userVideoCount:(NSString *)userVideoCount
                      userFollowsYou:(NSString *)userFollowsYou
                       userYouFollow:(NSString *)userYouFollow;

/**
 * Create a new instance from a dictionary using the CFUserPublicIDKey
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 * Returns a dictionary representation of a Chatter suitable 
 * for JSON serialization
 */
- (NSDictionary *)dictionaryRepresentation;

@end
