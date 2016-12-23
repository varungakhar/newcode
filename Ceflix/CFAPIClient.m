//
//  CFAPIClient.m
//  Ceflix
//
//  Created by Tobi Omotayo on 14/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFAPIClient.h"
#import "CFConnectTimelineItem.h"
#import "CFAPIRequest.h"
#import "AppDelegate.h"
#import "NSError+CeflixExtensions.h"
#import "NSURL+CFLocalFile.h"
#import "CFMultipartForm.h"

/**
 * The user-defaults key for the user identifier
 */
static NSString *const CFUserIdentifierKey = @"UserIdentifier";

NSString * const CFAPIClientUploadProgressNotification = @"CFAPIClientUploadProgressNotification";
NSString * const CFAPIClientUploadBytesUploaded = @"CFAPIClientUploadBytesUploaded";
NSString * const CFAPIClientUploadTotalBytesToUpload = @"CFAPIClientUploadTotalBytesToUpload";

NSString * const CFAPIClientBackgroundUploadCompletedNotification = @"CFAPIClientBackgroundUploadCompletedNotification";
NSString * const CFAPIClientBackgroundUploadFailedNotification = @"CFAPIClientBackgroundUploadFailedNotification";
NSString * const CFAPIClientBackgroundRequestFailedErrorKey = @"CFAPIClientBackgroundUploadFailedError";

NSString * const CFAPIClientBackgroundDownloadStartedNotification = @"CFAPIClientBackgroundDownloadStartedNotification";
NSString * const CFAPIClientBackgroundDownloadCompletedNotification = @"CFAPIClientBackgroundDownloadCompletedNotification";
NSString * const CFAPIClientBackgroundDownloadFailedNotification = @"CFAPIClientBackgroundDownloadFailedNotification";
NSString * const CFAPIClientBackgroundDownloadProgressNotification = @"CFAPIClientBackgroundDownloadProgressNotification";
NSString * const CFAPIClientBackgroundBytesDownloaded = @"CFAPIClientBackgroundBytesDownloaded";
NSString * const CFAPIClientBackgroundTotalBytesToDownload = @"CFAPIClientBackgroundTotalBytesToDownload";

static NSString * const CFAPIEndpointURLKey = @"EndpointURL";
static NSString * const CFAPIClientErrorDomain = @"CeflixErrorDomain";
static NSString * const CFAPIClientBackgroundSessionIdentifier = @"Ceflix Background Session";

static NSTimeInterval const CFAPIVideoPrepareTimeout = 300;
static NSTimeInterval const CFAPIVideoUploadTimeout = 600;

@interface CFAPIClient () <NSURLSessionDataDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableDictionary *tasksToRequests;
@property (nonatomic, strong) NSMutableDictionary *tasks;
@property (nonatomic, strong, readwrite) NSURL *endpointURL;
@property (nonatomic, strong) NSURLSession *defaultSession;
@property (nonatomic, strong) NSURLSession *backgroundSession;
@property (nonatomic, strong) NSMutableArray *responseErrors;

@end

@implementation CFAPIClient

- (instancetype)initWithEndpoint:(NSURL *)endpointURL {
    if ((self = [super init])) {
        self.tasksToRequests = [NSMutableDictionary dictionary];
        self.tasks = [NSMutableDictionary dictionary];
        self.endpointURL = endpointURL;
        
        // note: ditching backgroundSessionConfiguration: for this latest one because it's deprecated. so i think it still works.
        NSURLSessionConfiguration *sessionConf = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:CFAPIClientBackgroundSessionIdentifier];
        self.backgroundSession = [NSURLSession sessionWithConfiguration:sessionConf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        [self.backgroundSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
            for (NSURLSessionUploadTask *task in uploadTasks) {
                self.tasks[@(task.taskIdentifier)] = task;
            }
        }];
        
        sessionConf = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultSession = [NSURLSession sessionWithConfiguration:sessionConf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        // store last-used endpoint URL to user-defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:endpointURL.absoluteString forKey:CFAPIEndpointURLKey];
        [defaults synchronize];
    }
    return self;
}

