//
//  ApiObject.swift
//  NasaDaily
//
//  Created by Andreas Hartanto on 2023-02-06.
//

import Foundation

struct NasaPhoto: Codable {
    let photos: [MarsPhoto]
}

struct MarsPhoto: Codable {
    let id: Int
    let sol: Int
    let camera: CameraData
    let img_src: String
    let earth_date: String
    let rover: RoverData
}

struct CameraData: Codable {
    let id: Int
    let name: String
    let rover_id: Int
    let full_name: String
}

struct RoverData: Codable {
    let id: Int
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
}

