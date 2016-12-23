//
//  NSURL+CFLocalFile.m
//  Ceflix
//
//  Created by Tobi Omotayo on 16/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "NSURL+CFLocalFile.h"

@implementation NSURL (CFLocalFile)

- (NSURL *)localDownloadsFilesystemURL
{
    if ([self.scheme isEqualToString:@"file"]) {
        return self;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSURL *downloadsDirURL = [fm URLForDirectory:NSDocumentDirectory
                                        inDomain:NSUserDomainMask
                               appropriateForURL:nil
                                          create:NO
                                           error:nil];
    return [downloadsDirURL URLByAppendingPathComponent:self.path];
}

@end
