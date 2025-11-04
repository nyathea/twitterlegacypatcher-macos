#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWRuntime: NSObject

+ (void)exchangeInstanceMethod:(NSString *)method ofClass:(NSString *)classString prefix:(nullable NSString *)prefix;

+ (void)exchangeInstanceMethod:(NSString *)method ofClass:(NSString *)classString;

+ (void)exchangeClassMethod:(NSString *)method ofClass:(NSString *)classString;

@end

@interface NSString (TWXRuntime)

- (Class)twx_class;

@end

@interface NSObject (TWXRuntime)

- (void)twx_performSelector:(SEL)selector value:(unsigned long long)value;

- (void)twx_performSelector:(SEL)selector withObject:(id)object value:(unsigned long long)value;

- (void)twx_invoke:(NSString*)method arg:(id)arg;

- (id)twx_invokeAndReturnValue:(NSString*)method;

@end

NS_ASSUME_NONNULL_END
