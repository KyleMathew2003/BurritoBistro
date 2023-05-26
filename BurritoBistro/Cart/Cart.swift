//
//  Cart.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 5/24/23.
//

import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                        .foregroundColor(.black)
                        .opacity(0.5)
                        .ignoresSafeArea()
                    
                )
                Text("HAsubd")
                Spacer()
            }
            VStack{
                Spacer()
                Text("man")
            }
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bgc"))
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
