//
//  PayUOtpAssistSDKHelper.h
//  PayUNativeOtpAssistObjcSample
//
//  Created by Amit Salaria on 29/06/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import PayUNativeOtpAssist;

@interface PayUOtpAssistSDKHelper: NSObject

+(void)openOn:(UIViewController *)parentVC delegate:(id<PayUOtpAssistDelegate>)delegate and:(NSDictionary *)parameters;

@end
