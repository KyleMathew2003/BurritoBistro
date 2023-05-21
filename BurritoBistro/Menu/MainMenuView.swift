//
//  MainView.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 3/17/23.
//

import SwiftUI

struct MainMenu: View {
    
    @State private var OutsideSpacing = CGFloat(10)
    @State private var AddButtonSpacing = CGFloat(24)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @State private var shoppingCount:Int = 1

    
    @State private var CheckOutBubblePadding = CGFloat(35)
    
    @State private var MenuItemIndex = 0
    @State private var MenuHeight = CGFloat(60)
    @State private var MenuSpacing = CGFloat(20)
    
    @State private var scrollTarget: Int?
    
    let option: MenuOptions
    
    @State private var currentOption: MenuOptions = .entrees
        
    var body: some View {
        VStack {
            VStack(spacing:0){
                
                //Search Button and Settings
                VStack(alignment:.leading,spacing:5){
                    HStack {
                        Button {
                           
                        }label:{
                            HStack{
                                Text("Search")
                                Spacer()
                            }
                            .padding(.leading,BubbleContentSpacing)
                            .padding(.vertical,10)
                            .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.black)
                                .opacity(BubbleOpcaity)

                        )
                        }
                        Spacer()
                        
                        Button {
                        }label:{
                            Image(systemName: "gear")
                                .padding(OutsideSpacing)
                                .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(.black)
                                    .opacity(BubbleOpcaity)
                            )
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal,OutsideSpacing)
                    
                }
               
                .padding(.bottom,10)
                .background(Color("bgc"))
                
                //Below is menu item buttons
                ScrollViewReader{ hMenuVal in
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack(spacing:0){
                            ForEach(MenuOptions.allCases, id: \.self){ item in
                                Button{
                                    MenuItemIndex = item.index
                                    withAnimation(.default){
                                        hMenuVal.scrollTo(item.index,anchor:.bottomLeading)
                                    }
                                    scrollTarget = item.index
                                }label: {
                                    VStack(spacing:5){
                                        Text("\(item.title)")
                                            .fontWeight(MenuItemIndex == item.index ? .bold:.regular)
                                            .opacity(MenuItemIndex == item.index ? 1:0.5)
                                        Divider()
                                            .frame(height: MenuItemIndex == item.index ? 3:0.5)
                                            .overlay(Color.white)
                                    }
                                }
                                .padding(.leading,MenuSpacing)
                                .id(item.index)
                            }
                            
                            Spacer(minLength: UIScreen.main.bounds.width-50)

                        
                    }
                    }
                }
                .padding(.vertical)
                .frame(height:MenuHeight)
                .font(.headline)
                .foregroundColor(.white)
                .background(
                    Color.black
                        .opacity(BubbleOpcaity))

                ZStack {
                    ScrollViewReader { vMenuVal in
                        ScrollView (showsIndicators: false){
                            VStack {
                                ForEach(MenuOptions.allCases, id: \.self){ item in
                                VStack {
                                    VStack (spacing:0){
                                        
                                        //List title
                                        HStack{
                                            Text("\(item.title)")
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .padding(.leading,BubbleContentSpacing)
                                        .padding(.top,10)
                                        .padding(.bottom,10)
                                        
                                        //List itmes
                                        VStack{
                                            ForEach(MenuItems.filter{
                                                $0.group == item
                                            }){ items in
                                                Button{
                                                        
                                                }label:{
                                                    VStack(alignment:.leading,spacing:5){
                                                        HStack {
                                                            Text("\(items.foodName)")
                                                                .font(.title3)
                                                                .fontWeight(.bold)
                                                                .lineLimit(1)
                                                            Spacer()
                                                            Text("+")
                                                                .font(.body)
                                                                .padding(4)
                                                                .foregroundColor(.black)
                                                                .frame(
                                                                    minWidth:24,
                                                                    minHeight: 24,
                                                                    idealHeight: 24,
                                                                    maxHeight: 24)
                                                                .background(
                                                                RoundedRectangle(cornerRadius: 20)
                                                                )
                                                        }
                                                        .padding(.bottom,1)
                                                        Divider()
                                                            .overlay(.gray)
                                                        HStack(alignment: .top) {
                                                            Text("\(items.description)")
                                                                .font(.caption)
                                                                .lineLimit(3)
                                                            Spacer()
                                                            Text("$\(items.price)")
                                                                .font(.caption)
                                                                .padding(4)
                                                                .frame(minWidth: 24, idealWidth: 24, alignment: .bottom)
                                                                .opacity(0.5)
                                                        }
                                                    }
                                                    .foregroundColor(.white)
                                                    .padding(BubbleContentSpacing)
                                                    .background(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .opacity(BubbleOpcaity)
                                                )
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                    }
                                }
                                .id(item.index)
                                }
                                .modifier(OffsetMod(option: .entrees))
                                
                                Spacer(minLength: 500)
                            }
                            .onChange(of: scrollTarget){ target in
                                if let target = target {
                                    scrollTarget = nil
                                    
                                    withAnimation{
                                        vMenuVal.scrollTo(target,anchor: .top)
                                    }
                                }
                                
                            }
                            
                        }
                        
                        //end of ScrollView
                        .padding(.horizontal,OutsideSpacing)
                    }
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                
                            }label:{
                                HStack {
                                    Text("Check Out")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                    Text("\(shoppingCount)")
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
                        )
                        .padding(40)
                        .frame(width:UIScreen.main.bounds.width)
                        .background(
                            HalfBubbleTop(radius: 50)
                            )
                        
                    }
                    .ignoresSafeArea()
                    //checkout
                }
                
                
                
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            .background(Color("bgc"))

    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainMenu(option: .entrees)
            MainMenu(option: .entrees)
                .previewDevice("iPhone 8")
        }
    }
}
