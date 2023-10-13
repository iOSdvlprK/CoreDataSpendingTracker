//
//  AddCardForm.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/13.
//

import SwiftUI

struct AddCardForm: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    @State private var cardType = "Visa"
    
    @State private var month = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    
                    Picker("Type", selection: $cardType) {
                        let type = ["Visa", "Mastercard", "Discover", "Citibank"]
                        ForEach(type, id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                }, header: { Text("Card Info") })
                
                Section(content: {
                    Picker("Month", selection: $month) {
                        ForEach(1..<13, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                    
                    Picker("Year", selection: $year) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                }, header: { Text("Expiration") })
                
                Section(content: {
                    ColorPicker("Color", selection: $color)
                }, header: { Text("Color") })
            }
            .navigationTitle("Add Credit Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
//        MainView()
    }
}
