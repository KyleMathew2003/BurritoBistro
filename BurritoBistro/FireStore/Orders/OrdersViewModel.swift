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

struct Order: Identifiable, Hashable, Equatable{
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID().uuidString
    var orderModel: OrderModel
    let timeStamp: Date
    let total: Float
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
}

struct foodIngredient{
    let food: String
    let options: [String]
    let count: Int
}

class OrdersViewModel: ObservableObject{
    private var authManager : AuthManager
    private var my_Order: OrderModel
    
    init(my_Order: OrderModel, auth: AuthManager) {
        self.authManager = auth
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
                food.append(.init(food: i.Item.foodName, options: options, count: i.Count))
            }
            var foodIngredientdict:[String:Any] = [:]
            for pair in food {
                foodIngredientdict[UUID().uuidString] = [
                    "foodName": pair.food,
                    "options": pair.options,
                    "count": pair.count
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
            let document = await Firestore.firestore().collection("users").document(authManager.userSession!.uid)
            var dataArray = try await document.getDocument().data()?["OrderNumbers"] as? [String] ?? ["nil"]
            await dataArray.append(my_Order.OrderNumber)
                
            
            await Firestore.firestore().collection("users")
                .document(authManager.userSession!.uid)
                .updateData(["OrderNumbers": dataArray]) { error in
                    if let error = error{
                        print("Error updating data: \(error.localizedDescription)")
                    }
                    else {
                        print("Update successful")
                        
                    }
                }
        }
        catch{
            print("DEBUG: Failed to place order \(error.localizedDescription)")

        }
    }
}
