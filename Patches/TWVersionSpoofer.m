// Version spoofing for Mac Catalyst Twitter app
// Spoofs version for onboarding requests to fix sign in

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TWVersionSpoofer.h"
#import "TWRuntime.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *spoofedVersion = @"11.0";

@implementation TWVersionSpoofer

+ (void)loadFeature {
    [TWRuntime exchangeInstanceMethod:@"setValue:forHTTPHeaderField:" ofClass:@"NSMutableURLRequest"];
}

@end

@implementation NSObject (TWVersionSpoofer)

- (void)NSMutableURLRequest_setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (![self isKindOfClass:[NSMutableURLRequest class]]) {
        [self NSMutableURLRequest_setValue:value forHTTPHeaderField:field];
        return;
    }
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)self;
    NSURL *url = request.URL;
    
    // Spoof version for onboarding requests
    if ([field isEqualToString:@"X-Twitter-Client-Version"] && 
        url && [url.absoluteString containsString:@"/1.1/onboarding/"]) {
        [self NSMutableURLRequest_setValue:spoofedVersion forHTTPHeaderField:field];
        return;
    }
    
    // Spoof user agent for onboarding requests
    if ([field isEqualToString:@"User-Agent"] && 
        url && [url.absoluteString containsString:@"/1.1/onboarding/"]) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(Twitter-[^/]+/)[0-9.]+" 
                                                                               options:0 
                                                                                 error:&error];
        if (regex && !error) {
            NSString *modifiedAgent = [regex stringByReplacingMatchesInString:value 
                                                                      options:0 
                                                                        range:NSMakeRange(0, value.length) 
                                                                 withTemplate:[NSString stringWithFormat:@"$1%@", spoofedVersion]];
            [self NSMutableURLRequest_setValue:modifiedAgent forHTTPHeaderField:field];
            return;
        }
    }
    
    [self NSMutableURLRequest_setValue:value forHTTPHeaderField:field];
}

@end

NS_ASSUME_NONNULL_END

