//
//  AddCardView.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import Foundation
import SwiftUI

struct AddCardView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State var showingInvalidInputAlert: Bool = false
    
    @State var name: String = ""
    @State var number: String = ""
    @State var expirationMonth: String = ""
    @State var expirationYear: String = ""
    @State var securityCode: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                // Name
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
             
                // Card number
                TextField("Card Number", text: $number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .fontDesign(.monospaced)
                
                HStack(spacing: 12) {
                    // Expiration date
                    HStack(spacing: 1) {
                        TextField("Month", text: $expirationMonth)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .fontDesign(.monospaced)
                        
                        Text("/")
                        
                        TextField("Year", text: $expirationYear)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .fontDesign(.monospaced)
                    }
                    
                    // Security code
                    TextField("CVV", text: $securityCode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .fontDesign(.monospaced)
                }
            }
            
            Button("Done", systemImage: "checkmark") {
                if let newCard = Card(
                    name: name,
                    number: number,
                    expirationMonth: expirationMonth,
                    expirationYear: expirationYear,
                    securityCode: securityCode
                ) {
                    context.insert(newCard)
                    dismiss()
                } else {
                    showingInvalidInputAlert = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .alert("Invalid input", isPresented: $showingInvalidInputAlert) {
            Button("Ok", role: .cancel) {
                showingInvalidInputAlert = false
            }
        }
    }
}
