//
//  RoverModel.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//
import Foundation

struct RoverModel: Codable {
    var photos: [RoverPhotos]
}

struct RoverPhotos: Codable {
    var camera: Camera
    var imageSrc: String
    var earthDate: String
    var rover: Rover
    
    enum CodingKeys: String, CodingKey {
        case camera
        case imageSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct Camera: Codable {
    var id: Int
    var name: String
    var roverId: Int
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
}

struct Rover: Codable {
    var name: String
    var landingDate: String
    var launchDate: String
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
}
