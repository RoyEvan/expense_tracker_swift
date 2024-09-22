//
//  TestCustomListView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 22/09/24.
//

import SwiftUI

struct TestCustomListView: View {
    var iconTitle: String = "iconTitle"
    var iconSub: String? = "+"
    var subTitle: String = "subTitle"
    var money: String = "0"
    var view: Bool = true
    
    @State var list = ["ab", "bc", "cd", "de"]
    var body: some View {
        VStack {
            List {
                
                ForEach(list, id: \.self) { i in
                    ZStack(alignment: .topTrailing) {
                        if view {
                            Text("View")
                                .font(.system(size: 12))
                                .foregroundStyle(.blue)
                                .padding([.top, .trailing], 10)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(iconTitle)
                                .font(.title)
                            
                            HStack {
                                if let iconSub = iconSub, !iconSub.isEmpty {
                                    Text(iconSub)
                                }
                                Text(i)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundStyle(Color("textColor"))
                            }
                            
                            Text("Rp. \(money)")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .foregroundStyle(Color("textColor"))
                        }
//                        .padding()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                    }
//                    .frame(width: 165, height: 135, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
//                    .shadow(color: .black.opacity(0.12), radius: 40, y: 4)
                    
//                    loop += 1
                }
                .onDelete(perform: { indexSet in
                    
                })
                .onMove(perform: move)
                .listRowSeparator(.hidden)
                
            }
//            .scrollContentBackground(.hidden)
//            .background()
//            .alert()
        }
//        .background(Color.green)
        
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        list.move(fromOffsets: source, toOffset: destination)
        
        print(source)
        print(destination)

    }
}

#Preview {
    TestCustomListView()
}
