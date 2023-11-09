//
//  UnsplashDecodable.swift
//  PhotoApp
//
//  Created by Wass on 25/10/2023.
//

//   let unsplashPhotos = try? JSONDecoder().decode(UnsplashPhotos.self, from: jsonData)

import Foundation

// MARK: - UnsplashPhoto
typealias Photos = [UnsplashPhoto]

struct Result: Decodable {
    let total: Int
    let total_pages: Int
    let results: Photos
}

struct UnsplashPhoto: Decodable {
    let id, slug: String
    let promotedAt: Date?
    let width, height: Int
    let color, blur_hash: String?
    let description: String?
    let urls: Urls
    let links: UnsplashPhotoLinks
    let likes: Int
    let liked_by_user: Bool
    let sponsorship: Sponsorship?
    let topic_submissions: TopicSubmissions?
    let user: User

}

// MARK: - UnsplashPhotoLinks
struct UnsplashPhotoLinks: Decodable {
    let html, download, download_location: String

}

// MARK: - Sponsorship
struct Sponsorship: Decodable {
    let impression_urls: [String]
    let tagline: String
    let tagline_url: String
    let sponsor: User


}

// MARK: - User
struct User: Decodable {
    let id: String
    let username, name, first_name: String
    let last_name, twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let links: UserLinks
    let profile_image: ProfileImage
    let instagram_username: String?
    let total_collections, total_likes, total_photos: Int
    let accepted_tos, for_hire: Bool
    let social: Social

}

// MARK: - UserLinks
struct UserLinks: Decodable {
    let html, photos, likes: String
    let portfolio, following, followers: String

}

// MARK: - ProfileImage
struct ProfileImage: Decodable {
    let small, medium, large: String
}

// MARK: - Social
struct Social: Decodable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
}

// MARK: - TopicSubmissions
struct TopicSubmissions: Decodable {
    let nature: Nature?
    let the3DRenders: The3DRenders?

}

// MARK: - Nature
struct Nature: Decodable {
    let status: String
}

// MARK: - The3DRenders
struct The3DRenders: Decodable {
    let status: String
    let approvedOn: Date

}

// MARK: - Urls
struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb, small_s3: String

}

