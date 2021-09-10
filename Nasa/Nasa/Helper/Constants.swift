//
//  Constants.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

struct Constants {
    
    struct Network {
        static let baseUrlRovers = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
        static let spirit = "spirit/"
        static let apiKey = "biqg3VBwvmwDxkwey8vrai2QcjcW9841KigdJ1Za"
        static let apiKey2 = "cyeeGRcj4ubgT6NRKCKZUY9CxGMA0YmWVx2O7tNv"
    }
    
    struct Style {
        
        struct Text {
            
            enum Bar {
                static let curiosity = "Curiosity"
                static let opportunity = "Opportunity"
                static let spirit = "Spirit"
            }
            
            enum Error {
                static let ok = "OK"
                static let oops = "Oops"
                static let genericError = "Generic Error"
                static let decodingError = "Decoding Error"
                static let noResultsFound = "No results found"
                static let decoding = "Beklenmeyen bir hata oluştu."
                static let networkError = "Beklenmeyen bir hata oluştu."
                static let timeout = "İstek zaman aşımına uğradı, daha sonra tekrar deneyiniz."
            }
        }
    }
}
