import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var transaction: Transaction

    @State private var showCancelAlert = false
    @State private var showMissingFieldsAlert = false
    @State private var showDeleteAlert = false
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                CancelDoneButtonView(
                                    text: "Cancel",
                                    action: {
                                        showCancelAlert = true
                                    }
                                )
                                Spacer()
                                CancelDoneButtonView(
                                    text: "Done",
                                    action: {
                                        if transaction.name.isEmpty || transaction.amount <= 0 {
                                            showMissingFieldsAlert = true
                                        } else {
                                            dismiss()
                                        }
                                    }
                                )
                            }
                            .padding(20)

                            IncomeExpenseButtonView(isIncomeMode: Binding(
                                get: { transaction.type == .income },
                                set: { transaction.type = $0 ? .income : .expense }
                            ))

                            VStack(spacing: 12) {
                                CustomTextFieldForDate(label: "Date", selectedDate: $transaction.date)
                                CustomTextFieldForString(label: "Title", text: $transaction.name)
                                CustomTextFieldForInt(label: "Amount", text: $transaction.amount)
                                CustomTextFieldForString(label: "Description", text: Binding(
                                    get: { transaction.desc ?? "" },
                                    set: { transaction.desc = $0.isEmpty ? nil : $0 }
                                ))
                                CustomTextFieldForInt(label: "Quantity", text: $transaction.count)
                                Button(role: .destructive) {
                                    showDeleteAlert = true
                                } label: {
                                    Text("Delete Transaction")
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding()
                        }
                    }
                    Spacer()
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel editing this transaction?")
        }
        .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Delete this transaction?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                context.delete(transaction)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
