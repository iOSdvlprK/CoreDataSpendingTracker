//
//  MainView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/12.
//

import SwiftUI

struct MainView: View {
    @State private var shouldPresentAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
//    @State private var cardSelectionIndex = 0
    @State private var selectedCardHash = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !cards.isEmpty {
//                    TabView(selection: $cardSelectionIndex) {
//                        ForEach(0..<cards.count, id: \.self) { i in
//                            CreditCardView(card: cards[i])
//                                .padding(.bottom, 50)
//                                .tag(i)
//                        }
//                    }
                    TabView(selection: $selectedCardHash) {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                                .tag(card.hash)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 300)
                    .indexViewStyle(PageIndexViewStyle.page(backgroundDisplayMode: .always))
                    .onAppear {
                        self.selectedCardHash = cards.first?.hash ?? 0
                    }
                    
//                    if let selectedCard = cards[cardSelectionIndex] {
//                        Text(selectedCard.name ?? "")
//                        TransactionsListView(card: selectedCard)
//                    }
                    if let firstIndex = cards.firstIndex(where: { $0.hash == selectedCardHash }) {
                        let card = self.cards[firstIndex]
//                        Text(card.name ?? "")
                        TransactionsListView(card: card)
                    }
                    
                } else {
                    emptyPromptMessage
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
//                        AddCardForm()
                        AddCardForm(card: nil) { card in
                            self.selectedCardHash = card.hash
                        }
                    }
            }
            .navigationTitle("Credit Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }
            }
        }
    }
    
    private var emptyPromptMessage: some View {
        VStack {
            Text("You currently have no cards in the system.")
                .padding(.horizontal, 70)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            
            Button(action: {
                shouldPresentAddCardForm.toggle()
            }, label: {
                Text("+ Add Your First Card")
                    .foregroundColor(Color(.systemBackground))
            })
            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
        }
        .font(.system(size: 22, weight: .semibold))
    }
    
    struct CreditCardView: View {
        let card: Card
        
        @State private var shouldShowActionSheet = false
        @State private var shouldShowEditForm = false
        
        @State private var refreshId = UUID()
        
        private func handleDelete() {
            let viewContext = PersistenceController.shared.container.viewContext
            
            viewContext.delete(card)
            
            do {
                try viewContext.save()
            } catch {
                // error handling
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Text(card.name ?? "")
                        .font(.system(size: 25, weight: .semibold))
                    Spacer()
                    Button(action: {
                        shouldShowActionSheet.toggle()
                    }, label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 28, weight: .bold))
                    })
                    .confirmationDialog(
                        Text(self.card.name ?? ""),
                        isPresented:
                            $shouldShowActionSheet,
                        titleVisibility: .visible,
                        actions: {
                            Button(action: {
                                shouldShowEditForm.toggle()
                            }, label: {
                                Text("Edit")
                            })
                            Button(role: .destructive, action: {
                                handleDelete()
                            }, label: {
                                Text("Delete Card")
                            })
                        }, message: {
                            Text("Options")
                        }
                    )
                }
                
                HStack {
                    let imageName = card.type?.lowercased() ?? ""
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                        .clipped()
                    Spacer()
                    Text("Balance: $5,000")
                        .font(.system(size: 19, weight: .semibold))
                }
                
                Text(card.number ?? "")
                
                HStack {
                    Text("Credit Limit: $\(card.limit)")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Valid Thru")
                        Text("\(String(format: "%02d", card.expMonth))/\(String(card.expYear % 2000))")
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(
                VStack {
                    if let colorData = card.color,
                       let uiColor = UIColor.color(data: colorData),
                       let actualColor = Color(uiColor) {
                        LinearGradient(colors: [
                            actualColor.opacity(0.6),
                            actualColor
                        ], startPoint: .center, endPoint: .bottom)
                    } else {
                        Color.cyan
                    }
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
            .fullScreenCover(isPresented: $shouldShowEditForm) {
                AddCardForm(card: self.card)
            }
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
    }
}
