//
//  PayementSelection.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 10/31/23.
//

import SwiftUI

struct PayementSelection: View {
    @Environment(\.dismiss) private var dismiss
    @State private var OutsideSpacing = CGFloat(10)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @EnvironmentObject var AuthManager: AuthManager
    
   

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
                        Text("Card Selction")
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
                        VStack(spacing:10){
                            VStack(alignment:.leading,spacing:5){
                                HStack {
                                    Text("****-****-1249")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .padding(.bottom,1)
                            }
                            .foregroundColor(.white)
                            .padding(BubbleContentSpacing)
                            .background(
                            RoundedRectangle(cornerRadius: 25)
                                .opacity(BubbleOpcaity)
                        )
                        }
                        .padding(.horizontal,OutsideSpacing*2)
                        .padding(.top,5)
                        
                        VStack(spacing:10){
                            
                            NavigationLink{
                                addPaymentMethods()
                                    .navigationBarHidden(true)
                            }label:{
                                
                                VStack(alignment:.leading,spacing:5){
                                    HStack {
                                        Text("****-****-1249")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.bottom,1)
                                }
                                .foregroundColor(.white)
                                .padding(BubbleContentSpacing)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .opacity(BubbleOpcaity)
                                )
                            }
                            
                        }
                        .padding(.horizontal,OutsideSpacing*2)
                        .padding(.top,5)
                        
                    }
                    .padding(.top,OutsideSpacing)
                    Spacer()
                }
            }
        }
        .onAppear{
            Task{
                do{
                    try await TokenModel.shared.populateTokenArray(AuthManager)
            } catch {
                print("Main Menu Error: \(error)")
            }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bgc"))    }
}

#Preview {
    PayementSelection()
}
