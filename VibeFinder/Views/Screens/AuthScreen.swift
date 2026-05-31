import SwiftUI

struct AuthScreen: View {
    let viewModel: AuthViewModel
    @FocusState private var focusedField: AuthField?
    private let modeAnimation = Animation.spring(response: 0.42, dampingFraction: 0.86)

    private enum AuthField: Hashable {
        case email
        case password
        case confirmPassword
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    Spacer(minLength: 32)

                    VStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppTheme.surface)
                                .frame(width: 76, height: 76)
                                .shadow(color: AppTheme.shadow, radius: 16, x: 0, y: 8)
                            Image(systemName: "sparkles.tv")
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundStyle(AppTheme.accent)
                        }
                        Text("VibeFinder")
                            .font(.largeTitle.bold())
                            .foregroundStyle(AppTheme.ink)
                        Text("Mood-based discovery for movies, series, and games.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 12) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textFieldStyle(.plain)
                            .modernAuthField()
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }

                        SecureField("Password", text: $viewModel.password)
                            .textContentType(viewModel.isRegisterMode ? .newPassword : .password)
                            .textFieldStyle(.plain)
                            .modernAuthField()
                            .focused($focusedField, equals: .password)
                            .submitLabel(viewModel.isRegisterMode ? .next : .done)
                            .onSubmit {
                                focusedField = viewModel.isRegisterMode ? .confirmPassword : nil
                            }

                        if viewModel.isRegisterMode {
                            SecureField("Confirm password", text: $viewModel.confirmPassword)
                                .textContentType(.newPassword)
                                .textFieldStyle(.plain)
                                .modernAuthField()
                                .focused($focusedField, equals: .confirmPassword)
                                .submitLabel(.done)
                                .onSubmit {
                                    focusedField = nil
                                }
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                        }

                        if case .error(let message) = viewModel.state {
                            Text(message)
                                .font(.footnote)
                                .foregroundStyle(AppTheme.error)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            Task { await viewModel.submit() }
                        } label: {
                            ZStack {
                                if viewModel.isRegisterMode {
                                    Label("Create account", systemImage: "person.crop.circle.badge.checkmark")
                                        .transition(.authModeTextTransition)
                                } else {
                                    Label("Sign in", systemImage: "person.crop.circle.badge.checkmark")
                                        .transition(.authModeTextTransition)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                        .disabled(viewModel.state == .loading)

                        Button {
                            focusedField = nil
                            withAnimation(modeAnimation) {
                                viewModel.toggleMode()
                            }
                        } label: {
                            ZStack {
                                if viewModel.isRegisterMode {
                                    Text("Already have an account")
                                        .transition(.authModeTextTransition)
                                } else {
                                    Text("Create an account")
                                        .transition(.authModeTextTransition)
                                }
                            }
                            .frame(height: 22)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(AppTheme.accent)
                    }
                    .modernSurfaceCard(padding: 18)
                    .animation(modeAnimation, value: viewModel.isRegisterMode)

                    Spacer()
                }
                .padding(20)
                .frame(maxWidth: .infinity)
            }
            .appScreenBackground()
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
            .tint(AppTheme.accent)
        }
    }
}

private extension View {
    func modernAuthField() -> some View {
        self
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(AppTheme.inputSurface, in: RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .stroke(AppTheme.border.opacity(0.28))
            )
    }
}

private extension AnyTransition {
    static var authModeTextTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
}

#Preview {
    AuthScreen(viewModel: AuthViewModel(service: MockAuthService()))
}
