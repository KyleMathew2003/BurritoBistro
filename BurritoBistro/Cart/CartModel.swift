//
//  CartModel.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/16/23.
//

import SwiftUI

//model
struct CartVals: Equatable, Hashable{
    var Item: MenuFoodItems
    
    var Count: Int
}

//viewmodel
struct my_Cart{
    @State private var Menu = MenuItems

    var Cart: [CartVals] = []
    
    func cartCount() -> Int {
        return Cart.count
    }
    
    func subtotal() -> Float {
        return Cart.reduce(0) { $0 + Float($1.Count) * $1.Item.sumIngredientPrice()}
        }
    
    mutating func removeFromCart(menuFoodItem:MenuFoodItems){
        for i in Cart{
            if i.Item == menuFoodItem{
                if i.Count == 1{
                    Cart.remove(at: Cart.firstIndex(of: i)!)
                } else{
                    Cart[Cart.firstIndex(of: i)!].Count += -1
                }
            }
        }
    }
    
    mutating func addToCart(menuFoodItem: MenuFoodItems){
        var isIn = false
        for i in Cart{
            if i.Item == menuFoodItem{
                isIn = true
                Cart[Cart.firstIndex(of: i)!].Count += 1

            }
        }
        if isIn == false{
            Cart.append(.init(Item: menuFoodItem, Count: 1))
        }
    }
    
    mutating func replaceCartItem(cur_CartItem: CartVals, MenuFoodItem: MenuFoodItems){
        Cart[Cart.firstIndex(where:{ $0 == cur_CartItem})!] = .init(Item: MenuFoodItem, Count: Cart[Cart.firstIndex(where:{ $0 == cur_CartItem})!].Count)
    }
    
    mutating func replaceIngredients(cur_CartItem: CartVals, MenuFoodItem: inout MenuFoodItems){
        for i in cur_CartItem.Item.Ingredients.IngredientOptions.indices{
            for j in cur_CartItem.Item.Ingredients.IngredientOptions[i].section_Option.indices{
                MenuFoodItem.Ingredients.IngredientOptions[i].section_Option[j].isOn = cur_CartItem.Item.Ingredients.IngredientOptions[i].section_Option[j].isOn
            }
            
        }
    }
    mutating func resetToggles(MenuFoodItem: inout MenuFoodItems){
        for i in MenuFoodItem.Ingredients.IngredientOptions.indices{
            for j in MenuFoodItem.Ingredients.IngredientOptions[i].section_Option.indices{
                MenuFoodItem.Ingredients.IngredientOptions[i].section_Option[j].isOn = false
            }
        }
    }
    
    
    
    func optionsSelected() -> Bool {
        let flatArray = Cart.flatMap{ $0.Item.Ingredients.IngredientOptions}
        let flatterArray = flatArray.flatMap{$0.section_Option}
        let filteredArray = flatterArray.filter{$0.isOn}
        
        if filteredArray.count != 0{
            return true
        } else {
            return false
        }
    }
}
