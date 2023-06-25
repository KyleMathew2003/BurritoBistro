//
//  FetchOrderData.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/24/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

func fetchOrdersData(_ authManager: AuthManager) async throws -> [Order]{
    var authManager = authManager

    var output: [Order] = []
    var my_OrderNumbers = try await Firestore.firestore().collection("users").document(authManager.userSession!.uid).getDocument().data()?["OrderNumbers"] as? [String] ?? []
  
    var my_Orders:[String:Any] = [:]
    for i in my_OrderNumbers {
        my_Orders[i] = (try await Firestore.firestore().collection("orders").document(i).getDocument().data())!
        let time = ((my_Orders[i]! as! [String:Any])["timeStamp"] as! Timestamp).dateValue()
        let totals = (my_Orders[i]! as! [String:Any])["price"] as! Float
        
        let cart = (my_Orders[i]! as! [String:Any])["food"] as! [String:Any]
        
        var CartArray: [CartVals] = []
        
        for j in cart.values{
            let count = (((j as? [String:Any])?["count"])! as? Int)!
            var item: MenuFoodItems = MenuItems.first{ $0.foodName == (((j as? [String:Any])?["foodName"])! as? String)!}!
            var options: [String] = ((j as? [String:Any])?["options"])! as? [String] ?? []
            
            for k in item.Ingredients.IngredientOptions.indices{
                for l in item.Ingredients.IngredientOptions[k].section_Option.indices{
                    if (options.contains(item.Ingredients.IngredientOptions[k].section_Option[l].option)){
                        item.Ingredients.IngredientOptions[k].section_Option[l].isOn.toggle()
                    }
                }
            }
            if CartArray.contains(.init(Item: item, Count: count)){
                CartArray[CartArray.firstIndex(of: .init(Item: item, Count: count))!].Count += 1
            } else{
                CartArray.append(.init(Item: item, Count: count))
            }
        }
        
        let My_Cart:my_Cart = .init(Cart: CartArray)
        
        let Tip = totals - My_Cart.subtotal()
   
        var curOrder: Order = await .init(orderModel: .init(Order: My_Cart, Tip: Tip), timeStamp: time, total: totals)
        output.append(curOrder)
    }
    return output
}
