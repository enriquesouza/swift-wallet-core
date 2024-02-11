//
//  ContentView.swift
//  wallet-core
//
//  Created by Enrique Souza Soares on 10/02/2024.
//

import SwiftUI
import WalletCore
import Foundation

struct ContentView: View {
    let wallet = HDWallet(mnemonic: "liquid brand gaze spare someone toe cause nuclear rug west wash mask", passphrase: "")!
    @StateObject private var viewModel = WalletViewModel()
    
    var body: some View {
        let address = wallet.getAddressForCoin(coin: .bitcoin)
        
        VStack {
            Text("BTC address: \(address)")
                .padding()
            
            Text(viewModel.unspentOutputs)
                .padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchUnspentOutputs(for: address)
            }
        }
    }
}

@MainActor // Ensures all updates are on the main thread
class WalletViewModel: ObservableObject {
    @Published var unspentOutputs: String = "Loading..."
    
    // Replace with your actual function to fetch unspent outputs
    func fetchUnspentOutputs(for address: String) async {
        guard let url = URL(string: "https://api.blockcypher.com/v1/btc/main/addrs/\(address)?unspentOnly=true") else {
            self.unspentOutputs = "Invalid URL"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode your data or process it as needed
            // This is a placeholder; you'd replace this with actual data processing
            self.unspentOutputs = String(decoding: data, as: UTF8.self)
        } catch {
            self.unspentOutputs = "Fetch failed: \(error.localizedDescription)"
        }
    }
}


#Preview {
    ContentView()
}
