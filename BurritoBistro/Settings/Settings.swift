//
//  Settings.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/16/23.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: AuthManager
    
    var body: some View {
        
        VStack(spacing:0){
            ZStack{
                HStack(alignment: .center){
                    ZStack{
                        HStack(alignment:.center){
                            Button{
                                dismiss()
                            }label:{
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                            .padding(25)
                            .padding(.top)
                            Spacer()
                        }
                        
                        Text("Settings")
                            .fontWeight(Font.Weight.bold)
                            .font(.title)
                            .padding()
                            .padding(.top,8)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.vertical)
                            .padding(.top,5)
                    }
                }
            }

                .background(
                    HalfBubbleBottom(radius: 50)
                        .opacity(0.5)
                )
            Button{
                viewModel.signOut()
            }label: {
                HStack{
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .font(.title3)
                    Spacer()
                }
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.black)
                    .opacity(0.5)
                )
            }
            .padding()
            .buttonStyle(.plain)
            Image("BurritoIcon")
                .resizable()
                .foregroundColor(.white)
                .opacity(0.5)
                .frame(width: 2*UIScreen.main.bounds.height/23 + 2, height: 2*UIScreen.main.bounds.height/23 + 2)
                .padding(UIScreen.main.bounds.height/23 - 9)
                .background(
                Circle()
                    .opacity(0.5)
                )
                .padding(.top,25)
                .padding(.bottom,25)
            Spacer()
           
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,alignment: .center)
        .background(Color("bgc"))
        .ignoresSafeArea()
    }
}



struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
        Settings()
            .previewDevice("iPhone 8")

    }
}
