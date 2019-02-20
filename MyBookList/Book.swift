//
//  Book.swift
//  MyBookList
//
//  Created by Kio on 28/01/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import Foundation

// MARK: Models
class Book: Decodable {
    let id: Int?
    let title: String?
    let isbn: String?
    var description: String?
    let price: Int?
    let currencyCode: String?
    let author: String?
    
}


extension Book{
    func toCurrencyFormat() -> String {
        
        print(currencyCode!)
        print(price!)
        
        var localecomponents = Locale.components(fromIdentifier: Locale.current.identifier)
        // Set currency code
        localecomponents[NSLocale.Key.currencyCode.rawValue] = currencyCode //(EUR,USD,GBP, etc)
        // Get the updated locale identifier
        let locId = Locale.identifier(fromComponents: localecomponents)

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: locId)
        numberFormatter.numberStyle = NumberFormatter.Style.currency

        var tmpPrice = Double(price!)
        tmpPrice = tmpPrice/100
        
        
        print(tmpPrice)
        
        return numberFormatter.string(from: NSNumber(value: tmpPrice)) ?? ""
        
    }
    
    
    func alterAllDetails (desc:String, title:String,author:String,isbn:String,price:String) {
        
    }
}



