//
//  MainView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/12.
//

import SwiftUI

struct MainView: View {
    @State private var shouldPresentAddCardForm = false
    @State private var shouldShowAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 300)
                    .indexViewStyle(PageIndexViewStyle.page(backgroundDisplayMode: .always))
                    
                    Text("Get started by adding your first transaction")
                    
                    Button {
                        shouldShowAddTransactionForm.toggle()
                    } label: {
                        Text("+ Transaction")
                            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                            .background(Color(.label))
                            .foregroundColor(Color(.systemBackground))
                            .font(.headline)
                            .cornerRadius(5)
                    }
                    .fullScreenCover(isPresented: $shouldShowAddTransactionForm) {
                        AddTransactionForm()
                    }
                    
                    ForEach(transactions) { transaction in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.name ?? "")
                                        .font(.headline)
                                    if let date = transaction.timestamp {
                                        Text(dateFormatter.string(from: date))
                                    }
                                }
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.system(size: 24))
                                    }
                                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                                    
                                    Text(String(format: "$%.2f", transaction.amount))
                                }

                            }
                            
                            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .foregroundColor(Color(.label))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        .padding()
                    }
                } else {
                    emptyPromptMessage
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm()
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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
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
