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
    var body: some View {
        VStack {
            GoogleSignInButton(action: handleSignInButton).padding()
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
            // If sign in succeeded, display the app's main content view.
            print("ID Token: \(result.user.idToken?.tokenString ?? "")")
        }
    }
}

#Preview {
    MainView()
}
