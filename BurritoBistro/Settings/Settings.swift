//
//  Settings.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/16/23.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var AuthManager: AuthManager
    
    var body: some View {
        
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
                    Text("Settings")
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
            Button{
                AuthManager.signOut()
                
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
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
        .background(Color("bgc"))
    }
}



struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
        Settings()
            .previewDevice("iPhone 8")

    }
}
