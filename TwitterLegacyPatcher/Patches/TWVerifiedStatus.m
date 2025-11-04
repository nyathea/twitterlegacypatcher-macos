//
//  TWXVerifiedStatus.m
//  TwitterX
//
//  Restores legacy verification badges for historically verified users
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "TWVerifiedStatus.h"
#import "TWRuntime.h"

NS_ASSUME_NONNULL_BEGIN

static NSSet<NSString *> *_legacyVerifiedUserIDs = nil;

@implementation TWVerifiedStatus

+ (void)loadFeature {
    NSLog(@"[TWVerifiedStatus] Loading legacy verification feature...");
    
    // Load legacy verified user IDs
    [self loadLegacyVerifiedUsers];
    
    // Hook TFSTwitterUserSource verified property
    [TWRuntime exchangeInstanceMethod:@"verified" ofClass:@"TFSTwitterUserSource"];
    
    NSLog(@"[TWVerifiedStatus] Legacy verification feature loaded with %lu verified users", (unsigned long)_legacyVerifiedUserIDs.count);
}

+ (void)loadLegacyVerifiedUsers {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [frameworkBundle pathForResource:@"legacy-verified" ofType:@"txt"];
    
    if (!filePath) {
        NSLog(@"[TWVerifiedStatus] Warning: legacy-verified.txt not found in framework bundle");
        _legacyVerifiedUserIDs = [NSSet set];
        return;
    }
    
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"[TWVerifiedStatus] Error reading legacy-verified.txt: %@", error.localizedDescription);
        _legacyVerifiedUserIDs = [NSSet set];
        return;
    }
    
    // Parse CSV and extract user IDs
    NSMutableSet<NSString *> *userIDs = [NSMutableSet set];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    
    // Skip header line (line 0)
    for (NSUInteger i = 1; i < lines.count; i++) {
        NSString *line = [lines[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (line.length == 0) {
            continue;
        }
        
        // Extract first column (user ID) from CSV
        NSRange commaRange = [line rangeOfString:@","];
        if (commaRange.location != NSNotFound) {
            NSString *userID = [line substringToIndex:commaRange.location];
            [userIDs addObject:userID];
        }
    }
    
    _legacyVerifiedUserIDs = [userIDs copy];
    NSLog(@"[TWVerifiedStatus] Loaded %lu legacy verified user IDs", (unsigned long)_legacyVerifiedUserIDs.count);
}

+ (BOOL)isLegacyVerified:(NSString *)userID {
    if (!userID || userID.length == 0) {
        return NO;
    }
    return [_legacyVerifiedUserIDs containsObject:userID];
}

@end

@implementation NSObject (TWXVerifiedStatus)

// TFSTwitterUserSource hook
- (BOOL)TFSTwitterUserSource_verified {
    // Check if this user has legacy verification
    NSNumber *userIDNumber = [self valueForKey:@"userIDNumber"];
    
    if (userIDNumber) {
        NSString *userIDString = [userIDNumber stringValue];
        BOOL isLegacyVerified = [TWVerifiedStatus isLegacyVerified:userIDString];
        
        if (isLegacyVerified) {
            return YES;
        }
    }
    
    // Fall back to original verification status
    return [self TFSTwitterUserSource_verified];
}

@end

NS_ASSUME_NONNULL_END

