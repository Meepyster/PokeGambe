//
//  TradeService.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/3/25.
//

import Foundation

class TradeService {
    static let baseURL = "https://6be15b0e9aed.ngrok-free.app"
    
    // MARK: - Codable request bodies
    struct CreateTradeRequest: Codable {
        let userA: String
        let cardA: Card
    }
    
    struct JoinTradeRequest: Codable {
        let userB: String
    }
    
    struct OfferRequest: Codable {
        let userB: String
        let cardB: Card
    }
    
    struct ConfirmRequest: Codable {
        let userId: String
    }
    
    // MARK: - User A creates trade
    static func createTrade(userA: String, cardA: Card) async throws -> Trade {
        let url = URL(string: "\(baseURL)/trades")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = CreateTradeRequest(userA: userA, cardA: cardA)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Trade.self, from: data)
    }
    
    // MARK: - User B joins trade
    static func joinTrade(tradeId: String, userB: String) async throws -> Trade {
        let url = URL(string: "\(baseURL)/trades/\(tradeId)/join")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = JoinTradeRequest(userB: userB)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Trade.self, from: data)
    }
    
    // MARK: - User B offers a card
    static func offerCard(tradeId: String, userB: String, cardB: Card) async throws -> Trade {
        let url = URL(string: "\(baseURL)/trades/\(tradeId)/offer")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = OfferRequest(userB: userB, cardB: cardB)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Trade.self, from: data)
    }
    
    // MARK: Confirm trade
    static func confirmTrade(tradeId: String, userId: String) async throws -> Trade {
        let url = URL(string: "\(baseURL)/trades/\(tradeId)/confirm")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ConfirmRequest(userId: userId)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Trade.self, from: data)
    }
    
    // MARK: Fetch trade state (polling backbone)
    static func fetchTrade(tradeId: String) async throws -> Trade {
        let url = URL(string: "\(baseURL)/trades/\(tradeId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Trade.self, from: data)
    }
    
//    // MARK: Start polling
//    static func startPolling(tradeId: String, isTrading:Bool, interval: TimeInterval = 5.0, update: @escaping (Trade) -> Void) {
//        Task {
//            while isTrading {
//                do {
//                    let trade = try await fetchTrade(tradeId: tradeId)
//                    update(trade)
//                } catch {
//                    print("Polling error: \(error)")
//                }
//                try? await Task.sleep(nanoseconds: UInt64(interval * 500_000_000))
//            }
//        }
//    }
    static func startPolling(
        tradeId: String,
        interval: TimeInterval = 5.0,
        update: @escaping (Trade) -> Void
    ) -> Task<Void, Never> {
        let task = Task {
            while !Task.isCancelled {
                do {
                    let trade = try await fetchTrade(tradeId: tradeId)
                    update(trade)
                } catch {
                    print("Polling error: \(error)")
                }
                try? await Task.sleep(nanoseconds: UInt64(interval * 300_000_000))
            }
        }
        return task
    }
}
