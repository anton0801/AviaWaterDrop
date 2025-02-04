import SwiftUI

struct TropheyItem: Identifiable {
    let id: String
    let tropheyImage: String
}

let tropheys = [
    TropheyItem(id: "trophey_1", tropheyImage: "trophey_1"),
    TropheyItem(id: "trophey_2", tropheyImage: "trophey_2"),
    TropheyItem(id: "trophey_3", tropheyImage: "trophey_3"),
    TropheyItem(id: "trophey_4", tropheyImage: "trophey_4"),
    TropheyItem(id: "trophey_5", tropheyImage: "trophey_5"),
    TropheyItem(id: "trophey_6", tropheyImage: "trophey_6"),
    TropheyItem(id: "trophey_7", tropheyImage: "trophey_7"),
    TropheyItem(id: "trophey_8", tropheyImage: "trophey_8"),
    TropheyItem(id: "trophey_9", tropheyImage: "trophey_9")
]

struct TropheysGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var fuelback = 0
    @State var coins = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back_btn")
                    }
                    Spacer()
                    Image("tropheys_title")
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
                Spacer().frame(height: 120)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.fixed(170)),
                        GridItem(.fixed(170)),
                        GridItem(.fixed(170))
                    ]) {
                        ForEach(tropheys, id: \.id) { trophey in
                            Image(trophey.tropheyImage)
                                .opacity(UserDefaults.standard.bool(forKey: "\(trophey.id)_gained") ? 1 : 0.6)
                        }
                    }
                    .padding(.vertical)
                    .background(
                        Image("tropheys_bg")
                            .resizable()
                            .frame(width: 560)
                    )
                }
            }
        }
        .background(
            Image("app_general_back")
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
}

#Preview {
    TropheysGameView()
}
