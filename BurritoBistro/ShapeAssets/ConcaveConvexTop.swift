//
//  ConcaveConvexTop.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 2/19/23.
//

import Foundation
import SwiftUI

struct ConcaveConvexTop: Shape {
    @State var radius:Int

    func path(in rect: CGRect) -> Path {
        let radius = CGFloat(radius)
        let width = rect.width
        let height = rect.height

        return Path { path in
            path.move(to: CGPoint(x:0,y:0))
            path.addLine(to: CGPoint(x:width,y:0))
            path.addLine(to: CGPoint(x:width, y: height-radius))
            path.addArc(
                center: CGPoint(x: width-radius, y: height-radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false)
            
            path.addArc(
                center: CGPoint(x: radius, y: height+radius),
                radius: radius,
                startAngle: Angle(degrees:270),
                endAngle: Angle(degrees: 180),
                clockwise: true)
            
            path.addLine(to:CGPoint(x:0,y:height))
            
        }
    }
}
struct ConcaveConvexBottom: Shape {
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
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addArc(
                center: CGPoint(x: width-radius, y: -radius),
                radius: radius,
                startAngle: Angle(degrees:90),
                endAngle: Angle(degrees: 0),
                clockwise: true)
            
           
            
            
        }
    }
}

struct ShapeReview: View {
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0){
                ConcaveConvexTop(radius: 50)
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                
                Spacer()

            }
            VStack(alignment: .center, spacing: 0){
                ConcaveConvexBottom(radius: 50)
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

struct ShapeReview_Previews: PreviewProvider {
    static var previews: some View {
        ShapeReview()
    }
}
