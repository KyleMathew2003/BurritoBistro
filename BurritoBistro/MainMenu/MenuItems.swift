//
//  MenuItems.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 5/19/23.
//

import Foundation
import SwiftUI

enum MenuTypes: Int, CaseIterable {
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

struct MenuFoodItems: Identifiable, Hashable{
    var id = UUID().uuidString
    let foodName: String
    let MenuItemDetails: MenuItemDetails
    let Ingredients: Ingredients
}


struct MenuItemDetails: Hashable {
    let description: String
    let price: Float
    let group: MenuTypes
}

struct Ingredients:  Hashable{
    let IngredientOptions: [IngredientOptions]
    
}

struct IngredientOptions: Hashable {
    let section: String
    let section_Option: [String]

  
    
}















var MenuItems: [MenuFoodItems] = [
    .init(
        foodName: "Bernardos Burrito",
        
        MenuItemDetails: .init(
            description: "Hello",
            price: 2.5,
            group: .entrees),
        
        Ingredients: .init(IngredientOptions: [
            .init(
                section: "Toppings",
                section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
            .init(
                section: "Combo?",
                section_Option: ["Soda","Drink"])
        ])
    ),
    .init(
        foodName: "Sam's Smash-Burger",
        
        MenuItemDetails: .init(
            description: "A Beutiful piece of thrillingly delicious Burger",
            price: 7,
            group: .entrees),
        
        Ingredients: .init(IngredientOptions: [
            .init(
                section: "Toppings",
                section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
            .init(
                section: "Combo?",
                section_Option: ["Soda","Drink"])
        ])
    ),
    .init(
        foodName: "Sam's Smash-Burger",
        
        MenuItemDetails: .init(
            description: "A Beutiful piece of thrillingly delicious Burger",
            price: 7,
            group: .entrees),
        
        Ingredients: .init(IngredientOptions: [
            .init(
                section: "Toppings",
                section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
            .init(
                section: "Combo?",
                section_Option: ["Soda","Drink"])
        ])
    ),
    
    .init(
        foodName: "Mashallah Masala Fries",
        
        MenuItemDetails: .init(
            description: "A masala",
            price: 4,
            group: .sides),
        
        Ingredients: .init(IngredientOptions: [
            .init(
                section: "Toppings",
                section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
            .init(
                section: "Combo?",
                section_Option: ["Soda","Drink"])
        ])
    ),
    
    .init(
        foodName: "Dank Drank",
        
        MenuItemDetails: .init(
            description: "A Dranks",
            price: 3,
            group: .drinks),
        
        Ingredients: .init(IngredientOptions: [
            .init(
                section: "Toppings",
                section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
            .init(
                section: "Combo?",
                section_Option: ["Soda","Drink"])
        ])
    ),
    
        .init(
            foodName: "Beniko's Boba",
            
            MenuItemDetails: .init(
                description: "A BBoba urritos",
                price: 4,
                group: .drinks),
            
            Ingredients: .init(IngredientOptions: [
                .init(
                    section: "Toppings",
                    section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
                .init(
                    section: "Combo?",
                    section_Option: ["Soda","Drink"])
            ])
        ),
    
        .init(
            foodName: "Oreos",
            
            MenuItemDetails: .init(
                description: "A Oreo treat",
                price: 2,
                group: .snacks),
            
            Ingredients: .init(IngredientOptions: [
                .init(
                    section: "Toppings",
                    section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
                .init(
                    section: "Combo?",
                    section_Option: ["Soda","Drink"])
            ])
        ),
        .init(
            foodName: "Gummies",
            
            MenuItemDetails: .init(
                description: "FlintStobeDelish",
                price: 2,
                group: .snacks),
            
            Ingredients: .init(IngredientOptions: [
                .init(
                    section: "Toppings",
                    section_Option: ["Tomatoes","Pickles","Carmelized Onions"]),
                .init(
                    section: "Combo?",
                    section_Option: ["Soda","Drink"])
            ])
        )
    
    

    


]


