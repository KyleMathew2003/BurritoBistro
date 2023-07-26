//
//  OrdersModel.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/18/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum OrderStatus: Int, CaseIterable{
    case processing
    case rejected
    case makingOrder
    case delivering
    case arrived
    case complete
    
    var OrderStatusShort: String{
        switch self{
        case .processing: return "Waiting"
        case .rejected: return "Rejected"
        case .makingOrder: return "Cooking"
        case .delivering: return "Delivering"
        case .arrived: return "Arrived"
        case .complete: return "Complete"
        }
    }
    var OrderSymbol: String{
        switch self{
        case .processing: return "clock"
        case .rejected: return "xmark.circle"
        case .makingOrder: return "frying.pan"
        case .delivering: return "box.truck"
        case .arrived: return "figure.walk.arrival"
        case .complete: return "checkmark.square"        }
    }
    
    var OrderStatus: String{
        switch self{
        case .processing: return "Processing"
        case .rejected: return "Rejected"
        case .makingOrder: return "Making Order"
        case .delivering: return "Delivering"
        case .arrived: return "Arrived"
        case .complete: return "Completed"
        }
    }
    
    
}


class OrderModel: ObservableObject{
    
    var Order: my_Cart
    var OrderNumber: String
    @Published var OrderStatus: OrderStatus
    var Total: Float
    var userSession: FirebaseAuth.User?
    var location: String



    
    init(Order: my_Cart, Tip: Float?, location: String) {
        self.location = location
        self.Order = Order
    
        self.userSession = Auth.auth().currentUser
        self.OrderNumber = UUID().uuidString
        self.OrderStatus = .processing
        self.Total = Order.subtotal() + (Tip ?? 0)
    }
    
    public func changeOrderNumber(input:String){
        self.OrderNumber = input
    }
    
    public func changeStatus(input: String){
        if input == "Processing"{
            self.OrderStatus = .processing
            return
        }
        if input == "Rejected"{
            self.OrderStatus = .rejected
            return
        }
        if input == "Making Order"{
            self.OrderStatus = .makingOrder
            return
        }
        if input == "Delivering"{
            self.OrderStatus = .delivering
            return
        }
        if input == "Delivering"{
            self.OrderStatus = .arrived
            return
        }
        if input == "Completed"{
            self.OrderStatus = .complete
            return
        }
        return
    }
}
