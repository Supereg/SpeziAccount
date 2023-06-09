//
// This source file is part of the Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI

struct AccountServicesView<Header: View>: View {
    @EnvironmentObject var account: Account
    @Environment(\.openURL)
    private var openURL

    private var header: Header
    private var button: (any AccountService) -> AnyView
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack {
                    header
                    Spacer(minLength: 0)
                    VStack(spacing: 16) {
                        if account.accountServices.isEmpty {
                            Text("MISSING_ACCOUNT_SERVICES", bundle: .module)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)

                            // swiftlint:disable:next force_unwrapping
                            let docsUrl = URL(string: "https://swiftpackageindex.com/stanfordspezi/speziaccount/documentation/speziaccount/createanaccountservice")!
                            Button {
                                openURL(docsUrl)
                            } label: {
                                Text("OPEN_DOCUMENTATION", bundle: .module)
                            }
                        } else {
                            ForEach(account.accountServices, id: \.id) { loginService in
                                button(loginService)
                            }
                        }
                    }
                        .padding(16)
                }
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    
    init(button: @escaping (any AccountService) -> AnyView) where Header == EmptyView {
        self.header = EmptyView()
        self.button = button
    }
    
    init(header: Header, button: @escaping (any AccountService) -> AnyView) {
        self.header = header
        self.button = button
    }
}


#if DEBUG
struct AccountServicesView_Previews: PreviewProvider {
    @StateObject private static var account: Account = {
        let accountServices: [any AccountService] = [
            UsernamePasswordAccountService(),
            EmailPasswordAccountService()
        ]
        return Account(accountServices: accountServices)
    }()

    static var previews: some View {
        NavigationStack {
            AccountServicesView(header: EmptyView()) { accountService in
                accountService.loginButton
            }
            .navigationTitle(String(localized: "LOGIN", bundle: .module))
        }
            .environmentObject(account)
    }
}
#endif
