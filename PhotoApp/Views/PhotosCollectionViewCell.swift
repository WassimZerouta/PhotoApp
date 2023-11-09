//
//  PhotosCollectionViewCell.swift
//  PhotoApp
//
//  Created by Wass on 25/10/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PhotoImageView: UIImageView!
    
    
    var currentPhoto: UnsplashPhoto?
    
    func setup(_ photo: UnsplashPhoto) {
        self.currentPhoto = photo
        
        PhotoImageView.backgroundColor = .darkGray

        let photoUrl = photo.urls.thumb
        let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000, preferredMemoryUsageAfterPurge: 60_000)
        
        AF.request(photoUrl).responseImage  { response in
            print(response)
            switch response.result {
            case .success(let image):
                imageCache.add(image, withIdentifier: photoUrl)

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
