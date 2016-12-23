//
//  CFCeflixVideo.m
//  Ceflix
//
//  Created by Tobi Omotayo on 12/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFCeflixRemoteVideo.h"
#import "CFComment.h"
#import "NSArray+Enumerable.h"

NSString *const CFDataStatusKey = @"status";
NSString *const CFDataErrorKey = @"error";
NSString *const CFDataReasonKey = @"reason";
NSString *const CFDataVideosKey = @"data";

NSString *const CFVideoPublicIDKey = @"videoID";
NSString *const CFVideoChannelIDKey = @"channelID";
NSString *const CFVideoChannelNameKey = @"channelName";
NSString *const CFVideoChannelProfilePictureKey = @"channelProfilePicture";
NSString *const CFVideoTitleKey = @"videos_title";
NSString *const CFVideoDescriptionKey = @"description";
NSString *const CFVideoThumbnailKey = @"thumbnail";
NSString *const CFVideoIsLiveKey = @"isLive";
NSString *const CFVideoURLKey = @"url";
NSString *const CFVideoViewsKey = @"views";
NSString *const CFVideoCommentsKey = @"comments";

@interface CFCeflixRemoteVideo ()

@property (nonatomic, copy, readwrite) NSString *publicID;
@property (nonatomic, copy, readwrite) NSString *channelID;
@property (nonatomic, copy, readwrite) NSString *channelName;
@property (nonatomic, copy, readwrite) NSString *channelProfilePicture;
@property (nonatomic, copy, readwrite) NSString *isLive;
@property (nonatomic, copy, readwrite) NSString *thumbnail;
@property (nonatomic, copy, readwrite) NSString *videoURL;
@property (nonatomic, copy, readwrite) NSArray *comments;

@end

@implementation CFCeflixRemoteVideo

- (instancetype)initWithPublicID:(NSString *)publicID
                       channelID:(NSString *)channelID
                     channelName:(NSString *)channelName
           channelProfilePicture:(NSString *)channelProfilePicture
                           title:(NSString *)title
                videoDescription:(NSString *)videoDescription
                          isLive:(NSString *)isLive
                       thumbnail:(NSString *)thumbnail
                        videoURL:(NSString *)videoURL
                           views:(NSString *)views {
    
    if ((self = [super initWithTitle:title videoDescription:videoDescription])) {
        self.publicID = publicID;
        self.channelID = channelID;
        self.channelName = channelName;
        self.channelProfilePicture = channelProfilePicture;
        self.isLive = isLive;
        self.thumbnail = thumbnail;
        self.videoURL = videoURL;
        self.views = views;
    }
    
    return self;
}

- (instancetype)initWithEventId:(NSString *)eventId
                       username:(NSString *)username
                     timeago:(NSString *)timeago
           eventDesc:(NSString *)eventDesc
               numberOfComments:(NSString *)numberOfComments thumbnail:(NSString*)thumbnail profile:(NSString *)profile views:(NSString*)views firstname:(NSString*)firstname lastname:(NSString*)lastname
{
    
        self.eventId = eventId;
        self.username = username;
        self.eventDesc = eventDesc;
        self.timeago = timeago;
        self.numberOfComments = numberOfComments;
        self.thumbnail=thumbnail;
        self.channelProfilePicture=profile;
        self.views=views;
        self.firstname=firstname;
        self.lastname=lastname;
    
    return self;
}

- (id)initWithLiveStreamDictionary:(NSDictionary *)dictionary
{
    
    return [self initWithEventId:[dictionary valueForKey:@"eventID"] username:[dictionary valueForKey:@"username"] timeago:[dictionary valueForKey:@"timeAgo"] eventDesc:[dictionary valueForKey:@"eventDesc"] numberOfComments:[dictionary valueForKey:@"numOfComments"] thumbnail:[dictionary valueForKey:@"thumbnail"] profile:[dictionary valueForKey:@"profile_pic"] views:[dictionary valueForKey:@"views"] firstname:[dictionary valueForKey:@"fname"] lastname:[dictionary valueForKey:@"lname"]];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    return [self initWithPublicID:dictionary[CFVideoPublicIDKey]
                        channelID:dictionary[CFVideoChannelIDKey]
                      channelName:dictionary[CFVideoChannelNameKey]
            channelProfilePicture:dictionary[CFVideoChannelProfilePictureKey]
                            title:dictionary[CFVideoTitleKey]
                 videoDescription:dictionary[CFVideoDescriptionKey]
                           isLive:dictionary[CFVideoIsLiveKey]
                        thumbnail:dictionary[CFVideoThumbnailKey]
                         videoURL:dictionary[CFVideoURLKey]
                            views:dictionary[CFVideoViewsKey]];
    
}

- (NSDictionary *)dictionaryRepresentationForLiveStream {
    


    return @{
             @"eventID": self.eventId,
             @"username": self.username,
             @"timeAgo": self.timeago,
             @"eventDesc": self.eventDesc,
             @"numOfComments": self.numberOfComments,
             @"thumbnail": self.thumbnail,
             @"views":self.views,
             @"fname":self.firstname,
             @"lname":self.lastname
             };
    
}



- (NSDictionary *)dictionaryRepresentation {
    
    NSArray *commentDicts = [self.comments mappedArrayWithBlock:^id(id obj)
    {
        return [(CFComment *)obj dictionaryRepresentation];
    }];
    
    return @{
             CFVideoPublicIDKey: self.publicID,
             CFVideoChannelIDKey: self.channelID,
             CFVideoChannelNameKey: self.channelName,
             CFVideoChannelProfilePictureKey: self.channelProfilePicture,
             CFVideoTitleKey: self.title,
             CFVideoDescriptionKey: self.videoDescription,
             CFVideoIsLiveKey: self.isLive,
             CFVideoThumbnailKey: self.thumbnail,
             CFVideoURLKey: self.videoURL,
             CFVideoViewsKey: self.views,
             CFVideoCommentsKey: commentDicts
             };
    
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<0x%x %@ publicID=%@ title=%@", (unsigned int)self, NSStringFromClass([self class]), self.publicID, self.title];
    
}

@end
