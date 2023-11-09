//
//  PhotoDetailsViewController.swift
//  PhotoApp
//
//  Created by Wass on 27/10/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoDetailsViewController: UIViewController {
    
    var photo: UnsplashPhoto?
    private let VCIdentifier = "UserDetails"
    
    @IBOutlet weak var photoDisplayer: UIImageView!
    @IBOutlet weak var photoArtistUsername: UILabel!
    @IBOutlet weak var photoLikes: UILabel!
    @IBOutlet weak var photoDescription: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var RounndedProfilePictureView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setPhotoDatas()
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(.white), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped))
        
        
        navigationItem.leftBarButtonItem = backbutton

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RounndedProfilePictureViewPressed))
        RounndedProfilePictureView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func RounndedProfilePictureViewPressed() {
        if let nextController = storyboard?.instantiateViewController(withIdentifier: VCIdentifier) as? UserDetailsViewController {
            if let user = photo?.user {
                nextController.user = user
                self.navigationController?.pushViewController(nextController, animated: true)

            }
        }
    }
    
    func setConstraints() {
        let screenBounds = self.view.bounds
        let multiplier = CGFloat(photo!.height)/CGFloat(photo!.width)
        photoDisplayer.translatesAutoresizingMaskIntoConstraints = false
        
        photoDisplayer.backgroundColor = .darkGray

        RounndedProfilePictureView.translatesAutoresizingMaskIntoConstraints = false
        photoArtistUsername.translatesAutoresizingMaskIntoConstraints = false
        photoLikes.translatesAutoresizingMaskIntoConstraints = false
        photoDescription.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.translatesAutoresizingMaskIntoConstraints = false



        NSLayoutConstraint.activate([
            
            photoDisplayer.topAnchor.constraint(equalTo: self.view.topAnchor),
            photoDisplayer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            photoDisplayer.widthAnchor.constraint(equalToConstant: screenBounds.width),
            photoDisplayer.heightAnchor.constraint(equalToConstant: CGFloat(screenBounds.width*multiplier)),
            
            RounndedProfilePictureView.topAnchor.constraint(equalTo: photoDisplayer.bottomAnchor, constant: 10),
            RounndedProfilePictureView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            RounndedProfilePictureView.heightAnchor.constraint(equalToConstant: 40),
            
            photoArtistUsername.topAnchor.constraint(equalTo: photoDisplayer.bottomAnchor, constant: 10),
            photoArtistUsername.leftAnchor.constraint(equalTo: RounndedProfilePictureView.rightAnchor, constant: 10),
            photoArtistUsername.heightAnchor.constraint(equalToConstant: 30),
            
            photoLikes.topAnchor.constraint(equalTo: photoDisplayer.bottomAnchor, constant: 10),
            photoLikes.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            photoLikes.heightAnchor.constraint(equalToConstant: 30),
            
            heartImageView.topAnchor.constraint(equalTo: photoDisplayer.bottomAnchor, constant: 10),
            heartImageView.rightAnchor.constraint(equalTo: photoLikes.leftAnchor, constant: -5),
            heartImageView.heightAnchor.constraint(equalToConstant: 30),
            
            photoDescription.topAnchor.constraint(equalTo: photoArtistUsername.bottomAnchor, constant: 15),
            photoDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            photoDescription.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
        ])
    }
    
    func setPhotoDatas() {
        guard let fetchPhoto = photo else { return}
        
        let photoDisplayerImageUrl = fetchPhoto.urls.regular
        let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000, preferredMemoryUsageAfterPurge: 60_000)
        
        AF.request(photoDisplayerImageUrl).responseImage  { response in
          print(response)
            switch response.result {
            case .success(let image):
                print(image)
                
                imageCache.add(image, withIdentifier: photoDisplayerImageUrl)
                
                DispatchQueue.main.async {
                    
                    self.photoDisplayer.image = image
                    self.photoDisplayer.contentMode = .scaleAspectFit

                }
                
            case .failure(let error):
                print(error)
            }

        }
        
        let rounndedProfilePictureImageUrl = fetchPhoto.user.profile_image.large
        
        AF.request(fetchPhoto.user.profile_image.large).responseImage { response in
            switch response.result {
            case .success(let image):
                
                imageCache.add(image, withIdentifier: rounndedProfilePictureImageUrl)

                DispatchQueue.main.async {
                    self.RounndedProfilePictureView.image = image
                    self.RounndedProfilePictureView.contentMode = .scaleToFill
                    self.RounndedProfilePictureView.RoundedProfilePictureView()
                }
                
            case .failure(let error):
                print(error)
            }

        }
        
        photoArtistUsername.text = fetchPhoto.user.username
        photoLikes.text = String(fetchPhoto.likes)
        
        if let description = fetchPhoto.description {
            photoDescription.text = description
            
        } else {
            photoDescription.text = ""
        }
    }
}
