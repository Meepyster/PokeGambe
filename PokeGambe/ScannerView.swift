//
//  ScannerView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/18/25.
//


import SwiftUI
import SwiftData
import CodeScanner

public struct ScannerView: View {
    @Environment(GameStateModel.self) private var model
    public var body: some View {
        BackgroundView()
            .opacity(0.70)
        CodeScannerView(
            codeTypes: [.qr],
            completion: handleScan
        )
        Button(action: {
            model.showScanner.toggle()
        }) {
            Text("Close")
                .font(.headline).bold(true)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color(red: 0.23, green: 0.29, blue: 0.36))
                .cornerRadius(25)
                .shadow(radius: 3)
                .bold(true)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 10)
        .padding(.bottom, 680)
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scanResult):
            model.scannedCode = scanResult.string
            model.showScanner = false
            print("Scanned code: \(scanResult.string)")

            Task {
                do {
                    print("THE THING IS HERE \(scanResult.string)")
                    let card = try await CardService.fetchTradedCard(scanResult.string)
                    model.tradeToShow = card
                    model.showLargeTradeImage = true
                    print("Fetched traded card: \(card.cardTitle)")
                } catch {
                    print("❌ Failed to fetch traded card: \(error)")
                }
            }

        case .failure(let error):
            print("❌ Scanning failed: \(error.localizedDescription)")
            model.showScanner = false
        }
    }
}

struct QRScannerView: View {
    @Environment(\.dismiss) var dismiss
    var onScan: (String) -> Void

    var body: some View {
        CodeScannerView(codeTypes: [.qr]) { result in
            switch result {
            case .success(let code):
                onScan(code.string)
                dismiss()
            case .failure(let error):
                print("Scanning failed: \(error)")
                dismiss()
            }
        }
    }
}

