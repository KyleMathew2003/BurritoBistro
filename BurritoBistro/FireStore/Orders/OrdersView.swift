//
//  OrdersView.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/18/23.
//

import SwiftUI
import Combine
import Foundation

struct OrdersView: View {
    @Binding var Orders: [Order]
    @Binding var my_Cart: my_Cart

    @EnvironmentObject var AuthManager: AuthManager
    @State private var Menu = MenuItems

    private func binding(for element:MenuFoodItems) -> Binding<MenuFoodItems> {
        guard let index = MenuItems.firstIndex(where: { $0 == element }) else {
                fatalError("Element not found in parentArray")
            }
            return $Menu[index]
        }
    
    private func addToOrderToCart(order:Order){
        for item in order.orderModel.Order.Cart{
            if my_Cart.Cart.compactMap({$0.Item}).contains(where:{$0 == item.Item}){
                my_Cart.Cart[my_Cart.Cart.firstIndex(where: {$0.Item == item.Item})!].Count += item.Count
            } else {
                my_Cart.Cart.append(.init(Item: item.Item, Count: item.Count))
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
        
    @State private var ImageSize = CGFloat(12)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @State private var OutsideSpacing = CGFloat(10)
    @State private var CheckOutBubblePadding = CGFloat(35)
   
    var body: some View {
        ZStack{
            
            VStack(spacing:0){
                HStack{
                    ZStack{
                        HStack{
                    Button{
                        dismiss()
                    }label:{
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }

                    Spacer()
                        }
                        Text("Check Out")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.bottom,10)
                .background(
                    HalfBubbleBottom(radius: 20)
                        .foregroundColor(Color("bubbleColor"))
                        .ignoresSafeArea()
                    
                )
                
                ScrollView{
                    VStack(){
                        ForEach($Orders, id:\.self){ $i in
                            Button{
                              addToOrderToCart(order: i)
                            }label:{
                            
                            VStack(alignment:.leading){
                                HStack {
                                    Text("\(DateFormatter.localizedString(from: i.timeStamp, dateStyle: .medium, timeStyle: .none))")
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    Circle()
                                        .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                        .opacity(0.5)
                                    Text("\(i.orderModel.OrderStatus.OrderStatus)")
                                        .font(.caption)
                                        .fontWeight(.light)
                                    Spacer()

                                }
                                .padding(.bottom,5)
                            }
                            .foregroundColor(.white)
                            .padding(BubbleContentSpacing)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .opacity(BubbleOpcaity)
                            )
                            .padding(.horizontal,OutsideSpacing)
                            
                        }
                            .buttonStyle(.plain)

                        }
                        
                        VStack(spacing:10){
                            HStack(spacing:0){
                                Text("Subtotal")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Text(" (Tax Included)")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.light)
                                Spacer()
                            }
                            Divider()
                                .overlay(Color.white)
                                .opacity(0.5)
                                .padding(.horizontal)
                            HStack(spacing:0){
                                Text("Total")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Text(" (Tax Included)")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.light)
                                Spacer()
                            }
                        }
                        .padding(.horizontal,OutsideSpacing*2)
                        .padding(.top)
                    }
                    .padding(.top,OutsideSpacing)
                Spacer()
                }
            }
         
            VStack {
                Spacer()
            }
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bgc"))
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(Orders: .constant([.init(orderModel: .init(Order: .init(Cart: [.init(Item: .init(foodName: "bal", MenuItemDetails: .init(description: "", price: 1, group: .drinks), Ingredients: .init(IngredientOptions: [])), Count: 1)]), Tip: 1), timeStamp: .now, total: 1),.init(orderModel: .init(Order: .init(Cart: [.init(Item: .init(foodName: "bal", MenuItemDetails: .init(description: "", price: 1, group: .drinks), Ingredients: .init(IngredientOptions: [])), Count: 1)]), Tip: 1), timeStamp: .now, total: 1)]), my_Cart: .constant(.init(Cart: [])))
    }
}
