//
//  SampleQueueId.h
//  Ceflix
//
//  Created by Oluwatobi Omotayo on 2/13/16.
//  Copyright © 2016 Kindlebit Solution Pvt.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleQueueId : NSObject

@property (readwrite) int count;
@property (readwrite) NSURL* url;

-(id) initWithUrl:(NSURL*)url andCount:(int)count;



@end
