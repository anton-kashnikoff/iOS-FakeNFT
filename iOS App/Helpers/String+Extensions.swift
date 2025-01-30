//
//  String+Extensions.swift
//  FakeNFT
//
//  Created by Andy Kruch on 14.10.23.
//

import Foundation

extension String {
    var encodeURL: String {
        if let encodedString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            encodedString
        } else {
            "encode error!"
        }
    }
    
    var decodeURL: String {
        if let decodedString = removingPercentEncoding {
            decodedString
        } else {
            "decode error!"
        }
    }
}
