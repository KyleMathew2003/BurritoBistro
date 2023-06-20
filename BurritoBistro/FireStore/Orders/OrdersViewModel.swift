//
//  OrdersViewModel.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/18/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct foodIngredient{
    let food: String
    let options: [String]
}

class OrdersViewModel: ObservableObject{
    private var my_Order: OrderModel
    
    init(my_Order: OrderModel) {
        self.my_Order = my_Order
    }
    
    
    
    
    func addOrder() async throws{
        do{
            guard let user = Auth.auth().currentUser else { return }
            var food: [foodIngredient] = []
            for i in await (my_Order.Order.Cart){
                var options: [String] = []
                let flatArray = i.Item.Ingredients.IngredientOptions.flatMap{ $0.section_Option}
                let filteredArray = flatArray.filter{$0.isOn}
                for j in (filteredArray){
                    options.append(j.option)
                }
                food.append(.init(food: i.Item.foodName, options: options))
            }
            var foodIngredientdict:[String:Any] = [:]
            for pair in food {
                foodIngredientdict[UUID().uuidString] = [
                    "key": pair.food,
                    "values": pair.options
                ] as [String : Any]
            }
            
            let data = await ["orderNumber" : my_Order.OrderNumber,
                        "userID" : user.uid,
                              "price" : (round(my_Order.Total * 100) / 100),
                        "food" : foodIngredientdict,
                        "orderStatus" : my_Order.OrderStatus.OrderStatus,
                        "timeStamp" : Timestamp(date: Date())] as [String : Any]
            await Firestore.firestore().collection("orders")
                .document(my_Order.OrderNumber)
                .setData(data){ _ in
                    print("DEBUG: Order data uploaded")
                }
        }
        catch{
            print("DEBUG: Failed to place order \(error.localizedDescription)")

        }
    }
}
