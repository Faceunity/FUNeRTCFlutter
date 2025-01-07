#import "NertcFaceunityPlugin.h"
#import <NERtcSDK/NERtcSDK.h>
#import <FURenderKit/FURenderKit.h>

@interface NertcFaceunityPlugin () <NERtcEngineVideoFrameObserver> {
    
}

@end

@implementation NertcFaceunityPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"nertc_faceunity_plugin"
                                     binaryMessenger:[registrar messenger]];
    NertcFaceunityPlugin* instance = [[NertcFaceunityPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    //NSLog(@"func %@", call.method);
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if ([@"enableFuBeauty" isEqualToString:call.method]) {
        NSNumber *enableVal = call.arguments[@"enable"];
        //NSLog(@"enable %@", enableVal);
        int response = [self enableFuBeauty:enableVal.boolValue];
        result(@(response));
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark -- call method
- (int)enableFuBeauty:(BOOL)enable {
    int result = 0;
    if (enable) {
        result = [[NERtcEngine sharedEngine] setVideoFrameObserver:self];
    }
    else {
        result = [[NERtcEngine sharedEngine] setVideoFrameObserver:nil];
    }
    return result;
}

#pragma mark -- NERtcEngineVideoFrameObserver
- (void)onNERtcEngineVideoFrameCaptured:(CVPixelBufferRef)bufferRef rotation:(NERtcVideoRotationType)rotation {
    if (!fuIsLibraryInit()) {
        //NSLog(@"fu uninit");
        return;
    }
    
    FURenderInput *input = [[FURenderInput alloc] init];
    input.pixelBuffer = bufferRef;
    input.renderConfig.imageOrientation = 0;
    FUImageOrientation orientation = FUImageOrientationUP;
    switch (rotation) {
        case kNERtcVideoRotation_0:
            orientation = FUImageOrientationUP;
            break;
        case kNERtcVideoRotation_90:
            orientation = FUImageOrientationLeft;
            break;
        case kNERtcVideoRotation_180:
            orientation = FUImageOrientationDown;
            break;
        case kNERtcVideoRotation_270:
            orientation = FUImageOrientationRight;
            break;
        default:
            break;
    }
    input.renderConfig.imageOrientation = orientation;

    FURenderOutput *outPut = [[FURenderKit shareRenderKit] renderWithInput:input];
    [self convertPixBuffer: outPut.pixelBuffer dstPixBuffer:bufferRef];
}

- (void)convertPixBuffer:(CVPixelBufferRef) srcPixelBuffer dstPixBuffer:(CVPixelBufferRef) outPixelBuffer {
    CVPixelBufferLockBaseAddress(srcPixelBuffer, 0);
    size_t height = CVPixelBufferGetHeight(srcPixelBuffer);

    // Y分量
    void *yBaseAddress = CVPixelBufferGetBaseAddressOfPlane(srcPixelBuffer, 0);
    size_t yBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(srcPixelBuffer, 0);
    size_t yLength = yBytesPerRow * height;
    
    // UV分量
    void *uvBaseAddress = CVPixelBufferGetBaseAddressOfPlane(srcPixelBuffer, 1);
    size_t uvBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(srcPixelBuffer, 1);
    size_t uvLength = uvBytesPerRow * height / 2;
    
    CVPixelBufferUnlockBaseAddress(srcPixelBuffer, 0);
    CVPixelBufferLockBaseAddress(outPixelBuffer, 0);
    void *yBaseAddressOld = CVPixelBufferGetBaseAddressOfPlane(outPixelBuffer, 0);
    memcpy(yBaseAddressOld, yBaseAddress, yLength);
    void *uvBaseAddressOld = CVPixelBufferGetBaseAddressOfPlane(outPixelBuffer, 1);
    memcpy(uvBaseAddressOld, uvBaseAddress, uvLength);
    CVPixelBufferUnlockBaseAddress(outPixelBuffer, 0);
}

@end
