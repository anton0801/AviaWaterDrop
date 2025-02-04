import SwiftUI

struct LevelsGameView: View {

    @Environment(\.presentationMode) var presMode
    
    @State var fuelback = 0
    @State var coins = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            presMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_btn")
                        }
                        Spacer()
                        Image("play_title")
                            .resizable()
                            .frame(width: 200, height: 100)
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
                    HStack {
                        NavigationLink(destination: LevelDetailsView(level: 1)
                            .navigationBarBackButtonHidden()) {
                                Image("level_1")
                            }
                            .offset(y: -50)
                        NavigationLink(destination: LevelDetailsView(level: 2)
                            .navigationBarBackButtonHidden()) {
                                Image("level_2")
                            }
                            .offset(y: 50)
                        NavigationLink(destination: LevelDetailsView(level: 3)
                            .navigationBarBackButtonHidden()) {
                                Image("level_3")
                            }
                            .offset(y: -50)
                        NavigationLink(destination: LevelDetailsView(level: 4)
                            .navigationBarBackButtonHidden()) {
                                Image("level_4")
                            }
                            .offset(y: 50)
                        NavigationLink(destination: LevelDetailsView(level: 5)
                            .navigationBarBackButtonHidden()) {
                                Image("level_5")
                            }
                            .offset(y: -50)
                        NavigationLink(destination: LevelDetailsView(level: 6)
                            .navigationBarBackButtonHidden()) {
                                Image("level_6")
                            }
                            .offset(y: 50)
                    }
                }
            }
            .background(
                Image("levels_bg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height + 30)
                    .ignoresSafeArea()
            )
            .onAppear {
                fuelback = UserDefaults.standard.integer(forKey: "fuelback")
                coins = UserDefaults.standard.integer(forKey: "coins")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LevelsGameView()
}
