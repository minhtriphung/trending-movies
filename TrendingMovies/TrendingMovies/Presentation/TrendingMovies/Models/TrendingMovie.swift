//
//  TrendingMovie.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import SwiftyJSON
import RealmSwift

enum TrendingMovieTime {
    case day
    case week
}

class TrendingMovie: Object, JSONParsable {
    
    // MARK: Define Variables
    @objc dynamic var id: Int = 0
    @objc dynamic var adult: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var backdropUrl: String = ""
    @objc dynamic var voteAverage: Float = 0.0
    @objc dynamic var overview: String = ""
    @objc dynamic var tagline: String = ""
    @objc dynamic var originalLanguage: String = ""
    dynamic var genres: [Genres] = []
    dynamic var productionCountries: [ProductionCountry] = []
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    // MARK: Init
    override init() {
        id = 0
        adult = false
        title = ""
        releaseDate = ""
        imageUrl = ""
        backdropUrl = ""
        voteAverage = 0.0
        overview = ""
        tagline = ""
        originalLanguage = ""
        genres = []
        productionCountries = []
    }

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.adult = json["adult"].boolValue
        self.title = json["title"].stringValue
        self.imageUrl = String(format: "%@%@", TMDBImageUrl, json["poster_path"].stringValue)
        self.backdropUrl = String(format: "%@%@", TMDBImageUrl, json["backdrop_path"].stringValue)
        self.releaseDate = json["release_date"].stringValue
        self.voteAverage = json["vote_average"].floatValue
        self.overview = json["overview"].stringValue
        self.tagline = json["tagline"].stringValue
        self.originalLanguage = json["original_language"].stringValue
        self.genres = json["genres"].arrayValue.compactMap { Genres(json: $0) }
        self.productionCountries = json["production_countries"].arrayValue.compactMap { ProductionCountry(json: $0) }
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageWith(fileName: String) -> UIImage? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }

}
