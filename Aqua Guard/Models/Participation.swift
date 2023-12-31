//
//  Participation.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 27/11/2023.
//

import Foundation
struct Participation: Decodable {
    let _id: String
    let DateEvent: Date
    let Eventname: String

    private enum CodingKeys: String, CodingKey {
        case _id
        case DateEvent = "DateEvent"
        case Eventname = "Eventname"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)

        // Use ISO8601DateFormatter for decoding dates
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Set the desired time zone
        DateEvent = try isoFormatter.date(from: container.decode(String.self, forKey: .DateEvent)) ?? Date()


        Eventname = try container.decode(String.self, forKey: .Eventname)
    }
}

