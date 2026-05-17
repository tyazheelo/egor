//
//  ContentView.swift
//  RGBullsEye
//
//  Author: [Твоё Имя Фамилия]
//  Group: [Твоя Группа]
//
//  MARK: - RGBullsEye Game
//  Goal: Match the target color using RGB sliders
//  Concepts: @State, @Binding, VStack, HStack, Slider, Alert
//
//  TODO: Add high score tracking
//  FIXME: Fix slider thumb positioning on older devices
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    // MARK: - State Properties
    @State private var targetRed = Double.random(in: 0...1)
    @State private var targetGreen = Double.random(in: 0...1)
    @State private var targetBlue = Double.random(in: 0...1)
    
    @State private var guessRed = 0.5
    @State private var guessGreen = 0.5
    @State private var guessBlue = 0.5
    
    @State private var showingScore = false
    @State private var scoreMessage = ""
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var roundCount = 0
    
    // MARK: - Computed Properties
    private var targetColor: Color {
        Color(red: targetRed, green: targetGreen, blue: targetBlue)
    }
    
    private var guessColor: Color {
        Color(red: guessRed, green: guessGreen, blue: guessBlue)
    }
    
    private var score: Int {
        let redDiff = targetRed - guessRed
        let greenDiff = targetGreen - guessGreen
        let blueDiff = targetBlue - guessBlue
        let diff = sqrt(redDiff * redDiff + greenDiff * greenDiff + blueDiff * blueDiff)
        // Max score 100, min 0
        return Int((1.0 - diff) * 100.0)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // MARK: - Color Blocks
                HStack(spacing: 20) {
                    // Target color block
                    VStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(targetColor)
                            .frame(width: 150, height: 150)
                            .shadow(radius: 5)
                        Text("Match this color")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Guess color block
                    VStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(guessColor)
                            .frame(width: 150, height: 150)
                            .shadow(radius: 5)
                        
                        Text(String(format: "R: %.0f  G: %.0f  B: %.0f",
                              guessRed * 255, guessGreen * 255, guessBlue * 255))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                Divider()
                
                // MARK: - RGB Sliders
                VStack(spacing: 15) {
                    ColorSliderView(
                        value: $guessRed,
                        color: .red,
                        label: "Red"
                    )
                    
                    ColorSliderView(
                        value: $guessGreen,
                        color: .green,
                        label: "Green"
                    )
                    
                    ColorSliderView(
                        value: $guessBlue,
                        color: .blue,
                        label: "Blue"
                    )
                }
                .padding(.horizontal)
                
                Divider()
                
                // MARK: - Score and Buttons
                HStack {
                    Text("Round: \(roundCount)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("Score: \(currentScore)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                }
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    Button(action: checkScore) {
                        Text("Hit Me!")
                            .frame(minWidth: 100)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button(action: newRound) {
                        Text("New Round")
                            .frame(minWidth: 100)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
            .padding()
            .navigationTitle("RGBullsEye")
            .alert(isPresented: $showingScore) {
                Alert(
                    title: Text(scoreTitle),
                    message: Text(scoreMessage),
                    dismissButton: .default(Text("Continue")) {
                        newRound()
                    }
                )
            }
        }
    }
    
    // MARK: - Private Methods
    private func checkScore() {
        let currentRoundScore = score
        currentScore += currentRoundScore
        roundCount += 1
        
        scoreTitle = currentRoundScore >= 80 ? "Excellent!" : "Good try!"
        scoreMessage = "Your score this round: \(currentRoundScore)\nTotal score: \(currentScore)"
        showingScore = true
    }
    
    private func newRound() {
        targetRed = Double.random(in: 0...1)
        targetGreen = Double.random(in: 0...1)
        targetBlue = Double.random(in: 0...1)
        
        // Reset sliders to mid position
        guessRed = 0.5
        guessGreen = 0.5
        guessBlue = 0.5
    }
}

// MARK: - Reusable Color Slider Component
struct ColorSliderView: View {
    @Binding var value: Double
    let color: Color
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 50, alignment: .leading)
                .foregroundColor(color)
                .bold()
            
            Slider(value: $value, in: 0...1, step: 0.01)
                .accentColor(color)
            
            Text(String(format: "%.0f", value * 255))
                .frame(width: 40, alignment: .trailing)
                .foregroundColor(color)
        }
    }
}

// MARK: - Preview (совместимая версия для Xcode 13 и старше)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
