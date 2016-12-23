//
//  Reply.h
//  Ceflix
//
//  Created by Oluwatobi Omotayo on 2/16/16.
//  Copyright © 2016 Kindlebit Solution Pvt.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFSerializable.h"

/**
 * The Key for the publicID property
 */
extern NSString *const ReplyPublicIDKey;

/**
 * The Key for the username property
 */
extern NSString *const ReplyUserNameKey;

/**
 * The Key for the text property
 */
extern NSString *const ReplyTextKey;

/**
 * The Key for the profile picture property
 */
extern NSString *const ReplyProfilePictureKey;

/**
 * The Key for the timestamp property
 */
extern NSString *const ReplyTimestampKey;

/**
 * Represents single comment
 */
@interface CFReply : NSObject <CFSerializable>

/**
 * The unique public ID used to communicate with the backend server
 */

/**
* The username of the author of the comment
*/
@property (nonatomic, copy, readonly) NSString *userName;

/**
 * The text payload of the reply
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 * The profile picture of the author of the reply
 */
@property (nonatomic, copy, readonly) NSString *profilePic;

/**
 * The timestamp of the reply
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

/**
 * Initialize a new instance with the given parameters
 */
-(instancetype)initWithUserName:(NSString *)userName text:(NSString *)text profilePic:(NSString *)profilePic timestamp:(NSDate *)timestamp;


/**
 * Initialize a new instance with the values from the given
 * dictionary using the following keys:
 * - ReplyPublicIDKey (NSString)
 * - ReplyProfilePictureKey (NSString)
 * - ReplyUserNameKey (NSString)
 * - ReplyTextKey (NSString)
 * - ReplyTimestampKey
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 * Returns a dictionary represetation of the instance
 * with using the following keys:
 * - ReplyPublicIDKey (NSString)
 * - ReplyProfilePictureKey (NSString)
 * - ReplyUserNameKey (NSString)
 * - ReplyTextKey (NSString)
 * - ReplyTimestampKey
 */

- (NSDictionary *)dictionaryRepresentation;

@end

