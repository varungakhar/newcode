//
//  CFChannel.h
//  Ceflix
//
//  Created by Tobi Omotayo on 30/08/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFSerializable.h"

extern NSString *const CFChannelDataStatusKey;
extern NSString *const CFChannelDataErrorKey;
extern NSString *const CFChannelDataReasonKey;
extern NSString *const CFDataChannelsKey;

/**
 * The key for the publicID property
 */
extern NSString *const CFChannelPublicIDKey;

/**
 * The key for the channel name property
 */
extern NSString *const CFChannelNameKey;

/**
 * The key for the Description property
 */
extern NSString *const CFChannelDescriptionKey;

/**
 * The dictionary key for the Channel Profile Picture property
 */
extern NSString *const CFChannelProfilePictureKey;

/**
 * The dictionary key for the Subscriber count property
 */
extern NSString *const CFChannelSubscribersCountKey;

/**
 * The key for the Videos count under channel property
 */
extern NSString *const CFChannelVideosCountKey;

/**
 * The key for the Website URL of Channel
 */
// extern NSString *const CFChannelWebURLKey;

/**
 * The dictionary key for the Videos under channel property
 */
extern NSString *const CFChannelVideosKey;


@interface CFChannel : NSObject <CFSerializable>

/**
 * The unique public ID used to communicate with the backend server
 */
@property (nonatomic, copy, readonly) NSString *publicID;

/**
 * The Channel name or title
 */
@property (nonatomic, copy, readonly) NSString *channelName;

/**
 * The Description of the Channel
 */
@property (nonatomic, copy, readonly) NSString *channelDescription;

/**
 * The profile picture (banner) url for channel
 */
@property (nonatomic, copy, readonly) NSString *profilePicture;

/**
 * The Subscribers count of the Channel
 */
@property (nonatomic, copy, readonly) NSString *channelSubscribersCount;

/**
 * The video count of the channel
 */
@property (nonatomic, copy, readonly) NSString *videosCount;

/**
 * The Web URL for the Channel if provided
 */
// @property (nonatomic, copy, readonly) NSString *channelWebURL;

/**
 * The videos under the channel
 */
@property (nonatomic, copy, readonly) NSArray *videos;

/**
 * Initialize a new instance with the given publicID, channelName, channelDescription
 * thumbnail, channelSubscriberCount, channelVideosCount, channelWebURL(coming soon) and videos
 */
- (instancetype)initWithPublicID:(NSString *)publicID channelName:(NSString *)channelName channelDescription:(NSString *)channelDescription profilePicture:(NSString *)profilePicture subscribersCount:(NSString *)subscribersCount videosCount:(NSString *)videosCount videos:(NSArray *)videos; // webURL:(NSString *)webURL;

/**
 * Initialize a new instance with the values from the given
 * dictionary using the following keys:
 * - CFChannelPublicIDKey (NSString)
 * - CFChannelNameIDKey (NSString)
 * - CFChannelDescriptionKey (NSString)
 * - CFChannelProfilePictureKey (NSString)
 * - CFChannelSubscribersCountKey (NSString)
 * - CFChannelVideosCountKey (NSString)
 * - CFChannelWebURLKey (NSString)
 * - CFChannelVideosKey (NSString)
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 * Returns a dictionary representation of this instance with
 * the following keys:
 * - CFChannelPublicIDKey (NSString)
 * - CFChannelNameIDKey (NSString)
 * - CFChannelDescriptionKey (NSString)
 * - CFChannelProfilePictureKey (NSString)
 * - CFChannelSubscribersCountKey (NSString)
 * - CFChannelVideosCountKey (NSString)
 * - CFChannelWebURLKey (NSString)
 * - CFChannelVidoesKey (NSString)
 */
- (NSDictionary *)dictionaryRepresentation;


@end












