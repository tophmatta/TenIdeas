//
//  SettingsView.swift
//  Ten Ideas
//
//  Created by Toph Matta on 11/6/23.
//  Copyright © 2023 Toph. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        ZStack {
            VStack {
                Text("Settings")
                    .systemFontUltraLight(size: 50)
                Spacer()
                Button {
                    
                } label: {
                    Text("Delete All Lists")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .font(.system(size: 25))
                        .cornerRadius(15)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Done")
                    }
                    .buttonStyle(ClearButtonBlackBorderStyle())
                }
                .padding(.trailing, 35)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
