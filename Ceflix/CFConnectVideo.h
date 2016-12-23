//
//  CFConnectVideo.h
//  Ceflix
//
//  Created by Tobi Omotayo on 12/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFVideo.h"

/**
 * A model object representing videos available for viewing on the server
 */
@interface CFConnectVideo : CFVideo

@property (nonatomic, copy, readonly) NSString *publicID;
// @property (nonatomic, strong, readonly) NSString *caption;
@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, strong, readonly) NSString *thumbnailImageURL;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, strong, readonly) NSArray *tags;
@property (nonatomic, strong, readonly) NSString *shareCount;
@property (nonatomic, strong, readonly) NSString *likeCount;
@property (nonatomic, strong, readonly) NSString *viewCount;
@property (nonatomic, strong, readonly) NSString *commentCount;

- (instancetype)initWithPublicID:(NSString *)publicID
                         caption:(NSString *)caption
                             URL:(NSURL *)URL
               thumbnailImageURL:(NSString *)thumbnailImageURL
                        duration:(NSTimeInterval)duration
                            tags:(NSArray *)tags
                      shareCount:(NSString *)shareCount
                       likeCount:(NSString *)likeCount
                       viewCount:(NSString *)viewCount
                    commentCount:(NSString *)commentCount;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
