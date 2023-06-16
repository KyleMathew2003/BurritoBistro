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

protocol AuthFormProtocol {
    var formIsValid: Bool{ get }
}

@MainActor
final class AuthManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: Profile?
    @Published var inUseError: String = ""
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: Failed to sign in ERROR: \(error.localizedDescription)")
        }
        
    }
    func createUser(withEmail email: String, password: String, firstName: String, lastName: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = Profile(id: result.user.uid, firstName: firstName, lastName: lastName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch{
                inUseError = "Email Already In Use"
            
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            
        }
    }
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil 
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
    }
}
