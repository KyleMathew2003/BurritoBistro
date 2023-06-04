//
//  SignIn.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 3/16/23.
//

import SwiftUI

struct SignIn: View {
    @State private var Pass:String = ""
    @State private var User:String = ""
    @State private var Email:String = ""
    @State var button: Bool = true

    let height = UIScreen.main.bounds.height


    var body: some View {
        
        VStack(spacing:0){
            Text("Welcome To Bernardo's Burrito Bistro!")
                .fontWeight(Font.Weight.bold)
                .font(.title)
                .padding()
                .padding(.top,8)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width)
                .padding(.vertical)
                .background(
                    ConcaveConvexTop(radius: 50)
                        .opacity(0.5)
                )
            
            Image("BurritoIcon")
                .resizable()
                .foregroundColor(.white)
                .opacity(0.5)
                .frame(width: 2*height/23 + 2, height: 2*height/23 + 2)
                .padding(height/23 - 9)
                .background(
                Circle()
                    .opacity(0.5)
                )
                .padding(.top,25)
                .padding(.bottom,25)
            
            VStack(spacing:5){
                Text("Sign In!")
                    .fontWeight(Font.Weight.bold)
                    .font(.title3)
                    .padding(.top,15)
                    .padding(.bottom,8)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Divider()
                    .padding(.horizontal,5)
                    .frame(width:260)
                    .overlay(Color.white
                        .opacity(0.5))
                VStack(spacing:3){
                    TextField("",text: $Email)
                        .placeholder(when: Email.isEmpty){
                            Text("Email")
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .padding(.horizontal,20)
                    Divider()
                        .frame(width:250)
                        .overlay(Color.white
                            .opacity(0.3))
                }
                .padding(.vertical,5)


                VStack(spacing:3){
                    TextField("",text: $Pass)
                        .placeholder(when: Pass.isEmpty){
                            Text("Password")
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .padding(.horizontal,20)
                    Divider()
                        .frame(width:250)
                        .overlay(Color.white
                            .opacity(0.3))
                }
                .padding(.vertical,5)
                .padding(.bottom,5)

            }
            .padding(.bottom,5)
            .frame(alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .opacity(0.8)
            )
            VStack(spacing:5){
                Text("Not a member? Sign Up!")
                    .foregroundColor(.white)
                    .opacity(0.5)
                Text("Forgot Password?")
                    .foregroundColor(.white)
                    .opacity(0.5)
            }
            .padding(10)
            Spacer()
            
            Button(action: {
                self.button.toggle()
            }){
                Text("JOIN US")
                    .fontWeight(button ? Font.Weight.medium : Font.Weight.bold)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 170)
                    .background(
                        RoundedRectangle(cornerRadius: 45)
                            .foregroundColor(.teal)
                    )
                    .opacity(button ? 0.5:1)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.vertical,20)
            .background(
                ConcaveConvexBottom(radius: 50)
                    .opacity(0.5)
            )
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,alignment: .center)
        .background(Color("bgc"))
        .ignoresSafeArea()
    }
}

extension View {
    func SignInplaceholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
    ZStack(alignment: alignment){
        placeholder().opacity(shouldShow ? 0.3:0)
        self
    }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
        SignIn()
            .previewDevice("iPhone 8")

    }
}
