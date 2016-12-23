//
//  CFAPIClient.h
//  Ceflix
//
//  Created by Tobi Omotayo on 14/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CFConnectVideo;
@class CFCeflixRemoteVideo;

/**
 * A notification posted when any upload progress occurs. The object
 * of the notification is a NSNumber wrapping the unique request
 * identifier (NSUInteger). The userInfo dictionary contains two keys:
 * CFAPIClientUploadBytesUploaded and CFAPIClientUploadTotalBytesToUpload.
 */
extern NSString *const CFAPIClientUploadProgressNotification;

/**
 * A key to the userInfo dictionary for a CFAPIClientUploadProgressNotification
 * which is a NSNumber instance reporting the total number of bytes uploaded 
 * so far.
 */
extern NSString *const CFAPIClientUploadBytesUploaded;

/**
 * A key to the userInfo dictionary for CFAPIClientUploadProgressNotification
 * which is a NSNumber instance reporting the total number of bytes to upload.
 */
extern NSString *const CFAPIClientUploadTotalBytesToUpload;

/**
 * A notification posted when a background upload completes. The object
 * of the notification is a NSNumber wrapping the unique request indentifier
 * (NSUInteger). The userInfo dictionary is empty.
 */
extern NSString *const CFAPIClientBackgroundUploadCompletedNotification;

/**
 * A notification posted when a background upload fails. The object 
 * of the notification is a NSNumber wrapping unique request identifier
 * (NSUInteger). The userInfo dictionary contains a single object which 
 * is the underlying error (using the CFAPIClientBackgroundRequestFailedErrorKey)
 */
extern NSString *const CFAPIClientBackgroundUploadFailedNotification;

/**
 * A notification post when a new background download is started. The object
 * of the notification is an instance of VFMVideoDownload. The userInfo
 * dictionary will be nil.
 */
extern NSString * const CFAPIClientBackgroundDownloadStartedNotification;

/**
 * A notification posted when a background download completes successfully.
 * The object of the notification is a NSNumber wrapping the unique request
 * identifier (NSUInteger). The userInfo dictionary will be empty.
 */
extern NSString * const CFAPIClientBackgroundDownloadCompletedNotification;

/**
 * A notification posted when a background download fails. The object
 * will be a NSNumber instance wrapping the unique request identifier
 * (NSUInteger). The userInfo dictionary contains a single object which
 * is the underlying error (using the VFMAPIClientBackgroundRequestFailedErrorKey)
 */
extern NSString * const CFAPIClientBackgroundDownloadFailedNotification;

/**
 * A notification posted as a background download is processing. The
 * object of the notification is a NSNumber instance wrapping the unique
 * request identifier (NSUInteger). The userInfo dictionary contains two
 * keys: VFMAPIClientBackgroundBytesDownloaded and VFMAPIClientBackgroundTotalBytesToDownload
 */
extern NSString * const CFAPIClientBackgroundDownloadProgressNotification;

/**
 * The userInfo key to a NSNumber indicating the number of bytes
 * downloaded so far.
 */
extern NSString * const CFAPIClientBackgroundBytesDownloaded;

/**
 * The userInfo key to a NSNumber indicating the total number
 * of bytes to download.
 */
extern NSString * const CFAPIClientBackgroundTotalBytesToDownload;

/**
 * The key to the userInfo dictionary for the VFMAPIClientBackgroundUploadFailedNotification
 * notification to get the underlying NSError instance
 */
extern NSString * const CFAPIClientBackgroundRequestFailedErrorKey;


/**
 * A singleton class encapsulating network access to the underlying
 * CeFlix Server (for now it's just for CeFlix Connect)
 */
@interface CFAPIClient : NSObject

@property (nonatomic, strong, readonly) NSURL *endpointURL;

/**
 * Returns the single shared instance for this application. If the 
 * +setSharedInstanceEndpoint: menthod has never been invoked, this 
 * method will return nil.
 */
+ (instancetype)sharedInstance;

/**
* Sets the shared instance (returned via +sharedInstance) to a new
* instance with the given endpoint URL. The URL will be persisted
* to user-defaults and will be used to attempt to automatically
* recreate the +sharedInstance when the app is restarted.
* NB: If the shared instance already has inflight tasks, they will
* immediately be canceled and invalidated
* @param endpointURL
*/
+ (void)setSharedInstanceEndpoint:(NSURL *)endpointURL;

