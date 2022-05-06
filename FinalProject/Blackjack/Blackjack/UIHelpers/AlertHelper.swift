//
//  AlertHelper.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-04-03.
//

import Foundation
import UIKit

class AlertHelper {
    static func createTwoActionAlert(view: UIViewController, title: String, message: String, action1: UIAlertAction, action2: UIAlertAction) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(action1)
        alert.addAction(action2)

        // show the alert
        view.present(alert, animated: true)
    }
}
