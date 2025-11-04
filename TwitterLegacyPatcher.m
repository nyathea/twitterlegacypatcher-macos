#import "TwitterLegacyPatcher.h"
#import "TWCertificateBypass.h"
#import "TWAdBlocker.h"
#import "TWAccountEnhancements.h"
#import "TWMediaEnhancements.h"
#import "TWVersionSpoofer.h"
#import "TWAboutInfo.h"
#import "TWVerifiedStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSObject (TWX)

+ (void)load {
    NSLog(@"[LegacyPatcher] Loading patches for Mac Catalyst Twitter app...");
    
    [TWCertificateBypass loadFeature];
    [TWAdBlocker loadFeature];
    [TWAccountEnhancements loadFeature];
    [TWMediaEnhancements loadFeature];
    [TWVersionSpoofer loadFeature];
    [TWVerifiedStatus loadFeature];
    [TWAboutInfo loadFeature];
    
    NSLog(@"[LegacyPatcher] All patches loaded successfully!");
}

@end

NS_ASSUME_NONNULL_END
