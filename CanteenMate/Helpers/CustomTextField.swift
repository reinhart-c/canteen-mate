import SwiftUI

struct CustomTextFieldForString: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            TextField("Value", text: $text)
                .foregroundColor(.gray)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct CustomTextFieldForInt: View {
    var label: String
    @Binding var text: Int
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            TextField("Value", value: $text, format: .number)
                .foregroundColor(.gray)
                .keyboardType(.numberPad)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct CustomTextFieldForDate: View {
    var label: String
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 100, alignment: .leading) // Fixed width for label
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden() // Hide label to prevent extra spacing
                .frame(maxWidth: .infinity, alignment: .leading) // Force DatePicker to align left
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .leading) // Ensure the whole HStack aligns left
    }
}
