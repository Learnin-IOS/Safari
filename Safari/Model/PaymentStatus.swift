//
//  PaymentStatus.swift
//  Safari
//
//  Created by Le Bon B' Bauma on 07/12/2022.
//

import SwiftUI

enum PaymentStatus: String,CaseIterable {
    
    case started = "Connected..."
    case initiated = "Secure payment..."
    case finished = "Purchased"
    
    var symbolImage: String {
        switch self {
        case .started:
            return "wifi"
        case .initiated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
