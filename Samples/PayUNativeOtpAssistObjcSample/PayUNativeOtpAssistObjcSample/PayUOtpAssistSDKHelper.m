//
//  PayUOtpAssistSDKHelper.m
//  PayUNativeOtpAssistObjcSample
//
//  Created by Amit Salaria on 29/06/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PayUBizCoreKit/PayUBizCoreKit.h>
#import "PayUNativeOtpAssistObjcSample-Swift.h"
@import PayUNativeOtpAssist;
@import PayUParamsKit;

@interface PayUOtpAssistSDKHelper: NSObject

@end

@implementation PayUOtpAssistSDKHelper: NSObject

+(void)openOn:(UIViewController *)parentVC delegate:(id<PayUOtpAssistDelegate>)delegate and:(NSDictionary *)parameters {
    
    // Open SDK
    [PayUOtpAssist openWithParentVC: parentVC
                       paymentParam: [PayUOtpAssistSDKHelper getPaymentParametersFrom:parameters]
                             config:[PayUOtpAssistSDKHelper getUIConfigurations]
                           delegate:delegate];
    
}

+(PayUOtpAssistConfig *)getUIConfigurations {
    
    PayUOtpAssistConfig *config = [PayUOtpAssistConfig new];
    config.themeColor = [[UIColor alloc] initWithRed:0.01960784314 green:0.231372549 blue:0.7568627451 alpha:1.0];
    config.merchantLogo = [UIImage imageNamed:@"logo"];
    config.shouldShowMerchantSummary = YES;
    config.merchantResponseTimeout = 10000; // In milliseconds
    return config;
    
}

+(PayUPaymentParam *)getPaymentParametersFrom: (NSDictionary *)parameters {

    NSLog(@"User Details -> %@", [parameters description]);

    NSNumber * transactionId = [NSNumber numberWithInt:([[NSDate date] timeIntervalSince1970])];

    PayUPaymentParam *paymentParam = [[PayUPaymentParam alloc]
                                               initWithKey: [parameters objectForKey:SampleAppConstants.key]
                                               transactionId: [transactionId stringValue]
                                               amount: [parameters objectForKey:SampleAppConstants.amount]
                                               productInfo: @"Nokia"
                                               firstName: @"First Name"
                                               email: [parameters objectForKey:SampleAppConstants.email]
                                               phone: @"9876543210"
                                               surl: @"https://payu.herokuapp.com/ios_success"
                                               furl: @"https://payu.herokuapp.com/ios_failure"
                                               environment: EnvironmentProduction];
    
    paymentParam.userCredential = [parameters objectForKey:SampleAppConstants.userCredential];

    paymentParam.hashes = [PayUHashes new];
    
    NSString *hashString = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@||||||%@", paymentParam.key, [transactionId stringValue], paymentParam.amount, paymentParam.productInfo, paymentParam.firstName, paymentParam.email, @"udf1", @"udf2", @"udf3", @"udf4", @"udf5", [parameters objectForKey:SampleAppConstants.salt]];
    
    paymentParam.hashes.paymentHash = [[PayUDontUseThisClass new] getHash:hashString];
    
    paymentParam.udfs = [PayUUserDefines new];
    paymentParam.udfs.udf1 = @"udf1";
    paymentParam.udfs.udf2 = @"udf2";
    paymentParam.udfs.udf3 = @"udf3";
    paymentParam.udfs.udf4 = @"udf4";
    paymentParam.udfs.udf5 = @"udf5";

    NSString *cardToken = [parameters objectForKey:SampleAppConstants.cardName];
    
    if ((cardToken == nil || [cardToken  isEqual: @""])) {  // New Card
        CCDC *ccdc = [CCDC new];
        ccdc.cardNumber = [parameters objectForKey:SampleAppConstants.cardNumber];
        ccdc.expiryYear = [parameters objectForKey:SampleAppConstants.cardExpiryYear];
        ccdc.expiryMonth = [parameters objectForKey:SampleAppConstants.cardExpiryMonth];
        ccdc.cvv = [parameters objectForKey:SampleAppConstants.cvv];
        ccdc.txnS2SFlow = @"4";
        ccdc.nameOnCard = @"Test Card Name";
        ccdc.shouldSaveCard = [parameters objectForKey:SampleAppConstants.saveCard];
        paymentParam.paymentOption = ccdc;
    } else {    // Saved Card
        SavedCard *savedCard = [SavedCard new];
        savedCard.cardNumber = [parameters objectForKey:SampleAppConstants.cardNumber];
        savedCard.expiryYear = [parameters objectForKey:SampleAppConstants.cardExpiryYear];
        savedCard.expiryMonth = [parameters objectForKey:SampleAppConstants.cardExpiryMonth];
        savedCard.cvv = [parameters objectForKey:SampleAppConstants.cvv];
        savedCard.cardToken = [parameters objectForKey:SampleAppConstants.cardToken];
        savedCard.txnS2SFlow = @"4";
        savedCard.nameOnCard = @"Test Card Name";
        savedCard.shouldSaveCard = [parameters objectForKey:SampleAppConstants.saveCard];
        paymentParam.paymentOption = savedCard;
    }
    

    return paymentParam;
}

@end
