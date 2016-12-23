//
//  CFConnectVideo.m
//  Ceflix
//
//  Created by Tobi Omotayo on 10/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFConnectTimelineItem.h"
#import "CFUser.h"
#import "CFConnectVideo.h"

static NSString *const CFConnectItemVideoType = @"_type";
static NSString *const CFConnectItemUserID = @"user_id";
static NSString *const CFConnectItemUserData = @"user_data";
static NSString *const CFConnectItemTimeStamp = @"time_stamp";
static NSString *const CFConnectItemVideoData = @"video_data";

@interface CFConnectTimelineItem ()

@property (nonatomic, copy, readwrite) NSString *videoType;
@property (nonatomic, strong, readwrite) NSString *userID;
@property (nonatomic, strong, readwrite) CFUser *userData;
@property (nonatomic, strong, readwrite) NSDate *timeStamp;
@property (nonatomic, strong, readwrite) CFConnectVideo *videoData;

@end

@implementation CFConnectTimelineItem

- (instancetype)initWithVideoType:(NSString *)videoType
                           userID:(NSString *)userID
                         userData:(CFUser *)userData
                        timeStamp:(NSDate *)timeStamp
                        videoData:(CFConnectVideo *)videoData {
    if ((self = [super init])) {
        self.videoType = videoType;
        self.userID = userID;
        self.userData = userData;
        self.timeStamp = timeStamp;
        self.videoData = videoData;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    CFUser *userFromDict = [[CFUser alloc] initWithDictionary:dict[CFConnectItemUserData]];
    CFConnectVideo *videoFromDict = [[CFConnectVideo alloc] initWithDictionary:dict[CFConnectItemVideoData]];
    
    return [self initWithVideoType:dict[CFConnectItemVideoType]
                            userID:dict[CFConnectItemUserID]
                          userData:userFromDict
                         timeStamp:[[self class]
                                    dateFromString:dict[CFConnectItemTimeStamp]]
                         videoData:videoFromDict];
}

- (NSDictionary *)dictionaryRepresentation {
    // CFUser *userDict = dict[CFConnectItemUserData];
    // CFConnectVideo *videoDict = dict[CFConnectItemVideoData];
    
    return @{
             CFConnectItemVideoType: self.videoType,
             CFConnectItemUserID: self.userID,
             CFConnectItemUserData: self.userData,
             CFConnectItemTimeStamp: [[self class] stringFromDate:self.timeStamp],
             CFConnectItemVideoData: self.videoData
             };
}

#pragma mark - Date formatting

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    });
    
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [[self dateFormatter] dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return [[self dateFormatter] stringFromDate:date];
}

@end