/**
 * Cancels the request associated with the given unique identifier
 */
- (void)cancelRequestWithIdentifier:(NSUInteger)requestID;

/**
 * Fetch the list of CeFlix connect timeline items (contains video and user data) for the currently logged in user.
 * @param success A callback block that receives an array of video model objects
 * @param failure A callback block that receives an NSError
 * @return NSUInteger identifier for the request.
 */
- (NSUInteger)fetchTimeLineItemsWithSuccess:(void(^)(NSArray *connectTimelineItems))success
                         failure:(void(^)(NSError *error))failure;

/**
 * Prepares a new video data object on the server endpoint with the given parameters.
 * If successful, the `success` block will be invoked, otherwise the
 * `error` block is invoked.
 *
 * If the call is successful, you may follow up with a call to -uploadVideoFromURL:toPath:success:failure:
 * to upload the actual movie data file.
 * @param caption (required)
 * @param thumbnail (required)
 * @param duration (required)
 * @param tags (optional)
 * @param success
 * @param error
 * @return NSUInteger identifer for the request. Can be used for cancelation.
 */
// this method is supposed to post the video attributes to the service, with thumbnail,for my own version uploadvideo is done together. so find a way to do this.
- (NSUInteger)prepareVideoWithCaption:(NSString *)caption
                            thumbnail:(UIImage *)thumbnail
                             duration:(NSString *)duration
                        tags:(NSArray *)tags
                            success:(void(^)(NSString *))success
                            failure:(void(^)(NSError *))failure;

/**
 * Uploads the video file references by `sourceURL` to the video endpoint path
 * referred to by `path`. This upload occurs in the background so success,
 * upload progress and failure are all reported via notifications.
 * @param sourceURL
 * @param path In the form of 'connect/post_video
 */
// - (NSUInteger)uploadVideoFromURL:(NSURL *)sourceURL toPath:(NSString *)path;
- (NSUInteger)uploadVideoWithCaption:(NSString *)caption
                           thumbnail:(UIImage *)thumbnail
                            duration:(NSString *)duration
                                tags:(NSString *)tags
                             fromURL:(NSURL *)sourceURL
                              toPath:(NSString *)path
                             success:(void (^)(NSString *))success
                             failure:(void (^)(NSError *))failure;

/**
 * Download the associated movie and thumbnail image files from the given
 * CFCeflixRemoteVideo. The downloading will be performed in the background even
 * when the app is offline.
 *
 * As soon as download request is made, a
 * CFAPIClientBackgroundDownloadStartedNotification will be posted.
 *
 * Download progress can be monitored by listening for
 * CFAPIClientBackgroundDownloadProgressNotification.
 *
 * If the download completes successfully a
 * CFAPIClientBackgroundDownloadCompletedNotification will be posted, otherwise
 * the client will post a CFAPIClientBackgroundDownloadFailedNotification.
 * @param video
 */
- (void)downloadMovieAndThumbnailForVideo:(CFCeflixRemoteVideo *)video;

/**
 * Indicates whether or not a background task is currently running
 * that is downloading the associated movie file
 * @param video
 * @return BOOL
 */
- (BOOL)isDownloadingMovieFromVideo:(CFCeflixRemoteVideo *)video;

/**
 * Indicates whether or not a background task is currently running
 * that is downloading the associated thumbnail image file
 * @param video
 * @return BOOL
 */
// i don't think i will be dowloading thumnail separately with the video in our own API
- (BOOL)isDownloadingThumbnailImageFromVideo:(CFCeflixRemoteVideo *)video;

/**
 * Pause any outstanding downloads for the given VFMVideoDownload instance.
 * The underlying task will be canceled and the resumption data will be
 * persisted to the download.
 */
// - (void)pauseDownloadsForVideo:(VFMVideoDownload *)download;

/**
 * Resume any previously-canceled downloads (via -pauseDownloadsForVideo:)
 * using the persisted resumption data in the given VFMVideoDownload instance.
 */
// - (void)resumeDownloadsForVideo:(VFMVideoDownload *)download;

/**
 * When invoked, any response errors are temporarily accumulated and then
 * reported to the application delegate once the underlying background session's
 * -URLSessionDidFinishEventsForBackgroundURLSession: delegate method is
 * invoked.
 */
- (void)beginTrackingReponseErrors;


@end


















