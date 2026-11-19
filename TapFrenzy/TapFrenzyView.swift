import SwiftUI
import UIKit
internal import Combine

// Step 5: game phases
enum GamePhase {
    case idle, playing, over
}

struct TapFrenzyView: View {
    // Step 3: score state
    @State private var score = 0
    // Step 4: countdown
    @State private var timeRemaining = 10
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // Step 5: phase
    @State private var phase: GamePhase = .idle
    // Step 6: persisted high score
    @AppStorage("highScore") private var highScore = 0

    // Challenge C1: Combo
    @State private var lastTapTime: Date? = nil
    @State private var combo = 1

    // Challenge C4: Shrinking button
    @State private var buttonSize: CGFloat = 200

    // Challenge C2: Trap colour
    @State private var isTrap = false

    var body: some View {
        VStack(spacing: 24) {
            switch phase {
            case .idle, .playing:
                playView
            case .over:
                gameOverView
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onReceive(timer) { _ in tick() }
    }

    // MARK: - Play screen
    private var playView: some View {
        VStack(spacing: 24) {
            Text("Tap Frenzy")
                .font(.title2.bold())

            Text("TIME: \(timeRemaining)s")
                .font(.title.bold())
                .foregroundColor(timerColor)   // Stretch: timer colour shift

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(score)")
                    .font(.system(size: 80, weight: .heavy))
                // Challenge C1: combo indicator
                if combo > 1 {
                    Text("x\(combo)!")
                        .font(.title.bold())
                        .foregroundColor(.orange)
                }
            }

            Spacer()

            Button(action: handleTap) {
                Text(phase == .idle ? "TAP\nto start" : "TAP")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Circle().fill(isTrap ? Color.red : Color.blue))
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Best: \(highScore)")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Game over screen
    private var gameOverView: some View {
        VStack(spacing: 16) {
            Text("Time's up")
                .font(.largeTitle.bold())
            Text("YOUR SCORE")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(score)")
                .font(.system(size: 80, weight: .heavy))
            Text("Best: \(highScore)")
                .font(.title3)
            Button("Play Again") {
                resetGame()
            }
            .font(.title3.bold())
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Capsule().fill(Color.blue))
            .foregroundColor(.white)
        }
    }

    // MARK: - Helpers
    private var timerColor: Color {
        if timeRemaining > 6 { return .green }
        if timeRemaining > 3 { return .orange }
        return .red
    }

    private func handleTap() {
        // First tap moves idle -> playing
        if phase == .idle { startGame() }
        guard phase == .playing else { return }

        // Stretch: haptic feedback
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        // Challenge C2: taps during the trap colour lose a point
        if isTrap {
            score = max(0, score - 1)
            combo = 1
            lastTapTime = nil
            return
        }

        // Challenge C1: combo if two taps are within 300ms
        let now = Date()
        if let last = lastTapTime, now.timeIntervalSince(last) < 0.3 {
            combo = min(combo + 1, 5)
        } else {
            combo = 1
        }
        lastTapTime = now
        score += combo

        // Challenge C4: shrink the button a little each tap
        withAnimation(.easeOut(duration: 0.1)) {
            buttonSize = max(100, buttonSize - 3)
        }
    }

    private func startGame() {
        score = 0
        timeRemaining = 10
        combo = 1
        lastTapTime = nil
        buttonSize = 200
        isTrap = false
        phase = .playing
        // fresh timer so the first full second starts on the first tap
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    private func resetGame() {
        score = 0
        timeRemaining = 10
        combo = 1
        lastTapTime = nil
        buttonSize = 200
        isTrap = false
        phase = .idle
    }

    private func tick() {
        guard phase == .playing else { return }
        if timeRemaining > 0 { timeRemaining -= 1 }
        if timeRemaining == 0 {
            endGame()
            return
        }
        // Challenge C2: random chance each second to flash red for 0.5s
        if Int.random(in: 0..<3) == 0 {
            isTrap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTrap = false
            }
        }
    }

    private func endGame() {
        isTrap = false
        if score > highScore { highScore = score }
        phase = .over
    }
}

#Preview {
    TapFrenzyView()
}
