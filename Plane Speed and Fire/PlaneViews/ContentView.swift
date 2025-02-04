import SwiftUI

struct ContentView: View {
    
    @State var loadingPercentage: Double = 0.0
    @State var planeGameLoaded = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color.init(red: 0, green: 130/255, blue: 159/255),
                                Color.init(red: 0, green: 47/255, blue: 57/255)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 400, height: 30)
                        .opacity(0.8)
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(
                            RadialGradient(colors: [
                                Color.init(red: 192/255, green: 39/255, blue: 39/255)
                            ], center: .center, startRadius: 0, endRadius: 360)
                        )
                        .frame(width: 390 * loadingPercentage, height: 28)
                        .padding(.leading, 5)
//                    
//                    HStack {
//                        Spacer()
//                        Text("\(String(format: "%.0f", (loadingPercentage * 100)))%")
//                            .font(.custom("HoltwoodOneSC-Regular", size: 18))
//                            .foregroundColor(.white)
//                            .shadow(color: .black, radius: 1, x: -1, y: 0)
//                            .shadow(color: .black, radius: 1, x: 1, y: 0)
//                        Spacer()
//                    }
                }
                .frame(width: 40)
                
                NavigationLink(destination: HomeBunkerView()
                    .navigationBarBackButtonHidden(), isActive: $planeGameLoaded) {
                        
                    }
            }
            .background(
                Image("load_image_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height + 30)
                    .ignoresSafeArea()
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 5.5)) {
                    loadingPercentage = 1.0
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.8) {
                    planeGameLoaded = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
