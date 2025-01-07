# 简介

本工程是网易云信NERTC接入相芯美颜flutter demo，提供美颜、瘦脸、美妆等功能。

# 用法

## 第一步：联系相芯商务获取美颜证书，然后替换下面的证书文件

### Android

faceunity_ui_flutter/faceunity_plugin/android/src/main/kotlin/com/faceunity/faceunity_plugin/authpack.java

由于Android功能仅支持java17及以下版本，可以通过配置example/android/gradle.properties文件，配置java的sdk版本，例如：

```

org.gradle.java.home=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/home

```
  
### iOS

faceunity_ui_flutter/faceunity_plugin/ios/Classes/Tools/authpack.h

## 第二步：进入项目example

## 第三步：[创建云信应用并获取 App Key](https://doc.yunxin.163.com/console/docs/TIzMDE4NTA?platform=console)

## 第四步：在 [网易云信控制台](https://app.yunxin.163.com/global/home) 中为已创建的应用开通 [音视频通话](https://doc.yunxin.163.com/console/concept/zc3NDYzNzc?platform=console) 服务。

## 第五步 ：打开文件lib/call.dart，替换文件中的云信appkey

## 第六步：flutter pub get、flutter pub upgrade

## 第七步：flutter run