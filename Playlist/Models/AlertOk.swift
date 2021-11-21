//
//  AlertComplete.swift
//  Playlist
//
//  Created by Viktoriya on 29.10.2021.
//

import UIKit

extension UIViewController {
    
    func alertOk(title: String,
                 message: String,
                 handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok",
                               style: .default) {  (_) in
            handler?()
        }
        alert.addAction(ok)
        present(alert,
                animated: true,
                completion: nil)
    }
}
