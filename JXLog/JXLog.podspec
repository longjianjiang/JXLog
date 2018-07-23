Pod::Spec.new do |s|
  s.name             = 'JXLog'
  s.version          = '0.0.1'
  s.summary          = 'A Log Component'
  s.homepage         = 'https://github.com/longjianjiang/JXLog'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "longjianjiang" => "brucejiang5.7@gmail.com" }
  s.source           = { :git => 'https://github.com/longjianjiang/JXLog.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.source_files = 'JXLog', 'JXLog/JXLog/**/*.{h,m}'
end