#pragma mark - Shared Instance Methods

static CFAPIClient *SharedInstance;

+ (void)initialize {
    NSString *endpointURLString = [[NSUserDefaults standardUserDefaults] objectForKey:CFAPIEndpointURLKey];
    if (endpointURLString) {
        NSURL *endpointURL = [NSURL URLWithString:endpointURLString];
        SharedInstance = [[CFAPIClient alloc] initWithEndpoint:endpointURL];
    }
}

+ (instancetype)sharedInstance {
    return SharedInstance;
}

+ (void)setSharedInstanceEndpoint:(NSURL *)endpointURL {
    if (SharedInstance) {
        [SharedInstance shutdown];
    }
    
    SharedInstance = [[CFAPIClient alloc] initWithEndpoint:endpointURL];
}

#pragma mark - Public Methods

- (void)cancelRequestWithIdentifier:(NSUInteger)requestID {
    NSLog(@"%s canceling request with identifier: %lu", __PRETTY_FUNCTION__, (unsigned long)requestID);
    
    NSURLSessionTask *task = self.tasks[@(requestID)];
    [task cancel];
    [self.tasks removeObjectForKey:@(requestID)];
}

- (NSUInteger)fetchTimeLineItemsWithSuccess:(void(^)(NSArray *connectTimelineItems))success
                                    failure:(void(^)(NSError *error))failure {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:CFUserIdentifierKey];
    
    NSString *path = [NSString stringWithFormat:@"connect/timeline/%@", userID];
    NSURL *URL = [NSURL URLWithString:path relativeToURL:self.endpointURL];
    
    NSLog(@"%s fetching videos from %@", __PRETTY_FUNCTION__, URL);
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    [URLRequest setHTTPMethod:@"GET"];
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    void (^innerSuccess)(NSHTTPURLResponse *, NSData *) = ^(NSHTTPURLResponse *response, NSData *data) {
        NSError *error = nil;
        id resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *results = [resultDictionary objectForKey:@"data"];
        
        if (results) {
            if ([results isKindOfClass:[NSArray class]]) {
                NSMutableArray *timelineItems = [NSMutableArray array];
                for (NSDictionary *dict in results) {
                    CFConnectTimelineItem *timelineItem = [[CFConnectTimelineItem alloc] initWithDictionary:dict];
                    [timelineItems addObject:timelineItem];
                }
                
                success(timelineItems);
            }
            else {
                NSDictionary *dict = @{NSLocalizedDescriptionKey: @"Invalid JSON response"};
                error = [NSError errorWithDomain:CFAPIClientErrorDomain code:0 userInfo:dict];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    };
    
    CFAPIRequest *request = [[CFAPIRequest alloc] initWithExpectedStatusCode:200 success:innerSuccess failure:failure];
    
    NSURLSessionDataTask *dataTask = [self.defaultSession dataTaskWithRequest:URLRequest];
    self.tasksToRequests[@(dataTask.taskIdentifier)] = request;
    self.tasks[@(dataTask.taskIdentifier)] = dataTask;
    [dataTask resume];
    
    return dataTask.taskIdentifier;
}

// the real upload video should merge prepare and upload together.
- (NSUInteger)uploadVideo:(NSData *)video
              withCaption:(NSString *)caption
                           thumbnail:(UIImage *)thumbnail
                            duration:(NSString *)duration
                                tags:(NSString *)tags
                             fromURL:(NSURL *)sourceURL
                              toPath:(NSString *)path
                             success:(void (^)(NSString *))success
                             failure:(void (^)(NSError *))failure {
    
    NSAssert(caption != nil, @"Caption must be non-nil");
    NSAssert(caption.length > 0, @"Title must be non-zero length");
    NSAssert(thumbnail != nil, @"You must provide a thumbnail image");
    
    NSString *userID; // set this to user defaults encID
    
    // create the request
    NSURL *URL = [NSURL URLWithString:@"/videos" relativeToURL:self.endpointURL];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    path = [path stringByAppendingPathComponent:@"movie"];
    [URLRequest setTimeoutInterval:CFAPIVideoUploadTimeout];
    [URLRequest setHTTPMethod:@"POST"];
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [URLRequest setValue:@"movie/mp4" forHTTPHeaderField:@"Content-Type"];
    
    //create the body
    CFMultipartForm *multipart = [[CFMultipartForm alloc] init];
    [multipart addFormValue:caption forName:@"caption"];
    [multipart addFormValue:userID forName:@"user_id"];
    [multipart addFormValue:tags forName:@"tags"];
    
    NSURLSessionUploadTask *task = [self.backgroundSession uploadTaskWithRequest:URLRequest fromFile:sourceURL];
    self.tasks[@(task.taskIdentifier)] = task;
    [task resume];
    
    return task.taskIdentifier;
    
}

- (void)beginTrackingReponseErrors
{
    self.responseErrors = [NSMutableArray array];
}

#pragma mark - Private Helpers

- (void)shutdown
{
    [self.defaultSession invalidateAndCancel];
    [self.backgroundSession invalidateAndCancel];
    [self.tasksToRequests removeAllObjects];
    [self.tasks removeAllObjects];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"%s session %@ is now invalid: %@", __PRETTY_FUNCTION__, session.sessionDescription, error);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"%s session=%@", __PRETTY_FUNCTION__, session);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate invokeBackgroundTaskCompletionHandlerWithErrors:self.responseErrors];
    self.responseErrors = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"%s %@ dataTask=%@ response=%@", __PRETTY_FUNCTION__, [NSString stringWithFormat:@"%@ %@", dataTask.originalRequest.HTTPMethod, dataTask.originalRequest.URL.path], dataTask, response);
    
    CFAPIRequest *APIRequest = self.tasksToRequests[@(dataTask.taskIdentifier)];
    if (APIRequest) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        APIRequest.response = HTTPResponse;
        
        if (APIRequest.expectedStatusCode != HTTPResponse.statusCode) {
            completionHandler(NSURLSessionResponseCancel);
            
            NSDictionary *dict = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Unexpected HTTP status code: %li", (long)HTTPResponse.statusCode]};
            NSError *error = [NSError errorWithDomain:CFAPIClientErrorDomain code:0 userInfo:dict];
            if (APIRequest.failure != NULL) {
                APIRequest.failure(error);
            }
            
            [self.tasksToRequests removeObjectForKey:@(dataTask.taskIdentifier)];
            [self.tasks removeObjectForKey:@(dataTask.taskIdentifier)];
            
            return;
        }
    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%s %@ data=(%li bytes)", __PRETTY_FUNCTION__, [NSString stringWithFormat:@"%@ %@", dataTask.originalRequest.HTTPMethod, dataTask.originalRequest.URL.path], (unsigned long)data.length);
    CFAPIRequest *APIRequest = self.tasksToRequests[@(dataTask.taskIdentifier)];
    if (APIRequest) {
        [APIRequest appendData:data];
    }
}

