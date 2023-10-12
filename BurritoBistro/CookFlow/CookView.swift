//
//  CookView.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 7/21/23.
//

import SwiftUI
import Foundation




struct CookView: View {
    @EnvironmentObject var AuthManager: AuthManager
    @StateObject var myOrder = incompleteOrderFetch()
    
    @State private var toggleStates: [[[String:Bool]]] = [[],[]]
    
    @State private var curStates: [Int:OrderStatus] = [:]
        
    private func populateCurStates(){
        curStates = [:]
        for i in myOrder.incompleteOrders.indices{
            curStates[i] = (myOrder.incompleteOrders[i].0.orderModel.OrderStatus)
        }
    }

    
    private func updateOrderStatus(for id: Int, with newValue: OrderStatus){
        myOrder.incompleteOrders[id].0.orderModel.OrderStatus = newValue
        myOrder.objectWillChange.send()
    }
    
    
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
    
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                HStack{
                    ZStack{
                        HStack{
                            NavigationLink{
                                Settings()
                                    .navigationBarHidden(true)
                            } label: {
                                Image(systemName: "gear")
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundColor(.black)
                                            .opacity(0.5)
                                    )
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        Text("Incomplete Orders")
                            .fontWeight(Font.Weight.bold)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.bottom,10)
                .frame(width:UIScreen.main.bounds.width)
                .background(
                    HalfBubbleBottom(radius: 20)
                        .foregroundColor(Color("bubbleColor"))
                        .ignoresSafeArea()
                    
                )
                HStack{
                    ScrollView{
                        VStack(spacing:0){
                            ForEach(myOrder.incompleteOrders.indices, id:\.self){ i in
                                VStack(){
                                    HStack(alignment: .center) {
                                        Image(systemName: toggleBinding(for:  myOrder.incompleteOrders[i].0.id, in: 0, with: false).wrappedValue ? "checkmark.square" : "square")
                                            .foregroundColor(toggleBinding(for:  myOrder.incompleteOrders[i].0.id, in: 0, with: false).wrappedValue ? Color.teal: Color.white)
                                            .rotationEffect(Angle(degrees: toggleBinding(for: myOrder.incompleteOrders[i].0.id, in: 0, with: false).wrappedValue ? 0: -90))
                                            .simultaneousGesture(LongPressGesture(minimumDuration: 0).onEnded { _ in
                                                toggleBinding(for:  myOrder.incompleteOrders[i].0.id, in: 0, with: false).wrappedValue.toggle()
                                            })
                                            .animation(.linear(duration: 0.2))
                                            .frame(width:20)
                                        Text("\(DateFormatter.localizedString(from:  myOrder.incompleteOrders[i].0.timeStamp, dateStyle: .medium, timeStyle: .none))")
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                        Circle()
                                            .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                            .opacity(0.5)
                                        Text("\( myOrder.incompleteOrders[i].1.firstName) \(myOrder.incompleteOrders[i].1.lastName)")
                                            .font(.caption)
                                            .fontWeight(.light)
                                            .onTapGesture {
                                                print(myOrder.incompleteOrders[i].0.orderModel.OrderStatus)

                                            }
                                        Circle()
                                            .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                            .opacity(0.5)
                                        Text("\( myOrder.incompleteOrders[i].0.total, specifier: "%.2f")")
                                            .font(.caption)
                                            .fontWeight(.light)
                                        Spacer()
                                        
                                    }
                                    .padding(.bottom,5)
                                    VStack(alignment:.center){
                                        ForEach(myOrder.incompleteOrders[i].0.orderModel.Order.Cart.indices, id:\.self) { itemIndex in
                                            VStack(alignment:.leading){
                                                HStack(alignment:.center){
                                                    Image(systemName: toggleBinding(for: myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].id, in: i+1, with: false).wrappedValue ? "checkmark.square" : "square")
                                                    
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 10, height: 10)
                                                        .padding(.top,3)
                                                        .foregroundColor(toggleBinding(for: myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].id, in: i+1, with: false).wrappedValue ? Color.teal : Color.white)
                                                        .rotationEffect(Angle(degrees:toggleBinding(for: myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].id, in: i+1, with: false).wrappedValue ? 0:-90))
                                                        .gesture(LongPressGesture(minimumDuration: 0).onEnded { _ in
                                                            toggleBinding(for: myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].id, in: i+1,with: false).wrappedValue.toggle()                                                        })
                                                        .animation(.linear(duration: 0.2))
                                                    
                                                    VStack(alignment:.leading){
                                                        HStack(alignment:.center){
                                                            Text(myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].Item.foodName)
                                                                .font(.caption)
                                                            Circle()
                                                                .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                                .opacity(0.5)
                                                            Text("\(myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].Count)")
                                                            Spacer()
                                                            Text("\(myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].Item.sumIngredientPrice() * Float(myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].Count), specifier:"%.2f")")
                                                                .font(.caption)
                                                        }
                                                        .font(.caption)
                                                        
                                                        
                                                        
                                                        ForEach(myOrder.incompleteOrders[i].0.orderModel.Order.Cart[itemIndex].Item.returnOnOptions(), id:\.0){ option in
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
                                        Divider()
                                            .overlay{
                                                Color.white
                                                    .opacity(0.5)
                                            }
                                        HStack{
                                            VStack(alignment:.leading){
                                                Text(myOrder.incompleteOrders[i].0.orderModel.location)
                                            }
                                            .font(.caption)
                                            Spacer()
                                        }
                                        Divider()
                                            .overlay{
                                                Color.white
                                                    .opacity(0.5)
                                            }
                                        HStack{
                                            Text("Subtotal")
                                            Spacer()
                                            Text("\(myOrder.incompleteOrders[i].0.orderModel.Order.subtotal(), specifier: "%.2f")")
                                        }
                                        .font(.footnote)
                                        HStack{
                                            Text("Tip")
                                            Spacer()
                                            Text("\(myOrder.incompleteOrders[i].0.total - myOrder.incompleteOrders[i].0.orderModel.Order.subtotal(), specifier: "%.2f")")
                                        }
                                        .font(.footnote)
                                        HStack{
                                            Text("Total")
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("\(myOrder.incompleteOrders[i].0.total, specifier: "%.2f")")
                                                .fontWeight(.semibold)
                                        }
                                        .font(.subheadline)
                                        Divider()
                                            .overlay{
                                                Color.white
                                                    .opacity(0.5)
                                            }
                                        VStack{
                                        HStack(spacing:0){
                                            ForEach(OrderStatus.allCases.prefix(3), id: \.self){ item in
                                                Button{
                                                    if myOrder.incompleteOrders[i].0.undo == false{
                                                        updateOrderStatus(for: i, with: item)
                                                    }
                                                }label:{
                                                    VStack(alignment:.center,spacing:4){
                                                        Image(systemName: item.OrderSymbol)
                                                            .resizable()
                                                            .frame(width:15, height:15)
                                                            .foregroundColor(item == .rejected ? Color.red : Color.white)
                                                        Text(item.OrderStatusShort)
                                                            .font(.caption2)
                                                    }
                                                    .padding(5)
                                                    .padding(.horizontal,10)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 25)
                                                            .foregroundColor(myOrder.incompleteOrders[i].0.orderModel.OrderStatus == item ?
                                                                             Color.teal

                                                                             :
                                                                             Color.clear)
                                                    )
                                                    .frame(maxWidth:.infinity)
                                                }
                                                .animation(.linear)
                                            }
                                        }
                                            HStack(spacing:0){
                                                ForEach(OrderStatus.allCases.suffix(3), id: \.self){ item in
                                                    Button{
                                                        if myOrder.incompleteOrders[i].0.undo == false{
                                                            updateOrderStatus(for: i, with: item)
                                                        }
                                                    }label:{
                                                        VStack(alignment:.center,spacing:4){
                                                            Image(systemName: item.OrderSymbol)
                                                                .resizable()
                                                                .frame(width:15, height:15)
                                                                .foregroundColor(item == .complete ? Color.teal : Color.white)

                                                        
                                                            Text(item.OrderStatusShort)
                                                                .font(.caption2)
                                                        }
                                                        .padding(5)
                                                        .padding(.horizontal,10)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .foregroundColor(myOrder.incompleteOrders[i].0.orderModel.OrderStatus == item ?
                                                                                 Color.teal

                                                                                 :
                                                                                 Color.clear)
                                                            
                                                            
                                                        )
                                                        .frame(maxWidth:.infinity)
                                                    }
                                                    .animation(.linear)

                                                }
                                            }
                                            Text("Currently: \(curStates[i]?.OrderStatus ?? "")")
                                                .font(.caption)

                                            Button{
                                                if myOrder.incompleteOrders[i].0.undo == false{
                                                    myOrder.incompleteOrders[i].0.undo = true
                                                    myOrder.objectWillChange.send()

                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                        
                                                        if myOrder.incompleteOrders[i].0.undo{
                                                            Task{
                                                                do {
                                                                    let orderNumber = myOrder.incompleteOrders[i].0.orderModel.OrderNumber
                                                                    let newValues = myOrder.incompleteOrders[i].0.orderModel.OrderStatus
                                                                    try await myOrder.uploadOrderStatus(AuthManager, orderNumber: orderNumber, newValue: newValues, i: i)
                                                                    populateCurStates()
                                                                } catch{
                                                                    print(error)
                                                                }
                                                            }
                                                        }
                                                        myOrder.incompleteOrders[i].0.undo = false
                                                        myOrder.objectWillChange.send()
                                                    }
                                                } else{
                                                    myOrder.incompleteOrders[i].0.undo = false
                                                    myOrder.objectWillChange.send()
                                                }

                                            } label:{
                                                Text(myOrder.incompleteOrders[i].0.undo ? "Undo" : "Update")
                                                    .opacity(myOrder.incompleteOrders[i].0.orderModel.OrderStatus == curStates[i] ?
                                                             0.5
                                                             :
                                                             1)
                                                    .padding(5)
                                                    .padding(.horizontal,40)
                                                    .background(
                                                        ZStack(alignment:.leading){
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .foregroundColor((myOrder.incompleteOrders[i].0.orderModel.OrderStatus == curStates[i] || myOrder.incompleteOrders[i].0.undo == true) ?
                                                                                 Color.clear
                                                                                 
                                                                                 :
                                                                                    Color.teal)

                                                            RoundedRectangle(cornerRadius: 25)
                                                                .foregroundColor(Color.teal)
                                                                .frame(maxWidth: myOrder.incompleteOrders[i].0.undo ? .infinity : 0)
                                                                .animation(.linear(duration: myOrder.incompleteOrders[i].0.undo ? 2 : 0))
                                                        }
                                                            
                                                        )
                                            }
                                            .disabled(myOrder.incompleteOrders[i].0.orderModel.OrderStatus == curStates[i])
                                    }
                                        .frame(maxWidth:.infinity)
                                        }
                                        .animation(.spring(response: 0.5))
                                        
                                    
                                }
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .opacity(0.5)
                                )
                                .animation(.spring(response:0.5))
                                .padding(.horizontal,10)
                                .padding(.top,10)
                            }
                            Spacer(minLength: 150)
                        }
                    }
                    .frame(maxWidth:.infinity)
                    .ignoresSafeArea()

                }
                .frame(maxWidth:.infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
            .background(Color("bgc"))
            .onAppear{
                Task{
                    do{
                        myOrder.incompleteOrders = try await myOrder.fetchIncompleteOrders(AuthManager)
                        populateCurStates()
                    } catch{
                        print(error)
                    }
                }

            }
            
            .navigationBarHidden(true)
        }
    }
}
