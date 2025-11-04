// Media enhancements for Mac Catalyst Twitter app
// Fixes image URLs and forces highest quality for media

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TWMediaEnhancements.h"
#import "TWRuntime.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TWMediaEnhancements

+ (void)loadFeature {
    // Hook TFSTwitterEntityMedia to fix image URLs
    [TWRuntime exchangeInstanceMethod:@"originalDisplayURL" ofClass:@"TFSTwitterEntityMedia"];
    [TWRuntime exchangeInstanceMethod:@"displayURL" ofClass:@"TFSTwitterEntityMedia"];
    [TWRuntime exchangeInstanceMethod:@"accessibilityText" ofClass:@"TFSTwitterEntityMedia"];
    
    // Hook media upload configuration
    [TWRuntime exchangeInstanceMethod:@"photoUploadHighQualityImagesSettingIsVisible" ofClass:@"TFNTwitterMediaUploadConfiguration"];
    
    // Hook slideshow for high quality images
    [TWRuntime exchangeInstanceMethod:@"_t1_shouldDisplayLoadHighQualityImageItemForImageDisplayView:highestQuality:" ofClass:@"T1SlideshowViewController"];
    [TWRuntime exchangeInstanceMethod:@"_t1_loadHighQualityActionItemWithTitle:forImageDisplayView:highestQuality:" ofClass:@"T1SlideshowViewController"];
    
    // Hook T1ImageDisplayView for high quality
    [TWRuntime exchangeInstanceMethod:@"_tfn_shouldUseHighestQualityImage" ofClass:@"T1ImageDisplayView"];
    [TWRuntime exchangeInstanceMethod:@"_tfn_shouldUseHighQualityImage" ofClass:@"T1ImageDisplayView"];
    
    // Hook T1HighQualityImagesUploadSettings
    [TWRuntime exchangeInstanceMethod:@"shouldUploadHighQualityImages" ofClass:@"T1HighQualityImagesUploadSettings"];
}

@end

@implementation NSObject (TWXMediaEnhancements)

// Fix image URLs
- (NSString *)fixImageURL:(NSString *)originalURL {
    if (originalURL && [originalURL containsString:@"pic.x.com"]) {
        return [originalURL stringByReplacingOccurrencesOfString:@"pic.x.com" withString:@"pic.twitter.com"];
    }
    return originalURL;
}

- (NSString *)TFSTwitterEntityMedia_originalDisplayURL {
    NSString *originalURL = [self TFSTwitterEntityMedia_originalDisplayURL];
    if ([self isKindOfClass:[@"TFSTwitterEntityMedia" twx_class]]) {
        return [self fixImageURL:originalURL];
    }
    return originalURL;
}

- (NSString *)TFSTwitterEntityMedia_displayURL {
    NSString *originalURL = [self TFSTwitterEntityMedia_displayURL];
    if ([self isKindOfClass:[@"TFSTwitterEntityMedia" twx_class]]) {
        return [self fixImageURL:originalURL];
    }
    return originalURL;
}

- (NSString *)TFSTwitterEntityMedia_accessibilityText {
    NSString *originalText = [self TFSTwitterEntityMedia_accessibilityText];
    if ([self isKindOfClass:[@"TFSTwitterEntityMedia" twx_class]]) {
        return [self fixImageURL:originalText];
    }
    return originalText;
}

// High quality media upload settings
- (BOOL)TFNTwitterMediaUploadConfiguration_photoUploadHighQualityImagesSettingIsVisible {
    if ([self isKindOfClass:[@"TFNTwitterMediaUploadConfiguration" twx_class]]) {
        return YES;
    }
    return [self TFNTwitterMediaUploadConfiguration_photoUploadHighQualityImagesSettingIsVisible];
}

// Slideshow high quality
- (BOOL)T1SlideshowViewController__t1_shouldDisplayLoadHighQualityImageItemForImageDisplayView:(id)view highestQuality:(BOOL)highestQuality {
    if ([self isKindOfClass:[@"T1SlideshowViewController" twx_class]]) {
        return YES;
    }
    return [self T1SlideshowViewController__t1_shouldDisplayLoadHighQualityImageItemForImageDisplayView:view highestQuality:highestQuality];
}

- (id)T1SlideshowViewController__t1_loadHighQualityActionItemWithTitle:(id)title forImageDisplayView:(id)view highestQuality:(BOOL)highestQuality {
    if ([self isKindOfClass:[@"T1SlideshowViewController" twx_class]]) {
        highestQuality = YES;
    }
    return [self T1SlideshowViewController__t1_loadHighQualityActionItemWithTitle:title forImageDisplayView:view highestQuality:highestQuality];
}

// Image display view high quality
- (BOOL)T1ImageDisplayView__tfn_shouldUseHighestQualityImage {
    if ([self isKindOfClass:[@"T1ImageDisplayView" twx_class]]) {
        return YES;
    }
    return [self T1ImageDisplayView__tfn_shouldUseHighestQualityImage];
}

- (BOOL)T1ImageDisplayView__tfn_shouldUseHighQualityImage {
    if ([self isKindOfClass:[@"T1ImageDisplayView" twx_class]]) {
        return YES;
    }
    return [self T1ImageDisplayView__tfn_shouldUseHighQualityImage];
}

// Upload settings
- (BOOL)T1HighQualityImagesUploadSettings_shouldUploadHighQualityImages {
    if ([self isKindOfClass:[@"T1HighQualityImagesUploadSettings" twx_class]]) {
        return YES;
    }
    return [self T1HighQualityImagesUploadSettings_shouldUploadHighQualityImages];
}

@end

NS_ASSUME_NONNULL_END

