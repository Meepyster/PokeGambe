//
//  GameStateModel.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/4/25.
//
import SwiftUI
import SwiftData

@Observable
class GameStateModel: ObservableObject {
    var pulledCards: [Card] = []
    var isOpeningPack: Bool = false

    // Tasks & polling
    var pollingTask: Task<Void, Never>? = nil
    var isPolling: Bool = false

    // Trading state
    var isTradingA: Bool = false
    var isTradingB: Bool = false
    var tradeStatus: Trade?

    // SwiftData context (inject from a View or App on startup)
    var modelContext: ModelContext?

    // Data collections
    var cards: [Card] = []

    // Networking / responses
    var cardResponse: CardResponse?

    // UI text/state
    var currentQuote: String = ""
    var profit: Double = 0

    // Persisted values
    // Manual persistence using UserDefaults (no @AppStorage in model types)
    var IGN: String {
        didSet { UserDefaults.standard.set(IGN, forKey: "IGN") }
    }
    var balance: Double {
        didSet { UserDefaults.standard.set(balance, forKey: "balance") }
    }
    var dexValue: Double {
        didSet { UserDefaults.standard.set(dexValue, forKey: "dexValue") }
    }
    var lastUpdated: Double {
        didSet { UserDefaults.standard.set(lastUpdated, forKey: "lastUpdated") }
    }

    // UI flags
    var showGains: Bool = false
    var gains: Double = 0
    var showDex: Bool = false
    var showHistDex: Bool = false
    var showConfirm: Bool = false
    var showLargeImage: Bool = false
    var cardToShow: DBCard?
    var histCardToShow: HistCard?
    var showOptionsMenu: Bool = false
    var showLargeHistImage: Bool = false
    var cardViewShow: Bool = false
    var showTotalView: Bool = false
    var refreshedView: Bool = false
    var showAddFunds: Bool = false
    var toAdd: String = "0.00"
    var buttonArmed: Bool = true

    // New Trade + Scan State
    var showTradeQR: Bool = false
    var tradeQRCodeURL: URL?
    var showScanner: Bool = false
    var scannedCode: String?
    var tradeToShow: Card?
    var showLargeTradeImage: Bool = false

//    @AppStorage("balance") public var balance: Double = 60
//    func getBalance() -> Double {
//        return balance
//    }
//    func changeBalance(_ amount: Double) {
//        balance += amount
//    }

    init() {
        // Initialize persisted values from UserDefaults without using self until all properties are set
        let defaults = UserDefaults.standard

        let ignValue: String = defaults.string(forKey: "IGN") ?? "TONKYWONKY"
        let balanceValue: Double = (defaults.object(forKey: "balance") as? Double) ?? 0.0
        let dexValueValue: Double = (defaults.object(forKey: "dexValue") as? Double) ?? 0.0
        let lastUpdatedValue: Double = (defaults.object(forKey: "lastUpdated") as? Double) ?? Date().timeIntervalSince1970

        // Assign to stored properties
        self.IGN = ignValue
        self.balance = balanceValue
        self.dexValue = dexValueValue
        self.lastUpdated = lastUpdatedValue

        // Seed defaults if they were missing (do not rely on didSet during init)
        if defaults.string(forKey: "IGN") == nil { defaults.set(ignValue, forKey: "IGN") }
        if defaults.object(forKey: "balance") == nil { defaults.set(balanceValue, forKey: "balance") }
        if defaults.object(forKey: "dexValue") == nil { defaults.set(dexValueValue, forKey: "dexValue") }
        if defaults.object(forKey: "lastUpdated") == nil { defaults.set(lastUpdatedValue, forKey: "lastUpdated") }
    }

    // MARK: - SwiftData Helpers

    /// Inject a ModelContext from the outside (e.g., in App/Scene or a root View)
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    /// Fetch and cache DBCard entities into `savedCards`.


    /// Fetch and cache HistCard entities into `savedHistCards`.

}

