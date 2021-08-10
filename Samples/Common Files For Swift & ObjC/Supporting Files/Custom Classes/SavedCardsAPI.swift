//
//  SavedCards.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import Foundation
import PayUBizCoreKit

struct StoredCard {
    var name: String!
    var number: String!
    var month: String!
    var year: String!
    var cvv: String?
    var token: String!
    var bin: String!
    var cardType: String!
    var customObj: Any?
}

class SavedCardsAPI {
    
    class func fetchAll(paymentParam: PayUModelPaymentParams, completion: @escaping (([StoredCard])->())) {
        
        PayUWebServiceResponse().getPayUPaymentRelatedDetail(forMobileSDK: paymentParam) { (paymentRelatedDetails, error, extraParam) in
            
            var paymentOptions = [StoredCard]()
            if let paymentRelatedDetails = paymentRelatedDetails {
                
                if (paymentRelatedDetails.availablePaymentOptionsArray.contains(PAYMENT_PG_STOREDCARD)) {
                    for eachStoredCard in paymentRelatedDetails.storedCardArray {
                        if let eachStoredCard = eachStoredCard as? PayUModelStoredCard {
                            var savedCard = StoredCard()
                            savedCard.number = eachStoredCard.cardNo
                            savedCard.month = eachStoredCard.expiryMonth
                            savedCard.year = eachStoredCard.expiryYear
                            savedCard.name = eachStoredCard.nameOnCard
                            savedCard.customObj = eachStoredCard
                            savedCard.token = eachStoredCard.cardToken
                            savedCard.bin = eachStoredCard.cardBin
                            savedCard.cardType = eachStoredCard.cardType
                            paymentOptions.append(savedCard)
                        }
                    }
                }
            }
            
            completion(paymentOptions)
        }
    }
    
    class func saveCard(paymentParam: PayUModelPaymentParams) {
        PayUWebServiceResponse().saveUserCard(paymentParam) { (storedCard, errorMessage, otherInfo) in
            print(storedCard, errorMessage, otherInfo)
        }
    }
    
}
