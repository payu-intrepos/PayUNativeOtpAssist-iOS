# Supress warning messages.
original_verbose, $VERBOSE = $VERBOSE, nil

# Read file
vars_from_file = File.read("../Dependency/PayUParamsKit/GitHub/Version.txt")
eval(vars_from_file)

# Activate warning messages again.
$VERBOSE = original_verbose

Pod::Spec.new do |s|
s.name                = "PayUIndia-NativeOtpAssist"
s.version             = NATIVE_OTP_ASSIST_POD_VERSION
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
NATIVE_OTP_ASSIST_PODSPEC_DEPENDENCIES.each do |dependency|
    dependency
end

end
