//
//  addPaymentMethods.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 11/1/23.
//

import SwiftUI

struct addPaymentMethods: View {
    @Environment(\.dismiss) private var dismiss
    @State private var OutsideSpacing = CGFloat(10)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @EnvironmentObject var AuthManager: AuthManager
    
    @State private var CardNum = ""
    @State private var CCV = ""
    @State private var MM = ""
    @State private var YY = ""
    
    @State private var Zip = ""
    
    @State private var Name = ""
    
    
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
                        Text("Add Card Method")
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
                        
                        HStack{
                            Text("Card Information")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal,2*OutsideSpacing)

                        
                        HStack{
                            TextField("", text: $Name)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .placeholder(when: Name.isEmpty) {
                                    TextField("Cardholder Name", text:.constant("Cardholder Name"))
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
                        .padding(.horizontal,OutsideSpacing)

                        

                        HStack(){
                            HStack{
                                TextField("", text: $CardNum)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .placeholder(when: CardNum.isEmpty) {
                                        TextField("Card Number", text:.constant("Card Number"))
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
                        
                        
                        HStack(){
                            HStack{
                                TextField("", text: $MM)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .placeholder(when: MM.isEmpty) {
                                        TextField("MM", text:.constant("MM"))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                            .disabled(true)
                                    }
                                TextField("", text: $YY)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .placeholder(when: YY.isEmpty) {
                                        TextField("YY", text:.constant("YY"))
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
                            
                            HStack{
                                TextField("", text: $CCV)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .placeholder(when: CCV.isEmpty) {
                                        TextField("CCV", text:.constant("CCV"))
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
                        
                        HStack(){
                            HStack{
                                TextField("", text: $Zip)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .placeholder(when: Zip.isEmpty) {
                                        TextField("Zip Code", text:.constant("Zip Code"))
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
                        
                        
                        
                    }
                    .padding(.top,OutsideSpacing)
                    
          
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Button {
                        Task{
                            do{
                                MyStripeManager.shared.createToken(cvc: CCV, numbers: CardNum, expMonth: 12, expYear: 27 as UInt, name: "Kyle Mathew", Zip: "11784")
                            } catch{
                                print(error)
                            }
                        }
                        
                        
                      
                    }label:{
                        HStack {
                            Text("Add Payment Method")
                                .font(.title)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .disabled(!formIsValid)
                            
                        }
                    }
                }
                .padding(4)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.teal)
                   
                        .opacity(!formIsValid ? 0.5 : 1.0)
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
        .background(Color("bgc"))    }
}

extension addPaymentMethods {
    var formIsValid: Bool{
        return !(CCV == "")
        && !(Zip == "")
        && !(CardNum == "")
        && !(MM == "")
        && !(YY == "")

    }
}

#Preview {
    addPaymentMethods()
}
