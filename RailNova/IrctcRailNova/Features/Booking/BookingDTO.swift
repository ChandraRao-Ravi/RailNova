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

/*
{
    "id": "c560426e-c982-4af8-ab5b-6fd55a7f0696",
    "user_id": "nAsx1KFA8eSZTziM1jnmwhBANZ03",
    "train_number": "12951",
    "from_station": "NDLS",
    "to_station": "BCT",
    "journey_date": "2024-05-24T00:00:00.000Z",
    "total_fare": "3155",
    "status": "CONFIRMED",
    "created_at": "2026-05-29T15:46:47.787Z"
}
*/
struct BookingResponseDTO: Decodable {
    let id: String?
    let userId: String?
    let train_number: String?
    let from_station: String?
    let to_station: String?
    let journeyDate: String?
    let total_fare: String?
    let status: String?
    let pnr: String?
    let created_at: String?
}
