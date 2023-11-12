//
//  ButtonStyle+Extension.swift
//  Ten Ideas
//
//  Created by Toph Matta on 11/12/23.
//  Copyright © 2023 Toph. All rights reserved.
//

import SwiftUI

struct ClearButtonBlackBorderStyle: ButtonStyle {
    var size: CGFloat
    
    init(fontSize: CGFloat = 19) {
        self.size = fontSize
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size, weight: .ultraLight))
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 10)
            .background(.clear)
            .foregroundStyle(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
            )
    }
}
