#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeManager,NSObject)
RCT_EXTERN_METHOD(testCall)
RCT_EXTERN_METHOD(openBundle:(NSString *)name)
RCT_EXTERN_METHOD(downloadBundle:(NSString *)name)
RCT_EXTERN_METHOD(getToken)
RCT_EXTERN_METHOD(setToken:(NSString *)token)
//RCT_EXTERN_METHOD(getConfigData:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(getConfigData:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
@end
