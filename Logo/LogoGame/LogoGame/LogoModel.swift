//
//  LogoModel.swift
//  LogoGame
//
//  Created by Shreyas S on 10/04/21.
//

import Foundation

struct LogoModel: Codable {
    let imageUrl: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "imgUrl"
        case name
    }
}

extension Decodable {
    static func parse(jsonFile: String) -> Self? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let output = try? JSONDecoder().decode(self, from: data)
        else {
            return nil
        }
        
        return output
    }
}
