//
//  CFCeflixVideo.h
//  Ceflix
//
//  Created by Tobi Omotayo on 12/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFVideo.h"

#import "CFSerializable.h"

extern NSString *const CFDataStatusKey;
extern NSString *const CFDataErrorKey;
extern NSString *const CFDataReasonKey;
extern NSString *const CFDataVideosKey;

/**
 * The key for the publicID property
 */
extern NSString *const CFVideoPublicIDKey;

/**
 * The key for the channelID property
 */
extern NSString *const CFVideoChannelIDKey;

/**
 * The key for the channelName property
 */
extern NSString *const CFVideoChannelNameKey;

/**
 * The key for the channel Profile Picture property
 */
extern NSString *const CFVideoChannelProfilePictureKey;

/**
 * The key for the Title property
 */
extern NSString *const CFVideoTitleKey;

/**
 * The key for the Description property
 */
extern NSString *const CFVideoDescriptionKey;

/**
 * The dictionary key for the isLive property
 */
extern NSString *const CFVideoIsLiveKey;

/**
 * The dictionary key for the VideoThumbnail property
 */
extern NSString *const CFVideoThumbnailKey;

/**
 * The dictionary key for the iOSURL property
 */
extern NSString *const CFVideoURLKey;

/**
 * The dictionary key for the Views property
 */
extern NSString *const CFVideoViewsKey;

/**
 * The dictionary key for the comments property
 */
extern NSString *const CFVideoCommentsKey;


/**
 * Represent a single video
 */

@interface CFCeflixRemoteVideo : CFVideo <CFSerializable>

/**
 * The unique public ID used to communicate with the backend server
 */
@property (nonatomic, copy, readonly) NSString *publicID;

/**
 * The Channel ID that shows the channel that the video belongs to
 */
@property (nonatomic, copy, readonly) NSString *channelID;

/**
 * The Name of the channel the video belongs to
 */
@property (nonatomic, copy, readonly) NSString *channelName;

/**
 * The URL for the Profile picture of the channel the video belongs to
 */
@property (nonatomic, copy, readonly) NSString *channelProfilePicture;

/**
 * This specifies if the video is a Live one
 */
@property (nonatomic, copy, readonly) NSString *isLive;

/**
 * The thumbnail url for video
 */
@property (nonatomic, copy, readonly) NSString *thumbnail;

/**
 * The stream URL for the video for iOS devices
 */
@property (nonatomic, copy, readonly) NSString *videoURL;

/**
 * The number of views of the video
 */
@property (nonatomic, strong) NSString *views;

/**
 * The comments for the video
 */
@property (nonatomic, copy, readonly) NSArray *comments;


@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *eventDesc;
@property (nonatomic, copy, readwrite) NSString *timeago;
@property (nonatomic, copy, readwrite) NSString *eventId;
@property (nonatomic, copy, readwrite) NSString *numberOfComments;
@property (nonatomic, copy, readwrite) NSString *firstname,*lastname;
/**
 * Initialize a new instance with the given publicID, channelID, channelName, channelProfilePicture, title, videoDescription
 * isLive, thumbnail, videoURL, views and comments
 */

- (instancetype)initWithPublicID:(NSString *)publicID channelID:(NSString *)channelID channelName:(NSString *)channelName channelProfilePicture:(NSString *)channelProfilePicture title:(NSString *)title videoDescription:(NSString *)videoDescription isLive:(NSString *)isLive thumbnail:(NSString *)thumbnail videoURL:(NSString *)videoURL views:(NSString *)views;

/**
 * Initialize a new instance with the values from the given
 * dictionary using the following keys:
 * - CFVideoPublicIDKey (NSString)
 * - CFVideoChannelIDKey (NSString)
 * - CFVideoChannelNameKey (NSString)
 * - CFVideoChannelProfilePictureKey (NSString)
 * - CFVideoTitleKey (NSString)
 * - CFVideoDescriptionKey (NSString)
 * - CFVideoIsLiveKey (NSString)
 * - CFVideoThumbnailKey (NSString)
 * - CFVideoURLKey (NSString)
 * - CFVideoViewsKey (NSString)
 * - CFVideoCommentsKey (NSString)
 */
- (id)initWithLiveStreamDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 * Returns a dictionary representation of this instance with
 * the following keys:
 * - CFVideoPublicIDKey (NSString)
 * - CFVideoChannelIDKey (NSString)
 * - CFVideoChannelNameKey (NSString)
 * - CFVideoChannelProfilePictureKey (NSString)
 * - CFVideoTitleKey (NSString)
 * - CFVideoDescriptionKey (NSString)
 * - CFVideoIsLiveKey (NSString)
 * - CFVideoThumbnailKey (NSString)
 * - CFVideoURLKey (NSString)
 * - CFVideoViewsKey (NSString)
 * - CFVideoCommentsKey (NSString)
 */
- (NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)dictionaryRepresentationForLiveStream;
@end
