//
//  SignIn.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 3/16/23.
//

import SwiftUI

struct SignIn: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var Error = ["", "", "", ""]

    @State private var Pass:String = ""
    @State private var Email:String = ""
    
    @EnvironmentObject var viewModel: AuthManager
    
    let height = UIScreen.main.bounds.height
    
    func checkError() {
        if Email.isEmpty{
            Error[0] = "Please Put In An Email"
        } else{
            Error[0] = ""
        }
        if !Email.contains("@"){
            Error[1] = "This Email Is Not Valid"
        } else {
            Error[1] = ""

        }
        if Pass.isEmpty{
            Error[2] = "Please Put In A Password"
        } else{
            Error[2] = ""

        }
        if Pass.count < 6 {
            Error[3] = "This Password Is Not Valid"
        } else{
            Error[3] = ""

        }
    }
    


    var body: some View {
        
        VStack(spacing:0){
            Text("Hello")
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
                    if !(Error[1] == ""){
                        Text(Error[1])
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    if !(Error[0] == ""){
                        Text(Error[0])
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                   
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
                    if !(Error[3] == ""){
                        Text(Error[3])
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    if !(Error[2] == ""){
                        Text(Error[2])
                            .font(.caption)
                            .foregroundColor(.red)
                    }

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
                Button{
                    dismiss()
                } label: {
                    Text("Not a member? Sign Up!")
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
                    Text("Forgot Password?")
                        .foregroundColor(.white)
                        .opacity(0.5)
            }
            .padding(10)
            Spacer()
            
            Button(action: {
                if (formIsValid){
                    checkError()
                        Task{
                            try await viewModel.signIn(withEmail: Email, password: Pass)
                        }
                    
                } else {
                    checkError()
                    
                }
            }){
                Text("JOIN US")
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 170)
                    .background(
                        RoundedRectangle(cornerRadius: 45)
                            .foregroundColor(.teal)
                    )
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

extension SignIn: AuthFormProtocol {
    var formIsValid: Bool{
        return !Email.isEmpty
        && Email.contains("@")
        && !Pass.isEmpty
        && Pass.count >= 6
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
        SignIn()
            .previewDevice("iPhone 8")

    }
}
