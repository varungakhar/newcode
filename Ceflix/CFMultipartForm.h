//
//  CFMultipartForm.h
//  Ceflix
//
//  Created by Tobi Omotayo on 29/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Represents a multi-part for uploading data over HTTP.
 */
@interface CFMultipartForm : NSObject

/**
 * Add a simple form name-value pair
 */
- (void)addFormValue:(NSString *)value forName:(NSString *)name;

/**
 * Add PNG image data
 */
- (void)addPNGImage:(UIImage *)image forName:(NSString *)name;

/**
 * Add JPEG image data
 */
- (void)addJPEGImage:(UIImage *)image forName:(NSString *)name;

/**
 * Add file data with the given content-type
 */
- (void)addFileAtURL:(NSURL *)URL contentType:(NSString *)contentType fileName:(NSString *)fileName forName:(NSString *)name;

/**
 * Returns multi-part encoded form data for use directly in HTTP requests
 */
- (NSData *)finalizedData;

/**
 * Returns an appropriate HTTP Content-Type header value that includes
 * the multipart boundary value
 */
- (NSString *)contentType;

@end
