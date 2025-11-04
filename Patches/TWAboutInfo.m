// Extended About Settings info with patcher version
// Adds TwitterX version info to Twitter's About Settings screen

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import "TWAboutInfo.h"
#import "TWRuntime.h"

NS_ASSUME_NONNULL_BEGIN

// Category to add iOS-style section/row properties to NSIndexPath on macOS
@interface NSIndexPath (TWXTableView)
@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, readonly) NSInteger row;
@end

@implementation NSIndexPath (TWXTableView)

- (NSInteger)section {
    if (self.length >= 1) {
        return [self indexAtPosition:0];
    }
    return 0;
}

- (NSInteger)row {
    if (self.length >= 2) {
        return [self indexAtPosition:1];
    }
    return 0;
}

@end

static NSString *_patcherVersion = nil;
static NSString *_originalAppVersion = nil;

@implementation TWAboutInfo

+ (void)loadFeature {
    NSLog(@"[TWAboutInfo] Loading about info feature...");
    
    // Get patcher version from TwitterX framework bundle
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    _patcherVersion = [frameworkBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (!_patcherVersion) {
        _patcherVersion = @"Unknown";
    }
    
    // Get original app version
    _originalAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSLog(@"[TWAboutInfo] Patcher version: %@", _patcherVersion);
    NSLog(@"[TWAboutInfo] Original app version: %@", _originalAppVersion);
    
    // Hook T1AboutSettingsViewController
    [TWRuntime exchangeInstanceMethod:@"setSections:" ofClass:@"T1AboutSettingsViewController"];
    [TWRuntime exchangeInstanceMethod:@"tableView:cellForRowAtIndexPath:" ofClass:@"T1AboutSettingsViewController"];
    
    NSLog(@"[TWAboutInfo] About info feature loaded");
}

+ (NSString *)patcherVersion {
    return _patcherVersion ?: @"Unknown";
}

@end

@implementation NSObject (TWAboutInfo)

// T1AboutSettingsViewController hooks
- (void)T1AboutSettingsViewController_setSections:(NSArray *)sections {
    // Only modify sections if this is actually T1AboutSettingsViewController
    Class targetClass = [@"T1AboutSettingsViewController" twx_class];
    if (targetClass && [self isKindOfClass:targetClass] && _originalAppVersion && sections.count > 0) {
        NSMutableArray *modifiedSections = [NSMutableArray arrayWithArray:sections];
        
        // Get the first section and add our custom item
        if (modifiedSections[0] && [modifiedSections[0] isKindOfClass:[NSArray class]]) {
            NSMutableArray *firstSection = [NSMutableArray arrayWithArray:modifiedSections[0]];
            
            // Insert patcher version item at index 1
            [firstSection insertObject:@"PatcherVersion" atIndex:1];
            
            // Replace the first section
            [modifiedSections replaceObjectAtIndex:0 withObject:[firstSection copy]];
        }
        
        sections = [modifiedSections copy];
    }
    
    [self T1AboutSettingsViewController_setSections:sections];
}

- (id)T1AboutSettingsViewController_tableView:(id)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class targetClass = [@"T1AboutSettingsViewController" twx_class];
    if (targetClass && [self isKindOfClass:targetClass] && _originalAppVersion && indexPath.section == 0) {
        if (indexPath.row == 0) {
            // Modify the existing version cell to show original version
            id cell = [self T1AboutSettingsViewController_tableView:tableView cellForRowAtIndexPath:indexPath];
            
            @try {
                id textLabel = [cell valueForKey:@"textLabel"];
                if (textLabel) {
                    [textLabel setValue:@"App Version" forKey:@"text"];
                }
                id detailTextLabel = [cell valueForKey:@"detailTextLabel"];
                if (detailTextLabel) {
                    [detailTextLabel setValue:_originalAppVersion forKey:@"text"];
                }
            } @catch (NSException *exception) {
                NSLog(@"[TWXAboutInfo] Error modifying cell: %@", exception);
            }
            
            return cell;
        } else if (indexPath.row == 1) {
            Class TFNTextCell = [@"TFNTextCell" twx_class];
            if (TFNTextCell) {
                SEL selector = NSSelectorFromString(@"value1CellForTableView:indexPath:withText:detailText:accessoryType:");
                if ([TFNTextCell respondsToSelector:selector]) {
                    NSMethodSignature *signature = [TFNTextCell methodSignatureForSelector:selector];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    
                    [invocation setTarget:TFNTextCell];
                    [invocation setSelector:selector];
                    [invocation setArgument:&tableView atIndex:2];
                    [invocation setArgument:&indexPath atIndex:3];
                    
                    NSString *text = @"Patcher Version";
                    [invocation setArgument:&text atIndex:4];
                    
                    NSString *detailText = _patcherVersion;
                    [invocation setArgument:&detailText atIndex:5];
                    
                    NSInteger accessoryType = 0;
                    [invocation setArgument:&accessoryType atIndex:6];
                    
                    [invocation invoke];
                    
                    id __unsafe_unretained patcherCell;
                    [invocation getReturnValue:&patcherCell];
                    @try {
                        NSInteger selectionStyle = 0; // UITableViewCellSelectionStyleNone
                        [patcherCell setValue:@(selectionStyle) forKey:@"selectionStyle"];
                    } @catch (NSException *exception) {
                    }
                    
                    return patcherCell;
                }
            }
        }
    }
    
    return [self T1AboutSettingsViewController_tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

NS_ASSUME_NONNULL_END



