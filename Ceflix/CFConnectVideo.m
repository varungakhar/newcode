//
//  CFConnectVideo.m
//  Ceflix
//
//  Created by Tobi Omotayo on 12/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFConnectVideo.h"
#import "NSArray+Enumerable.h"

static NSString *const CFConnectVideoPublicID = @"video_id";
static NSString *const CFConnectVideoCaption = @"caption";
static NSString *const CFConnectVideoURL = @"video_url";
static NSString *const CFConnectVideoThumbnailURL = @"thumbnail_url";
static NSString *const CFConnectVideoDuration = @"duration";
static NSString *const CFConnectVideoTags = @"tags";
static NSString *const CFConnectVideoShareCount = @"num_shares";
static NSString *const CFConnectVideoLikeCount = @"num_likes";
static NSString *const CFConnectVideoViewCount = @"num_views";
static NSString *const CFConnectVideoCommentCount = @"num_comments";

@interface CFConnectVideo ()

@property (nonatomic, copy, readwrite) NSString *publicID;
// @property (nonatomic, strong, readwrite) NSString *caption;
@property (nonatomic, strong, readwrite) NSURL *URL;
@property (nonatomic, strong, readwrite) NSString *thumbnailImageURL;
@property (nonatomic, assign, readwrite) NSTimeInterval duration;
@property (nonatomic, strong, readwrite) NSArray *tags;
@property (nonatomic, strong, readwrite) NSString *shareCount;
@property (nonatomic, strong, readwrite) NSString *likeCount;
@property (nonatomic, strong, readwrite) NSString *viewCount;
@property (nonatomic, strong, readwrite) NSString *commentCount;

@end

@implementation CFConnectVideo

- (instancetype)initWithPublicID:(NSString *)publicID
                         caption:(NSString *)caption
                             URL:(NSURL *)URL
               thumbnailImageURL:(NSString *)thumbnailImageURL
                        duration:(NSTimeInterval)duration
                            tags:(NSArray *)tags
                      shareCount:(NSString *)shareCount
                       likeCount:(NSString *)likeCount
                       viewCount:(NSString *)viewCount
                    commentCount:(NSString *)commentCount {
    if ((self = [super initWithCaption:caption])) {
        self.publicID = publicID;
        // self.caption = caption;
        self.URL = URL;
        self.thumbnailImageURL = thumbnailImageURL;
        self.duration = duration;
        self.tags = tags;
        self.shareCount = shareCount;
        self.likeCount = likeCount;
        self.viewCount = viewCount;
        self.commentCount = commentCount;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    // NSArray *tags = [dict[CFConnectVideoTags] mappedArrayWithBlock:^id(id obj) {}
    
    return [self initWithPublicID:dict[CFConnectVideoPublicID]
                          caption:dict[CFConnectVideoCaption]
                              URL:dict[CFConnectVideoURL]
                thumbnailImageURL:dict[CFConnectVideoThumbnailURL]
                         duration:[dict[CFConnectVideoDuration] doubleValue]
                             tags:dict[CFConnectVideoTags]
                       shareCount:dict[CFConnectVideoShareCount]
                        likeCount:dict[CFConnectVideoLikeCount]
                        viewCount:dict[CFConnectVideoViewCount]
                     commentCount:dict[CFConnectVideoCommentCount]];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             CFConnectVideoPublicID: self.publicID,
             CFConnectVideoCaption: self.caption,
             CFConnectVideoURL: self.URL,
             CFConnectVideoThumbnailURL: self.thumbnailImageURL,
             CFConnectVideoDuration: @(self.duration),
             CFConnectVideoTags: self.tags,
             CFConnectVideoShareCount: self.shareCount,
             CFConnectVideoLikeCount: self.likeCount,
             CFConnectVideoViewCount: self.viewCount,
             CFConnectVideoCommentCount: self.commentCount
             };
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.publicID = [aDecoder decodeObjectForKey:CFConnectVideoPublicID];
    // self.caption = [aDecoder decodeObjectForKey:CFConnectVideoCaption];
    self.URL = [aDecoder decodeObjectForKey:CFConnectVideoURL];
    self.thumbnailImageURL = [aDecoder decodeObjectForKey:CFConnectVideoThumbnailURL];
    self.duration = [[aDecoder decodeObjectForKey:CFConnectVideoDuration] doubleValue];
    self.tags = [aDecoder decodeObjectForKey:CFConnectVideoTags];
    self.shareCount = [aDecoder decodeObjectForKey:CFConnectVideoShareCount];
    self.likeCount = [aDecoder decodeObjectForKey:CFConnectVideoLikeCount];
    self.viewCount = [aDecoder decodeObjectForKey:CFConnectVideoViewCount];
    self.commentCount = [aDecoder decodeObjectForKey:CFConnectVideoCommentCount];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.publicID forKey:CFConnectVideoPublicID];
    // [aCoder encodeObject:self.caption forKey:CFConnectVideoCaption];
    [aCoder encodeObject:self.URL forKey:CFConnectVideoURL];
    [aCoder encodeObject:self.thumbnailImageURL forKey:CFConnectVideoThumbnailURL];
    [aCoder encodeObject:@(self.duration) forKey:CFConnectVideoDuration];
    [aCoder encodeObject:self.tags forKey:CFConnectVideoTags];
    [aCoder encodeObject:self.shareCount forKey:CFConnectVideoShareCount];
    [aCoder encodeObject:self.likeCount forKey:CFConnectVideoLikeCount];
    [aCoder encodeObject:self.viewCount forKey:CFConnectVideoViewCount];
    [aCoder encodeObject:self.commentCount forKey:CFConnectVideoCommentCount];
}

#pragma mark - Date Formatting

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






