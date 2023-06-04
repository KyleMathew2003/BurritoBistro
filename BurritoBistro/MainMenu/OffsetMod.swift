//
//  OffsetMod.swift
//  BurritoBistro
//
//  Created by Kyle Mathew on 5/19/23.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey{
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct OffsetMod: ViewModifier {
    
    let option: MenuTypes
    
    @Binding var total: Int
    
    @Binding var visible: Bool
    
    @Binding var VisibleIndexArray: [Int]

    
    func body(content: Content) -> some View {
        if visible == true{
        content
            .overlay(
                
                GeometryReader { proxy in
                    Color.clear.opacity(0.5)
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named("scroll")))
                }
            )
            .onPreferenceChange(OffsetKey.self) { proxy in
                
                if option.index != 0 {

                    if proxy.minY <= 0.00001{
                        total = option.index
                    } else{
                        total = -1
                    }
                } else{
                    total = 0
                }
                
                VisibleIndexArray[option.index] = total
                
                
            }
        } else {
            content
                .overlay(Color.clear)
        }
}
    
    
    
}

