import SwiftUI

struct ContentView: View {
    @AppStorage("username") var username: String = ""
    @State private var selectedMode: ChatMode? = nil
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        NavigationStack {
            
            if username.isEmpty {
                userNameEntryView
            } else {
                mainView
                    .onChange(of: networkMonitor.isConnected) { connected in
                        if selectedMode == .online && !connected {
                            selectedMode = .offline
                        } else if selectedMode == .offline && connected{
                            selectedMode = .online
                        }
                    }
            }
        }
    }
    
    private var userNameEntryView: some View {
        VStack(spacing: 20) {
            AppText(text: "Enter your username")
                .font(.headline)
            
            AppTextField(placeHolder: "Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        }
        .navigationTitle("Welcome")
    }
    
    private var mainView: some View {
        if selectedMode == nil {
            AnyView(VStack(spacing: 25) {
                
                AppText(text: "Choose Chat Mode")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 240)

                
                HStack {
                    Button {
                        selectedMode = .online
                    } label: {
                        ModeButton(
                            title: "Online Chat",
                            color: .blue,
                            icon: "cloud.fill"
                        )
                    }
                    
                    Button {
                        selectedMode = .offline
                    } label: {
                        ModeButton(
                            title: "Offline Mode",
                            color: .green,
                            icon: "antenna.radiowaves.left.and.right"
                        )
                    }
                }
                
                Spacer()
            
                Button {
                    selectedMode = networkMonitor.isConnected ? .online : .offline
                } label: {
                    ModeButton(
                        title: "Start Chat",
                        color: .red,
                        icon: "message.fill"
                    )
                }
            }
            .padding()
            .navigationTitle("BitChat"))
        } else {
            switch selectedMode {
            case .online:
                AnyView(ChatListView(goBack: {selectedMode = nil}))
            case .offline:
                AnyView(OfflineChatView(goBack: {selectedMode = nil}))
            case .none:
                AnyView(EmptyView())
            }
        }
    }
}



enum ChatMode {
    case online
    case offline
}

struct ModeButton: View {
    let title: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            AppText(text: title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
