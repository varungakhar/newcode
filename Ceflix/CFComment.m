//
//  Comment.m
//  Ceflix
//
//  Created by Oluwatobi Omotayo on 2/16/16.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFComment.h"

NSString *const CommentPublicIDKey = @"id";
NSString *const CommentTextKey = @"comment";
NSString *const CommentTimeKey = @"com_time";
NSString *const CommentFirstNameKey = @"fname";
NSString *const CommentLastNameKey = @"lname";
NSString *const CommentProfilePictureKey = @"profile_pic";
NSString *const CommentUserNameKey = @"username";
NSString *const CommentUserIDKey = @"userID";
NSString *const CommentTotalRepliesKey = @"totalreplies";
NSString *const CommentTimeAgoKey = @"timeAgo";

@interface CFComment ()

@property (nonatomic, copy, readwrite) NSString *publicID;
@property (nonatomic, copy, readwrite) NSString *comment;
@property (nonatomic, copy, readwrite) NSString *commentTime;
@property (nonatomic, copy, readwrite) NSString *firstName;
@property (nonatomic, copy, readwrite) NSString *lastName;
@property (nonatomic, copy, readwrite) NSString *profilePic;
@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *userID;
@property (nonatomic, copy, readwrite) NSString *totalReplies;
@property (nonatomic, copy, readwrite) NSString *timeAgo;

@end

@implementation CFComment

- (instancetype)initWithPublicID:(NSString *)publicID
                         comment:(NSString *)comment
                     commentTime:(NSString *)commentTime
                       firstName:(NSString *)firstName
                        lastName:(NSString *)lastName
                      profilePic:(NSString *)profilePic
                        userName:(NSString *)userName
                          userID:(NSString *)userID
                    totalReplies:(NSString *)totalReplies
                         timeAgo:(NSString *)timeAgo {
    
    if ((self = [super init])) {
        self.publicID = publicID;
        self.comment = comment;
        self.commentTime = commentTime;
        self.firstName = firstName;
        self.lastName = lastName;
        self.profilePic = profilePic;
        self.userName = userName;
        self.userID = userID;
        self.totalReplies = totalReplies;
        self.timeAgo = timeAgo;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithPublicID:dictionary[CommentPublicIDKey] comment:dictionary[CommentTextKey] commentTime:dictionary[CommentTimeKey] firstName:dictionary[CommentFirstNameKey] lastName:dictionary[CommentLastNameKey] profilePic:dictionary[CommentProfilePictureKey] userName:dictionary[CommentUserNameKey] userID:dictionary[CommentUserIDKey] totalReplies:dictionary[CommentTotalRepliesKey] timeAgo:dictionary[CommentTimeAgoKey]];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             CommentPublicIDKey: self.publicID,
             CommentTextKey: self.comment,
             CommentTimeKey: self.commentTime,
             CommentFirstNameKey: self.firstName,
             CommentLastNameKey: self.lastName,
             CommentProfilePictureKey: self.profilePic,
             CommentUserNameKey: self.userName,
             CommentUserIDKey: self.userID,
             CommentTotalRepliesKey: self.totalReplies,
             CommentTimeAgoKey: self.timeAgo
        };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: 0x%x publicID=%@ firstName=%@ lastName=%@ profilePic=%@ userName=%@ text=%@ totalReplies=%@ timestamp=%@>", NSStringFromClass([self class]), (unsigned int)self, self.publicID, self.firstName, self.lastName, self.profilePic, self.userName, self.comment, self.totalReplies, self.timeAgo];
}

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

+ (NSString *)strigFromDate:(NSDate *)date {
    return [[self dateFormatter] stringFromDate:date];
}
            
@end
            











