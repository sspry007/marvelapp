//
//  MarvelService.swift
//  marvelapp
//
//  Created by Steven Spry on 3/10/25.
//  https://developer.marvel.com/account
//

import Foundation
import CryptoKit
import SwiftUI

enum MarvelError: Error, Equatable {
    case parseError
    case invalidURL
    case notAuthorized
    case serverError(status: Int)
    case unhandledStatus(status: Int)
    case unhandledError(error: String)

    var localizedDescription: String {
        switch self {
        case .parseError:
            return "Parsing Error"
        case .invalidURL:
            return "Invalid URL"
        case .notAuthorized:
            return "Not authorized"
        case .serverError(let status):
            return "Server Error \(status)"
        case .unhandledStatus(let status):
            return "Unhandled http status code \(status)"
        case .unhandledError(let error):
            return "Unhandled http error \(error)"
        }
    }
}

enum ImageVariant: String {
    case fullsizeImage = ""
    case standardFantastic = "/standard_fantastic"
}

class MarvelService: ObservableObject {
    
    static let shared: MarvelService = {
        let instance = MarvelService()
        instance.setup()
        return instance
    }()
    
    let baseURL = "https://gateway.marvel.com/v1/"
    let imageCache = NSCache<AnyObject, AnyObject>()
    private var apiKey:String = ""
    private var appHash:String = ""

    private init() {}
    
    private func setup() {
        self.imageCache.totalCostLimit = 100 * 1024 * 1024 // 100 MB
        
        if let url = Bundle.main.url(forResource: "Configuration", withExtension:"plist") {
            do {
                let data = try Data(contentsOf: url)
                let result = try PropertyListDecoder().decode(Configuration.self, from: data)
                self.apiKey = result.apiKey
                self.appHash = result.appHash
            } catch {
                print(error)
            }
        } else {
            "Configuration.plist not present".log()
        }
    }
    
    func characters(offset:Int = 0,limit:Int = 21) async throws -> ([Character], Int, String) {
        let urlString = "\(baseURL)public/characters\(self.queryString(offset:offset,limit: limit))"
        "Marvel Service Characters offset=\(offset) limit=\(limit)".log()

        if let url = URL(string: urlString) {
            var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                var statusCode:Int = 0
                if let urlResponse = response as? HTTPURLResponse {
                    statusCode = urlResponse.statusCode
                }
                switch statusCode {
                case 200:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.marvel())
                    do {
                        let charactersResponse:CharactersResponse = try decoder.decode(CharactersResponse.self, from: data)
                        return (charactersResponse.data.results,charactersResponse.data.total,charactersResponse.attributionText)
                    } catch {
                        throw MarvelError.parseError
                    }
                default:
                    throw MarvelError.unhandledStatus(status: statusCode)
                }
            }
            catch MarvelError.notAuthorized {
                throw MarvelError.notAuthorized
            }
        } else {
            throw MarvelError.invalidURL
        }
    }
    
    func collection(collectionURI: String) async throws -> ([CollectionThumbnail], String) {
        let urlString = "\(collectionURI)\(self.queryString(offset:0,limit: 20))"
        "Marvel Service Collection".log()
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                var statusCode:Int = 0
                if let urlResponse = response as? HTTPURLResponse {
                    statusCode = urlResponse.statusCode
                }
                switch statusCode {
                case 200:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.marvel())
                    do {
                        let collectionResponse:CollectionResponse = try decoder.decode(CollectionResponse.self, from: data)
                        return (collectionResponse.data.results,collectionResponse.attributionText)
                    } catch {
                        throw MarvelError.parseError
                    }
                default:
                    throw MarvelError.unhandledStatus(status: statusCode)
                }
            }
            catch MarvelError.notAuthorized {
                throw MarvelError.notAuthorized
            }
        } else {
            throw MarvelError.invalidURL
        }
    }
    
    func thumbnailImage(from thumbnail: Thumbnail) async throws -> UIImage? {
        let urlString = "\(thumbnail.path)\(ImageVariant.standardFantastic.rawValue).\(thumbnail.fileExtension)"
        if let url = URL(string: urlString) {
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                "Thumbnail Image returned from cache".log()
                return imageFromCache
            }

            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                var statusCode:Int = 0
                if let urlResponse = response as? HTTPURLResponse {
                    statusCode = urlResponse.statusCode
                }
                switch statusCode {
                case 200:
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url as AnyObject)
                    }
                    return UIImage(data: data)
                default:
                    throw MarvelError.unhandledStatus(status: statusCode)
                }
            } catch (let error) {
                throw MarvelError.unhandledError(error: error.localizedDescription)
            }
        } else {
            throw MarvelError.invalidURL
        }
    }
}

extension MarvelService {
    
    fileprivate func queryString(offset:Int = 0,limit:Int = 21) -> String {
        var queryString = "?ts=1"
        queryString.append("&apikey=\(self.apiKey)")
        queryString.append("&hash=\(self.appHash)")
        queryString.append("&offset=\(offset)")
        queryString.append("&limit=\(limit)")
        //queryString.append("&orderBy=-modified")
        return queryString
    }
    
    fileprivate func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
