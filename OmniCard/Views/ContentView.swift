//
//  ContentView.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Card.dateAdded, order: .forward) var cards: [Card]
    
    @State private var showingAddCardSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cards) { card in
                    cardListItem(card)
                }
                .onDelete(perform: deleteCards)
            }
            .navigationTitle("Cards")
            .toolbar {
                newCardButton
            }
            .sheet(isPresented: $showingAddCardSheet) {
                AddCardView()
            }
        }
    }
    
    func cardListItem(_ card: Card) -> some View {
        HStack(alignment: .top) {
            // Card name
            Text(card.name)
                .font(.title3)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                // Card number
                Text(String(repeating: "**** ", count: 3) + String(card.number.suffix(4)))
                    .font(.callout)
                    .fontWeight(.regular)
                    .fontDesign(.monospaced)
                
                HStack(alignment: .center) {
                    // Expiration date
                    Text("\(card.expirationMonth)/\(card.expirationYear)")
                        .font(.caption)
                        .fontWeight(.thin)
                        .fontDesign(.monospaced)
                    
                    // Security code
                    Text(card.securityCode)
                        .font(.caption)
                        .fontWeight(.thin)
                        .fontDesign(.monospaced)
                }
            }
        }
        .listRowInsets(
            EdgeInsets(
                top: 10,
                leading: 16,
                bottom: 10,
                trailing: 16
            )
        )
    }
    
    var newCardButton: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add card", systemImage: "plus") {
                showingAddCardSheet = true
            }
        }
    }
    
    func deleteCards(at offsets: IndexSet) {
        let cardsToDelete = offsets.map { cards[$0] }
        for card in cardsToDelete {
            context.delete(card)
        }
    }
}

#Preview {
    ContentView()
}
