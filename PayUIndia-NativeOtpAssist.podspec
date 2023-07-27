Pod::Spec.new do |s|
s.name                = "PayUIndia-NativeOtpAssist"
s.version             = "3.0.0"
s.license             = "MIT"
s.homepage            = "https://github.com/payu-intrepos/PayUNativeOtpAssist-iOS"
s.author              = { "PayUbiz" => "contact@payu.in"  }

s.summary             = "Native OTP Assist SDK for IOS"
s.description         = "The OTP Assist SDK provides a complete authentication flow for cards transactions. It offers to capture OTP in the merchant app without any redirection to the bank’s 3Dsecure/ACS page. This means that there's one less point of failure in the checkout process and a faster completion rate for transactions."

s.source              = { :git => "https://github.com/payu-intrepos/PayUNativeOtpAssist-iOS.git",
:tag => "#{s.version}"
}
s.documentation_url   = "https://payumobile.gitbook.io/sdk-integration/ios/native-otp-assist"
s.platform            = :ios , "11.0"
s.vendored_frameworks = 'framework/PayUNativeOtpAssist.xcframework'
s.dependency            'PayUIndia-PayUParams', '~>5.0',
s.dependency            'PayUIndia-Analytics', '~>3.0',
s.dependency            'PayUIndia-CrashReporter', '~>2.1',
s.dependency            'PayUIndia-NetworkReachability', '~>1.0',
s.dependency            'PayUIndia-CommonUI', '~>1.1'
end

end
