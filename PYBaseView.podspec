

Pod::Spec.new do |s|
  s.name             = 'PYBaseView'
  s.version          = '0.1.8'
  s.summary          = '对tableview的封装，高效、解耦。Button的封装: 状态的管理，链式调用'

  s.description      = <<-DESC
对tableview的封装，高效、解耦。Button的封装: 状态的管理，链式调用
                       DESC

  s.homepage         = 'https://github.com/LiPengYue/PYBaseView'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiPengYue' => '15076299703@163.com' }
  s.source           = { :git => 'https://github.com/LiPengYue/PYBaseView.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '8.0'

  s.source_files = 'PYBaseView/Classes/**/*'
  
  s.dependency 'PYBaseStringHandler'
  s.dependency 'PYBaseColorHandler'
end
