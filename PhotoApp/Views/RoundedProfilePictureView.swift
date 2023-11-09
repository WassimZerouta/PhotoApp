//
//  RoundedProfilePictureView.swift
//  PhotoApp
//
//  Created by Wass on 02/11/2023.
//

import Foundation
import UIKit

extension UIImageView {
    
    func RoundedProfilePictureView() {
        layer.borderWidth = 3
        layer.masksToBounds = false
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
