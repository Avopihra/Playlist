//
//  AlertComplete.swift
//  Playlist
//
//  Created by Viktoriya on 29.10.2021.
//

import UIKit

extension UIViewController {
    
    func alertCompleted( title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let completed = UIAlertAction(title: "Completed", style: .default)
        alert.addAction(completed)
        present(alert, animated: true, completion: nil)
    }
    
}
