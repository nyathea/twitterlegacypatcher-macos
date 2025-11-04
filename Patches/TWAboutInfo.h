// Extended About Settings info
// Adds version info to Twitter's About Settings screen

#import <Foundation/Foundation.h>
#import "TWFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWAboutInfo : NSObject <TWFeature>

+ (NSString *)patcherVersion;

@end

NS_ASSUME_NONNULL_END



