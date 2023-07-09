//
//  MainFlow.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 6/16/23.
//

import SwiftUI

struct MainFlowView: View {
    @EnvironmentObject var viewModel: AuthManager
    var body: some View {
        Group{
            if viewModel.userSession == nil{
                SignUp()
            } else{
                MainMenu()
            }
        }
    }
}

struct MainFlowView_Previews: PreviewProvider {
    static var previews: some View {
        MainFlowView()
    }
}
