//
//  MainPadDeviceView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/23.
//

import SwiftUI

struct MainPadDeviceView: View {
    @State private var shouldShowAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .frame(width: 370)
                        }
                    }
                }
                Text("TEST")
            }
            .navigationTitle("Money Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }
            }
            .sheet(isPresented: $shouldShowAddCardForm) {
                AddCardForm()
            }
        }
    }
    
    private var addCardButton: some View {
        Button {
            shouldShowAddCardForm.toggle()
        } label: {
            Text("+ Card")
        }

    }
}

struct MainPadDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        MainPadDeviceView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .environment(\.horizontalSizeClass, .regular)
            .previewInterfaceOrientation(.portrait)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
