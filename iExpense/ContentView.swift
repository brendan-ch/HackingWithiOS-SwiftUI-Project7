//
//  ContentView.swift
//  iExpense
//
//  Created by Brendan Chen on 2024.04.03.
//

import SwiftUI
import Observation

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
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
                .onDelete(perform: removeItems)
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
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
