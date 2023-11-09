//
//  UserPhotoCollectionViewCell.swift
//  PhotoApp
//
//  Created by Wass on 02/11/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class UserPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PhotoImageView: UIImageView!
    
    
    var currentPhoto: UnsplashPhoto?
    
    func setup(_ photo: UnsplashPhoto) {
        self.currentPhoto = photo
        PhotoImageView.backgroundColor = .darkGray
        
        AF.request(photo.urls.small).responseImage { response in
          print(response)
            switch response.result {
            case .success(let image):
                print("\(image)")
                DispatchQueue.main.async {
                    self.PhotoImageView.image = image
                    self.PhotoImageView.contentMode = .scaleAspectFill
                }
                
            case .failure(let error):
                print(error)
            }

        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        PhotoImageView.image = nil
    }
}
