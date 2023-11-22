Pod::Spec.new do |s|

  s.name             = 'CustomCamera'

  s.version          = '1.0.0'

  s.summary          = 'CustomCamera Description.'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.homepage         = 'https://github.com/PEPDigitalPublishing/CustomCamera'

  s.author           = { '崔冉' => 'cuir@pep.com.cn' }

  s.source           = { :git => 'https://github.com/PEPDigitalPublishing/CustomCamera'}

  s.ios.deployment_target = '10.0'

  s.source_files = 'PEPCustomCamera/CustomCamera/Defines/PEPCustomCameraHeader.h'

  s.public_header_files = 'PEPCustomCamera/CustomCamera/Defines/PEPCustomCameraHeader.h'

  s.resource = 'CustomCamera.bundle'

  s.subspec 'CameraManager' do |ss|

    ss.source_files = 'PEPCustomCamera/CustomCamera/CameraManager/*.{h,m}'
    ss.public_header_files = 'PEPCustomCamera/CustomCamera/CameraManager/*.{h,m}'

  end

  s.subspec 'Controllers' do |ss|

    ss.source_files = 'PEPCustomCamera/CustomCamera/Controllers/*.{h,m}'
    ss.public_header_files = 'PEPCustomCamera/CustomCamera/Controllers/*.{h,m}'

  end

  s.subspec 'Defines' do |ss|

    ss.source_files = 'PEPCustomCamera/CustomCamera/Defines/*.{h,m}'
    ss.public_header_files = 'PEPCustomCamera/CustomCamera/Defines/*.{h,m}'

  end

  s.subspec 'KKImageBrowser' do |ss|

    ss.source_files = 'PEPCustomCamera/CustomCamera/Lib/KKImageBrowser/Classes/*.{h,m}'
    ss.public_header_files = 'PEPCustomCamera/CustomCamera/Lib/KKImageBrowser/Classes/*.{h,m}'

  end

  s.subspec 'View' do |ss|

    ss.source_files = 'PEPCustomCamera/CustomCamera/View/*.{h,m}'
    ss.public_header_files = 'PEPCustomCamera/CustomCamera/View/*.{h,m}'

  end

  s.frameworks = 'UIKit', 'AVFoundation', 'CoreMedia'

end
















