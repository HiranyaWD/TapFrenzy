import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 8) {
                    Text("Tap Games")
                        .font(.largeTitle.bold())
                    Text("Pick a mode")
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink {
                        TapFrenzyView()
                    } label: {
                        ModeButton(title: "Tap Frenzy",
                                   subtitle: "10 seconds. Tap like crazy.",
                                   color: .blue)
                    }

                    NavigationLink {
                        LightItUpView()
                    } label: {
                        ModeButton(title: "Light It Up",
                                   subtitle: "Tap the glowing card in time.",
                                   color: .orange)
                    }
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
        }
    }
}

struct ModeButton: View {
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title2.bold())
            Text(subtitle)
                .font(.subheadline)
                .opacity(0.9)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(RoundedRectangle(cornerRadius: 20).fill(color))
    }
}

#Preview {
    HomeView()
}
