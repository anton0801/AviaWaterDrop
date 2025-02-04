import SwiftUI
import StoreKit

struct HomeBunkerView: View {
    
    @Environment(\.requestReview) var requestReview
    
    @State var fuelback = 0
    @State var coins = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            exit(0)
                        } label: {
                            Image("exit_game")
                        }
                        Spacer()
                        Image("menu_title")
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
                    Spacer()
                }
                
                
                VStack {
                    Spacer().frame(height: 100)
                    HStack {
                        NavigationLink(destination: TropheysGameView()
                            .navigationBarBackButtonHidden()) {
                            Image("trophies")
                        }
                        NavigationLink(destination: LevelsGameView()
                            .navigationBarBackButtonHidden()) {
                            Image("play_btn")
                        }
                        NavigationLink(destination: WorkshopView()
                            .navigationBarBackButtonHidden()) {
                            Image("workshop")
                        }
                    }
                    HStack {
                        Button {
                            requestReview()
                        } label: {
                            Image("rate_us")
                        }
                        NavigationLink(destination: EmptyView()
                            .navigationBarBackButtonHidden()) {
                            Image("privacy_policy")
                        }
                        NavigationLink(destination: SettingsAppView()
                            .navigationBarBackButtonHidden()) {
                            Image("settings")
                        }
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
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "first_set_up") {
                    UserDefaults.standard.set(20, forKey: "fuelback")
                    UserDefaults.standard.set(true, forKey: "first_set_up")
                }
                
                fuelback = UserDefaults.standard.integer(forKey: "fuelback")
                coins = UserDefaults.standard.integer(forKey: "coins")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeBunkerView()
}
