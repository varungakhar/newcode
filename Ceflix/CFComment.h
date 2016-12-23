//
//  Comment.h
//  Ceflix
//
//  Created by Tobi Omotayo on 20/06/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFSerializable.h"

/**
 * The key for the publicID property
 */
extern NSString *const CommentPublicIDKey;

/**
 * The key for the text property
 */
extern NSString *const CommentTextKey;

/**
 * The key for the time property
 */
extern NSString *const CommentTimeKey;

/**
 * The key for the first name property
 */
extern NSString *const CommentFirstNameKey;

/**
 * The key for the last name property
 */
extern NSString *const CommentLastNameKey;

/**
 * The key for the profile picture property
 */
extern NSString *const CommentProfilePictureKey;

/**
 * The key for the username property
 */
extern NSString *const CommentUserNameKey;

/**
 * The key for the userID property
 */
extern NSString *const CommentUserIDKey;

/**
 * The key for the number of replies  property
 */
extern NSString *const CommentTotalRepliesKey;

/**
 * The key for the time ago property
 */
extern NSString *const CommentTimeAgoKey;


/**
 * Represents single comment
 */

@interface CFComment : NSObject <CFSerializable>

/**
 * The unique public ID used to communicate with the backend server
 */
@property (nonatomic, copy, readonly) NSString *publicID;

/**
 * The text/message for the comment
 */
@property (nonatomic, copy, readonly) NSString *comment;

/**
 * The time the comment what posted
 */
@property (nonatomic, copy, readonly) NSString *commentTime;

/**
 * The first name of the author of the comment
 */
@property (nonatomic, copy, readonly) NSString *firstName;

/**
 * The last name of the author of the comment
 */
@property (nonatomic, copy, readonly) NSString *lastName;

/**
 * The profile picture of the author of the comment
 */
@property (nonatomic, copy, readonly) NSString *profilePic;

/**
 * The username of the author of the comment
 */
@property (nonatomic, copy, readonly) NSString *userName;

/**
 * The userID of the author of the comment
 */
@property (nonatomic, copy, readonly) NSString *userID;

/**
 * The total replies to the comment
 */
@property (nonatomic, copy, readonly) NSString *totalReplies;

/**
 * The time ago of the comment
 */
@property (nonatomic, copy, readonly) NSString *timeAgo;

/**
 * Initialize a new instance with the given parameters
 */
- (instancetype)initWithPublicID:(NSString *)publicID
                         comment:(NSString *)comment
                     commentTime:(NSString *)commentTime
                       firstName:(NSString *)firstName
                        lastName:(NSString *)lastName
                      profilePic:(NSString *)profilePic
                        userName:(NSString *)userName
                          userID:(NSString *)userID
                    totalReplies:(NSString *)totalReplies
                         timeAgo:(NSString *)timeAgo;

/**
 * Initialize a new instance with the values from the given
 * dictionary using the following keys:
 * - CommentPublicIDKey (NSString)
 * - CommentTextKey (NSString)
 * - CommentTimeKey (NSString)
 * - CommentFirstNameKey (NSString)
 * - CommentLastNameKey (NSString)
 * - CommentProfilePictureKey (NSString)
 * - CommentUserNameKey (NSString)
 * - CommentUserIDKey (NSString)
 * - CommentTotalRepliesKey (NSString)
 * - CommentTimeAgoKey (NSString)
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 * Returns a dictionary representation of this instance with
 * the following keys:
 * - CommentPublicIDKey (NSString)
 * - CommentTextKey (NSString)
 * - CommentTimeKey (NSString)
 * - CommentFirstNameKey (NSString)
 * - CommentLastNameKey (NSString)
 * - CommentProfilePictureKey (NSString)
 * - CommentUserNameKey (NSString)
 * - CommentUserIDKey (NSString)
 * - CommentTotalRepliesKey (NSString)
 * - CommentTimeAgoKey (NSString)
 */
- (NSDictionary *)dictionaryRepresentation;

@end






















