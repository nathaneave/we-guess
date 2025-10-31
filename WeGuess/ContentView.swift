//
//  ContentView.swift
//  WeGuess
//
//  Created by Nathan Eave on 5/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScoreCorrect = false
    @State private var showingScoreWrong = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var userTap = 0
    @State private var numRounds = 0
    @State private var gameOver = false
    @State private var tappedFlag: Int? = nil
    @State private var tappedFlagRotationAmount = 0.0
    
    struct FlagImage: View {
        var image: String
        
        var body: some View {
            Image(image)
                .clipShape(.capsule)
                .shadow(radius: 5)

        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            tappedFlag = number
                            withAnimation {
                                flagTapped(number)
                                userTap = number
                                
                            }
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        .rotation3DEffect(.degrees(number == tappedFlag ? tappedFlagRotationAmount : 0.0), axis:(x: 0, y:1, z:0))
                    }
 
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding()
            
            .alert(scoreTitle, isPresented: $showingScoreCorrect) {
                Button("Countinue", action: askQuestion)
            } message: {
                Text("Your score is \(score).")
            }
            
            .alert(scoreTitle, isPresented: $showingScoreWrong) {
                Button("Countinue", action: askQuestion)
            } message: {
                Text("You tapped on the flag of \(countries[userTap]).")
            }
            
            .alert("Game Over", isPresented: $gameOver) {
                Button("Play Again", action: reset)
            } message: {
                Text("Great work! Your score was \(score)/8.")
            }


        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            showingScoreCorrect = true
            tappedFlagRotationAmount += 360
        } else {
            scoreTitle = "Wrong"
            showingScoreWrong = true
        }
        numRounds += 1
        if numRounds == 8 {
            gameOver = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        numRounds = 0
        score = 0
    }
}
    

#Preview {
    ContentView()
}
