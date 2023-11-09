//
//  UnsplashAPIHelper.swift
//  PhotoApp
//
//  Created by Wass on 25/10/2023.
//

import Foundation
import Alamofire


// Creation of the APIHelper protocol
protocol APIHelper {
    func performRequest(_ page: String, completion: @escaping (Bool, [UnsplashPhoto]?) -> Void)
    func fetchUserImages(_ username: String,completion: @escaping (Bool, [UnsplashPhoto]?) -> Void)
    func fetchImagesByQuery(_ query: String, _ page: String,completion: @escaping (Bool, [UnsplashPhoto]?) -> Void)
}


// Class NewsAPIHelper which uses the protocol APIHelper
class UnsplashAPIHelper: APIHelper {
    
    static let shared = UnsplashAPIHelper()
    
    private init() {}
    
    
    private func getUrl(_ page: String) -> URL {
        let stringUrl = "https://api.unsplash.com/photos/?client_id=YTJI2g6Z9DjItGp8-jvQx3N8SkoDYNwhrjjbb_a5-u8&page=\(page)&per_page=21"
        return URL(string: stringUrl)!
    }
    
    private func getUserImageUrl(_ username: String) -> URL {
        let stringUrl = "https://api.unsplash.com/users/\(username)/photos/?client_id=YTJI2g6Z9DjItGp8-jvQx3N8SkoDYNwhrjjbb_a5-u8"
        return URL(string: stringUrl)!
    }
    
