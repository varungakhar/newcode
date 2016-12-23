//
//  CFVideoUpload.m
//  Ceflix
//
//  Created by Tobi Omotayo on 23/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFConnectVideoUpload.h"
#import "CFVideo.h"

static NSString * const CFVideoUploadVideo = @"video";
static NSString * const CFVideoUploadLocalVideoURL = @"localVideoURL";
static NSString * const CFVideoUploadThumbnailImageData = @"thumbnailImageData";
static NSString * const CFVideoUploadThumbnailImageSize = @"thumbnailImageSize";
static NSString * const CFVideoUploadThumbnailImageProgress = @"thumbnailImageProgress";
static NSString * const CFVideoUploadVideoContentProgress = @"videoContentProgress";
static NSString * const CFVideoUploadVideoContentSize = @"videoContentSize";
static NSString * const CFVideoUploadPreparationRequestIdentifier = @"preparationRequestIdentifier";
static NSString * const CFVideoUploadUploadRequestIdentifier = @"uploadRequestIdentifier";

@interface CFConnectVideoUpload ()

@property (nonatomic, strong, readwrite) CFVideo *video;
@property (nonatomic, strong, readwrite) UIImage *thumbnailImage;
@property (nonatomic, strong, readwrite) NSURL *localMovieURL;

@property (nonatomic, strong) NSUUID *internalIdentifier;

@property (nonatomic, strong) NSNumber *thumbnailImageSize;
@property (nonatomic, strong) NSNumber *thumbnailImageProgress;
@property (nonatomic, strong) NSNumber *videoContentSize;
@property (nonatomic, strong) NSNumber *videoContentProgress;

@end

@implementation CFConnectVideoUpload

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    CFVideo *video = [aDecoder decodeObjectOfClass:[CFVideo class] forKey:CFVideoUploadVideo];
    NSURL *localVideoURL = [aDecoder decodeObjectOfClass:[NSURL class] forKey:CFVideoUploadLocalVideoURL];
    NSData *thumbnailImageData = [aDecoder decodeObjectOfClass:[NSData class] forKey:CFVideoUploadThumbnailImageData];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailImageData];
    
    self = [self initWithVideo:video
                 localVideoURL:localVideoURL
                thumbnailImage:thumbnailImage];
    
    self.thumbnailImageSize = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:CFVideoUploadThumbnailImageSize];
    self.thumbnailImageProgress = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:CFVideoUploadThumbnailImageProgress];
    self.videoContentSize = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:CFVideoUploadVideoContentSize];
    self.videoContentProgress = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:CFVideoUploadVideoContentProgress];
    
    NSNumber *preReqID = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:CFVideoUploadPreparationRequestIdentifier];
    if (preReqID) {
        self.preparationRequestIdentifier = [preReqID unsignedIntegerValue];
    }
    
    NSNumber *uploadReqID = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:CFVideoUploadUploadRequestIdentifier];
    if (uploadReqID) {
        self.uploadRequestIdentifier = [uploadReqID unsignedIntegerValue];
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.video forKey:CFVideoUploadVideo];
    
    [aCoder encodeObject:self.localMovieURL forKey:CFVideoUploadLocalVideoURL];
    [aCoder encodeObject:UIImagePNGRepresentation(self.thumbnailImage) forKey:CFVideoUploadThumbnailImageData];
    
    if (self.thumbnailImageSize) {
        [aCoder encodeObject:self.thumbnailImageSize forKey:CFVideoUploadThumbnailImageSize];
    }
    
    if (self.thumbnailImageProgress) {
        [aCoder encodeObject:self.thumbnailImageProgress forKey:CFVideoUploadThumbnailImageProgress];
    }
    
    if (self.videoContentProgress) {
        [aCoder encodeObject:self.videoContentProgress forKey:CFVideoUploadVideoContentProgress];
    }
    
    if (self.videoContentSize) {
        [aCoder encodeObject:self.videoContentSize forKey:CFVideoUploadVideoContentSize];
    }
    
    if (self.preparationRequestIdentifier != NSNotFound) {
        [aCoder encodeObject:@(self.preparationRequestIdentifier) forKey:CFVideoUploadPreparationRequestIdentifier];
    }
    
    if (self.uploadRequestIdentifier != NSNotFound) {
        [aCoder encodeObject:@(self.uploadRequestIdentifier) forKey:CFVideoUploadUploadRequestIdentifier];
    }
}

#pragma mark - Instance Methods

