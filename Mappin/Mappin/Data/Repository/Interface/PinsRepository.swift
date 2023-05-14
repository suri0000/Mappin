//
//  PinsRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinsRepository {
    func create(
        music: Music,
        location: Location,
        weather: Weather
    ) async throws -> Pin
    
    func readList(
        category: PinsCategory?,
        centerLatitude: Double,
        centerLongitude: Double,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
    
    func readDetail(id: Int) async throws -> Pin
    func delete(id: Int) async throws
    func readLatest(category: PinsCategory?) async throws -> Pin
}
