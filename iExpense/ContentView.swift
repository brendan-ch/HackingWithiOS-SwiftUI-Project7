//
//  ContentView.swift
//  iExpense
//
//  Created by Brendan Chen on 2024.04.03.
//

import SwiftUI
import Observation

struct ContentViewSection: View {
    var sectionName: String
    var expenses: Expenses
    var onDeleteInSection: (IndexSet, String) -> Void
    
    func onDelete(at offsets: IndexSet) {
        onDeleteInSection(offsets, sectionName)
    }
    
    var body: some View {
        Section(sectionName) {
            ForEach(expenses.items.filter { $0.type == sectionName }) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    if item.amount < 10 {
                        Text(item.amount, format: .currency(code: Locale.current.currency!.identifier))
                            .foregroundStyle(.green)
                    } else if item.amount < 100 {
                        Text(item.amount, format: .currency(code: Locale.current.currency!.identifier))
                    } else {
                        Text(item.amount, format: .currency(code: Locale.current.currency!.identifier))
                            .foregroundStyle(.red)
                    }
                }
            }
            .onDelete(perform: onDelete)
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<ExpenseItem.types.count, id: \.self) { index in
                    ContentViewSection(sectionName: ExpenseItem.types[index], expenses: expenses, onDeleteInSection: removeItems)
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, in section: String) {
        let filtered = expenses.items.filter { $0.type == section }
        let idToRemove = filtered[offsets.first!].id
        
        for i in 0..<expenses.items.count {
            if expenses.items[i].id == idToRemove {
                expenses.items.remove(at: i)
                return
            }
        }
    }
}

#Preview {
    ContentView()
}
