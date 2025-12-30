# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
 platform :ios, '9.0'

   source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'DormitoryManagementPro' do 
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # use_frameworks!
  pod 'Masonry'                                   #自动布局
  pod 'SDAutoLayout'                              #自动布局
  pod 'AFNetworking', '~> 4.0'                    #网络请求
  pod 'MJExtension', '~> 3.0.13'                  #数据模型转换
  pod 'MJRefresh'                                 #上下拉刷新加载
  pod 'SDWebImage', '~> 3.7.5'                    #网络图片缓存
  pod 'SVProgressHUD', '~> 2.2.5'                 #弹出框
  pod 'IQKeyboardManager'                         #键盘插件不覆盖输入框
  #pod 'YYKit' , '~>1.0.9'			  #YYKit
  pod 'YYCategories' , '1.0.4'			  # YYKit 的一套分类
  pod 'YYText', '~> 1.0.5'                        #富文本内容展示
  pod 'YYModel', '~>1.0.4'		     	  #字典转模型
  pod 'YYImage', '~>1.0.4'			  #YYImage
  pod 'WebViewJavascriptBridge', '~> 6.0'         #HtmlWKWebview
  pod 'ReactiveObjC'				  #RAC
  pod 'ActionSheetPicker-3.0', '~> 2.3.0'	  #快速下拉
  pod 'AvoidCrash'				  #闪退捕捉
  pod 'SJVideoPlayer'		 		  #视频播放器
  pod 'HWPanModal', '~> 0.6.0'			  #底部弹出视图
  pod 'Toast', '~> 4.0.0'			  #Toast
  pod 'ZZCircleProgress', '~> 0.2.1'		  #进度条
  pod 'STPickerView', '2.4'			  #地址选择器
  pod 'MTGeometry'
  pod 'OpenCV2', '~> 4.3.0'
 # pod 'YZAuthID'				  #指纹FaceID验证

#######---------- 企业第三方 ------------------########
  pod 'WechatOpenSDK'   	       #微信
  pod  'AlipaySDK-iOS' 		#支付宝
  pod 'AMapLocation' 		  # 高的定位地图
  pod 'UMCCommon'		  # 友盟
  #pod 'AMap3DMap' #3D地图SDK 
  #pod 'AMap2DMap' #2D地图SDK (2D和3D不能同时使用) 
  pod 'AMapSearch' #搜索功能
  pod 'AMapNavi'  #导航功能

  pod 'GTSDK', '2.4.1.0-noidfa' 		 #个推无 IFDA 版本
  #pod 'Bugly'					#异常捕捉
end 


target 'NotificationService' do
      platform :ios, "10.0"
      pod 'GTExtensionSDK'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.2'
    end
  end
end
