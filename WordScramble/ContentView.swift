//
//  ContentView.swift
//  WordScramble
//
//  Created by Дима РМФ on 22.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var userScore = 0

    
    var body: some View {
     
        NavigationView {
            
            List {
                
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                Text("Score: \(userScore)")
                
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Reset", action: startGame)
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK" , role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            
        }
        
        
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 3 && answer != rootWord else { return }
        
        //Extra validation to come
        guard isOridinal(word: answer) else {
            userScore -= answer.count
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            userScore -= answer.count
            wordError(title: "Word not possible", message: "You cant spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) && answer.count > 3 else {
            userScore -= answer.count
            wordError(title: "Word not recognized", message: "You cant just make them up, you know!")
            return
        }
        
        if isOridinal(word: answer) || isPossible(word: answer) || isReal(word: answer) && answer.count > 3  {
            userScore += answer.count
        }
        
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    
    //---------------------//----------------------//
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load strat.txt from bundle.")
    }
    
    
    func isOridinal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let missSpelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return missSpelledRange.location == NSNotFound
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//    let people = ["finn", "Leia", "Luke", "Rei"]
//----------------------------------------//
//        List {
//            Text("Static row")
//
//            ForEach(people, id: \.self) {
//                Text($0)
//            }
//
//            Text("Static row")
////            Section("Section 1") {
////                Text("Static row 1")
////                Text("Static row 2")
////            }
////            Section("Section 2") {
////                ForEach(0..<5) {
////                    Text("Hello world \($0)")
////                }
////            }
////
////            Section("Section 3") {
////                Text("Static row 3")
////                Text("Static row 4")
////            }
//        }
//        .listStyle(.grouped)
//----------------------------------------//    }
//    func loadFile() {
//        if  let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
//            // here
//            if let fileContents = try? String(contentsOf: fileURL) {
//                //we loaded the file into the string
//
//            }
//        }
//    }
//---------------------------------------//
//      func test() {
//        let word = "swift"
//        let checker = UITextChecker()
//
//        let range = NSRange(location: 0, length: word.utf16.count)
//        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//
//        let allGood = misspelledRange.location == NSNotFound
//    }
