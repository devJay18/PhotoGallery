//
//  Extension.swift
//  WeatherApp
//
//  Created by apple on 03/02/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertController(
        title: String = "",
        message: String,
        didTapOkay: @escaping () -> Void = { }
    ) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .default) { _ in
            didTapOkay()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
