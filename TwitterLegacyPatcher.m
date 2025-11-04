// The MIT License (MIT) - Copyright (c) 2018 Carlos Vidal
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
