//
//  AuthManager.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/16/23.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import Stripe

protocol AuthFormProtocol {
    var formIsValid: Bool{ get }
}

@MainActor
class AuthManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: Profile?
    @Published var inUseError: String = ""
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func initializeMyStripeManager() {
            MyStripeManager.createSharedInstance(authManager: self)
        }
    
    func signIn(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            withAnimation(.easeInOut){
                self.userSession = result.user
            }
            await fetchUser()
        }catch{
            print("DEBUG: Failed to sign in ERROR: \(error.localizedDescription)")
        }
        
    }
    func createUser(withEmail email: String, password: String, firstName: String, lastName: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            withAnimation(.easeInOut){
                self.userSession = result.user
            }
            let user = Profile(id: result.user.uid, firstName: firstName, lastName: lastName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()            
            let data = ["email": email.lowercased(), "firstName": firstName, "lastName": lastName, "uid": user.id, "OrderNumbers" : [], "TokenNumbers" : [:]] as [String : Any]
            Firestore.firestore().collection("users")
                .document(user.id)
                .setData(data){ _ in
                    print("DEBUG: User data uploaded")
                }
        } catch{
                inUseError = "Email Already In Use"
            
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            
        }
    }
    func signOut(){
        do{
            try Auth.auth().signOut()
            withAnimation(.easeInOut){
                self.userSession = nil
                self.currentUser = nil
            }
        } catch {
            print("DEBUG: FAILED to sign out with errror \(error.localizedDescription)")
        }
    }
    func deleteAccount(){
        
    }
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as:Profile.self)
        
        print("DEBUG: Cur User is: \(self.currentUser)")
        
        self.initializeMyStripeManager()
        
        let stripeKeyCollection = Firestore.firestore().collection("Stripe")
        stripeKeyCollection.document("stripeKey").getDocument{ (document, error) in
            if let document = document, document.exists {
                if let stripePublishableKey = document.data()?["PublishedKey"] as? String {
                    MyStripeManager.shared.publishableKey = stripePublishableKey
                    StripeAPI.defaultPublishableKey = MyStripeManager.shared.publishableKey
                    print(MyStripeManager.shared.publishableKey)
                } else {
                    print("ERROR: Stripe Key Not Found")
                }
            }else{
                print("ERROR: Stripe Key Document Not Found")
            }
        }
        
        stripeKeyCollection.document("LamdaHttpEndPoint").getDocument{ (document, error) in
            if let document = document, document.exists {
                if let EndPoint = document.data()?["LamdaEndPoint"] as? String {
                    MyStripeManager.shared.HTTPEndPoint = EndPoint
                    print(MyStripeManager.shared.HTTPEndPoint)
                } else {
                    print("ERROR: EndPoint Not Found")
                }
            }else{
                print("ERROR: EndPoint  Document Not Found")
            }
        }
        
        
        
    }
}


