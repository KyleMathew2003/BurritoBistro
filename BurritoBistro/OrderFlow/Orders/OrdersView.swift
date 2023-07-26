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
    @Binding var My_Order: Orders
    
    @Binding var my_Cart: my_Cart

    @EnvironmentObject var AuthManager: AuthManager
    @State private var Menu = MenuItems
    
    @State private var toggleStates: [[[String:Bool]]] = [[],[]]

    private func toggleBinding(for id: String, in arrayIndex:Int, with completed:Bool) -> Binding<Bool>{
        return Binding<Bool>(
            get: {
                if(arrayIndex == 0){
                }
                return isToggleOn(for: id, in: arrayIndex, with: completed)
            },
        set: { newValue in
            updateToggleState(for: id, in: arrayIndex, with: completed ,newValue: newValue)
        })
    }
    private func isToggleOn(for id: String, in arrayIndex: Int, with completed: Bool) -> Bool{
        DispatchQueue.main.async{
            if completed == true{
                while arrayIndex >= toggleStates[1].count{
                        toggleStates[1].append([:])
                }
            } else{
                while arrayIndex >= toggleStates[0].count{
                        toggleStates[0].append([:])
                }
            }
        }
        if completed == true{
            if arrayIndex < toggleStates[1].count{
                return toggleStates[1][arrayIndex][id] ?? false
            }
        } else{
            if arrayIndex < toggleStates[0].count{
                return toggleStates[0][arrayIndex][id] ?? false
            }
        }
            return false
    }
    
    private func updateToggleState(for id: String, in arrayIndex: Int, with completed: Bool, newValue: Bool){
        DispatchQueue.main.async {
        if arrayIndex >= toggleStates.count{
            if completed == true{
                toggleStates[1].append([id:newValue])

            } else {
                toggleStates[0].append([id:newValue])
            }
        }
            if completed == true {
                toggleStates[1][arrayIndex][id] = newValue
            } else {
                toggleStates[0][arrayIndex][id] = newValue
            }
        toggleBinding(for: id, in: arrayIndex, with: completed).wrappedValue = newValue
    }
    }

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
                        Text("Orders")
                            .fontWeight(Font.Weight.bold)
                            .font(.title)
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
                    VStack(spacing:OutsideSpacing){
                        if (My_Order.Orders.flatMap({$0.orderModel.OrderStatus != .complete && $0.orderModel.OrderStatus != .rejected}).count > 0){
                            VStack(spacing:OutsideSpacing){
                                HStack{
                                    Text("Current Orders")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding(.horizontal,20)
                                
                                ForEach(My_Order.Orders.indices, id:\.self) { i in
                                    if ((My_Order.Orders[i].orderModel.OrderStatus != .complete) && (My_Order.Orders[i].orderModel.OrderStatus != .rejected)){
                                        Button{
                                            addToOrderToCart(order: My_Order.Orders[i])
                                        }label:{
                                            
                                            VStack(alignment:.leading){
                                                HStack {
                                                    Image(systemName:  "chevron.down")
                                                        .rotationEffect(Angle(degrees: toggleBinding(for: My_Order.Orders[i].id, in: 0, with: false).wrappedValue ? 0: -90))
                                                        .simultaneousGesture(LongPressGesture(minimumDuration: 0).onEnded { _ in
                                                            toggleBinding(for: My_Order.Orders[i].id, in: 0, with: false).wrappedValue.toggle()
                                                        })
                                                        .animation(.linear(duration: 0.2))
                                                        .frame(width:20)
                                                    Text("\(DateFormatter.localizedString(from: My_Order.Orders[i].timeStamp, dateStyle: .medium, timeStyle: .none))")
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                    Circle()
                                                        .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                        .opacity(0.5)
                                                    Text("\(My_Order.Orders[i].orderModel.OrderStatus.OrderStatus)")
                                                        .font(.caption)
                                                        .fontWeight(.light)
                                                    Circle()
                                                        .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                        .opacity(0.5)
                                                    Text("\(My_Order.Orders[i].total, specifier: "%.2f")")
                                                        .font(.caption)
                                                        .fontWeight(.light)
                                                    Spacer()
                                                    
                                                }
                                                .padding(.bottom,5)
                                                if toggleBinding(for: My_Order.Orders[i].id, in: 0, with: false).wrappedValue == true{
                                                    VStack(alignment:.leading){
                                                        ForEach(My_Order.Orders[i].orderModel.Order.Cart.indices, id:\.self) { itemIndex in
                                                            VStack(alignment:.leading){
                                                                HStack(alignment:.top){
                                                                    Image(systemName: "chevron.down")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 10, height: 10)
                                                                        .padding(.top,3)
                                                                        .rotationEffect(Angle(degrees:toggleBinding(for: My_Order.Orders[i].orderModel.Order.Cart[itemIndex].id, in: i+1, with: false).wrappedValue ? 0:-90))
                                                                        .gesture(LongPressGesture(minimumDuration: 0).onEnded { _ in
                                                                            toggleBinding(for: My_Order.Orders[i].orderModel.Order.Cart[itemIndex].id, in: i+1,with: false).wrappedValue.toggle()                                                        })
                                                                        .animation(.linear(duration: 0.2))
                                                                    
                                                                    VStack(alignment:.leading){
                                                                        HStack(alignment:.center){
                                                                            Text(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Item.foodName)
                                                                                .font(.caption)
                                                                            Circle()
                                                                                .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                                                .opacity(0.5)
                                                                            Text("\(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Count)")
                                                                            Spacer()
                                                                            Text("\(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Item.sumIngredientPrice() * Float(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Count), specifier:"%.2f")")
                                                                                .font(.caption)
                                                                        }
                                                                        .font(.caption)
                                                                        
                                                                        if toggleBinding(for: My_Order.Orders[i].orderModel.Order.Cart[itemIndex].id, in: i+1, with: false).wrappedValue == true{
                                                                            
                                                                            ForEach(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Item.returnOnOptions(), id:\.0){ option in
                                                                                HStack{
                                                                                    Text(option.0)
                                                                                    Spacer()
                                                                                    if option.1 != 0{
                                                                                        Text("\(option.1, specifier: "%.2f")")
                                                                                    }
                                                                                }
                                                                                .font(.caption2)
                                                                                .foregroundColor(.white)
                                                                                .opacity(0.5)
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        Divider()
                                                            .overlay{
                                                                Color.white
                                                                    .opacity(0.5)
                                                            }
                                                        HStack{
                                                            Text("Subtotal")
                                                            Spacer()
                                                            Text("\(My_Order.Orders[i].orderModel.Order.subtotal(), specifier: "%.2f")")
                                                        }
                                                        .font(.footnote)
                                                        HStack{
                                                            Text("Tip")
                                                            Spacer()
                                                            Text("\(My_Order.Orders[i].total - My_Order.Orders[i].orderModel.Order.subtotal(), specifier: "%.2f")")
                                                        }
                                                        .font(.footnote)
                                                        HStack{
                                                            Text("Total")
                                                                .fontWeight(.semibold)
                                                            Spacer()
                                                            Text("\(My_Order.Orders[i].total, specifier: "%.2f")")
                                                                .fontWeight(.semibold)
                                                        }
                                                        .font(.subheadline)
                                                    }
                                                    .animation(.spring(response: 0.5))
                                                    
                                                }
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
                                        .animation(.spring(response:0.5))
                                        
                                    }
                                }
                                
                            }
                        }
                        
                   
                        
                        if (My_Order.Orders.flatMap({$0.orderModel.OrderStatus == .complete || $0.orderModel.OrderStatus == .rejected}).count > 0){
                            VStack(spacing:OutsideSpacing){
                                HStack{
                                    Text("Past Orders")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.semibold)

                                    Spacer()
                                }
                                .padding(.horizontal,20)
                                .animation(.spring(response: 0.5))
                                
                                ForEach(My_Order.Orders.indices, id:\.self) { i in
                                    if (My_Order.Orders[i].orderModel.OrderStatus == .complete || My_Order.Orders[i].orderModel.OrderStatus == .rejected){
                                        Button{
                                            addToOrderToCart(order: My_Order.Orders[i])
                                        }label:{
                                            
                                            VStack(alignment:.leading){
                                                HStack {
                                                    Image(systemName:  "chevron.down")
                                                        .rotationEffect(Angle(degrees: toggleBinding(for: My_Order.Orders[i].id, in: 0, with: true).wrappedValue ? 0: -90))
                                                        .simultaneousGesture(LongPressGesture(minimumDuration: 0).onEnded { _ in
                                                            toggleBinding(for: My_Order.Orders[i].id, in: 0, with: true).wrappedValue.toggle()
                                                        })
                                                        .animation(.linear(duration: 0.2))
                                                        .frame(width:20)
                                                    Text("\(DateFormatter.localizedString(from: My_Order.Orders[i].timeStamp, dateStyle: .medium, timeStyle: .none))")
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                    Circle()
                                                        .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                        .opacity(0.5)
                                                    Text("\(My_Order.Orders[i].orderModel.OrderStatus.OrderStatus)")
                                                        .font(.caption)
                                                        .fontWeight(.light)
                                                    Circle()
                                                        .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                        .opacity(0.5)
                                                    Text("\(My_Order.Orders[i].total, specifier: "%.2f")")
                                                        .font(.caption)
                                                        .fontWeight(.light)
                                                    Spacer()
                                                    
                                                }
                                                .padding(.bottom,5)
                                                if toggleBinding(for: My_Order.Orders[i].id, in: 0, with: true).wrappedValue == true{
                                                    VStack(alignment:.leading){
                                                        ForEach(My_Order.Orders[i].orderModel.Order.Cart.indices, id:\.self) { itemIndex in
                                                            VStack(alignment:.leading){
                                                                HStack(alignment:.top){
                                                                    Image(systemName: "chevron.down")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 10, height: 10)
                                                                        .padding(.top,3)
                                                                        .rotationEffect(Angle(degrees:toggleBinding(for: My_Order.Orders[i].orderModel.Order.Cart[itemIndex].id, in: i+1, with: true).wrappedValue ? 0:-90))
                                                                        .gesture(LongPressGesture(minimumDuration: 0).onEnded { _ in
                                                                            toggleBinding(for: My_Order.Orders[i].orderModel.Order.Cart[itemIndex].id, in: i+1,with: true).wrappedValue.toggle()                                                        })
                                                                        .animation(.linear(duration: 0.2))
                                                                    
                                                                    VStack(alignment:.leading){
                                                                        HStack(alignment:.center){
                                                                            Text(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Item.foodName)
                                                                                .font(.caption)
                                                                            Circle()
                                                                                .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                                                .opacity(0.5)
                                                                            Text("\(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Count)")
                                                                            Spacer()
                                                                            Text("\(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Item.sumIngredientPrice() * Float(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Count), specifier:"%.2f")")
                                                                                .font(.caption)
                                                                        }
                                                                        .font(.caption)
                                                                        
                                                                        if toggleBinding(for: My_Order.Orders[i].orderModel.Order.Cart[itemIndex].id, in: i+1, with: true).wrappedValue == true{
                                                                            
                                                                            ForEach(My_Order.Orders[i].orderModel.Order.Cart[itemIndex].Item.returnOnOptions(), id:\.0){ option in
                                                                                HStack{
                                                                                    Text(option.0)
                                                                                    Spacer()
                                                                                    if option.1 != 0{
                                                                                        Text("\(option.1, specifier: "%.2f")")
                                                                                    }
                                                                                }
                                                                                .font(.caption2)
                                                                                .foregroundColor(.white)
                                                                                .opacity(0.5)
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        Divider()
                                                            .overlay{
                                                                Color.white
                                                                    .opacity(0.5)
                                                            }
                                                        HStack{
                                                            Text("Subtotal")
                                                            Spacer()
                                                            Text("\(My_Order.Orders[i].orderModel.Order.subtotal(), specifier: "%.2f")")
                                                        }
                                                        .font(.footnote)
                                                        HStack{
                                                            Text("Tip")
                                                            Spacer()
                                                            Text("\(My_Order.Orders[i].total - My_Order.Orders[i].orderModel.Order.subtotal(), specifier: "%.2f")")
                                                        }
                                                        .font(.footnote)
                                                        HStack{
                                                            Text("Total")
                                                                .fontWeight(.semibold)
                                                            Spacer()
                                                            Text("\(My_Order.Orders[i].total, specifier: "%.2f")")
                                                                .fontWeight(.semibold)
                                                        }
                                                        .font(.subheadline)
                                                    }
                                                    .animation(.spring(response: 0.5))
                                                    
                                                }
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
                                        .animation(.spring(response:0.5))
                                        
                                    }
                                }
                                
                            }
                        }

                        
                    }
                    .padding(.top,OutsideSpacing)
                Spacer(minLength: 200)
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
        OrdersView(My_Order: .constant(.init()), my_Cart: .constant(.init(Cart: [])))
    }
}
