//
//  CookDBSOrders.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 7/21/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct OrderUserData{
    var firstName: String
    var lastName: String
    var phoneNumber: Int
}

class incompleteOrderFetch: ObservableObject{
    public var incompleteOrders: [(Order,OrderUserData)] = []
    
    func printOrders(){
        for i in incompleteOrders{
            print(i.0.timeStamp)
        }
    }
    
    func uploadOrderStatus(_ authManager: AuthManager, orderNumber: String, newValue: OrderStatus,i: Int) async throws{
        var authManager = authManager
        
        guard let my_session = try await authManager.userSession else{
            return
        }
        do {
                let db = Firestore.firestore()
                try await db.collection("orders").document(orderNumber).updateData(["orderStatus": newValue.OrderStatus])
            } catch {
                print(error)
                throw error
            }
        incompleteOrders[i].0.orderModel.OrderStatus = newValue
    }
    
    func fetchIncompleteOrders(_ authManager: AuthManager) async throws -> [(Order,OrderUserData)] {
        var authManager = authManager
        
        var IncompleteOrders: [(Order,OrderUserData)] = []
        
        guard let my_session = try await authManager.userSession else{
            return []
        }
        
        let my_OrderNumbersBuffer = try await Firestore.firestore().collection("orders").whereField("orderStatus", notIn: ["Completed","Rejected"])
        
        var myQueryData:[(Date,Float,String,[String:Any], String,String,String,String)] = []
        
        var tempQuery = try await my_OrderNumbersBuffer.getDocuments()
        
        for document in tempQuery.documents{
            if let data = document.data() as? [String:Any]{
                let mytime = (data["timeStamp"] as! Timestamp).dateValue()
                let totals = data["price"] as! Float
                var mystatus = data["orderStatus"] as! String
                let cart = data["food"] as! [String:Any]
                let location = data["location"] as! String
                let firstName = data["firstName"] as! String
                let lastName = data["lastName"] as! String
                let orderNum = data["orderNumber"] as! String
                myQueryData.append((mytime,totals,mystatus,cart,location,firstName,lastName,orderNum))
            }
        }
        
        for document in myQueryData{
            let time = document.0
            let totals = document.1
            var status = document.2
            let cart = document.3
            let location = document.4
            let firstName = document.5
            let lastName = document.6
            let orderNum = document.7
            
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
                
                let My_Cart:my_Cart = .init(Cart: CartArray)
                
                let Tip = totals - My_Cart.subtotal()
                
                var curOrder: Order = .init(orderModel: .init(Order: My_Cart, Tip: Tip, location: location), timeStamp: time, total: totals)
                curOrder.orderModel.changeStatus(input: status)
                curOrder.orderModel.changeOrderNumber(input: orderNum)
                IncompleteOrders.append((curOrder,.init(firstName: firstName, lastName: lastName, phoneNumber: 0)))
            }
        }
        incompleteOrders = IncompleteOrders
        return incompleteOrders
    }
    
}
