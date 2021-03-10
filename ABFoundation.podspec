Pod::Spec.new do |s|
	s.name             = "ABFoundation"
	s.version          = "0.0.1"
	s.summary          = "致力于提高项目开发效率的解决方案"
	s.description      = <<-DESC
							ABFoundation iOS
							DESC
	s.homepage         = "https://github.com/whdevlab/ABFoundation"
	s.license          = 'MIT'
	s.author           = {"whdevlab" => "whdevlab@163.com"}
	s.source           = {:git => "https://github.com/whdevlab/ABFoundation.git", :tag => s.version.to_s}
	s.social_media_url = 'https://github.com/whdevlab/ABFoundation'
	s.requires_arc     = true
	s.platform         = :ios, '9.0'
	s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'Photos'
	s.source_files     = 'Core/*.{h,m}'
	s.dependency "AFNetworking"
	s.dependency "SocketRocket"
	s.subspec 'ABNet' do |ss|
		ss.source_files = 'Core/ABNet/*.{h,m}'
	end
	s.subspec 'ABMQ' do |ss|
		ss.source_files = 'Core/ABMQ/*.{h,m}'
	end
	s.subspec 'ABWebSocket' do |ss|
		ss.source_files = 'Core/ABWebSocket/*.{h,m}'
	end
	s.subspec 'ABLanguage' do |ss|
		ss.source_files = 'Core/ABLanguage/*.{h,m}'
	end
	s.subspec 'WOCrashProtector' do |ss|
		ss.source_files = 'Core/WOCrashProtector/*.{h,m}'
		ss.subspec 'WOContainer' do |sss|
			sss.source_files = 'Core/WOCrashProtector/WOContainer/*.{h,m}'
		end
	end

end