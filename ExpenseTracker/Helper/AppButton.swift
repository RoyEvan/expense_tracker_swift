//
//  AppButton.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI

struct AppButton: View {
    var title: String = "Example Button"
    var systemName: String = "plus"
    var textColor: Color = .white
    var backgroundColor: String = "appColor"
    var action = {}
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
            Text(title)
        }
        .font(.system(size: 20, weight: .bold, design: .default))
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .foregroundColor(textColor)
        .background(
            Color(backgroundColor)
        )
        .cornerRadius(10)
    }
}

#Preview {
    AppButton()
}
