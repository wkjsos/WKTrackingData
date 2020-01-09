#
#  Be sure to run `pod spec lint WKTrackingData.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "WKTrackingData"
  spec.version      = "0.0.2"
  spec.summary      = "基于AOP的全埋点库"

  spec.description  = "一款轻量级的全埋点库，除了自动追踪用户事件外，也允许业务扩展，忽略和添加自定义参数。"

  spec.homepage     = "https://github.com/wkjsos/WKTrackingData.git"


  spec.license = { :type => 'MIT', :text => <<-LICENSE
         Copyright kurt_wang 2020
         LICENSE
  }


  spec.author       = { "kurt_wang" => "931625530@qq.com" }
  spec.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/wkjsos/WKTrackingData.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "WKTrackingData/WKTrackingData/Core/*", "WKTrackingData/WKTrackingData/Core/Resources/*", "WKTrackingData/WKTrackingData/Core/Util/*", "WKTrackingData/WKTrackingData/Core/AOP/*"


end
