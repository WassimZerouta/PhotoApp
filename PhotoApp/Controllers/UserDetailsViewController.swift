//
//  UserDetailsViewController.swift
//  PhotoApp
//
//  Created by Wass on 02/11/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class UserDetailsViewController: UIViewController {
    
    var user: User!
    var photos: Photos?
    
    let reuseIdentifier = "UserPhotos"
    private let VCIdentifier = "ShowDetails"
    
    @IBOutlet weak var usernameImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setConstraints()
        setUserDatas()
        let username = user.username
        UnsplashAPIHelper.shared.fetchUserImages(username, completion: { _, fetchPhotos in
            DispatchQueue.main.async {
                if let photos = fetchPhotos {
                    self.photos = photos
                    self.collectionView.reloadData()
                    
                }
            }
        })
        
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(.white), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped))
        
        
        navigationItem.leftBarButtonItem = backbutton
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setConstraints() {

        usernameImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        userLocation.translatesAutoresizingMaskIntoConstraints = false
        userBio.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            
            usernameImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usernameImageView.heightAnchor.constraint(equalToConstant: 100),
            usernameImageView.widthAnchor.constraint(equalToConstant: 100),
            usernameImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: usernameImageView.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30),


            userLocation.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            userLocation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            userLocation.heightAnchor.constraint(equalToConstant: 30),
            
            userBio.topAnchor.constraint(equalTo: userLocation.bottomAnchor, constant: 10),
            userBio.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            userBio.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: userBio.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])

    }
    
    func setUserDatas() {
        
        AF.request(user.profile_image.medium).responseImage { response in
          print(response)
            switch response.result {
            case .success(let image):
                print(image)
                DispatchQueue.main.async {
                    self.usernameImageView.image = image
                    self.usernameImageView.RoundedProfilePictureView()
                }
                
            case .failure(let error):
                print(error)
            }

        }
        
        usernameLabel.text = user.username
        if let location = user.location {
            userLocation.text = location
        }
        
        if let bio = user.bio {
            userBio.text = bio
        } else {
            userBio.text = ""
        }
    }
}

extension UserDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchPhotos = photos else { return 0}
        print(fetchPhotos.count)
        return fetchPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPhotoCollectionViewCell
        if let fetchPhotos = photos {
            cell.setup(fetchPhotos[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let nextController = storyboard?.instantiateViewController(withIdentifier: VCIdentifier) as? PhotoDetailsViewController {
            if let fetchPhotos = photos {
                let photo = fetchPhotos[indexPath.item]
                nextController.photo = photo
                self.navigationController?.pushViewController(nextController, animated: true)

            }
        }
    }
    
    
}

extension UserDetailsViewController: UICollectionViewDelegate {}

extension UserDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSideSize = self.view.frame.width/3.05
        return CGSize(width: cellSideSize, height: cellSideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
