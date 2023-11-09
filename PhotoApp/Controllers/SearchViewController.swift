//
//  SearchViewController.swift
//  PhotoApp
//
//  Created by Wass on 04/11/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    var photos: Photos?
    var searchSubject: String?
    
    private let reuseIdentifier = "SearchPhotos"
    private let VCIdentifier = "ShowDetails"
    
    var current_page = 1

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let title = searchSubject {
            self.navigationItem.title = title
        }
        setupCollectionView()
        collectionView.reloadData()
        
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(.white), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped))
        
        
        navigationItem.leftBarButtonItem = backbutton        
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    

}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchPhotos = photos else { return 0}
        print(fetchPhotos.count)
        return fetchPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchPhotosCollectionViewCell
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
            if let query = searchSubject {
                UnsplashAPIHelper.shared.fetchImagesByQuery( query ,String(current_page)) { _, fetchPhotos in
                    DispatchQueue.main.async {
                        if let photos = fetchPhotos {
                            self.photos?.append(contentsOf: photos)
                            self.collectionView.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

