//
//  TransitRepositoryError.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import Foundation

enum TransitRepositoryError: Error {
    case resourceNotFound(String)
    case decodingFailed(String, Error)
}
