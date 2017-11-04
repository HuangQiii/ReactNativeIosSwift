#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeManager,NSObject)
RCT_EXTERN_METHOD(testCall)
RCT_EXTERN_METHOD(openBundle:(NSString *)name)
RCT_EXTERN_METHOD(downloadBundle:(NSString *)name)
@end
