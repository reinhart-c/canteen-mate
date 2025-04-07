//
//  MenuCashierCard.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import Foundation

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.locale = Locale(identifier: "id_ID")
        return "Rp" + (formatter.string(from: NSNumber(value: self)) ?? "0")
    }
}

import SwiftUI

struct MenuCashierCard: View{
    var title: String
    var price: Int
    
    @Binding var numberOfTotal: Int
    
    
    var body: some View{
        //item menu
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text("\(title)")
                    Text("Rp\(price)")
                        .foregroundStyle(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    Button(action: minusPressed){
                        Image(systemName: "minus")
                            .foregroundStyle(Color.black)
                    }.padding(.horizontal, 6)
                    Text("\(numberOfTotal)")
                        .padding(.horizontal, 6)
                        .frame(width: 40)
                    Button(action: plusPressed){
                        Image(systemName: "plus")
                            .foregroundStyle(Color.black)
                    }.padding(.horizontal, 6)
                }
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            Divider()
                .background(Color(.systemGray5))
                .padding(.horizontal)
        }
    }
    
    func minusPressed(){
        if numberOfTotal > 0 {
            numberOfTotal -= 1
        }
    }
    
    func plusPressed(){
        numberOfTotal += 1
    }
}

#Preview {
    MenuCashierCard(title: "Mie Ayam Dinosaurus", price: 15000, numberOfTotal: .constant(0))
}

