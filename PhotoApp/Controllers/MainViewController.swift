//
//  MainController.swift
//  PhotoApp
//
//  Created by Wass on 25/10/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var PhotosCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let reuseIdentifier = "Photos"
    private let VCIdentifier = "ShowDetails"
    private let searchVCIdentifier = "showPhotos"
    
    var current_page = 1
    
    var photos: Photos?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        
        searchBar.placeholder = "Rechercher"
        searchBar.searchBarStyle = .minimal
        UnsplashAPIHelper.shared.performRequest(String(current_page)) { _, fetchPhotos in
            DispatchQueue.main.async {
                if let photos = fetchPhotos {
                    self.photos = photos
                    self.PhotosCollectionView.reloadData()

                }
            }
        }
    }
    
    private func setConstraints() {
        PhotosCollectionView.dataSource = self
        PhotosCollectionView.delegate = self
        
        searchBar.delegate = self
        
        PhotosCollectionView.isUserInteractionEnabled = true
        PhotosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
        searchBar.heightAnchor.constraint(equalToConstant: 50),
    
        PhotosCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
        PhotosCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
        PhotosCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        PhotosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchPhotos = photos else { return 0}
        print(fetchPhotos.count)
        return fetchPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PhotosCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let fetchPhotos = photos else { return}
        if indexPath.row == fetchPhotos.count-3 {
            current_page+=1
            UnsplashAPIHelper.shared.performRequest(String(current_page)) { _, fetchPhotos in
                DispatchQueue.main.async {
                    if let photos = fetchPhotos {
                        self.photos?.append(contentsOf: photos)
                        self.PhotosCollectionView.reloadData()

                    }
                }
            }
        }
    }
    
    
}

extension MainViewController: UICollectionViewDelegate {}

extension MainViewController: UICollectionViewDelegateFlowLayout {
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

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let nextController = storyboard?.instantiateViewController(withIdentifier: searchVCIdentifier) as? SearchViewController {
            if let query = searchBar.text {
                UnsplashAPIHelper.shared.fetchImagesByQuery(query, "1") { _, photos in
                    DispatchQueue.main.async {
                        if let fetchPhotos = photos {
                            nextController.photos = fetchPhotos
                            print(query)
                            print(fetchPhotos)
                            nextController.searchSubject = query
                            self.navigationController?.pushViewController(nextController, animated: true)

                        }
                    }
                }
            }
        }
    }
}

