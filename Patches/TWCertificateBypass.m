// Certificate bypass for Mac Catalyst Twitter app
// Bypasses SSL certificate pinning

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TWCertificateBypass.h"
#import "TWRuntime.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TWCertificateBypass

+ (void)loadFeature {
    // Hook TNUTLSTrustEvaluator to bypass certificate pinning
    [TWRuntime exchangeInstanceMethod:@"_isPinnedCertificateChain:" ofClass:@"TNUTLSTrustEvaluator"];
}

@end

@implementation NSObject (TWCertificateBypass)

- (BOOL)TNUTLSTrustEvaluator__isPinnedCertificateChain:(SecTrustRef)trust {
    if ([self isKindOfClass:[@"TNUTLSTrustEvaluator" twx_class]]) {
        return YES;
    }
    return [self TNUTLSTrustEvaluator__isPinnedCertificateChain:trust];
}

@end

NS_ASSUME_NONNULL_END