- (instancetype)initWithVideo:(CFVideo *)video
                localVideoURL:(NSURL *)localVideoURL
               thumbnailImage:(UIImage *)image {
    
    if ((self = [super init])) {
        self.video = video;
        self.localMovieURL = localVideoURL;
        self.thumbnailImage = image;
        self.preparationRequestIdentifier = NSNotFound;
        self.uploadRequestIdentifier = NSNotFound;
        self.internalIdentifier = [NSUUID UUID];
    }
    
    return  self;
}

- (NSNumber *)thumbnailImageSize {
    if (_thumbnailImageSize == nil) {
        NSData *data = UIImagePNGRepresentation(self.thumbnailImage);
        _thumbnailImageSize = @([data length]);
    }
    
    return _thumbnailImageSize;
}

- (void)updateThumbnailImageProgress:(NSNumber *)progress {
    self.thumbnailImageProgress = progress;
}

- (NSNumber *)videoContentSize {
    if (_videoContentSize == nil) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error = nil;
        NSDictionary *attrs = [fm attributesOfItemAtPath:self.localMovieURL.path error:&error];
        if (attrs) {
            _videoContentSize = attrs[NSFileSize];
        }
        else {
            NSLog(@"%s ERROR unable to get file attributes file attributes for %@: %@", __PRETTY_FUNCTION__, self.localMovieURL.path, error);
        }
    }
    
    return _videoContentSize;
}

- (void)updateVideoContentProgress:(NSNumber *)progress {
    self.videoContentProgress = progress;
}

- (float)progress {
    float total = [self.videoContentSize floatValue] + [self.thumbnailImageSize floatValue];
    float soFar = [self.videoContentProgress floatValue] + [self.thumbnailImageProgress floatValue];
    return soFar / total;
}

#pragma mark - Overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%0lx %@ video=%@ localVideoURL=%@ thumbnailImage=%@ preparationRequestIndetifier=%lu uploadRequestIdentifier=%lu>", (unsigned long)self, NSStringFromClass([self class]), self.video, self.localMovieURL, self.thumbnailImage, (unsigned long)self.preparationRequestIdentifier, (unsigned long)self.uploadRequestIdentifier];
}

#pragma mark - File Persistence 

+ (NSArray *)allUploads {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fm contentsOfDirectoryAtURL:[self uploadDirectoryURL]
                       includingPropertiesForKeys:nil
                                          options:0
                                            error:&error];
    
    if (files) {
        NSMutableArray *uploads = [NSMutableArray arrayWithCapacity:files.count];
        for (NSURL *URL in files) {
            if ([URL.pathExtension isEqualToString:@"upload"]) {
                CFConnectVideoUpload *upload = [NSKeyedUnarchiver unarchiveObjectWithFile:URL.path];
                NSString *UUIDString = [[URL.path lastPathComponent] stringByDeletingPathExtension];
                upload.internalIdentifier = [[NSUUID alloc] initWithUUIDString:UUIDString];
                [uploads addObject:upload];
            }
        }
        
        return uploads;
    }
    else if (error) {
        NSLog(@"Unable to get contents for %@: %@", [self uploadDirectoryURL], error);
    }
    return [NSArray array];
}

- (BOOL)save {
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:[self archiveFileName]];
    if (success) {
        NSLog(@"Saved upload: %@", self);
    }
    
    return success;
}

- (BOOL)delete {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    BOOL removed = [fm removeItemAtPath:[self archiveFileName] error:&error];
    NSAssert(removed, @"Failed to remove %@: %@", [self archiveFileName], error);
    NSLog(@"Removed upload: %@", self);
    return removed;
}

+ (NSURL *)uploadDirectoryURL {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docDirs = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSAssert(docDirs.count == 1, @"Found more than one Documents directory. What's up with that?");
    
    NSURL *docDir = [docDirs[0] URLByAppendingPathComponent:@"Uploads"];
    
    if (! [fm fileExistsAtPath:docDir.path]) {
        NSError *error = nil;
        BOOL success = [fm createDirectoryAtURL:docDir
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error];
        
        NSAssert(success, @"Failed to create directory %@: %@", docDir, error);
    }
    
    return docDir;
}

- (NSString *)archiveFileName {
    NSURL *docURL = [[self class] uploadDirectoryURL];
    NSURL *archiveURL = [[docURL URLByAppendingPathComponent:[self.internalIdentifier UUIDString]] URLByAppendingPathExtension:@"upload"];
    return [archiveURL path];
}

#pragma mark - Helpers

+ (NSSet *)keyPathsForValuesAffectingProgress {
    return [NSSet setWithObjects:@"thumbnailImageProgress", @"videoContentProgress", nil];
}

@end











