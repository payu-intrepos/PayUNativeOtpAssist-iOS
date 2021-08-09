Pod::Spec.new do |s|
s.name                = "PayUIndia-NativeOtpAssist"
s.version             = "1.0.0"
s.license             = "MIT"
s.homepage            = "https://github.com/payu-intrepos/PayUNativeOtpAssist-iOS"
s.author              = { "PayUbiz" => "contact@payu.in"  }

s.summary             = "Native OTP Assist SDK for IOS"
s.description         = "Analytics SDK for iOS by PayU."

s.source              = { :git => "https://github.com/payu-intrepos/PayUNativeOtpAssist-iOS.git",
:tag => "#{s.name}_#{s.version}"
}
s.documentation_url   = "https://payumobile.gitbook.io/sdk-integration/ios/native-otp-assist"
s.platform            = :ios , "11.0"
s.vendored_frameworks = "PayUNativeOtpAssist.xcframework"
s.dependency            'PayUIndia-NetworkReachability', '~> 1.0'
s.dependency            'PayUIndia-PayUParams', '~> 2.0'
s.dependency            'PayUIndia-Analytics', '~> 1.0'
s.dependency            'PayUIndia-CrashReporter', '~> 1.0'



end
