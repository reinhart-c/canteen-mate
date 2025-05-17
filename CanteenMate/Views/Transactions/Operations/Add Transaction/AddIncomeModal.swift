import Foundation
import SwiftUI


struct AddIncomeModal: View {
    @State private var isCustomMode: Bool = false
    @State private var isAddingIncome: Bool = true
    @State private var showCancelAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var options = [false, true]
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Income Mode", selection: $isCustomMode){
                    ForEach(options, id: \.self){opt in
                        if opt {
                            Text("Custom")
                        }else {
                            Text ("Menu")
                        }
                    }
                }.pickerStyle(.segmented)
                    .padding()
                if !isCustomMode {
                    IncomeModeMenuView(isCustomMode: $isCustomMode, isAddingIncome: $isAddingIncome)
                        .transition(.identity)
                }else if isCustomMode {
                    IncomeModeCustomView(isCustomMode: $isCustomMode, isAddingIncome: $isAddingIncome)
                        .transition(.identity)
                }
            }.navigationBarItems(
                leading: Button("Cancel") {
                   showCancelAlert = true
                }
            ).navigationTitle("Add Income")
                .background(Color(.systemGray6))
        }.onAppear(){
            if !isAddingIncome {
                dismiss()
            }
        }
        .onChange(of: isAddingIncome) {
            if !isAddingIncome {
                dismiss()
            }
        }
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Reset and Exit", role: .destructive) {
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("You have unsaved data. Are you sure you want to cancel?")
        }
    }
}

#Preview {
    AddIncomeModal()
}
