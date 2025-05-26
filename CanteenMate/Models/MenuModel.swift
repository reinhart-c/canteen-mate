//
//  MenuModel.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import Foundation
import SwiftData


@Model
class MenuModel: Identifiable {
    var id = UUID()
    var name: String = ""
    var price: Int = 0
    
    init(id: UUID = UUID(), name: String, price: Int) {
        self.id = id
        self.name = name
        self.price = price
    }
}
