//
//  TokenModel.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 10/31/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TokenModel{
    static var shared = TokenModel()
    var currentToken: String = ""
    var tokenArray:[String:[Any]] = [:]
    
    init() {
    }
        
    func populateTokenArray(_ auth: AuthManager) async throws{
        
        guard let my_session = try await auth.userSession else{
            return
        }
        
        var dataArray:[String:[Any]] = try await Firestore.firestore().collection("users").document(auth.userSession!.uid).getDocument().data()?["TokenNumbers"] as? [String:[Any]] ?? [:]
        
        
        
        self.tokenArray = dataArray
    }
    
    func addTokenArray(input:[String], _ auth: AuthManager) async throws{
        
        guard let my_session = try await auth.userSession else{
            return
        }
        
        let tokenKey = input[0]
        let document = await Firestore.firestore().collection("users").document(auth.userSession!.uid)
    
        do {
                try await document.updateData(["TokenNumbers.\(tokenKey)": FieldValue.arrayUnion(input)])
                print("Element added successfully")

                // Call populateTokenArray after the element is successfully added.
                do {
                    try await populateTokenArray(auth)
                } catch {
                    print("Error populating token array: \(error.localizedDescription)")
                }
            } catch {
                print("Error adding element: \(error.localizedDescription)")
            }
        
    }

    
    func removeTokenArray(Input:[String], _ auth: AuthManager) async throws{
        
        guard let my_session = try await auth.userSession else{
            return
        }
        
        let document = await Firestore.firestore().collection("users").document(auth.userSession!.uid)
        let tokenKey = Input[0]
        
        
        do {
                try await document.updateData(["TokenNumbers.\(tokenKey)": FieldValue.arrayRemove([Input])])
                print("Element removed successfully")

                // Call populateTokenArray after the element is successfully removed.
                do {
                    try await populateTokenArray(auth)
                } catch {
                    print("Error populating token array: \(error.localizedDescription)")
                }
            } catch {
                print("Error adding element: \(error.localizedDescription)")
            }
        
    }
    
}


