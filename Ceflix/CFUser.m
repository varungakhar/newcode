//
//  CFUser.m
//  Ceflix
//
//  Created by Tobi Omotayo on 02/07/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFUser.h"

NSString *const CFUserPublicIDKey = @"id";
NSString *const CFUserNameKey = @"username";
NSString *const CFFirstNameKey = @"fname";
NSString *const CFLastNameKey = @"lname";
NSString *const CFProfilePictureKey = @"profile_pic";
NSString *const CFCountryKey = @"country";
NSString *const CFGenderKey = @"gender";
NSString *const CFPhoneNumberKey = @"phone";
NSString *const CFUserBioKey = @"bio";
NSString *const CFFollowersCountKey = @"num_followers";
NSString *const CFFolloweesCountKey = @"num_followees";
NSString *const CFLikeCountKey = @"num_likes";
NSString *const CFVideoCountKey = @"num_videos";
NSString *const CFFollowsYouKey = @"follows_you";
NSString *const CFYouFollowKey = @"you_follow";

@interface CFUser ()

@property (nonatomic, copy, readwrite) NSString *userPublicID;
@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *userFirstName;
@property (nonatomic, copy, readwrite) NSString *userLastName;
@property (nonatomic, copy, readwrite) NSString *userProfilePicture;
@property (nonatomic, copy, readwrite) NSString *userCountry;
@property (nonatomic, copy, readwrite) NSString *userGender;
@property (nonatomic, copy, readwrite) NSString *userPhoneNumber;
@property (nonatomic, copy, readwrite) NSString *userBio;
@property (nonatomic, copy, readwrite) NSString *userFollowersCount;
@property (nonatomic, copy, readwrite) NSString *userFolloweesCount;
@property (nonatomic, copy, readwrite) NSString *userLikeCount;
@property (nonatomic, copy, readwrite) NSString *userVideoCount;
@property (nonatomic, copy, readwrite) NSString *userFollowsYou;
@property (nonatomic, copy, readwrite) NSString *userYouFollow;

@end

@implementation CFUser

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
                   userYouFollow:(NSString *)userYouFollow {
    
    if ((self = [super init])) {
        self.userPublicID = publicID;
        self.userName = userName;
        self.userFirstName = userFirstName;
        self.userLastName = userLastName;
        self.userProfilePicture = userProfilePicture;
        self.userCountry = userCountry;
        self.userGender = userGender;
        self.userPhoneNumber = userPhoneNumber;
        self.userBio = userBio;
        self.userFollowersCount = userFollowersCount;
        self.userFolloweesCount = userFolloweesCount;
        self.userLikeCount = userLikeCount;
        self.userVideoCount = userVideoCount;
        self.userFollowsYou = userFollowsYou;
        self.userYouFollow = userYouFollow;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    return [self initWithPublicID:dict[CFUserPublicIDKey]
                         userName:dict[CFUserNameKey]
                        userFirstName:dict[CFFirstNameKey]
                         userLastName:dict[CFLastNameKey]
                   userProfilePicture:dict[CFProfilePictureKey]
                          userCountry:dict[CFCountryKey]
                           userGender:dict[CFGenderKey]
                      userPhoneNumber:dict[CFPhoneNumberKey]
                              userBio:dict[CFUserBioKey]
                   userFollowersCount:dict[CFFollowersCountKey]
                   userFolloweesCount:dict[CFFolloweesCountKey]
                        userLikeCount:dict[CFLikeCountKey]
                       userVideoCount:dict[CFVideoCountKey]
                       userFollowsYou:dict[CFFollowsYouKey]
                        userYouFollow:dict[CFYouFollowKey]];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             CFUserPublicIDKey: self.userPublicID,
             CFUserNameKey: self.userName,
             CFFirstNameKey: self.userFirstName,
             CFLastNameKey: self.userLastName,
             CFProfilePictureKey: self.userProfilePicture,
             CFCountryKey: self.userCountry,
             CFGenderKey: self.userGender,
             CFPhoneNumberKey: self.userPhoneNumber,
             CFUserBioKey: self.userBio,
             CFFollowersCountKey: self.userFollowersCount,
             CFFolloweesCountKey: self.userFolloweesCount,
             CFLikeCountKey: self.userLikeCount,
             CFVideoCountKey: self.userVideoCount,
             CFFollowsYouKey: self.userFollowsYou,
             CFYouFollowKey: self.userYouFollow
             };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: 0x%x publicID=%@ userName=%@>",
            NSStringFromClass([self class]),
            (unsigned int)self,
            self.userPublicID, self.userName];
}

@end
