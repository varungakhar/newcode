//
//  Reply.m
//  Ceflix
//
//  Created by Oluwatobi Omotayo on 2/16/16.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFReply.h"

NSString *const ReplyPublicIDKey = @"id";
NSString *const ReplyUserNameKey = @"username";
NSString *const ReplyProfilePictureKey = @"profile_pic";
NSString *const ReplyTextKey = @"comment";
NSString *const ReplyTimestampKey = @"timestamp";

@interface CFReply ()

@property (nonatomic, copy, readwrite) NSString *publicID;
@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *profilePic;
@property (nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) NSDate *timestamp;

@end

@implementation CFReply

- (instancetype)initWithUserName:(NSString *)userName text:(NSString *)text profilePic:(NSString *)profilePic timestamp:(NSDate *)timestamp {
    
    if ((self = [super init])) {
        // self.publicID = publicID;
        self.userName = userName;
        self.profilePic = profilePic;
        self.text = text;
        self.timestamp = timestamp;
    }
    
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithUserName:dictionary[ReplyUserNameKey] text:dictionary[ReplyTextKey] profilePic:dictionary[ReplyProfilePictureKey] timestamp:[[self class] dateFromString:dictionary[ReplyTimestampKey]]];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             // ReplyPublicIDKey: self.publicID,
             ReplyUserNameKey: self.userName,
             ReplyProfilePictureKey: self.profilePic,
             ReplyTextKey: self.text,
             ReplyTimestampKey: self.timestamp
             };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: 0x%x publicID=%@ userName=%@ profilePic=%@ text=%@ timestamp=%@>", NSStringFromClass([self class]), (unsigned int)self, self.publicID, self.userName, self.profilePic, self.text, self.timestamp];
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

+ (NSString *)stringFromDate:(NSDate *)date {
    return [[self dateFormatter] stringFromDate:date];
}

@end















