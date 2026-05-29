//
//  BookingDTO.swift
//  IrctcRailNova
//
//  Created by Chandra Rao on 27/05/26.
//

import Foundation

struct BookingCreateRequest: Encodable {
    let userId: String
    let trainNumber: String
    let journeyDate: String
    let from: String
    let to: String
    let totalFare: Double
}

struct BookingResponseDTO: Decodable {
    let id: String
    let userId: String
    let trainNumber: String
    let journeyDate: String
    let from: String
    let to: String
    let pnr: String
    let totalFare: Double
    let status: String
}
