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
    
    @State var nickname: String = ""
    @State var name: String = ""
    @State var number: String = ""
    @State var expirationMonth: String = ""
    @State var expirationYear: String = ""
    @State var securityCode: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 32) {
                        headerSection
                        formFieldsSection
                        addCardButton
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.accentColor)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 48))
            
            Text("Add New Card")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Enter your card details below")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 32)
    }
    
    // Contains nickname, name, card number, expiration, and security code.
    var formFieldsSection: some View {
        VStack(spacing: 20) {
            cardNicknameSection
            cardholderNameSection
            cardNumberSection
            expirationAndCVVSection
        }
        .padding(.horizontal, 24)
    }
    
    var cardNicknameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Nickname")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("e.g. My Favorite Credit Card", text: $nickname)
                .textFieldStyle(CapsuleTextFieldStyle())
                .font(.body)
        }
    }
    
    var cardholderNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cardholder Name")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("Enter cardholder name", text: $name)
                .textFieldStyle(CapsuleTextFieldStyle())
                .font(.body)
        }
    }
    
    var cardNumberSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Number")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("1234 5678 9012 3456", text: $number)
                .keyboardType(.numberPad)
                .textFieldStyle(CapsuleTextFieldStyle())
                .font(.body)
                .fontDesign(.monospaced)
        }
    }
    
    var expirationAndCVVSection: some View {
        HStack(spacing: 16) {
            expirationDateSection
            securityCodeSection
        }
    }
    
    var expirationDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Expiration")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                TextField("MM", text: $expirationMonth)
                    .keyboardType(.numberPad)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .font(.body)
                    .fontDesign(.monospaced)
                    .frame(maxWidth: .infinity)
                
                Text("/")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                TextField("YY", text: $expirationYear)
                    .keyboardType(.numberPad)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .font(.body)
                    .fontDesign(.monospaced)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    var securityCodeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CVV")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("123", text: $securityCode)
                .keyboardType(.numberPad)
                .textFieldStyle(CapsuleTextFieldStyle())
                .font(.body)
                .fontDesign(.monospaced)
        }
    }
    
    var addCardButton: some View {
        Button {
            if let newCard = Card(
                nickname: nickname,
                name: name,
                number: number,
                expirationMonth: expirationMonth,
                expirationYear: expirationYear,
                securityCode: securityCode
            ) {
                context.insert(newCard)
                print("AddCardView.swift: payment network is \(newCard.paymentNetwork)")
                dismiss()
            } else {
                showingInvalidInputAlert = true
            }
        } label: {
            HStack(spacing: 12) {
                Text("Add Card")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Image(systemName: "plus")
                    .font(.title2)
            }
            .foregroundColor(.white)
        }
        .padding(.leading, 22) // Allow extra space for the text for feeling of centeredness
        .padding(.trailing, 16)
        .padding(.vertical, 16)
        .background(Color.blue, in: Capsule())
        .alert("Invalid Input", isPresented: $showingInvalidInputAlert) {
            Button("OK", role: .cancel) {
                showingInvalidInputAlert = false
            }
        } message: {
            Text("Please check your card details and try again.")
        }
    }
}

// Custom capsule text field style
struct CapsuleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            )
    }
}

#Preview {
    AddCardView()
}
