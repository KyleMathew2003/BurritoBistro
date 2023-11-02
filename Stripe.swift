//
//  Stripe.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 7/30/23.
//

import Foundation
import Stripe


 class MyStripeManager {
     static var shared: MyStripeManager!
     public var publishableKey: String = ""
     public var HTTPEndPoint: String = ""
          
     var authManager: AuthManager
     
     

         // Initialize MyStripeManager with an AuthManager instance
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
     
     
     
     static func createSharedInstance(authManager: AuthManager) {
             shared = MyStripeManager(authManager: authManager)
         }
     
     func createToken(cvc: String, numbers: String, expMonth: UInt, expYear: UInt, name: String, Zip: String) -> Void{
         let cardParams = STPCardParams()
         cardParams.cvc = cvc
         cardParams.number = numbers
         cardParams.expMonth = expMonth
         cardParams.expYear = expYear
         cardParams.name = name
         cardParams.addressZip = Zip
         
         var uploadInput:[String] = []

         
         STPAPIClient.shared.createToken(withCard: cardParams) { (token, error) in
             if let error = error {
                 print(error.localizedDescription)
             } else if let token = token {
                 
                let cardNumber = cardParams.number ?? ""
                let digits4 = String(cardNumber.suffix(4))
                let cardBrand = STPCardValidator.brand(forNumber: cardNumber)
                
           
                 let input = [token.tokenId, digits4, cardBrand.BrandString] as [String]
                 uploadInput = input
                
                 
                 Task {
                     [uploadInput] in
                                 do {
                                     try await TokenModel.shared.addTokenArray(input: uploadInput, self.authManager)
                                 } catch {
                                     print("Error adding token: \(error.localizedDescription)")
                                 }
                             }


                 print("Token created: \(token.tokenId)")
             }
         }
         
     }
     
          
     func createCharge(){
         let apiUrl = HTTPEndPoint
         let jsonInput = ["amount": 2900, "currency": "usd", "description": "XCode Charge", "source": "source"] as [String : Any]
         
         if let url = URL(string: apiUrl) {
             var request = URLRequest(url: url)
             request.httpMethod = "POST"
             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
             
             do {
                 let jsonData = try JSONSerialization.data(withJSONObject: jsonInput)
                 request.httpBody = jsonData
             } catch {
                 print("Error serializing JSON: \(error)")
                 return
             }
             
             let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                 if let error = error {
                     print("Error: \(error)")
                 } else if let data = data {
                     if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) {
                         print("Response JSON: \(jsonResult)")
                     }
                 }
             }
             
             task.resume()
         }
         
     }
    
}

extension STPCardBrand{
    var BrandString: String {
        switch self {
        case .JCB:
            return "JCB"
        case .amex:
            return "amex"
        case .cartesBancaires:
            return "cartesBancaires"
        case .dinersClub:
            return "dinersClub"
        case .discover:
            return "discover"
        case .mastercard:
            return "mastercard"
        case .unionPay:
            return "unionPay"
        case .visa:
            return "Visa"
        case .unknown:
            return "Some Processor"
        }
        
    }
}
