//
//  CFMultipartForm.m
//  Ceflix
//
//  Created by Tobi Omotayo on 29/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFMultipartForm.h"

static NSString *const CFBodyDataBoundary = @"ThIsIsAcOnTeNtBoUnDaRy";

@interface CFMultipartForm ()

@property (nonatomic, strong) NSMutableData *data;

@end

@implementation CFMultipartForm

- (id)init {
    if (self = [super init]) {
        self.data = [NSMutableData data];
    }
    
    return self;
}

#pragma mark - Instance Methods

- (void)addFormValue:(NSString *)value forName:(NSString *)name {
    [self appendBoundary];
    [self appendNewline];
    
    [self appendFieldNamed:name];
    [self appendNewline];
    [self appendNewline];
    
    [self.data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendNewline];
}

// to add array to the form
- (void)addArray:(NSString *)tags forName:(NSString *)name {
    [self appendBoundary];
    [self appendNewline];
    
    [self appendFieldNamed:name];
    [self.data appendData:[tags dataUsingEncoding:NSUTF8StringEncoding]];
}

// add video to the form
- (void)addVideo:(NSData *)videoData forName:(NSString *)name {
    [self appendBoundary];
    [self appendNewline];
    
    [self appendFieldNamed:name];
    [self.data appendData:[@"; filename=\"movie.mp4\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendNewline];
    [self appendContentType:@"movie/mp4"];
    
    [self appendNewline];
    [self appendNewline];
    
    [self.data appendData:videoData];
    [self appendNewline];
}

- (void)addPNGImage:(UIImage *)image forName:(NSString *)name {
    [self appendBoundary];
    [self appendNewline];
    
    [self appendFieldNamed:name];
    [self.data appendData:[@"; filename=\"image.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendNewline];
    [self appendContentType:@"image/png"];
    
    [self appendNewline];
    [self appendNewline];
    
    [self.data appendData:UIImagePNGRepresentation(image)];
    [self appendNewline];

}

- (void)addJPEGImage:(UIImage *)image forName:(NSString *)name {
    [self appendBoundary];
    [self appendNewline];
    
    [self appendFieldNamed:name];
    [self.data appendData:[@"; filename=\"image.jpeg\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendNewline];
    [self appendContentType:@"image/jpeg"];
    
    [self appendNewline];
    [self appendNewline];
    
    [self.data appendData:UIImageJPEGRepresentation(image, 1.0)];
    [self appendNewline];
}

- (void)addFileAtURL:(NSURL *)URL contentType:(NSString *)contentType fileName:(NSString *)fileName forName:(NSString *)name {
    [self appendBoundary];
    [self appendNewline];
    
    [self appendFieldNamed:name];
    [self appendContentType:contentType];
    
    [self appendNewline];
    [self appendNewline];
    
    [self.data appendData:[NSData dataWithContentsOfURL:URL]];
    [self appendNewline];
}

- (NSData *)finalizedData {
    NSMutableData *dataCopy = [NSMutableData dataWithData:self.data];
    
    NSString *finalBoundary = [NSString stringWithFormat:@"--%@--\r\n", CFBodyDataBoundary];
    [dataCopy appendData:[finalBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [NSData dataWithData:dataCopy];
}

- (NSString *)contentType {
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", CFBodyDataBoundary];
}

#pragma mark - Private Helpers

- (void)appendFieldNamed:(NSString *)name {
    NSString *string = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", name];
    [self.data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendContentType:(NSString *)contentType {
    NSString *string = [NSString stringWithFormat:@"Content-Type: %@", contentType];
    [self.data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendBoundary {
    [self.data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [self.data appendData:[CFBodyDataBoundary dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendNewline {
    [self.data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}


@end















