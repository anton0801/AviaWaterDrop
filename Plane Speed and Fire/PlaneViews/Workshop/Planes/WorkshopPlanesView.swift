import SwiftUI

let planes = [
    WorkshopItem(id: "plane_base", name: "Base Red Plane", image: "workshop_plane_base", price: 0),
    WorkshopItem(id: "plane_1", name: "Yellow Plane", image: "workshop_plane_1", price: 500),
    WorkshopItem(id: "plane_2", name: "Yellow Plane", image: "workshop_plane_2", price: 500),
    WorkshopItem(id: "plane_3", name: "Yellow Plane", image: "workshop_plane_3", price: 500),
    WorkshopItem(id: "plane_4", name: "Yellow Plane", image: "workshop_plane_4", price: 500),
    WorkshopItem(id: "plane_5", name: "Yellow Plane", image: "workshop_plane_5", price: 500)
]

struct WorkshopPlanesView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var fuelback = 0
    @State var coins = 0
    
    @State var purchasedItems: Set<String> = [] {
        didSet {
            UserDefaults.standard.set(Array(purchasedItems), forKey: "purchasedPlanes")
        }
    }
    
    @State var errorBuyAlert = false
    @State var selectedPlane = ""
    
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(planes, id: \.id) { plane in
                            ZStack {
                                
                                Image(plane.image)
                                
                                if !isItemPurchased(plane.id) {
                                    Image("price")
                                        .offset(y: -90)
                                }
                                
                                if !isItemPurchased(plane.id) {
                                    Button {
                                        withAnimation {
                                            purchaseItem(plane.id, cost: plane.price)
                                        }
                                    } label: {
                                        Image("buy_btn")
                                    }
                                    .offset(y: 90)
                                } else {
                                    if selectedPlane == plane.id {
                                        Image("selected")
                                            .offset(y: 90)
                                    } else {
                                        Button {
                                            withAnimation {
                                                selectedPlane = plane.id
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
            selectedPlane = UserDefaults.standard.string(forKey: "selected_plane") ?? "plane_base"
            
            purchasedItems = Set(UserDefaults.standard.stringArray(forKey: "purchasedPlanes") ?? [])
            if purchasedItems.isEmpty {
                purchaseItem(planes[0].id, cost: 0)
            }
        }
        .onChange(of: selectedPlane) { newPlane in
            UserDefaults.standard.set(newPlane, forKey: "selected_plane")
        }
        .alert(isPresented: $errorBuyAlert) {
            Alert(title: Text("Plane not purchased"), message: Text("You don't have enought coins to buy this background :("))
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
    WorkshopPlanesView()
}
