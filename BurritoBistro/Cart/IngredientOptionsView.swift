//
//  IngredientOptionsView.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/2/23.
//

import SwiftUI

struct IngredientOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var MenuFoodItem: MenuFoodItems
    @Binding var my_Cart: my_Cart
    @Binding var cartView: Bool
    @Binding var cur_CartItem: CartVals
    
    @State private var ImageSize = CGFloat(12)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @State private var OutsideSpacing = CGFloat(10)
    @State private var CheckOutBubblePadding = CGFloat(35)
    @State private var showAlert = false

    private func resetToggles(){
        for i in MenuFoodItem.Ingredients.IngredientOptions.indices{
            for j in MenuFoodItem.Ingredients.IngredientOptions[i].section_Option.indices{
                MenuFoodItem.Ingredients.IngredientOptions[i].section_Option[j].isOn = false
            }
        }
    }
    
    private func replaceIngredients(){
        for i in cur_CartItem.Item.Ingredients.IngredientOptions.indices{
            for j in cur_CartItem.Item.Ingredients.IngredientOptions[i].section_Option.indices{
                MenuFoodItem.Ingredients.IngredientOptions[i].section_Option[j].isOn = cur_CartItem.Item.Ingredients.IngredientOptions[i].section_Option[j].isOn
            }
            
        }
    }
    
    private func replaceCartItem(){
        my_Cart.Cart[my_Cart.Cart.firstIndex(where:{ $0 == cur_CartItem})!] = .init(Item: MenuFoodItem, Count: my_Cart.Cart[my_Cart.Cart.firstIndex(where:{ $0 == cur_CartItem})!].Count)
    }

    
    private func addToCart(menuFoodItem: MenuFoodItems){
        var isIn = false
        for i in my_Cart.Cart{
            if i.Item == menuFoodItem{
                isIn = true
                my_Cart.Cart[my_Cart.Cart.firstIndex(of: i)!].Count += 1

            }
        }
        if isIn == false{
            my_Cart.Cart.append(.init(Item: menuFoodItem, Count: 1))
        }
    }
    
    var body: some View {
        ZStack{
            
            VStack(spacing:0){
                HStack{
                    ZStack{
                        HStack{
                    Button{
                        dismiss()
                        resetToggles()
                    }label:{
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }

                    Spacer()
                        }
                        Text("Add to Cart")
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
                        
                        ForEach(MenuFoodItem.Ingredients.IngredientOptions, id:\.self){ i in
                
                VStack(alignment:.leading){
                    HStack {
                        Text("\(i.section)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        if i.selectionLimit != 0{
                            Circle()
                                .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                                .opacity(0.5)
                            Text("Choose up to \(i.selectionLimit)")
                                .lineLimit(1)
                                .font(.caption)
                                .frame(minWidth: 24, idealWidth: 24)
                                .opacity(0.5)
                        }
                        Spacer()
                        
                    }
                    .padding(.bottom,1)
                    Divider()
                        .overlay(.gray)
                        .opacity(0.4)
                    
                    //Creates the toggle for each ingredient option
                    ForEach(i.section_Option.indices, id:\.self){ j in
                        VStack{
                            HStack{
                                Text(i.section_Option[j].option)
                                Spacer()
                                if i.section_Option[j].optionPrice != 0{
                                    Text("\(i.section_Option[j].optionPrice, specifier: "%.2f")")
                                        .font(.caption)
                                        .frame(minWidth: 24, idealWidth: 24)
                                        .opacity(0.5)
                                }
                                if MenuFoodItem.Ingredients.IngredientOptions[MenuFoodItem.Ingredients.IngredientOptions.firstIndex(of: i)!].selectionLimit == 0{
                                    
                                    Image(systemName: i.section_Option[j].isOn ? "checkmark.square.fill" : "square")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(i.section_Option[j].isOn ? .white : .secondary)
                                                    .padding(.leading,5)
                                                    .onTapGesture {
                                                        MenuFoodItem.Ingredients.IngredientOptions[MenuFoodItem.Ingredients.IngredientOptions.firstIndex(of: i)!].section_Option[j].isOn.toggle()
                                                    }
                                } else{
                                    if MenuFoodItem.Ingredients.IngredientOptions[MenuFoodItem.Ingredients.IngredientOptions.firstIndex(of: i)!].selectionCount >= MenuFoodItem.Ingredients.IngredientOptions[MenuFoodItem.Ingredients.IngredientOptions.firstIndex(of: i)!].selectionLimit && MenuFoodItem.Ingredients.IngredientOptions[MenuFoodItem.Ingredients.IngredientOptions.firstIndex(of: i)!].section_Option[j].isOn == false
                                    {
                                        Image(systemName: i.section_Option[j].isOn ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(i.section_Option[j].isOn ? .white : .secondary)
                                            .padding(.leading,5)
                                            .onTapGesture {
                                                showAlert = true
                                            }
                                            .alert(isPresented: $showAlert) {
                                                Alert(title: Text("Dumb Bitch Alert"), message: Text("It says 'Choose up to \(i.selectionLimit)'"), dismissButton: .default(Text("I'm a dumb bitch")))
                                            }
                                        
                                    } else {
                                        Image(systemName: i.section_Option[j].isOn ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(i.section_Option[j].isOn ? .white : .secondary)
                                            .padding(.leading,5)
                                            .onTapGesture {
                                                MenuFoodItem.Ingredients.IngredientOptions[MenuFoodItem.Ingredients.IngredientOptions.firstIndex(of: i)!].section_Option[j].isOn.toggle()
                                            }
                                    }
                                }
                            }
                        }
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
                        
                        VStack(spacing:10){
                            HStack(spacing:0){
                                Text("Item Total")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("  (Tax Included)")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.light)
                                Spacer()
                                Text("\(MenuFoodItem.sumIngredientPrice(), specifier: "%.2f")")
                                    .foregroundColor(.white)
                                
                            }
                            HStack(spacing:0){
                                Text("Cart SubTotal")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("  (Tax Included)")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.light)
                                Spacer()
                                Text("\(my_Cart.subtotal()+MenuFoodItem.sumIngredientPrice(), specifier: "%.2f")")
                                    .foregroundColor(.white)

                            }
                        }
                        .padding(.horizontal,OutsideSpacing*2)
                        
                    }
                    .padding(.top,OutsideSpacing)

                Spacer()
                }

            }
         
            VStack {
                Spacer()
                HStack {
                    Button {
                        dismiss()
                        if cartView{
                            replaceCartItem()
                        } else{
                            addToCart(menuFoodItem: MenuFoodItem)

                        }
                        resetToggles()
                    }label:{
                        HStack {
                            if cartView{
                                Text("Change Options")
                                    .font(.title)
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            } else{
                                Text("Add To Cart")
                                    .font(.title)
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
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
        .onAppear(perform: replaceIngredients)
        
    }
}


struct IngredientOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientOptionsView(MenuFoodItem: .constant(.init(foodName: "bernies", MenuItemDetails: .init(description: "fsa", price: 2, group: .drinks), Ingredients: .init(IngredientOptions: [.init(section: "Helo", section_Option: [.init(option: "hello", optionPrice: 20)], selectionLimit: 1)]))), my_Cart: .constant(.init(Cart: [])), cartView: .constant(true), cur_CartItem: .constant(.init(Item: .init(foodName: "s", MenuItemDetails: .init(description: "", price: 2, group: .drinks), Ingredients: .init(IngredientOptions: [.init(section: "", section_Option: [.init(option: "", optionPrice: 2)], selectionLimit: 2)])), Count: 2)))
        
    }
}
