//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Brendan Chen on 2024.04.03.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

// Notice this pattern: everything is abstracted into the Expenses class,
// which takes care of saving and loading data
// The Expenses class is observable which means it can be used as state

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        // In the setter (?) for this variable, save the updated value
        // to UserDefaults
        // This won't work well if we're storing lots of data,
        // but it's fine for a simple app
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        // Load data from UserDefaults
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}
