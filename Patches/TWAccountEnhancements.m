// Account enhancements for Mac Catalyst Twitter app
// Enables various features like birdwatch, video zoom, voice messages, etc.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TWAccountEnhancements.h"
#import "TWRuntime.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TWAccountEnhancements

+ (void)loadFeature {
    // Hook TFNTwitterAccount to enable various features
    [TWRuntime exchangeInstanceMethod:@"hasBirdwatchNotes" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isBirdwatchPivotEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isBirdwatchConsumptionEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isVideoDynamicAdEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isVideoZoomEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isVODCaptionsEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isEditProfileUsernameEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isVitScopedNotificationsEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"isVitNotificationsFilteringEnabled" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"unretweetRequestMode" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"retweetRequestMode" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"destroyStatusRequestMode" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"updateStatusRequestMode" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"unfavoriteRequestMode" ofClass:@"TFNTwitterAccount"];
    [TWRuntime exchangeInstanceMethod:@"favoriteRequestMode" ofClass:@"TFNTwitterAccount"];
    
    // Hook TTACoreAnatomyFeatures to disable affiliate badges
    [TWRuntime exchangeInstanceMethod:@"isAffiliateBadgeEnabled" ofClass:@"TTACoreAnatomyFeatures"];
    [TWRuntime exchangeInstanceMethod:@"isVerificationV2AffiliateBadgingEnabled" ofClass:@"TTACoreAnatomyFeatures"];
    
    // Hook for undo tweet
    [TWRuntime exchangeInstanceMethod:@"shouldShowShowUndoTweetSentToast" ofClass:@"TFNTwitterToastNudgeExperimentModel"];
    
    // Hook for Chirp font
    [TWRuntime exchangeInstanceMethod:@"isChirpFontEnabled" ofClass:@"T1TFNUIConfiguration"];
}

@end

@implementation NSObject (TWXAccountEnhancements)

// TFNTwitterAccount hooks
- (BOOL)TFNTwitterAccount_isVideoDynamicAdEnabled {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return NO;
    }
    return [self TFNTwitterAccount_isVideoDynamicAdEnabled];
}

- (BOOL)TFNTwitterAccount_isVideoZoomEnabled {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return YES;
    }
    return [self TFNTwitterAccount_isVideoZoomEnabled];
}

- (BOOL)TFNTwitterAccount_isVODCaptionsEnabled {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return NO;
    }
    return [self TFNTwitterAccount_isVODCaptionsEnabled];
}

- (BOOL)TFNTwitterAccount_isEditProfileUsernameEnabled {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return YES;
    }
    return [self TFNTwitterAccount_isEditProfileUsernameEnabled];
}

- (BOOL)TFNTwitterAccount_isVitScopedNotificationsEnabled {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return NO;
    }
    return [self TFNTwitterAccount_isVitScopedNotificationsEnabled];
}

- (BOOL)TFNTwitterAccount_isVitNotificationsFilteringEnabled {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return NO;
    }
    return [self TFNTwitterAccount_isVitNotificationsFilteringEnabled];
}

- (NSUInteger)TFNTwitterAccount_unretweetRequestMode {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return 2;
    }
    return [self TFNTwitterAccount_unretweetRequestMode];
}

- (NSUInteger)TFNTwitterAccount_retweetRequestMode {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return 2;
    }
    return [self TFNTwitterAccount_retweetRequestMode];
}

- (NSUInteger)TFNTwitterAccount_destroyStatusRequestMode {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return 2;
    }
    return [self TFNTwitterAccount_destroyStatusRequestMode];
}

- (NSUInteger)TFNTwitterAccount_updateStatusRequestMode {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return 2;
    }
    return [self TFNTwitterAccount_updateStatusRequestMode];
}

- (NSUInteger)TFNTwitterAccount_unfavoriteRequestMode {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return 2;
    }
    return [self TFNTwitterAccount_unfavoriteRequestMode];
}

- (NSUInteger)TFNTwitterAccount_favoriteRequestMode {
    if ([self isKindOfClass:[@"TFNTwitterAccount" twx_class]]) {
        return 2;
    }
    return [self TFNTwitterAccount_favoriteRequestMode];
}

// TTACoreAnatomyFeatures hooks
- (BOOL)TTACoreAnatomyFeatures_isAffiliateBadgeEnabled {
    if ([self isKindOfClass:[@"TTACoreAnatomyFeatures" twx_class]]) {
        return NO;
    }
    return [self TTACoreAnatomyFeatures_isAffiliateBadgeEnabled];
}

- (BOOL)TTACoreAnatomyFeatures_isVerificationV2AffiliateBadgingEnabled {
    if ([self isKindOfClass:[@"TTACoreAnatomyFeatures" twx_class]]) {
        return NO;
    }
    return [self TTACoreAnatomyFeatures_isVerificationV2AffiliateBadgingEnabled];
}

// Undo tweet hook
- (BOOL)TFNTwitterToastNudgeExperimentModel_shouldShowShowUndoTweetSentToast {
    if ([self isKindOfClass:[@"TFNTwitterToastNudgeExperimentModel" twx_class]]) {
        return YES;
    }
    return [self TFNTwitterToastNudgeExperimentModel_shouldShowShowUndoTweetSentToast];
}

// Chirp font hook
- (BOOL)T1TFNUIConfiguration_isChirpFontEnabled {
    if ([self isKindOfClass:[@"T1TFNUIConfiguration" twx_class]]) {
        return YES;
    }
    return [self T1TFNUIConfiguration_isChirpFontEnabled];
}

@end

NS_ASSUME_NONNULL_END

