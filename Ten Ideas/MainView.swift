//
//  MainView.swift
//  Ten Ideas
//
//  Created by Toph Matta on 11/6/23.
//  Copyright © 2023 Toph. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack(alignment: .topLeading) {
                    Color.white
                    VStack(alignment: .leading) {
                        ZStack {
                            let size = proxy.size.width * 0.30
                            Rectangle()
                                .fill(Color.clear)
                                .border(Color.black, width: 2.0)
                                .frame(width: size, height: size)
                            Group {
                                Text("10i")
                            }
                            .systemFontUltraLight(size: 100)
                            .offset(x: 18, y: 15)//	
                        }
                    }
                    .padding([.leading, .top], 40)
                    VStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .offset(x: 15)
                                .font(Font.title.weight(.ultraLight))
                                .foregroundColor(.black)
                        }
                    }
                }
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        Spacer()
                        Group {
                            Button {
                                
                            } label: {
                                Text("create new")
                            }
                            Button {
                                
                            } label: {
                                Text("random")
                            }
                            Button {
                                
                            } label: {
                                Text("view")
                            }
                        }
                        .buttonStyle(ClearButtonBlackBorderStyle(fontSize: 48))
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, proxy.size.width * 0.2)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension View {
    func systemFontUltraLight(size: CGFloat) -> some View {
        return self.font(.system(size: size, weight: .ultraLight))
    }
}
