import SwiftUI

struct WorkshopItem: Identifiable {
    let id: String
    let name: String
    let image: String
    let price: Int
}

struct WorkshopView: View {
    
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
                        Image("workshop_title")
                            .resizable()
                            .frame(width: 300, height: 100)
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
                    Spacer().frame(height: 100)
                    HStack(spacing: 42) {
                        NavigationLink(destination: WorkshopBacksView()
                            .navigationBarBackButtonHidden()) {
                                Image("workshop_backgrounds")
                            }
                        NavigationLink(destination: WorkshopPlanesView()
                            .navigationBarBackButtonHidden()) {
                                Image("workshop_planes")
                            }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    WorkshopView()
}
