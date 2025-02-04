import SwiftUI

let backgrounds = [
    WorkshopItem(id: "background_new_your", name: "New York", image: "workshop_new_york", price: 500),
    WorkshopItem(id: "background_los_angeles", name: "Los Angeles", image: "workshop_los_angeles", price: 500),
    WorkshopItem(id: "background_texas", name: "Texas", image: "workshop_texas", price: 500)
]

struct WorkshopBacksView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var fuelback = 0
    @State var coins = 0
    
    @State var purchasedItems: Set<String> = [] {
        didSet {
            UserDefaults.standard.set(Array(purchasedItems), forKey: "purchasedItems")
        }
    }
    
    @State var errorBuyAlert = false
    @State var selectedBackground = ""
    
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
                HStack {
                    ForEach(backgrounds, id: \.id) { background in
                        ZStack {
                            
                            Image(background.image)
                            
                            if !isItemPurchased(background.id) {
                                Image("price")
                                    .offset(y: -90)
                            }
                            
                            if !isItemPurchased(background.id) {
                                Button {
                                    withAnimation {
                                        purchaseItem(background.id, cost: background.price)
                                    }
                                } label: {
                                    Image("buy_btn")
                                }
                                .offset(y: 90)
                            } else {
                                if selectedBackground == background.id {
                                    Image("selected")
                                        .offset(y: 90)
                                } else {
                                    Button {
                                        withAnimation {
                                            selectedBackground = background.id
                                        }
                                    } label: {
                                        Image("select")
                                    }
                                }
                            }
                        }
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
            selectedBackground = UserDefaults.standard.string(forKey: "selected_background") ?? "background_new_your"
            
            purchasedItems = Set(UserDefaults.standard.stringArray(forKey: "purchasedItems") ?? [])
            
            if purchasedItems.isEmpty {
                purchaseItem(backgrounds[0].id, cost: 0)
            }
        }
        .onChange(of: selectedBackground) { newBackground in
            UserDefaults.standard.set(newBackground, forKey: "selected_background")
        }
        .alert(isPresented: $errorBuyAlert) {
            Alert(title: Text("Background not purchased"), message: Text("You don't have enought coins to buy this background :("))
        }
    }
    
    func isItemPurchased(_ itemID: String) -> Bool {
        return purchasedItems.contains(itemID)
    }
    
    func purchaseItem(_ itemID: String, cost: Int) {
        guard coins >= cost, !isItemPurchased(itemID) else {
            self.errorBuyAlert = true
            return
        }
        
        coins -= cost
        purchasedItems.insert(itemID)
    }
    
}

#Preview {
    WorkshopBacksView()
}
