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
                        
                        ForEach(MenuFoodItem.Ingredients.IngredientOptions, id:\.self){ i in
                
                VStack(alignment:.leading){
                    HStack {
                        Text("\(i.section)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Circle()
                            .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                            .opacity(0.5)
                        Text("\(i.section)")
                            .font(.caption)
                            .frame(minWidth: 24, idealWidth: 24)
                            .opacity(0.5)
                        Spacer()
                        
                    }
                    .padding(.bottom,1)
                    ForEach(i.section_Option, id:\.self){ j in
                        VStack{
                            Toggle(isOn: .constant(j.isOn)){
                                Text(j.option)
                            }
                        }
                    }

                    Divider()
                        .overlay(.gray)
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

                        
                        
                        
                    }
                    .padding(.top,OutsideSpacing)

                Spacer()
                }

            }
         
            VStack {
                Spacer()
                HStack {
                    NavigationLink {
                    }label:{
                        HStack {
                            Text("Add To Cart")
                                .font(.title)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                            .lineLimit(1)
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


struct IngredientOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientOptionsView(MenuFoodItem: .constant(.init(foodName: "bernies", MenuItemDetails: .init(description: "fsa", price: 2, group: .drinks), Ingredients: .init(IngredientOptions: [.init(section: "Helo", section_Option: [.init(option: "hello", optionPrice: 20)])]))))
        
    }
}
