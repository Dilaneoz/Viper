//
//  Entity.swift
//  ViperOrnekBilgeAdam
//
//  Created by Dilan Öztürk on 1.04.2023.
//

import Foundation

struct Crypto : Decodable { // struct lar birer entity dir ve interactor tarafından kullanılan model nesnelerini içerir
    
    let currency : String // json dan alınan iki property si olan bi entity oluşturuyoruz
    let price : String
    
    
}
