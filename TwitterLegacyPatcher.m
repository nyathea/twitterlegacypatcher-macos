#import "TwitterLegacyPatcher.h"
#import "TWCertificateBypass.h"
#import "TWAdBlocker.h"
#import "TWAccountEnhancements.h"
#import "TWMediaEnhancements.h"
#import "TWVersionSpoofer.h"
#import "TWAboutInfo.h"
#import "TWVerifiedStatus.h"
#import <objc/runtime.h>

static BOOL IsTwitterApp(void) {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    return [bundleID isEqualToString:@"maccatalyst.com.atebits.Tweetie2"] ||
           [bundleID hasPrefix:@"com.atebits.Tweetie"];
}

static BOOL TwitterClassesAvailable(void) {
    return NSClassFromString(@"TFNItemsDataViewController") != nil ||
           NSClassFromString(@"TNUTLSTrustEvaluator") != nil;
}

static void LoadAllPatches(void) {
    NSLog(@"[LegacyPatcher] Loading patches...");
    
    [TWCertificateBypass loadFeature];
    [TWAdBlocker loadFeature];
    [TWAccountEnhancements loadFeature];
    [TWMediaEnhancements loadFeature];
    [TWVersionSpoofer loadFeature];
    [TWVerifiedStatus loadFeature];
    [TWAboutInfo loadFeature];
    
    NSLog(@"[LegacyPatcher] All patches loaded!");
}

static void TryLoadPatches(void);

static void ScheduleRetry(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TryLoadPatches();
    });
}

static int retryCount = 0;
static const int maxRetries = 50;

static void TryLoadPatches(void) {
    if (!IsTwitterApp()) {
        return;
    }
    
    if (TwitterClassesAvailable()) {
        LoadAllPatches();
    } else if (retryCount < maxRetries) {
        retryCount++;
        ScheduleRetry();
    } else {
        LoadAllPatches();
    }
}

__attribute__((constructor))
static void init_tweak(void) {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            TryLoadPatches();
        });
    }
}

__attribute__((visibility("default")))
void LoadFunction(void *gum_interceptor) {
    (void)gum_interceptor;
}
