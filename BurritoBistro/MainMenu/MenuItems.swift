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
    var Ingredients: Ingredients
    
    func sumIngredientPrice() -> Float {
        let flattenedArray = Ingredients.IngredientOptions.flatMap { $0.section_Option }
        let filteredArray = flattenedArray.filter { $0.isOn }
        let sum = filteredArray.reduce(0) { $0 + $1.optionPrice }
        return sum + MenuItemDetails.price
    }
}


struct MenuItemDetails: Hashable {
    let description: String
    var price: Float
    let group: MenuTypes
}

struct Ingredients:  Hashable{
    var IngredientOptions: [IngredientOptions]
    
}

struct IngredientOptions: Hashable {
    let section: String
    var section_Option: [IngredientSection_Options]
    let selectionLimit: Int
    
    var selectionCount: Int {
        section_Option.reduce(0) {count, child in
            return count + (child.isOn ? 1 : 0)
        }
    }
}

struct IngredientSection_Options: Hashable{
    var isOn: Bool = false
    let option: String
    let optionPrice: Float
}













var MenuItems: [MenuFoodItems] = [
    .init(
        foodName: "Bernardos Burrito",
        
        MenuItemDetails: .init(
            description: "Hello",
            price: 2.5,
            group: .entrees),
        
        Ingredients: .init(IngredientOptions: [
            .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 2),
            .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 2)

        ])
    ),
    .init(
        foodName: "Sam's Smash-Burger",
        
        MenuItemDetails: .init(
            description: "A Beutiful piece of thrillingly delicious Burger",
            price: 7,
            group: .entrees),
        
        Ingredients: .init(IngredientOptions: [
            .init(section: "Toppingzqowishda", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 1),
            .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 1)

        ])
    ),
    .init(
        foodName: "Sam's Smash-Burger",
        
        MenuItemDetails: .init(
            description: "A Beutiful piece of thrillingly delicious Burger",
            price: 7,
            group: .entrees),
        
        Ingredients: .init(IngredientOptions: [
            .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 1),
            .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 2)

        ])
    ),
    
    .init(
        foodName: "Mashallah Masala Fries",
        
        MenuItemDetails: .init(
            description: "A masala",
            price: 4,
            group: .sides),
        
        Ingredients: .init(IngredientOptions: [
            .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 0),
            .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 1)

        ])    ),
    
    .init(
        foodName: "Dank Drank",
        
        MenuItemDetails: .init(
            description: "A Dranks",
            price: 3,
            group: .drinks),
        
        Ingredients: .init(IngredientOptions: [
            .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 1),
            .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 2)

        ])
    ),
    
        .init(
            foodName: "Beniko's Boba",
            
            MenuItemDetails: .init(
                description: "A BBoba urritos",
                price: 4,
                group: .drinks),
            
            Ingredients: .init(IngredientOptions: [
                .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 2),
                .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 4)

            ])
        ),
    
        .init(
            foodName: "Oreos",
            
            MenuItemDetails: .init(
                description: "A Oreo treat",
                price: 2,
                group: .snacks),
            
            Ingredients: .init(IngredientOptions: [
                .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 2),
                .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 2)

            ])
        ),
        .init(
            foodName: "Gummies",
            
            MenuItemDetails: .init(
                description: "FlintStobeDelish",
                price: 2,
                group: .snacks),
            
            Ingredients: .init(IngredientOptions: [
                .init(section: "Toppings", section_Option: [.init(option: "Tomatoes", optionPrice: 1.00),.init(option: "Onions", optionPrice: 0)], selectionLimit: 3),
                .init(section: "Dineros", section_Option: [.init(option: "dasd", optionPrice: 0.00),.init(option: "ads", optionPrice: 0.10)], selectionLimit: 1)

            ])
        )
    
    

    


]


