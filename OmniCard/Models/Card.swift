//
//  Card.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import Foundation
import SwiftData

@Model
class Card {
    // The card number of the bank card (e.g. 1111 2222 3333 4444)
    var number: String
    var expirationDate: (String, String)
    var securityCode: String
    var dateCreated: Date
    
    init?(
        number: String,
        expirationDate: (String, String),
        securityCode: String,
        dateCreated: Date = Date()
    ) {
        do {
            self.number = try validatedCardNumber(number)
            self.expirationDate = try validatedExpirationDate(expirationDate)
            self.securityCode = try validatedSecurityCode(securityCode)
        } catch {
            return nil
        }
    }
    
    // Removes any whitespace from the string and verifies that the number contains exactly 16 digits
    func validatedCardNumber(_ number: String) throws -> String {
        // Remove whitespaces
        let filteredNumber = number.filter { !$0.isWhitespace }
        
        // Check that all characters are digits
        try enforceAllAreDigits(in: filteredNumber)
        
        // Verify that there are 16 digits
        try enforceLength(of: filteredNumber, equals: 16)
        
        return filteredNumber
    }
    
    // Removes any whitespaces from the two strings and verifies that the length of the month is
    // at most 2, and that the length of the year is at most 4
    func validatedExpirationDate(_ expirationDate: (month: String, year: String))
    throws -> (month: String, year: String) {
        // Remove whitespaces
        let filteredExpirationDate: (month: String, year: String) = (
            expirationDate.month.filter { !$0.isWhitespace },
            expirationDate.year.filter { !$0.isWhitespace }
        )
        
        // Check that all are digits
        try enforceAllAreDigits(in: filteredExpirationDate.month)
        try enforceAllAreDigits(in: filteredExpirationDate.year)
        
        // Verify the lengths
        try enforceLength(of: filteredExpirationDate.month, isAtMost: 2)
        try enforceLength(of: filteredExpirationDate.year, isAtMost: 4)
        
        return filteredExpirationDate
    }
    
    // Verifies that the length is 3 and that all characters are digits
    func validatedSecurityCode(_ code: String) throws -> String {
        try enforceAllAreDigits(in: code) // Check that all are digits
        try enforceLength(of: code, equals: 3)
        return code
    }
    
    // Throws invalidCharacterError
    func enforceAllAreDigits(in str: String) throws {
        for char in str {
            if !char.isNumber {
                throw CardError.invalidCharacterError
            }
        }
    }
    
    // Throws invalidLengthError
    func enforceLength(of str: String, equals length: Int) throws {
        if str.count != length {
            throw CardError.invalidLengthError
        }
    }
    
    // Throws invalidLengthError
    func enforceLength(of str: String, isAtMost length: Int) throws {
        if str.count > length {
            throw CardError.invalidLengthError
        }
    }
}

enum CardError: Error {
    case invalidCharacterError
    case invalidLengthError
}
