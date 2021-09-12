//
//  Constants.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

struct Constants {
    
    struct System {
        enum Storyboard {
            static let main = "Main"
            static let detail = "Detail"
        }
        enum Controller {
            static let curiosityViewController = "CuriosityViewController"
            static let opportunityViewController = "OpportunityViewController"
            static let spiritViewController = "SpiritViewController"
        }
    }
    
    struct Network {
        static let baseUrlRovers = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
        static let spirit = "spirit/"
        static let apiKey1 = "biqg3VBwvmwDxkwey8vrai2QcjcW9841KigdJ1Za"
        static let apiKey2 = "cyeeGRcj4ubgT6NRKCKZUY9CxGMA0YmWVx2O7tNv"
        static let apiKey3 = "EZssScTJFcvQSQw0M9sDiBv393JFqp8fb7eeRAJo"
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
            enum Label {
                static let cameras = "Cameras"
                static let filter = "Filter"
            }
        }
        struct Image {
            enum Icon {
                static let firstTab = "tab1"
                static let secondTab = "tab2"
                static let thirdTab = "tab3"
            }
        }
    }
}
