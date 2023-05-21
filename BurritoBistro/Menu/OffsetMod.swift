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
    
    let option: MenuOptions
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.red
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named("scroll")))
                }
            )
            .onPreferenceChange(OffsetKey.self) { proxy in
                let offset = proxy.minY
                print(offset)
            }
    }
}

struct OffsetMod_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            Text("Hello, world!")
                .modifier(OffsetMod(option: .entrees))
        }
    }
}
