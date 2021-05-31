//
//  RateServise.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import Foundation

struct RatesResult: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}

class RateService {
    func getExchangeRate<T:Decodable>(completionHandler: @escaping (_ result: T?, _ error: Error?) -> Void ) {
        guard let url = URL(string: DataConstants.latestCurrencyUrlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) {data, response, error in
            
            if let error = error {
                completionHandler(nil, error)
            }
            
            if let data = data {
                do {
                    let rates = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(rates, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
            
        }
        dataTask.resume()
    }
}

class RateServiceMock: RateService {
    
    let dataMock = """
    {"success":true,"timestamp":1622389324,"base":"EUR","date":"2021-05-30","rates":{"AED":4.478573,"AFN":95.651047,"ALL":123.271544,"AMD":634.816981,"ANG":2.188009,"AOA":783.031215,"ARS":115.2842,"AUD":1.581116,"AWG":2.194659,"AZN":2.077574,"BAM":1.957733,"BBD":2.461192,"BDT":103.300751,"BGN":1.955386,"BHD":0.459602,"BIF":2403.151603,"BMD":1.219255,"BND":1.613161,"BOB":8.416911,"BRL":6.372254,"BSD":1.218985,"BTC":3.4368746e-5,"BTN":88.351118,"BWP":12.98161,"BYN":3.0864,"BYR":23897.397982,"BZD":2.457088,"CAD":1.472134,"CDF":2440.948949,"CHF":1.097158,"CLF":0.032013,"CLP":883.355017,"CNY":7.764709,"COP":4520.997537,"CRC":753.392225,"CUC":1.219255,"CUP":32.310257,"CVE":111.038033,"CZK":25.458781,"DJF":216.686478,"DKK":7.436273,"DOP":69.57117,"DZD":162.567,"EGP":19.091,"ERN":18.291251,"ETB":52.452828,"EUR":1,"FJD":2.483018,"FKP":0.867518,"GBP":0.859235,"GEL":3.975248,"GGP":0.867518,"GHS":7.04777,"GIP":0.867518,"GMD":62.401946,"GNF":11979.180799,"GTQ":9.417753,"GYD":254.807649,"HKD":9.462578,"HNL":29.377998,"HRK":7.515859,"HTG":110.255253,"HUF":348.188795,"IDR":17443.149719,"ILS":3.961592,"IMP":0.867518,"INR":88.266386,"IQD":1780.721926,"IRR":51336.732166,"ISK":147.591288,"JEP":0.867518,"JMD":181.453868,"JOD":0.8645,"JPY":133.941306,"KES":131.25327,"KGS":101.960936,"KHR":4962.368274,"KMF":493.036288,"KPW":1097.329642,"KRW":1358.067648,"KWD":0.367057,"KYD":1.015779,"KZT":522.397721,"LAK":11515.863892,"LBP":1864.66058,"LKR":241.96944,"LRD":209.285586,"LSL":16.795285,"LTL":3.600144,"LVL":0.737516,"LYD":5.419636,"MAD":10.770294,"MDL":21.447745,"MGA":4573.425924,"MKD":61.56984,"MMK":2006.457197,"MNT":3475.990044,"MOP":9.745131,"MRO":435.273825,"MUR":49.31,"MVR":18.837951,"MWK":960.16787,"MXN":24.291265,"MYR":5.039795,"MZN":74.143357,"NAD":16.795285,"NGN":502.947231,"NIO":43.101124,"NOK":10.218918,"NPR":141.361709,"NZD":1.679814,"OMR":0.46935,"PAB":1.218985,"PEN":4.649066,"PGK":4.304427,"PHP":58.218,"PKR":188.454196,"PLN":4.484146,"PYG":8271.271045,"QAR":4.439354,"RON":4.918967,"RSD":117.694388,"RUB":89.250568,"RWF":1207.062449,"SAR":4.572561,"SBD":9.715333,"SCR":20.115,"SDG":511.481957,"SEK":10.13012,"SGD":1.61308,"SHP":0.867518,"SLL":12497.364153,"SOS":713.264587,"SRD":17.257382,"STD":25282.208921,"SVC":10.666367,"SYP":1533.256162,"SZL":16.795284,"THB":38.114362,"TJS":13.902312,"TMT":4.267392,"TND":3.323084,"TOP":2.72187,"TRY":10.433901,"TTD":8.279947,"TWD":33.694158,"TZS":2826.764729,"UAH":33.517075,"UGX":4323.702224,"USD":1.219255,"UYU":53.469529,"UZS":12918.007123,"VEF":260713567539.82474,"VND":28098.950709,"VUV":132.17604,"WST":3.067584,"XAF":656.592452,"XAG":0.043642,"XAU":0.00064,"XCD":3.295098,"XDR":0.843717,"XOF":656.573209,"XPF":119.914173,"YER":304.814155,"ZAR":16.806095,"ZMK":10974.762479,"ZMW":27.417647,"ZWL":392.600481}}
    """
    
    func getExchangeRate(completionHandler: @escaping (RatesResult?, Error?) -> Void) {
        do {
        let rates = try JSONDecoder().decode(RatesResult.self, from: dataMock.data(using: .utf8)! )
        completionHandler(rates, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
}
