//
//  Cart.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 5/24/23.
//

import SwiftUI
import Combine

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var Cart: [CartVals]
    
    @State private var ImageSize = CGFloat(12)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @State private var OutsideSpacing = CGFloat(10)
    @State private var CheckOutBubblePadding = CGFloat(35)
    
    @Binding var Tip: String
    
    
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
    
    

    
    
    var subtotalCost: Float {
        Cart.reduce(0) { $0 + Float($1.Count) * $1.Item.MenuItemDetails.price}
    }
    
    
    
   
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
                        
                        ForEach(Cart, id:\.self){ i in
                
                VStack(alignment:.leading){
                    HStack {
                        Text("\(i.Item.foodName)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Circle()
                            .frame(minWidth: 4, idealWidth: 5, maxWidth: 5, minHeight: 4, idealHeight: 5, maxHeight: 5)
                            .opacity(0.5)
                        Text("$\(i.Item.MenuItemDetails.price*Float(i.Count), specifier: "%.2f")")
                            .font(.caption)
                            .frame(minWidth: 24, idealWidth: 24)
                            .opacity(0.5)
                        Spacer()
                        
                        HStack {
                            if i.Count == 1{
                            Image(systemName: "trash")
                                    .resizable()
                                    .frame(width:ImageSize,height:ImageSize)

                            } else{
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .frame(width:ImageSize,height:ImageSize-5)


                            }
                            Text("\(i.Count)")
                                .font(.body)
                                .foregroundColor(.black)
                            Image(systemName: "chevron.up")
                                .resizable()
                                .frame(width:ImageSize,height:ImageSize-5)
                            

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
                    .padding(.bottom,1)
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
                                Text("Subtotal")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Text(" (Tax Included)")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.light)
                                Spacer()
                                Text("\(subtotalCost, specifier: "%.2f")")
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
                                Text("\(subtotalCost + returnTip(Tip: Tip), specifier: "%.2f")")
                                    .foregroundColor(.white)

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
                HStack {
                    NavigationLink {
                    }label:{
                        HStack {
                            Text("Place Order")
                                .font(.title)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                            .lineLimit(1)
                        
                            Text("\(subtotalCost, specifier: "%.2f")")
                                .foregroundColor(.white)
                                .font(.title3)
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

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(Cart: .constant([]), Tip: .constant(""))
    }
}
