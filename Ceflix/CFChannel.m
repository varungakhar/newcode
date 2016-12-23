//
//  CFChannel.m
//  Ceflix
//
//  Created by Tobi Omotayo on 30/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFChannel.h"
#import "NSArray+Enumerable.h"
#import "CFCeflixRemoteVideo.h"

NSString *const CFChannelDataStatusKey = @"status";
NSString *const CFChannelDataErrorKey = @"error";
NSString *const CFChannelDataReasonKey = @"reason";
NSString *const CFDataChannelsKey = @"data";

NSString *const CFChannelPublicIDKey = @"id";
NSString *const CFChannelNameKey = @"channel";
NSString *const CFChannelDescriptionKey = @"description";
NSString *const CFChannelProfilePictureKey = @"profilepic";
NSString *const CFChannelSubscribersCountKey = @"SubscriberCount";
NSString *const CFChannelVideosCountKey = @"VideoCount";
// NSString *const CFChannelWebURLKey = @"url";
NSString *const CFChannelVideosKey = @"channelVideos";

@interface CFChannel ()

@property (nonatomic, copy, readwrite) NSString *publicID;
@property (nonatomic, copy, readwrite) NSString *channelName;
@property (nonatomic, copy, readwrite) NSString *channelDescription;
@property (nonatomic, copy, readwrite) NSString *channelProfilePicture;
@property (nonatomic, copy, readwrite) NSString *subscribersCount;
@property (nonatomic, copy, readwrite) NSString *videosCount;
// @property (nonatomic, copy, readwrite) NSString *webURL;
@property (nonatomic, copy, readwrite) NSArray *videos;

@end

@implementation CFChannel

- (instancetype)initWithPublicID:(NSString *)publicID
                     channelName:(NSString *)channelName
              channelDescription:(NSString *)channelDescription
                  profilePicture:(NSString *)profilePicture
                subscribersCount:(NSString *)subscribersCount
                     videosCount:(NSString *)videosCount
                          videos:(NSArray *)videos {
    
    if (self = [super init]) {
        self.publicID = publicID;
        self.channelName = channelName;
        self.channelDescription = channelDescription;
        self.channelProfilePicture = profilePicture;
        self.subscribersCount = subscribersCount;
        self.videosCount = videosCount;
        self.videos = videos;
    }
    
    return self;
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    NSArray *videosFromDict = [dictionary[CFChannelVideosKey] mappedArrayWithBlock:^id(id obj) {
        return [[CFCeflixRemoteVideo alloc] initWithDictionary:obj];
    }];
    
    return [self initWithPublicID:dictionary[CFChannelPublicIDKey]
                      channelName:dictionary[CFChannelNameKey]
               channelDescription:dictionary[CFChannelDescriptionKey]
                   profilePicture:dictionary[CFChannelProfilePictureKey]
                 subscribersCount:dictionary[CFChannelSubscribersCountKey]
                      videosCount:dictionary[CFChannelVideosCountKey]
                           videos:videosFromDict];
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSArray *videoDicts = [self.videos mappedArrayWithBlock:^id(id obj) {
        return [(CFCeflixRemoteVideo *)obj dictionaryRepresentation];
    }];
    
    return @{
             CFChannelPublicIDKey: self.publicID,
             CFChannelNameKey: self.channelName,
             CFChannelDescriptionKey: self.channelDescription,
             CFChannelProfilePictureKey: self.channelProfilePicture,
             CFChannelSubscribersCountKey: self.channelSubscribersCount,
             CFChannelVideosCountKey: self.videosCount,
             CFChannelVideosKey: videoDicts
             };
}

// TODO: Add the - (NSString *)description just like other models

@end