#pragma mark - NSURLSessionTaskDelegate 

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if ([error isCancelationError]) {
        return;
    }
    
    // background tasks?
    if ([session.configuration.identifier isEqualToString:self.backgroundSession.configuration.identifier]) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        if (error) {
            [self.responseErrors addObject:error];
            NSDictionary *dict = @{CFAPIClientBackgroundRequestFailedErrorKey: error};
            
            if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
                [nc postNotificationName:CFAPIClientBackgroundUploadFailedNotification object:@(task.taskIdentifier) userInfo:dict];
            }
            else if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
                // do this later when implementing download of videos
            }
        }
        else {
            if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
                [nc postNotificationName:CFAPIClientBackgroundUploadCompletedNotification object:@(task.taskIdentifier) userInfo:nil];
            }
            else if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
                // do this later when implementing download of videos
            }
        }
    }
    // default session tasks (associated with CFAPIRequest instance)
    else {
        CFAPIRequest *APIRequest = self.tasksToRequests[@(task.taskIdentifier)];
        if (APIRequest) {
            if (error) {
                if (APIRequest.failure != NULL) {
                    APIRequest.failure(error);
                }
            }
            else {
                NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
                if (HTTPResponse.statusCode != APIRequest.expectedStatusCode) {
                    NSDictionary *dict = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Unexpected HTTP status code: %li", (long)HTTPResponse.statusCode]};
                    error = [NSError errorWithDomain:CFAPIClientErrorDomain code:0 userInfo:dict];
                    if (APIRequest.failure != NULL) {
                        APIRequest.failure(error);
                    }
                }
                else if (APIRequest.success != NULL) {
                    APIRequest.success(APIRequest.response, APIRequest.responseData);
                }
            }
        }
    }
    
    [self.tasks removeObjectForKey:@(task.taskIdentifier)];
    [self.tasksToRequests removeObjectForKey:@(task.taskIdentifier)];
    
    NSLog(@"%s %@ error=%@", __PRETTY_FUNCTION__, [NSString stringWithFormat:@"%@ %@", task.originalRequest.HTTPMethod, task.originalRequest.URL.path], error);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSURLRequest *request = task.originalRequest;
    NSString *resource = [NSString stringWithFormat:@"%@ %@", request.HTTPMethod, request.URL.path];
    NSLog(@"%s %@ (%lli/%lli/%lli)", __PRETTY_FUNCTION__, resource, bytesSent, totalBytesSent, totalBytesExpectedToSend);
    NSDictionary *userInfo = @{
                               CFAPIClientUploadBytesUploaded: @(totalBytesSent),
                               CFAPIClientUploadTotalBytesToUpload: @(totalBytesExpectedToSend)};
    [[NSNotificationCenter defaultCenter] postNotificationName:CFAPIClientUploadProgressNotification object:@(task.taskIdentifier) userInfo:userInfo];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:@"%@ %@", task.originalRequest.HTTPMethod, task.originalRequest.URL.path]);
    CFAPIRequest *APIRequest = self.tasksToRequests[@(task.taskIdentifier)];
    if (APIRequest) {
        if (! APIRequest.followRedirects) {
            completionHandler(NULL);
            return;
        }
    }
    completionHandler(request);
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%s (%lli/%lli/%lli)", __PRETTY_FUNCTION__, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    
    NSDictionary *userInfo = @{
                               CFAPIClientBackgroundBytesDownloaded: @(totalBytesWritten),
                               CFAPIClientBackgroundTotalBytesToDownload: @(totalBytesExpectedToWrite)
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:CFAPIClientBackgroundDownloadProgressNotification
                                                        object:@(downloadTask.taskIdentifier)
                                                      userInfo:userInfo];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSURL *requestURL = downloadTask.originalRequest.URL;
    NSURL *videoURL = [requestURL localDownloadsFilesystemURL];
    
    if (videoURL) {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSURL *videoParentURL = [videoURL URLByDeletingLastPathComponent];
        
        BOOL makeMove = NO;
        NSError *error = nil;
        if (! [fm fileExistsAtPath:videoParentURL.path]) {
            BOOL created = [fm createDirectoryAtPath:videoParentURL.path
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:&error];
            if (created) {
                makeMove = YES;
            }
            else {
                NSLog(@"%s ERROR failed to create directory %@: %@", __PRETTY_FUNCTION__, videoParentURL, error);
                return;
            }
        }
        else {
            makeMove = YES;
        }
        
        if (makeMove) {
            if ([fm moveItemAtURL:location toURL:videoURL error:&error]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:CFAPIClientBackgroundDownloadCompletedNotification
                                                                    object:@(downloadTask.taskIdentifier)];
            }
            else {
                NSLog(@"%s ERROR failed to move %@ to %@: %@", __PRETTY_FUNCTION__, location, videoURL, error);
            }
        }
    }
    else {
        NSLog(@"%s ERROR failed to locate downloads directory", __PRETTY_FUNCTION__);
    }
    
    [self.tasks removeObjectForKey:@(downloadTask.taskIdentifier)];
}

@end













