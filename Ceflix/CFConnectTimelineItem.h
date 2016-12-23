//
//  CFConnectVideo.h
//  Ceflix
//
//  Created by Tobi Omotayo on 10/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFVideo.h"
#import "CFConnectVideo.h"
#import "CFUser.h"

/*
 * A model object representing connect timeline item available for viewing on the server
 */
@interface CFConnectTimelineItem : NSObject

@property (nonatomic, copy, readonly) NSString *videoType;
@property (nonatomic, strong, readonly) NSString *userID;
@property (nonatomic, strong, readonly) CFUser *userData;
@property (nonatomic, strong, readonly) NSDate *timeStamp;
@property (nonatomic, strong, readonly) CFConnectVideo *videoData;

- (instancetype)initWithVideoType:(NSString *)videoType
                           userID:(NSString *)userID
                         userData:(CFUser *)userData
                        timeStamp:(NSDate *)timeStamp
                        videoData:(CFVideo *)videoData;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
