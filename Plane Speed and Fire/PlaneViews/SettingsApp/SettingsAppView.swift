import SwiftUI

struct SettingsAppView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var volumeActive = false
    @State var musicActive = false
    @State var vibrationsActive = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("back_btn")
                }
                Spacer()
                Image("settings_title")
                Spacer()
                Image("back_btn")
                    .opacity(0)
            }
            ZStack {
                Image("settings_values_back")
                VStack(alignment: .leading) {
                    Text("VOLUME")
                        .font(.custom("HoltwoodOneSC-Regular", size: 16))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: -1)
                        .shadow(color: .black, radius: 1, x: 1)
                    Button {
                        withAnimation {
                            volumeActive = !volumeActive
                        }
                    } label: {
                        if volumeActive {
                            Image("volume_seek_full")
                        } else {
                            Image("volume_seek")
                        }
                    }
                    
                    HStack {
                        Text("MUSIC")
                            .font(.custom("HoltwoodOneSC-Regular", size: 16))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: -1)
                            .shadow(color: .black, radius: 1, x: 1)
                        
                        Spacer()
                    
                        Button {
                            withAnimation {
                                musicActive = !musicActive
                            }
                        } label: {
                            if musicActive {
                                Image("switch_on")
                            } else {
                                Image("switch_off")
                            }
                        }
                    }
                    
                    HStack {
                        Text("VIBRATION")
                            .font(.custom("HoltwoodOneSC-Regular", size: 16))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: -1)
                            .shadow(color: .black, radius: 1, x: 1)
                        
                        Spacer()
                    
                        Button {
                            withAnimation {
                                vibrationsActive = !vibrationsActive
                            }
                        } label: {
                            if vibrationsActive {
                                Image("switch_on")
                            } else {
                                Image("switch_off")
                            }
                        }
                    }
                }
                .frame(width: 350)
            }
        }
        .background(
            Image("app_general_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height + 30)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SettingsAppView()
}
