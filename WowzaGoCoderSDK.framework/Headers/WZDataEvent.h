//
//  WZDataEvent.h
//  WowzaGoCoderSDK
//
//  Copyright 2007 – 2016, Wowza Media Systems, LLC.  All rights
//  reserved.
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "WZData.h"


/*!
 @class WZDataEvent
 @discussion The WZDataEvent class provides the top-level interface for encapsulating a list or map of items that represent server metadata that is sent and received by GoCoder.
 */
@interface WZDataEvent : NSObject

/*!
 *  The event name of the WZDataEvent
 */
@property (nonatomic, strong, nullable) NSString *eventName;

/*!
 *  The WZDataMap that contains the event data. If this value is set, eventListParams should be nil.
 */
@property (nonatomic, strong, nullable) WZDataMap *eventMapParams;

/*!
 *  The WZDataList that contains the event data. If this value is set, eventMapParams should be nil.
 */
@property (nonatomic, strong, nullable) WZDataList *eventListParams;

/*!
 *  Initialize a new WZDataEvent with a WZDataMap of event data
 *
 *  @param name the event name of the WZDataEvent.
 *  @param mapParams the map of event data to include in the WZDataEvent.
 *
 *  @return An instance of WZDataEvent
 */
- (nonnull instancetype) initWithName:(nonnull NSString *)name mapParams:(nonnull WZDataMap *)mapParams;

/*!
 *  Initialize a new WZDataEvent with a WZDataList of event data
 *
 *  @param name the event name of the WZDataEvent.
 *  @param listParams the list of event data to include in the WZDataEvent.
 *
 *  @return An instance of WZDataEvent
 */
- (nonnull instancetype) initWithName:(nonnull NSString *)name listParams:(nonnull WZDataList *)listParams;

@end


