//
//  BurritoBistroApp.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 1/31/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Stripe

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    let db = Firestore.firestore()
      
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
