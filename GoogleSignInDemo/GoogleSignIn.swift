//
//  GoogleSignIn.swift
//  GoogleSignInDemo
//
//  Created by Kelvin Ricafort on 2/11/26.
//
import GoogleSignIn
import SwiftUI

@main
struct GoogleSignIn: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
