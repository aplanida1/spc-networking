//
//  ViewController.swift
//  (SPC) Networking
//
//  Created by Albert Planida on 1/8/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set the delegate to self
        coinManager.delegate = self
        
        // make the request for all authors
        print("Start fetching list")
        coinManager.fetchCoinList()
        print("Done fetching list")
    }

}

// MARK: - Extensions

extension ViewController : CoinManagerDelegate {
    func didFetchAuthorList(_ coinManager: CoinManager, authorList: [Coin]) {
        print("didFetchAuthorList")
    }
    
    func didFetchAuthor(_ coinManager: CoinManager, author: Coin) {
        print("didFetchAuthor")
        
        // handle the data
    }
    
    func didFailWithError(error: Error) {
        print("didFailWithError")
        print(error)
        // handle the error
    }
    
}

