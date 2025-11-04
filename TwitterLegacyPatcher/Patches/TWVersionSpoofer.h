// Version spoofing for Mac Catalyst Twitter app
// Spoofs version for onboarding requests to prevent compatibility issues

#import <Foundation/Foundation.h>
#import "TWFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWVersionSpoofer : NSObject <TWFeature>

@end

NS_ASSUME_NONNULL_END

