//
//  NSURL+CFLocalFile.h
//  Ceflix
//
//  Created by Tobi Omotayo on 16/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CFLocalFile)

/**
 * Returns the local filesystem equivalent of this URL instances
 * for non-file schemes. Assuming a remote path like
 * http://someserver/videos/1234-abcd/movie.mov, this method will
 * return file:///~/Downloads/videos/1234-abcd/movie.mov. Otherwise
 * it simply returns `self`
 */
- (NSURL *)localDownloadsFilesystemURL;

@end
