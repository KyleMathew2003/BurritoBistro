//
//  Profile.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/16/23.
//

import Foundation

struct Profile: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
}

extension Profile{
    static var MOCK_USER = Profile(id: NSUUID().uuidString, firstName: "JUAN", lastName: "CARLOS", email: "juanCarlos@gmail.com")
}
