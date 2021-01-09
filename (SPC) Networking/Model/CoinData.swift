//
//  CoinData.swift
//  (SPC) Networking
//
//  Created by Albert Planida on 1/8/21.
//

import Foundation

struct CoinData: Decodable {
    // this represents the data retrieved from the server
    
    let id : String
    let symbol : String
    let name : String
}

