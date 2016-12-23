//
//  CFVideoUpload.h
//  Ceflix
//
//  Created by Tobi Omotayo on 23/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CFVideo;

/**
 * A persistent model object for tracking the progress of uploading metadata,
 * the thumbnail image and the movie file for a video to the server.
 */
@interface CFConnectVideoUpload : NSObject <NSCoding>

@property (nonatomic, strong, readonly) CFVideo *video;
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, strong, readonly) NSURL *localMovieURL;
@property (nonatomic, assign, readonly) float progress;

@property (nonatomic, assign) NSUInteger preparationRequestIdentifier; // might not be necessary
@property (nonatomic, assign) NSUInteger uploadRequestIdentifier;

- (instancetype)initWithVideo:(CFVideo *)video
                localVideoURL:(NSURL *)localVideoURL
               thumbnailImage:(UIImage *)image;

/*
 * The total size of the thumbnail image to upload
 */
- (NSNumber *)thumbnailImageSize;

/*
 * update the number of thumbnail image bytes uploaded so far
 */
- (void)updateThumbnailImageProgress:(NSNumber *)progress;

/*
 * The total size of the movie file to upload
 */
- (NSNumber *)videoContentSize;

/*
 * Update the number of bytes for the movie uploaded so far
 */
- (void)updateVideoContentProgress:(NSNumber *)progress;

/*
 * Fetch all archived upload instances from disk
 */
+ (NSArray *)allUploads;

/**
 * Persist the state of this upload instance to disk
 */
- (BOOL)save;

/**
 * Delete the persistent state of this upload from disk
 */
- (BOOL)delete;

@end
