//
//  PayUOtpAssistSDKHelper.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import UIKit
import PayUParamsKit
import PayUNativeOtpAssist
import PayUBizCoreKit

class PayUOtpAssistSDKHelper {
    
    class func open(on parentVC: UIViewController, delegate: PayUOtpAssistDelegate, and parameters: [String: Any]) {
        PayUPaymentCreateRequest().createRequest(param: PayUOtpAssistSDKHelper.getPaymentParameters(from: parameters)) { urlRequest, postParam, error in
            if error == nil {
                PayUOtpAssist.open(
                    parentVC: parentVC,
                    paymentParam: PayUOtpAssistSDKHelper.getPaymentParameters(from: parameters),
                    config: PayUOtpAssistSDKHelper.getUIConfigurations(),
                    delegate: delegate
                )
            }
            
        }
    }
    
    fileprivate class func getUIConfigurations() -> PayUOtpAssistConfig {
        
        let config = PayUOtpAssistConfig()
        config.merchantLogo = #imageLiteral(resourceName: "logo")
        config.shouldShowMerchantSummary = true
        config.themeColor = #colorLiteral(red: 0.01960784314, green: 0.231372549, blue: 0.7568627451, alpha: 1)
        config.merchantResponseTimeout = 10000 // In milliseconds
        return config
        
    }
    
    fileprivate class func getPaymentParameters(from parameters: [String: Any]) -> PayUPaymentParam {
        
        print("User Details -> ", parameters)
        
        let transactionId = Int64(Date().timeIntervalSince1970)
        
        let paymentParam = PayUPaymentParam(
            key: parameters[SampleAppConstants.key] as? String ?? "",
            transactionId: String(transactionId),
            amount: parameters[SampleAppConstants.amount] as? String ?? "",
            productInfo: "Nokia",
            firstName: "No Name",
            email: parameters[SampleAppConstants.email] as? String ?? "",
            phone: "9876543210",
            surl: "https://payu.herokuapp.com/ios_success",
            furl: "https://payu.herokuapp.com/ios_failure",
            environment: .production
        )
        
        paymentParam.userCredential = parameters[SampleAppConstants.userCredential] as? String ?? ""

        paymentParam.hashes = PayUHashes()
        
        let hashString = "\(paymentParam.key)|\(transactionId)|\(paymentParam.amount)|\(paymentParam.productInfo)|\(paymentParam.firstName)|\(paymentParam.email)|udf1|udf2|udf3|udf4|udf5||||||\(parameters[SampleAppConstants.salt] as? String ?? "")"
        
        paymentParam.hashes?.paymentHash = PayUDontUseThisClass().getHash(hashString)
        
        paymentParam.udfs = PayUUserDefines()
        paymentParam.udfs?.udf1 = "udf1"
        paymentParam.udfs?.udf2 = "udf2"
        paymentParam.udfs?.udf3 = "udf3"
        paymentParam.udfs?.udf4 = "udf4"
        paymentParam.udfs?.udf5 = "udf5"
        
        let savedCardToken = parameters[SampleAppConstants.cardToken] as? String ?? ""
        
        if savedCardToken.isEmpty { // New Card
            let ccdc = CCDC()
            ccdc.cardNumber = parameters[SampleAppConstants.cardNumber] as? String ?? ""
            ccdc.expiryYear = NSNumber(value: parameters[SampleAppConstants.cardExpiryYear] as? Int ?? 0)
            ccdc.expiryMonth = NSNumber(value: parameters[SampleAppConstants.cardExpiryMonth] as? Int ?? 0)
            ccdc.cvv = parameters[SampleAppConstants.cvv] as? String ?? ""
            ccdc.txnS2SFlow = "4"
            ccdc.nameOnCard = parameters[SampleAppConstants.cardName] as? String ?? ""
            ccdc.shouldSaveCard = parameters[SampleAppConstants.saveCard] as? Bool ?? false
            paymentParam.paymentOption = ccdc
        } else {    // Saved Card
            let savedCard = SavedCard()
            savedCard.cardNumber = parameters[SampleAppConstants.cardNumber] as? String ?? ""
            savedCard.expiryYear = NSNumber(value: parameters[SampleAppConstants.cardExpiryYear] as? Int ?? 0)
            savedCard.expiryMonth = NSNumber(value: parameters[SampleAppConstants.cardExpiryMonth] as? Int ?? 0)
            savedCard.cvv = parameters[SampleAppConstants.cvv] as? String ?? ""
            savedCard.txnS2SFlow = "4"
            savedCard.nameOnCard = parameters[SampleAppConstants.cardName] as? String ?? ""
            savedCard.shouldSaveCard = parameters[SampleAppConstants.saveCard] as? Bool ?? false
            savedCard.cardToken = parameters[SampleAppConstants.cardToken] as? String ?? ""
            paymentParam.paymentOption = savedCard
        }
        
        return paymentParam
    }
    
}
