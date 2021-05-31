//
//  DataModel.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import Foundation

class DataConstants {
    
    static let latestCurrencyUrlString = "http://api.exchangeratesapi.io/v1/latest?access_key=078f56bf5c0d7bafa97734ad66049ed0"
    
    enum Currency: String {
        case EUR = "EUR"
        case USD = "USD"
        case UAH = "UAH"
        case RUB = "RUB"
        case PLN = "PLN"
        case GBP = "GBP"
        case CZK = "CZK"
        case CNY = "CNY"
        case TRY = "TRY"
    }

    enum СurrencyTranslatedNames: String {
        case EUR = "євро"
        case USD = "доллар США"
        case UAH = "українська гривня"
        case RUB = "російський рубль"
        case PLN = "польський злотий"
        case GBP = "англійський фунт"
        case CZK = "чеська крона"
        case CNY = "китайський юань"
        case TRY = "турецька ліра"
    }
}
