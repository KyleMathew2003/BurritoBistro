//
//  HalfBubble.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 3/18/23.
//

import Foundation
import SwiftUI

struct HalfBubbleTop: Shape {
    @State var radius:Int

    func path(in rect: CGRect) -> Path {
        let radius = CGFloat(radius)
        let width = rect.width
        let height = rect.height

        return Path { path in
            path.move(to: CGPoint(x:width,y:height))
            path.addLine(to: CGPoint(x:0,y:height))
            path.addLine(to: CGPoint(x:0, y: radius))
            path.addArc(
                center: CGPoint(x: radius, y: radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false)
            path.addArc(
                center: CGPoint(x: width-radius, y: radius),
                radius: radius,
                startAngle: Angle(degrees:-90),
                endAngle: Angle(degrees: 0),
                clockwise: false)
            
           
            
            
        }
    }
}
struct HalfBubbleBottom: Shape {
    @State var radius:Int

    func path(in rect: CGRect) -> Path {
        let radius = CGFloat(radius)
        let width = rect.width
        let height = rect.height

        return Path { path in
            path.move(to: CGPoint(x:0,y:0))
            path.addLine(to: CGPoint(x:width,y:0))
            path.addArc(
                center: CGPoint(x: width-radius, y: height-radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false)
            path.addArc(
                center: CGPoint(x: radius, y: height-radius),
                radius: radius,
                startAngle: Angle(degrees:90),
                endAngle: Angle(degrees: 180),
                clockwise: false)
            
           
            
            
        }
    }
}



struct ShapeReviews: View {
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0){
                HalfBubbleTop(radius: 50)
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                

            }
            VStack(alignment: .center, spacing: 0){
                HalfBubbleBottom(radius: 50)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                
                Spacer()

            }
            VStack(alignment: .center, spacing: 0){
                Rectangle()
                    .opacity(0.3)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                Spacer()

            }
        }
        .frame(height:UIScreen.main.bounds.height-50)
        .ignoresSafeArea()
        
        
        
    }
}

struct ShapeReviews_Previews: PreviewProvider {
    static var previews: some View {
        ShapeReviews()
        ShapeReviews()
            .previewDevice("iPhone 8")
    }
}
