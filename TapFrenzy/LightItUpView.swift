import SwiftUI

struct LightItUpView: View {
    @State private var cards: [Card] = (0..<3).map{_ in Card()}
    
    var body: some View {
        VStack ( spacing:16){
            Text("Light It up")
                .font(.title.bold())
            
            Text("Cards: \(cards.count)")
                .foregroundStyle(.secondary)
            
            ForEach(cards) { card in
                Text("Card \(card.id.uuidString.prefix(4)) . lit: \(card.isLit ? "YES" : "no" )")
            }
        }
        .padding()
    }
}

#Preview {
    LightItUpView()
}
