#import <Foundation/Foundation.h>


/// Adds JSON generation to NSObject subclasses
@interface NSObject (NSObject_SBJSON)

/**
 @brief Returns a string containing the receiver encoded as a JSON fragment.

 This method is added as a category on NSObject but is only actually
 supported for the following objects:
 @li NSDictionary
 @li NSArray
 @li NSString
 @li NSNumber (also used for booleans)
 @li NSNull 
 */
- (NSString *)JSONFragment;

/**
 @brief Returns a string containing the receiver encoded in JSON.

 This method is added axs a category on NSObject but is only actually
 supported for the following objects:
 @li NSDictionary
 @li NSArray
 */
- (NSString *)JSONRepresentation;

@end

