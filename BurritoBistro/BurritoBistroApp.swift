//
//  BurritoBistroApp.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 1/31/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Stripe

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    let db = Firestore.firestore()
    STPAPIClient.shared.publishableKey = "pk_test_51NZQyLFo02kxDJpO73pD2OMI9sw9b3xUB7RZkGFVifWlhBbG9stTCT6555gEVo2JM3S6Y4zSFTkxxZYTCBNHrmKE00w21eiLUS"
    let stripeKeyCollection = db.collection("Stripe")
      stripeKeyCollection.document("stripeKey").getDocument{ (document, error) in
          if let document = document, document.exists {
              if let stripePublishableKey = document.data()?["PublishedKey"] as? String {
                  MyStripeManager.shared.publishableKey = stripePublishableKey
                  print(MyStripeManager.shared.publishableKey)
              } else {
                  print("ERROR: Stripe Key Not Found")
              }
          }else{
              print("ERROR: Stripe Key Document Not Found")
          }
      }
    return true
  }
}

@main
struct BurritoBistroApp: App {
    @StateObject var viewModel = AuthManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainFlowView()
                .environmentObject(viewModel)
        }
    }
}
