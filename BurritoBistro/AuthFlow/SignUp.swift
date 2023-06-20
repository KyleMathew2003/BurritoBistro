//
//  SignUp.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 1/31/23.
//

import SwiftUI

struct SignUp: View {
    @State private var Pass:String = ""
    @State private var confirmPass:String = ""
    @State private var Email:String = ""
    @State private var First:String = ""
    @State private var Last:String = ""
    @State var button: Bool = true
        
    @EnvironmentObject var viewModel: AuthManager
    
    @State private var Error = ["", "", "", "","","",""]

    
    let height = UIScreen.main.bounds.height
    
    func checkError() {
        if Email.isEmpty{
            Error[0] = "Please Put In An Email"
        } else{
            Error[0] = ""
        }
        if !Email.contains("@"){
            Error[1] = "Email Not Valid"
        } else {
            Error[1] = ""

        }
        if Pass.isEmpty{
            Error[2] = "Please Put In A Password"
        } else{
            Error[2] = ""

        }
        if Pass.count < 6 {
            Error[3] = "Password Not Valid"
        } else{
            Error[3] = ""

        }
        if First.isEmpty {
            Error[4] = "First Name Not Valid"
        } else{
            Error[4] = ""

        }
        if Last.isEmpty {
            Error[5] = "Last Name Not Valid"
        } else{
            Error[5] = ""

        }
        if !(confirmPass == Pass) {
            Error[6] = "Confirm Password Must Be The Same As Password"
        } else{
            Error[6] = ""

        }
        
    }

    
    var body: some View {
        NavigationView{
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
                    Text("Create An Account")
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
                        TextField("",text: $First)
                            .placeholder(when: First.isEmpty){
                                Text("First Name")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .padding(.horizontal,20)
                        Divider()
                            .frame(width:250)
                            .overlay(Color.white
                                .opacity(0.3))
                        if !(Error[4] == ""){
                            Text(Error[4])
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                    }
                    .padding(.vertical,5)
                    VStack(spacing:3){
                        TextField("",text: $Last)
                            .placeholder(when: Last.isEmpty){
                                Text("Last Name")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .padding(.horizontal,20)
                        Divider()
                            .frame(width:250)
                            .overlay(Color.white
                                .opacity(0.3))
                        if !(Error[5] == ""){
                            Text(Error[5])
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical,5)
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
                        if !(viewModel.inUseError == ""){
                            Text(viewModel.inUseError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
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
                    VStack(spacing:3){
                        TextField("",text: $confirmPass)
                            .placeholder(when: confirmPass.isEmpty){
                                Text("Confirm Password")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .padding(.horizontal,20)
                        Divider()
                            .frame(width:250)
                            .overlay(Color.white
                                .opacity(0.3))
                        if !(Error[6] == ""){
                            Text(Error[3])
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
                    NavigationLink{
                        SignIn()
                            .navigationBarHidden(true)
                    } label:{
                        Text("Already a member? Sign In!")
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                }
                .padding(10)
                Spacer()
                
                Button{
                        if (formIsValid){
                            checkError()
                                Task{
                                    try await viewModel.createUser(withEmail:Email,
                                                                   password:Pass,
                                                                   firstName:First,
                                                                   lastName:Last
                                    )
                                }
                        } else {
                            viewModel.inUseError = ""
                            checkError()
                            
                        }
                    
                }label:
                {
                    Text("JOIN THE CULT")
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 170)
                        .background(
                            RoundedRectangle(cornerRadius: 45)
                                .foregroundColor(.teal)
                        )
                        .opacity(1)
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
            .navigationBarHidden(true)
            
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
    ZStack(alignment: alignment){
        placeholder().opacity(shouldShow ? 0.3:0)
        self
    }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
        SignUp()
            .previewDevice("iPhone 8")

    }
}


extension SignUp: AuthFormProtocol {
    var formIsValid: Bool{
        return !Email.isEmpty
        && Email.contains("@")
        && !Pass.isEmpty
        && Pass.count >= 6
        && !First.isEmpty
        && !Last.isEmpty
        && Pass == confirmPass
    }
}
