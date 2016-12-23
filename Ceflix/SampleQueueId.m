//
//  SampleQueueId.m
//  Ceflix
//
//  Created by Oluwatobi Omotayo on 2/13/16.
//  Copyright © 2016 Kindlebit Solution Pvt.Ltd. All rights reserved.
//

#import "SampleQueueId.h"

@implementation SampleQueueId


-(id) initWithUrl:(NSURL*)url andCount:(int)count
{
    if (self = [super init])
    {
        self.url = url;
        self.count = count;
    }
    
    return self;
}

-(BOOL) isEqual:(id)object
{
    if (object == nil)
    {
        return NO;
    }
    
    if ([object class] != [SampleQueueId class])
    {
        return NO;
    }
    
    return [((SampleQueueId*)object).url isEqual: self.url] && ((SampleQueueId*)object).count == self.count;
}

-(NSString*) description
{
    return [self.url description];
}


@end
