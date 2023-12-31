//
//  AddCardForm.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/13.
//

import SwiftUI

struct AddCardForm: View {
    let card: Card?
    var didAddCard: ((Card) -> ())? = nil
    
    init(card: Card? = nil, didAddCard: ((Card) -> ())? = nil) {
        self.card = card
        self.didAddCard = didAddCard
        
        _name = State(initialValue: card?.name ?? "")
        _cardNumber = State(initialValue: card?.number ?? "")
        
        if let limit = card?.limit {
            _limit = State(initialValue: String(limit))
        }
        
        _cardType = State(initialValue: card?.type ?? "")
        _month = State(initialValue: Int(card?.expMonth ?? 1))
        _year = State(initialValue: Int(card?.expYear ?? Int16(Int(currentYear))))
        
        if let data = card?.color, let uiColor = UIColor.color(data: data) {
            let c = Color(uiColor)
            _color = State(initialValue: c)
        }
    }
    
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
            .navigationTitle(self.card != nil ? self.card?.name ?? "" : "Add Credit Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            let viewContext = PersistenceController.shared.container.viewContext
//            let card = Card(context: viewContext)
            let card = self.card != nil ? self.card! : Card(context: viewContext)
            
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.limit) ?? 0
            card.expMonth = Int16(self.month)
            card.expYear = Int16(self.year)
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            card.type = cardType
            
            do {
                try viewContext.save()
                
                dismiss()
                didAddCard?(card)
            } catch {
                print("Failed to persist new card: \(error)")
            }
            
        }, label: {
            Text("Save")
        })
    }
    
    private var cancelButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Text("Cancel")
        })
    }
}

extension UIColor {
    class func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: self, from: data)
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
//        AddCardForm()
        let context = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, context)
    }
}
