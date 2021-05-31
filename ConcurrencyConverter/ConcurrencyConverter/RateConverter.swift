//
//  RateConverter.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import Foundation

class RateConverter {
    var rateData: [String: Double]
    
    init(rateData: [String: Double]) {
        self.rateData = rateData
    }
    
    func convert(amount: Double, currency: DataConstants.Currency, into currency2: DataConstants.Currency) -> Double {
        let rate = getCurrencyRate(currency1: currency, currency2: currency2)
        
        return Double(round(1000*amount*rate)/1000) //round to x.xxx
    }
    
    func getCurrencyRate(currency1: DataConstants.Currency, currency2: DataConstants.Currency) -> Double {
        if let cur1Rate = rateData[currency1.rawValue], let cur2Rate = rateData[currency2.rawValue] {
        return cur2Rate/cur1Rate
        } else {
            return 0
        }
    }
    
}
