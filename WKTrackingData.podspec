
Pod::Spec.new do |spec|

  spec.name         = "WKTrackingData"
  spec.version      = "0.0.9"
  spec.summary      = "基于AOP的全埋点库"

  spec.description  = "一款轻量级的全埋点库，除了自动追踪用户事件外，也允许业务扩展，忽略和添加自定义参数。"

  spec.homepage     = "https://github.com/wkjsos/WKTrackingData.git"

  spec.license = { :type => 'MIT', :text => <<-LICENSE
         Copyright kurt_wang 2020
         LICENSE
  }

  spec.author       = { "kurt_wang" => "931625530@qq.com" }
  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/wkjsos/WKTrackingData.git", :tag => "#{spec.version}" }
  spec.source_files = "WKTrackingData/WKTrackingData/Core/*"

  spec.resource_bundles = {
    'WKTrackingData' => 'WKTrackingData/WKTrackingData/Core/Resources/viewcontroller_blacklist.json'
  }

  spec.subspec 'Util' do |ss|
    ss.source_files = "WKTrackingData/WKTrackingData/Core/Util/*"
  end
end
