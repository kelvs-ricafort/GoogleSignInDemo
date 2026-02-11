//
//  MainView.swift
//  GoogleSignInDemo
//
//  Created by Kelvin Ricafort on 2/11/26.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct MainView: View {
    @State private var user: GIDGoogleUser?
    
    var body: some View {
        VStack {
            // Check if the user is signed in.
            if let user = user {
                 // If signed in, show a welcome message and the sign-out button.
                Text("Hello, \(user.profile?.givenName ?? "User")!")
                    .font(.title)
                    .padding()
                Button("Sign Out", action: signOut)
                    .buttonStyle(.borderedProminent)
            } else {
                GoogleSignInButton(
                    scheme: .dark, // Options: .light, .dark, .auto
                    style: .standard, // Options: .standard, .wide, .icon
                    state: .normal, // Options: .normal, .disabled
                    action: handleSignInButton).padding()
            }
        }
        .onAppear {
            // On appear, try to restore a previous sign-in.
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                // This closure is called when the restoration is complete.
                if let user = user {
                    // If a user was restored, update the `user` state variable.
                    DispatchQueue.main.async {
                        self.user = user
                    }
                    
                    // Print the ID token to the console when restored.
                    print("Restored ID Token: \(user.idToken?.tokenString ?? "")")
                }
            }
        }
    }
    
    func handleSignInButton() {
        // Find the current window scene.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("There is no active window scene.")
            return
        }
        
        // Get the root view controller from the window scene.
        guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("There is no key window or root view controller")
            return
        }
        
        // Start the sign in process.
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let result = signInResult else {
                // Inspect error
                print("Errpr signing in: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                self.user = result.user
            }
            // If sign in succeeded, display the app's main content view.
            print("ID Token: \(result.user.idToken?.tokenString ?? "")")
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        // After signing out, set the `user` state variable to `nil`.
        self.user = nil
    }
}

#Preview {
    MainView()
}
