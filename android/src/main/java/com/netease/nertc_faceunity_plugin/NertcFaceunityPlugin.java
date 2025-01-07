package com.netease.nertc_faceunity_plugin;

import androidx.annotation.NonNull;
import android.util.Log;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import com.netease.lava.nertc.sdk.NERtcEx;
import com.netease.lava.nertc.sdk.video.NERtcVideoFrame;
import com.faceunity.core.entity.FURenderInputData;
import com.faceunity.core.entity.FURenderOutputData;
import com.faceunity.core.enumeration.FUInputBufferEnum;
import com.faceunity.core.enumeration.FUInputTextureEnum;
import com.faceunity.core.faceunity.FURenderKit;
import com.faceunity.faceunity_plugin.FaceunityKit;

/** nertc_faceunity_plugin */
public class NertcFaceunityPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;

    private FURenderKit mFuRenderKit;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "nertc_faceunity_plugin");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
            channel = null;
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } 
        else if (call.method.equals("enableFuBeauty")) {
            Boolean flag = call.argument("enable");
            int response = enableFuBeauty(flag);
            result.success(response);
        } 
        else {
            result.notImplemented();
        }
    }

    private int enableFuBeauty(boolean enable) {
        int result = 0;
        if (enable) {
            mFuRenderKit = FURenderKit.getInstance();
            NERtcEx.getInstance().setVideoCallback(this::onVideoCallback, false);
        } else {
            NERtcEx.getInstance().setVideoCallback(null, false);
        }
        return result;
    }

    private boolean onVideoCallback(NERtcVideoFrame neRtcVideoFrame) {

        //Log.d("1213", "onVideoCallback wid: " + neRtcVideoFrame.width + " height: " + neRtcVideoFrame.height);

        if (!FaceunityKit.INSTANCE.isKitInit()) {
          Log.d("1213", "callback fail");
          return false;
        }
    
        if (neRtcVideoFrame.format != NERtcVideoFrame.Format.TEXTURE_OES) {
          Log.d("1213", "format error");
          return false;
        }
    
        int width = neRtcVideoFrame.width;
        int height = neRtcVideoFrame.height;
        FURenderInputData inputData = new FURenderInputData(width, height);
        FURenderInputData.FUTexture texture = new FURenderInputData.FUTexture(FUInputTextureEnum.FU_ADM_FLAG_EXTERNAL_OES_TEXTURE, neRtcVideoFrame.textureId);
        inputData.setTexture(texture);
    
        FURenderOutputData outputData = mFuRenderKit.renderWithInput(inputData);
        neRtcVideoFrame.format = NERtcVideoFrame.Format.TEXTURE_RGB;
        neRtcVideoFrame.textureId = outputData.getTexture().getTexId();
        
        return true;
      }
}
