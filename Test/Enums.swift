
//
//  Constants.swift
//  Test
//
//  Created by Gnani on 28/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

enum RideCategory {
    case economy
    case premium
    
    var title: String {
        
        switch self {
        case .economy:
            return "Economy"
        case .premium:
            return "Premium"
        }
    }
    
    var rides: [RideType] {
        switch self {
        case .economy:
            return [.pool, .go, .bike]
        case .premium:
            return [.x, .xl]
        }
    }
}

enum RideType {
    case pool
    case go
    case bike
    case x
    case xl
    
    var title: String {
        
        switch self {
        case .pool:
            return "uberPOOL"
        case .go:
            return "uberGO"
        case .bike:
            return "uberBike"
        case .x:
            return "uberX"
        case .xl:
            return "uberXL"
        }
    }
    
    var buttonTitle: String {
        
        switch self {
        case .pool:
            return "CONFIRM POOL"
        case .go:
            return "CONFIRM UBERGO"
        case .bike:
            return "CONFIRM BIKE"
        case .x:
            return "CONFIRM UBERX"
        case .xl:
            return "CONFIRM UBERXL"
        }
    }
    
    var noOfRiders: String {
        
        switch self {
        case .pool:
            return "1-2"
        case .go:
            return "1-4"
        case .bike:
            return "1"
        case .x:
            return "1-4"
        case .xl:
            return "1-6"
        }
    }
    
    var price: String {
        
        switch self {
        case .pool:
            return "₹ 49.00"
        case .go:
            return "₹ 72.70"
        case .bike:
            return "₹ 28.60"
        case .x:
            return "₹ 121.54"
        case .xl:
            return "₹ 168.13"
        }
    }
}
