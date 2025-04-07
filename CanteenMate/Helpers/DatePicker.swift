//
//  DatePicker.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 03/04/25.
//

import Foundation

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @State private var showDatePicker = false
    
    var body: some View {
        HStack{
            Button(action: { changeDate(by: -1) }) {
                Text("<").font(.title2).padding()
            }
            
            Spacer()
            
            Text(formattedDate(selectedDate))
                .font(.title3)
                .padding()
                .onTapGesture { showDatePicker.toggle() }
            
            Spacer()
            
            Button(action: { changeDate(by: 1) }) {
                Text(">").font(.title2).padding()
            }
        }
        .frame(height: 45)
        .background(Color.gray.opacity(0.3))
        
        if showDatePicker {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()
        }
        
    }
    
    // Helper function to format date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    // Function to change date
    func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()))
}
