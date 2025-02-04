import SwiftUI
import SpriteKit

struct FiresGameView: View {
    
    @Environment(\.presentationMode) var presMode
    var level: Int
    
    @State var gameFiresScene: GameFiresScene!
    
    @State var gameStatus = ""
    
    @State var fuelback = 0
    @State var coins = 0
    
    @State var errorRestart = false
    
    var body: some View {
        ZStack {
            if let gameFiresScene = gameFiresScene {
                SpriteView(scene: gameFiresScene)
                    .ignoresSafeArea()
            }
            
            if gameStatus == "tutorial" {
                tutorialView
            } else if gameStatus == "game_win" {
                gameWin
            } else if gameStatus == "game_lose" {
                gameOver
            }
        }
        .onAppear {
            gameFiresScene = GameFiresScene(level: level)
            if !UserDefaults.standard.bool(forKey: "tutorial_showed") {
                gameFiresScene.isPaused = true
                gameStatus = "tutorial"
            }
            
            fuelback = UserDefaults.standard.integer(forKey: "fuelback")
            coins = UserDefaults.standard.integer(forKey: "coins")
        }
        .onChange(of: fuelback) { new in
            UserDefaults.standard.set(new, forKey: "fuelback")
        }
        .onChange(of: coins) { new in
            UserDefaults.standard.set(new, forKey: "coins")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("plane_fire_rested"))) { _ in
            coins += 100
            withAnimation {
                gameStatus = "game_win"
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("exit_game"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_over_plane_die"))) { _ in
            withAnimation {
                gameStatus = "game_lose"
            }
        }
    }
    
    @State var tutorialGuideIndex = 0
    
    private var tutorialView: some View {
        VStack {
            Button {
                if tutorialGuideIndex < 4 {
                    withAnimation {
                        tutorialGuideIndex += 1
                    }
                } else {
                    gameStatus = ""
                    UserDefaults.standard.set(true, forKey: "tutorial_showed")
                    gameFiresScene.isPaused = false
                }
            } label: {
                Image("guide_item_\(tutorialGuideIndex + 1)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var gameWin: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("exit_game")
                    }
                    Spacer()
                    Image("you_win")
                        .resizable()
                        .frame(width: 250, height: 100)
                    Spacer()
                    VStack(spacing: 4) {
                        ZStack {
                            Image("fuel_back")
                            Text("\(fuelback)/20")
                                .font(.custom("HoltwoodOneSc-Regular", size: 11))
                                .foregroundColor(.red)
                                .shadow(color: .white, radius: 1, x: -2, y: 0)
                                .shadow(color: .white, radius: 1, x: 2, y: 0)
                                .shadow(color: .white, radius: 1, x: 0, y: -1)
                                .shadow(color: .white, radius: 1, x: 0, y: 1)
                                .offset(x: -20)
                        }
                        ZStack {
                            Image("coins_back")
                            Text("\(coins)")
                                .font(.custom("HoltwoodOneSc-Regular", size: 11))
                                .foregroundColor(.yellow)
                                .shadow(color: .white, radius: 1, x: -2, y: 0)
                                .shadow(color: .white, radius: 1, x: 2, y: 0)
                                .shadow(color: .white, radius: 1, x: 0, y: -1)
                                .shadow(color: .white, radius: 1, x: 0, y: 1)
                                .offset(x: -20)
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                Spacer()
            }
            
            VStack {
                Text("Level successfully passed")
                    .font(.custom("HoltwoodOneSC-Regular", size: 20))
                    .foregroundColor(.white)
                
                Button {
                    gameFiresScene = gameFiresScene.gameRestartWith(level: level)
                    withAnimation {
                        gameStatus = ""
                    }
                } label: {
                    Image("restart_btn")
                }
            }
        }
        .background(
            Image("main_view_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height + 30)
                .ignoresSafeArea()
        )
    }
    
    private var gameOver: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("exit_game")
                    }
                    Spacer()
                    Image("game_over_title")
                        .resizable()
                        .frame(width: 250, height: 100)
                    Spacer()
                    VStack(spacing: 4) {
                        ZStack {
                            Image("fuel_back")
                            Text("\(fuelback)/20")
                                .font(.custom("HoltwoodOneSc-Regular", size: 11))
                                .foregroundColor(.red)
                                .shadow(color: .white, radius: 1, x: -2, y: 0)
                                .shadow(color: .white, radius: 1, x: 2, y: 0)
                                .shadow(color: .white, radius: 1, x: 0, y: -1)
                                .shadow(color: .white, radius: 1, x: 0, y: 1)
                                .offset(x: -20)
                        }
                        ZStack {
                            Image("coins_back")
                            Text("\(coins)")
                                .font(.custom("HoltwoodOneSc-Regular", size: 11))
                                .foregroundColor(.yellow)
                                .shadow(color: .white, radius: 1, x: -2, y: 0)
                                .shadow(color: .white, radius: 1, x: 2, y: 0)
                                .shadow(color: .white, radius: 1, x: 0, y: -1)
                                .shadow(color: .white, radius: 1, x: 0, y: 1)
                                .offset(x: -20)
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                Spacer()
            }
            
            VStack {
                Text("You didn't put out the fire")
                    .font(.custom("HoltwoodOneSC-Regular", size: 20))
                    .foregroundColor(.white)
                
                Button {
                    if fuelback >= 3 {
                        fuelback -= 3
                        gameFiresScene = gameFiresScene.gameRestartWith(level: level)
                        withAnimation {
                            gameStatus = ""
                        }
                    } else {
                        errorRestart = true
                    }
                } label: {
                    Image("restart_btn_2")
                }
            }
        }
        .background(
            Image("main_view_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height + 30)
                .ignoresSafeArea()
        )
        .alert(isPresented: $errorRestart) {
            Alert(title: Text("Error!"), message: Text("You do not have enough fuel for new flights! Wait for the fuel to be replenished!"))
        }
    }
    
}

#Preview {
    FiresGameView(level: 1)
}
