//
//  Cart.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 5/24/23.
//

import SwiftUI
import Combine

struct CartView: View {
    @EnvironmentObject var Auth: AuthManager
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var My_Order: Orders
    @Binding var my_Cart: my_Cart
    @Binding var Tip: String
    @State var Location: String = ""

    @State private var Menu = MenuItems
    @State private var ImageSize = CGFloat(12)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @State private var OutsideSpacing = CGFloat(10)
    @State private var CheckOutBubblePadding = CGFloat(35)
    
    private func binding(for element:MenuFoodItems) -> Binding<MenuFoodItems> {
        guard let index = MenuItems.firstIndex(where: { $0 == element }) else {
                fatalError("Element not found in parentArray")
            }
            return $Menu[index]
        }
    
    private func returnTip(Tip: String) -> Float{
        if Float(Tip) == nil {
            return 0.0
        } else{
            return Float(Tip)!
        }
    }
    
    private func onRecieveInputSanitize(_ input: String) -> String {
        if input.contains("."){
            let firstindex = Array(input).firstIndex(where: {i in i == "."})!
            let prefix = String(Array(input).prefix(upTo: firstindex+1))
            var suffix = String(Array(input).suffix(from: firstindex+1)).replacingOccurrences(of: ".", with: "")
            
            if Array(suffix).count > 2{
                suffix = String(Array(suffix).prefix(upTo: 2))
                return prefix + suffix
            }
            return prefix + suffix

            
        }
        return input
    }

    
    private func onSubmitInputSanitize(_ input: String) -> String {
        if input.contains("."){
        let firstindex = Array(input).firstIndex(where: {i in i == "."})!
        var prefix = String(Array(input).prefix(upTo: firstindex+1))
        var suffix = String(Array(input).suffix(from: firstindex+1))
        
        if prefix.count == 1 {
            prefix = "0."
        }
        
        if suffix.count == 0 {
            suffix = "00"
        }
        if suffix.count == 1{
            suffix = suffix + "0"
        }
        
        return prefix + suffix
        }
        return input + ".00"
    }
    
   
    var body: some View {
        NavigationView{
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
                            ForEach(my_Cart.Cart, id:\.self){ i in
                                NavigationLink{
                                    IngredientOptionsView(
                                        MenuFoodItem:
                                            self.binding(for:
                                                            MenuItems[MenuItems.firstIndex(where : {$0.foodName == i.Item.foodName})!])
                                        ,my_Cart: $my_Cart, cartView: .constant(true),cur_CartItem: $my_Cart.Cart[my_Cart.Cart.firstIndex(where: {$0 == i })!])
                                    .navigationBarHidden(true)
                                }label:{
                                    
                                    VStack(alignment:.leading, spacing: 10){
                                        HStack {
                                            Text("\(i.Item.foodName)")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .lineLimit(1)
                                            Circle()
                                                .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                                .opacity(0.5)
                                            Text("$\(i.Item.sumIngredientPrice()*Float(i.Count), specifier: "%.2f")")
                                                .font(.caption)
                                                .frame(minWidth: 24, idealWidth: 24)
                                                .opacity(0.5)
                                            Spacer()
                                            
                                            HStack {
                                                if i.Count == 1{
                                                    Button {
                                                        my_Cart.removeFromCart(menuFoodItem: i.Item)
                                                    } label:{
                                                        Image(systemName: "trash")
                                                            .resizable()
                                                            .frame(width:ImageSize,height:ImageSize)
                                                    }
                                                    
                                                } else{
                                                    Button {
                                                        my_Cart.removeFromCart(menuFoodItem: i.Item)
                                                    } label:{
                                                        Image(systemName: "chevron.down")
                                                            .resizable()
                                                            .frame(width:ImageSize,height:ImageSize-5)
                                                    }
                                                }
                                                Text("\(i.Count)")
                                                    .font(.body)
                                                    .foregroundColor(.black)
                                                Button {
                                                    my_Cart.addToCart(menuFoodItem: i.Item)
                                                } label:{
                                                    Image(systemName: "chevron.up")
                                                        .resizable()
                                                        .frame(width:ImageSize,height:ImageSize-5)
                                                }
                                            }
                                            .foregroundColor(.black)
                                            .frame(
                                                minHeight: 24,
                                                idealHeight: 24,
                                                maxHeight: 24)
                                            .padding(.horizontal,8)
                                            .padding(.vertical, 0)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .foregroundColor(.white)
                                                    .opacity(0.85)
                                            )
                                            
                                        }
                                        if i.Item.returnOnOptions().count != 0{
                                            Divider()
                                                .overlay(.white)
                                                .opacity(0.4)
                                        }
                                        ForEach(i.Item.returnOnOptions(), id:\.0) { j in
                                            HStack{
                                                Text(j.0)
                                                Spacer()
                                                if j.1 != 0{
                                                    Text("\(j.1,specifier : "%.2f")")
                                                }
                                            }
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .opacity(0.5)
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
                                
                            }
                            VStack(){
                                HStack{
                                    TextField("", text: $Location)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .placeholder(when: Location.isEmpty) {
                                            TextField("Enter Your Hall", text:.constant("Enter Your Hall"))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                                .disabled(true)
                                        }
                                }
                                .padding(.vertical)
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .opacity(BubbleOpcaity)
                                )
                                
                            }
                            .padding(.horizontal,OutsideSpacing)
                            
                            VStack(){
                                NavigationLink{
                                    PayementSelection()
                                    .navigationBarHidden(true)
                                }
                            label:{
                                HStack{
                                    TextField("", text: .constant(""))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .placeholder(when: true) {
                                            TextField("Select Payment Method", text:.constant("Select Payment Method"))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                                .disabled(true)
                                        }
                                        .disabled(true)
                                }
                                
                            }
                                
                            }
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .opacity(BubbleOpcaity)
                            )
                            .padding(.horizontal,OutsideSpacing)
                            
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
                                    Text("\(my_Cart.subtotal(), specifier: "%.2f")")
                                        .foregroundColor(.white)
                                    
                                }
                                HStack(spacing:10){
                                    Text("Tip")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    TextField("", text: $Tip)
                                        .placeholder(when: Tip.isEmpty) {
                                            TextField("0.00", text:.constant("0.00"))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.trailing)
                                                .disabled(true)
                                            
                                        }
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(.white)
                                        .onReceive(Just(Tip)){ newValue in
                                            let filtered = newValue.filter{ "0123456789.".contains($0)}
                                            if filtered != newValue {
                                                self.Tip = filtered
                                            }
                                            
                                            let filtered2 = onRecieveInputSanitize(self.Tip)
                                            self.Tip = filtered2
                                            
                                        }
                                        .onSubmit {
                                            self.Tip = onSubmitInputSanitize(self.Tip)
                                        }
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
                                    Text("\(my_Cart.subtotal() + returnTip(Tip: Tip), specifier: "%.2f")")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal,OutsideSpacing*2)
                            .padding(.top,5)
                        }
                        .padding(.top,OutsideSpacing)
                        Spacer()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            if Location != ""{
                                
                                let orderModel = OrderModel(Order: my_Cart, Tip: returnTip(Tip: Tip), location: Location)
                                let cur_Order = OrdersViewModel(my_Order: orderModel, auth: Auth)
                                Task{
                                    
                                    try await cur_Order.addOrder()
                                    do{
                                        await My_Order.fetchOrdersFromDatabase(authManager: Auth)
                                    } catch {
                                        print("Main Menu Error: \(error)")
                                    }
                                    my_Cart.clearCart()
                                    dismiss()
                                }
                            } else if Location == ""{
                                print("Yo This is Not Valid")
                            }
                        }label:{
                            HStack {
                                Text("Place Order")
                                    .font(.title)
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text("\(my_Cart.subtotal() + returnTip(Tip: Tip), specifier: "%.2f")")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding(7)
                                    .frame(
                                        minWidth:CheckOutBubblePadding,
                                        minHeight: CheckOutBubblePadding,
                                        idealHeight: CheckOutBubblePadding,
                                        maxHeight: CheckOutBubblePadding)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundColor(.black)
                                    )
                            }
                        }
                    }
                    .padding(4)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.teal)
                            .opacity(0.85)
                    )
                    .padding(40)
                    .frame(width:UIScreen.main.bounds.width)
                    .background(
                        HalfBubbleTop(radius: 50)
                            .foregroundColor(Color("bubbleColor"))
                    )
                }
                .ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bgc"))
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(My_Order: .constant(.init()), my_Cart: .constant(.init(Cart: [])), Tip: .constant(""))
    }
}
