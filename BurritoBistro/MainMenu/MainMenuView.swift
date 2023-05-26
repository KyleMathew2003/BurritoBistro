//
//  MainView.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 3/17/23.
//

import SwiftUI

struct MainMenu: View {
    
    //View Settings
    @State private var OutsideSpacing = CGFloat(10)
    @State private var AddButtonSpacing = CGFloat(24)
    @State private var BubbleContentSpacing = CGFloat(20)
    @State private var BubbleOpcaity = 0.5
    @State private var CheckOutBubblePadding = CGFloat(35)
    @State private var MenuHeight = CGFloat(60)
    @State private var MenuSpacing = CGFloat(20)
    //
    
    //Scroll Logic variables
    @State private var scrollTarget: Int?
    
    @State private var CurrentSection: MenuTypes = .entrees
    
    @State private var visible: Bool = true
    
    @State private var total: Int = 0
    
    @State private var VisibleIndexArray:[Int] = [Int](repeating: -1, count: MenuTypes.allCases.count)
    //
    
    
    @State private var Cart: [MenuFoodItems:Int] = [:]
    
   

    
    //delayToggle() work around will need adjustment for larger MenuOption enum counts
    //
    //This exists to turn off the geometry reader when a menu option is pressed
    // this is because clicking an option scrolls the vertical menu to the correct section
    // however doing so, would trigger geom reader to update VisibleIndexArray, which in turn changes
    // the CurrentSection, i.e. without the delay toggle:
    //
    // 1) clicking drinks from entrees, -> curr section would updated, to select drinks, thus
    // bolding/horzscrollng to drinks
    //
    // 2) the vertical scroll happens concurrently, however, as it goes to drinks, it must pass sides
    //
    // 3) this would trigger the geom reader for the sides, thus updating the curr section back to sides
    // thus highlighting and attempting to horzscroll there, but finally, when the
    // drinks section is reached, the geom reader is triggered, updating correctly again
    
    //This ends up appearing like a click selects drinks, then staggers back to sides,
    // and back to drinks again
    
    //ideally the delay toggle works as long as the animation plays, but there's no direct call back in
    //swift, alternate is manually toggling for a certain amount of time, which also cannot be
    // controlled through the duration param of withAnimation, for some reason scrollTo does not
    // get affected by it

    private func delayToggle() async {
        visible.toggle()
        try? await Task.sleep(nanoseconds: 300000000)
        visible.toggle()
    }
            
    var body: some View {
        NavigationView{
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
                                    print(VisibleIndexArray)
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
                                    ForEach(MenuTypes.allCases, id: \.self){ item in
                                        Button{
                                            
                                            if visible == true {
                                            
                                            Task{
                                            await delayToggle()
                                            }
                                            
                                            CurrentSection = MenuTypes.allCases[item.index]

                                            scrollTarget = item.index
                                            }
                                            
                                            
                                            

                                        }label: {
                                            VStack(spacing:5){
                                                Text("\(item.title)")
                                                    .fontWeight(CurrentSection.index == item.index ? .bold:.regular)
                                                    .opacity(CurrentSection.index == item.index ? 1:0.5)
                                                Divider()
                                                    .frame(height: CurrentSection.index == item.index ? 3:0.5)
                                                    .overlay(Color.white)
                                            }
                                        }
                                        .padding(.leading,MenuSpacing)
                                        .id(item.index)
                                    }
                                    
                                    Spacer(minLength: UIScreen.main.bounds.width-50)
                            }
                                
                                .onChange(of: VisibleIndexArray){ target in
                                    withAnimation(Animation.easeIn(duration: 0.0001)){
                                        hMenuVal.scrollTo(target.max()!,anchor: .bottomLeading)
                                        CurrentSection = MenuTypes.allCases[target.max()!]
                                    }
                                }
                                .onChange(of: CurrentSection){ target in
                                    withAnimation(Animation.easeIn(duration: 0.0001)){
                                        hMenuVal.scrollTo(target.index,anchor: .bottomLeading)

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
                        
                        }
                        //below is scroll sections and checkout overlayed
                        

                        ZStack {
                            //scroll sections
                            ScrollViewReader { vMenuVal in
                                ScrollView (showsIndicators: false){
                                    VStack() {
                                        ForEach(MenuTypes.allCases, id: \.self){ item in
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
                                                        $0.MenuItemDetails.group == item
                                                    }){ items in
                                                        Button{
                                                            if !Cart.contains(where: { $0.key == items }) {
                                                                Cart[items] = 1
                                                            } else{
                                                                Cart[items]! += 1
                                                            }
                                                            
                                                            print(Cart)

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
                                                                    Text("\(items.MenuItemDetails.description)")
                                                                        .font(.caption)
                                                                        .lineLimit(3)
                                                                    Spacer()
                                                                    Text("$\(items.MenuItemDetails.price)")
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
                                        .modifier(OffsetMod(option: item, total: $total, visible: $visible, VisibleIndexArray: $VisibleIndexArray))
                                        }
                                        .onChange(of: scrollTarget){ target in
                                            if let target = target {
                                                scrollTarget = nil
                                                CurrentSection = MenuTypes.allCases[target]


                                                
                                                
                                                withAnimation(Animation.easeIn(duration: 0.0001)){
                                                    vMenuVal.scrollTo(target,anchor: .top)
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        Spacer(minLength: 500)
                                    }
                                    
                                    
                                }
                                .coordinateSpace(name: "scroll")
                                
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
                                        
                                            Text("\(Cart.count)")
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
        .navigationBarHidden(true)

        }
        .ignoresSafeArea()

    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainMenu()
                .previewDevice("iPhone 12")
            MainMenu()
                .previewDevice("iPhone 8")
        }
    }
}
