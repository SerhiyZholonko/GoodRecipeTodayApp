//
//  FirebaseStore.swift
//  GoodRecipeToDay
//
//  Created by apple on 07.05.2023.
//

import FirebaseStorage
import UIKit

class FirebaseImageManager {
    
    static let shared = FirebaseImageManager()
    private let storageRef = Storage.storage().reference()
     init() {}
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(FirebaseImageManagerError.invalidImageData))
            return
        }
        let uuid = UUID().uuidString
        let imageRef = storageRef.child("images/\(uuid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    } else {
                        completion(.failure(FirebaseImageManagerError.uploadFailed))
                    }
                }
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let imageRef = storageRef.child(url.absoluteString)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(FirebaseImageManagerError.downloadFailed))
            }
        }
    }
    
//    func deleteImage(at url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
//        let imageRef = storageRef.child(url.absoluteString)
//        imageRef.delete { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
    func deleteImage(at url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference(forURL: url.absoluteString)

        reference.getMetadata { metadata, error in
            if let error = error {
                // Object does not exist or other error occurred
                completion(.failure(error))
            } else {
                // Object exists, proceed with deletion
                reference.delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }

}

enum FirebaseImageManagerError: Error {
    case invalidImageData
    case uploadFailed
    case downloadFailed
}


