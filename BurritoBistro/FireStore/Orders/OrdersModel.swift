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
    
    var OrderStatus: String{
        switch self{
        case .processing: return "Processing"
        case .rejected: return "Rejected"
        case .makingOrder: return "Making Order"
        case .delivering: return "Delivering"
        case .arrived: return "Arrived"
        case .complete: return "Complete"
        }
    }
    
    
}
@MainActor
class OrderModel: ObservableObject{
    
    var Order: my_Cart
    var OrderNumber: String
    var OrderStatus: OrderStatus
    var Total: Float
    var userSession: FirebaseAuth.User?

    
    init(Order: my_Cart, Tip: Float?) {
        self.Order = Order
        self.userSession = Auth.auth().currentUser
        self.OrderNumber = UUID().uuidString
        self.OrderStatus = .processing
        self.Total = Order.subtotal() + (Tip ?? 0)
    }
}
