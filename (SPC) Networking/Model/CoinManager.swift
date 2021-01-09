//
//  CoinManager.swift
//  (SPC) Networking
//
//  Created by Albert Planida on 1/8/21.
//

import Foundation

protocol CoinManagerDelegate {
    func didFetchAuthor(_ coinManager: CoinManager, author: Coin)
    func didFetchAuthorList(_ coinManager: CoinManager, authorList: [Coin])
    func didFailWithError(error: Error)
}

struct CoinManager {
    // handles all data requests for the Author model
    
    private let rootURL = "https://api.coingecko.com/api/v3/"
    
    var delegate: CoinManagerDelegate?
    
    func fetchCoinList() {
        let requestURL = "\(rootURL)coins/list"
        performFetch(with: requestURL) { _ in
            print("This is executed after fetching all authors")
        }
    }
    
    func fetchCoin(with id: Int) {
        
    }
    
    private func performFetch(with urlString: String, completion: (Any?) -> Void) {
        
        // 1. create the URL
        guard let requestURL = URL(string: urlString) else { return }
            
        // 2. create a session
        let session = URLSession(configuration: .default)
        
        // 3. give the session a task
        let task = session.dataTask(with: requestURL) { (data, response, error) in
            
            print(response?.mimeType)
            
            // 5. the completion handler
            // dataTask() gives you Data?, URLResponse?, and Error? to use in the closure
            
            // 5a. handle the error
            if error != nil {
                print(error!)
                
                // 5a. handle the error and stop execution
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            // 5b. handle the response and make sure it's an expected 2XX response
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                        return
                    }
            
            // 5c. handle the data, making sure it is json format
            if let mimeType = httpResponse.mimeType, mimeType == "application/json", let safeData = data {
                
                // 6. parse the JSON data
                if let coinList = parseJSONCoinList(safeData) {
                    print("The list was decoded")
                    
                    // run the delegate method
                    self.delegate?.didFetchAuthorList(self, authorList: coinList)
                }
                
            }
        }
        
        // 4. start the task
        task.resume()
    }
    
    private func parseJSONCoinList(_ listData: Data) -> [Coin]? {
        let decoder = JSONDecoder()
        
        do {
            // 7a. try to decode the data
            let decodedData = try decoder.decode([CoinData].self, from: listData)
            
            // 8. create the list that will be returned
            var coinList : [Coin] = []
            
            // 9. loop through all of the coins in the request
            for coinData in decodedData {
                let id = coinData.id
                let name = coinData.name
                let symbol = coinData.symbol
                
                // create the object
                let newCoin = Coin(id: id, symbol: symbol, name: name)
                
                // add to the list
                coinList.append(newCoin)
            }
            
            // 10. return the new list of coins
            return coinList
            
        } catch {
            
            // 7b. handle the decoding error
            print("parse JSON failed")
            self.delegate?.didFailWithError(error: error)
            return nil
            
        }
    }
}
