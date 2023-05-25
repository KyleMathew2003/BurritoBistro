//
//  MenuItems.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 5/19/23.
//

import Foundation
import SwiftUI

enum MenuOptions: Int, CaseIterable {
    case entrees
    case sides
    case drinks
    case snacks
    
    var title: String{
        switch self{
        case .entrees: return "Entrees"
        case .sides: return "Sides"
        case .drinks: return "Drinks"
        case .snacks: return "Snacks"
        }
    }
    
    var index: Int {
        switch self{
        case .entrees: return 0
        case .sides: return 1
        case .drinks: return 2
        case .snacks: return 3
        }
    }
}
struct MenuItemDetails: Identifiable, Hashable {
    var id = UUID().uuidString
    let foodName: String
    let description: String
    let price: Int
    let group: MenuOptions
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
}

var MenuItems: [MenuItemDetails] = [
    //Entrees
    .init(
        foodName: "Bernardo's Burrito",
        description: "A Beutiful piece of thrillingly delicious Burritosllingly delicious Burritosllingly delicious Burritosllingly delicious Burritosllingly delicious Burritos",
        price: 10,
        group: .entrees
    ),
    .init(
        foodName: "Sam's Smash-Burger",
        description: "A Beutiful piece of thrillingly delicious Burger",
        price: 7,
        group: .entrees
    ),
    
    //Sides
    .init(
        foodName: "Mashallah Masala Fries",
        description: "A masala",
        price: 4,
        group: .sides
    ),
    
    //Drinks
    .init(
        foodName: "Dank Drank",
        description: "A Dranks",
        price: 3,
        group: .drinks
    ),
    .init(
        foodName: "Beniko's Boba",
        description: "A BBoba urritos",
        price: 4,
        group: .drinks
    ),
    
    //Snacks
    .init(
        foodName: "Oreos",
        description: "A Oreos",
        price: 2,
        group: .snacks
    ),
    .init(
        foodName: "FlintStone Gummies",
        description: "A Flintstonefitos",
        price: 2,
        group: .snacks
    )
    

]

