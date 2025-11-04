// Ad blocker
// Hides ads, promoted content, and unwanted timeline items

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TWAdBlocker.h"
#import "TWRuntime.h"

@protocol TWAdBlockerSelectors <NSObject>
@optional
- (BOOL)isPromoted;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_BEGIN

@implementation TWAdBlocker

+ (void)loadFeature {
    // hide ads and unwanted content
    [TWRuntime exchangeInstanceMethod:@"tableViewCellForItem:atIndexPath:" ofClass:@"TFNItemsDataViewController"];
    [TWRuntime exchangeInstanceMethod:@"tableView:heightForRowAtIndexPath:" ofClass:@"TFNItemsDataViewController"];
    [TWRuntime exchangeInstanceMethod:@"tableView:heightForHeaderInSection:" ofClass:@"TFNItemsDataViewController"];
    
    // remove fleet bar
    [TWRuntime exchangeInstanceMethod:@"_t1_initializeFleets" ofClass:@"T1HomeTimelineItemsViewController"];
}

@end

@implementation NSObject (TWXAdBlocker)

- (BOOL)shouldHideItem:(id)item {
    if (!item) return NO;
    
    // Hide promoted tweets/ads
    if ([item respondsToSelector:@selector(isPromoted)] && [item performSelector:@selector(isPromoted)]) {
        return YES;
    }
    
    NSString *itemClassName = NSStringFromClass([item classForCoder]);
    
    // Hide who to follow suggestions
    if ([itemClassName isEqualToString:@"TFNTwitterUser"] && 
        [NSStringFromClass([self class]) isEqualToString:@"T1HomeTimelineItemsViewController"]) {
        return YES;
    }
    
    if ([itemClassName isEqualToString:@"T1URTTimelineUserItemViewModel"]) {
        id scribeComponent = [item valueForKey:@"scribeComponent"];
        if ([scribeComponent isKindOfClass:[NSString class]] && 
            [scribeComponent isEqualToString:@"suggest_who_to_follow"]) {
            return YES;
        }
    }
    
    if ([itemClassName isEqualToString:@"T1Twitter.URTModuleHeaderViewModel"] ||
        [itemClassName isEqualToString:@"T1Twitter.URTTimelineCarouselViewModel"]) {
        return YES;
    }
    
    // Hide connect people footers
    if ([itemClassName isEqualToString:@"T1URTFooterViewModel"] || 
        [itemClassName isEqualToString:@"TFNTwitterModuleFooter"]) {
        NSURL *url = [item valueForKey:@"url"];
        if (url && [url.absoluteString containsString:@"connect_people"]) {
            return YES;
        }
    }
    
    return NO;
}

- (id)TFNItemsDataViewController_tableViewCellForItem:(id)item atIndexPath:(id)indexPath {
    id cell = [self TFNItemsDataViewController_tableViewCellForItem:item atIndexPath:indexPath];
    
    if (![self isKindOfClass:[@"TFNItemsDataViewController" twx_class]]) {
        return cell;
    }
    return cell;
}

- (double)TFNItemsDataViewController_tableView:(id)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self isKindOfClass:[@"TFNItemsDataViewController" twx_class]]) {
        return [self TFNItemsDataViewController_tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    id item = [self performSelector:@selector(itemAtIndexPath:) withObject:indexPath];
    
    if ([self shouldHideItem:item]) {
        return 0;
    }
    
    return [self TFNItemsDataViewController_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (double)TFNItemsDataViewController_tableView:(id)tableView heightForHeaderInSection:(long long)section {
    if (![self isKindOfClass:[@"TFNItemsDataViewController" twx_class]]) {
        return [self TFNItemsDataViewController_tableView:tableView heightForHeaderInSection:section];
    }
    
    NSArray *sections = [self valueForKey:@"sections"];
    if (sections && section < sections.count) {
        NSArray *sectionItems = sections[section];
        if (sectionItems && sectionItems.count > 0) {
            id firstItem = sectionItems[0];
            NSString *sectionClassName = NSStringFromClass([firstItem classForCoder]);
            if ([sectionClassName isEqualToString:@"TFNTwitterUser"]) {
                return 0;
            }
        }
    }
    
    return [self TFNItemsDataViewController_tableView:tableView heightForHeaderInSection:section];
}

- (void)T1HomeTimelineItemsViewController__t1_initializeFleets {
    if ([self isKindOfClass:[@"T1HomeTimelineItemsViewController" twx_class]]) {
        return;
    }
    [self T1HomeTimelineItemsViewController__t1_initializeFleets];
}

@end

NS_ASSUME_NONNULL_END