    private func getImagesByQueryUrl(_ query: String,_ page: String ) -> URL {
        let stringUrl = "https://api.unsplash.com/search/photos/?client_id=YTJI2g6Z9DjItGp8-jvQx3N8SkoDYNwhrjjbb_a5-u8&page=\(page)&query=\(query)"
        return URL(string: stringUrl)!
    }

    
    // Perform the request
    func performRequest(_ page: String, completion: @escaping (Bool, [UnsplashPhoto]?) -> Void) {
        _ = AF.request(getUrl(page))
            .responseDecodable(of: Photos.self) { response in
                switch response.result {
                case .success(_):
                    guard let result = response.value else { return }
                    completion( true, result)
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        
    }
    
    func fetchUserImages(_ username: String,completion: @escaping (Bool, [UnsplashPhoto]?) -> Void) {
        _ = AF.request(getUserImageUrl(username))
            .responseDecodable(of: Photos.self) { response in
                switch response.result {
                case .success(_):
                    guard let result = response.value else { return }
                    completion( true, result)
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        
    }
    
    func fetchImagesByQuery(_ query: String, _ page: String,completion: @escaping (Bool, [UnsplashPhoto]?) -> Void) {
        _ = AF.request(getImagesByQueryUrl(query, page))
            .responseDecodable(of: Result.self) { response in
                switch response.result {
                case .success(_):
                    guard let result = response.value else { return }
                    completion( true, result.results)
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        
    }
}

class MockUnsplashAPIHelper: APIHelper {
    
    
    let photo1 = UnsplashPhoto(id:"", slug: "", promotedAt: nil, width: 10, height: 10, color: "", blur_hash: "", description: "", urls: Urls(raw: "", full: "", regular: "", small: "", thumb: "", small_s3: ""), links: UnsplashPhotoLinks(html: "", download: "", download_location: ""), likes: 1, liked_by_user: false, sponsorship: Sponsorship(impression_urls: [""], tagline: "", tagline_url: "", sponsor: User(id: "", username: "", name: "", first_name: "", last_name: "", twitter_username: "", portfolio_url: "", bio: "", location: "", links: UserLinks(html: "", photos: "", likes: "", portfolio: "", following: "", followers: ""), profile_image: ProfileImage(small: "", medium: "", large: ""), instagram_username: "", total_collections: 1, total_likes: 1, total_photos: 1, accepted_tos: true, for_hire: true, social: Social(instagramUsername: "", portfolioURL: "", twitterUsername: ""))), topic_submissions:nil , user: User(id: "", username: "", name: "", first_name: "", last_name: "", twitter_username: "", portfolio_url: "", bio: "", location: "", links: UserLinks(html: "", photos: "", likes: "", portfolio: "", following: "", followers: ""), profile_image: ProfileImage(small: "", medium: "", large: ""), instagram_username: "", total_collections: 1, total_likes: 1, total_photos: 1, accepted_tos: true, for_hire: true, social: Social(instagramUsername: "", portfolioURL: "", twitterUsername: "")))
    
    let photo2 = UnsplashPhoto(id:"", slug: "", promotedAt: nil, width: 10, height: 10, color: "", blur_hash: "", description: "", urls: Urls(raw: "", full: "", regular: "", small: "", thumb: "", small_s3: ""), links: UnsplashPhotoLinks(html: "", download: "", download_location: ""), likes: 1, liked_by_user: false, sponsorship: Sponsorship(impression_urls: [""], tagline: "", tagline_url: "", sponsor: User(id: "", username: "", name: "", first_name: "", last_name: "", twitter_username: "", portfolio_url: "", bio: "", location: "", links: UserLinks(html: "", photos: "", likes: "", portfolio: "", following: "", followers: ""), profile_image: ProfileImage(small: "", medium: "", large: ""), instagram_username: "", total_collections: 1, total_likes: 1, total_photos: 1, accepted_tos: true, for_hire: true, social: Social(instagramUsername: "", portfolioURL: "", twitterUsername: ""))), topic_submissions:nil , user: User(id: "", username: "", name: "", first_name: "", last_name: "", twitter_username: "", portfolio_url: "", bio: "", location: "", links: UserLinks(html: "", photos: "", likes: "", portfolio: "", following: "", followers: ""), profile_image: ProfileImage(small: "", medium: "", large: ""), instagram_username: "", total_collections: 1, total_likes: 1, total_photos: 1, accepted_tos: true, for_hire: true, social: Social(instagramUsername: "", portfolioURL: "", twitterUsername: "")))
    
    let photo3 = UnsplashPhoto(id:"", slug: "", promotedAt: nil, width: 10, height: 10, color: "", blur_hash: "", description: "", urls: Urls(raw: "", full: "", regular: "", small: "", thumb: "", small_s3: ""), links: UnsplashPhotoLinks(html: "", download: "", download_location: ""), likes: 1, liked_by_user: false, sponsorship: Sponsorship(impression_urls: [""], tagline: "", tagline_url: "", sponsor: User(id: "", username: "", name: "", first_name: "", last_name: "", twitter_username: "", portfolio_url: "", bio: "", location: "", links: UserLinks(html: "", photos: "", likes: "", portfolio: "", following: "", followers: ""), profile_image: ProfileImage(small: "", medium: "", large: ""), instagram_username: "", total_collections: 1, total_likes: 1, total_photos: 1, accepted_tos: true, for_hire: true, social: Social(instagramUsername: "", portfolioURL: "", twitterUsername: ""))), topic_submissions:nil , user: User(id: "", username: "", name: "", first_name: "", last_name: "", twitter_username: "", portfolio_url: "", bio: "", location: "", links: UserLinks(html: "", photos: "", likes: "", portfolio: "", following: "", followers: ""), profile_image: ProfileImage(small: "", medium: "", large: ""), instagram_username: "", total_collections: 1, total_likes: 1, total_photos: 1, accepted_tos: true, for_hire: true, social: Social(instagramUsername: "", portfolioURL: "", twitterUsername: "")))
    
    
    func performRequest(_ page: String, completion: @escaping (Bool, [UnsplashPhoto]?) -> Void) {
        let response = [photo1]
        completion(true, response)
    }
    
    func fetchUserImages(_ username: String, completion: @escaping (Bool, [UnsplashPhoto]?) -> Void) {
        let response = [photo1, photo2]
        completion(true, response)
    }
    
    func fetchImagesByQuery(_ query: String, _ page: String, completion: @escaping (Bool, [UnsplashPhoto]?) -> Void) {
        let response = [photo1, photo2, photo3]
        completion(true, response)
    }
}
