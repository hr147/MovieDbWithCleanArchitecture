//
//  UIAlertController+Extensions.swift
//  HRTaxiApp
//
//  Created by Haroon Ur Rasheed on 20/01/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlert(with error: Error) {
        let controller = UIAlertController(title: "Error Message",
                                           message: error.localizedDescription,
                                           preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addAction(action)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
    }
}
