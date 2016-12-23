//
//  Serializable.h
//  Ceflix
//
//  Created by Tobi Omotayo on 28/06/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CFSerializable <NSObject>

/**
 * Initialize a new instance based on the properties and structure
 * of the given dictionary
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 * Return a dictionary representing the data and structure of this 
 * object. This is effectively the inverse of -initWithDictionary
 */
- (NSDictionary *)dictionaryRepresentation;

@end
