import SwiftUI

struct ProfileView: View {
  @State private var userName: String = "Алексей Петров"
  @State private var userEmail: String = "alexey@example.com"
  @State private var isNotificationsEnabled: Bool = true
  @State private var isDarkModeEnabled: Bool = false
  @State private var selectedCurrency: String = "RUB"
  @State private var showingEditProfile = false
  @State private var showingSettings = false
  
  let currencies = ["RUB", "USD", "EUR", "KZT"]
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 0) {
          // Шапка профиля
          profileHeader
          
          // Статистика
          statsSection
          
          // Настройки
          settingsSection
          
          // Дополнительные опции
          additionalOptionsSection
          
          // Выйти
          logoutSection
        }
        .padding(.bottom, 30)
      }
      .background(Color(.systemGroupedBackground))
      .navigationTitle("Профиль")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          settingsButton
        }
      }
      .sheet(isPresented: $showingEditProfile) {
        EditProfileView(
          userName: $userName,
          userEmail: $userEmail
        )
      }
    }
  }
  
  // MARK: - Шапка профиля
  private var profileHeader: some View {
    VStack(spacing: 16) {
      // Аватар
      ZStack {
        Circle()
          .fill(
            LinearGradient(
              colors: [.blue, .purple],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 100, height: 100)
        
        Text(userName.prefix(1))
          .font(.system(size: 40, weight: .bold))
          .foregroundColor(.white)
      }
      
      // Имя и почта
      VStack(spacing: 4) {
        Text(userName)
          .font(.title2)
          .fontWeight(.semibold)
        
        Text(userEmail)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      
      // Кнопка редактирования
      Button(action: {
        showingEditProfile = true
      }) {
        HStack {
          Image(systemName: "pencil")
            .font(.caption)
          Text("Редактировать профиль")
            .font(.subheadline)
        }
        .foregroundColor(.blue)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Capsule().stroke(Color.blue, lineWidth: 1))
      }
    }
    .padding()
    .background(Color.white)
  }
  
  // MARK: - Статистика
  private var statsSection: some View {
    VStack(spacing: 0) {
      SectionHeader(title: "Статистика")
      
      HStack(spacing: 0) {
        StatItem(
          value: "12",
          label: "Рейсов",
          icon: "airplane"
        )
        
        Divider()
          .frame(height: 40)
        
        StatItem(
          value: "8",
          label: "Городов",
          icon: "building.2"
        )
        
        Divider()
          .frame(height: 40)
        
        StatItem(
          value: "156к",
          label: "Потрачено",
          icon: "rublesign.circle"
        )
      }
      .padding(.vertical, 16)
    }
    .background(Color.white)
    .padding(.top, 16)
  }
  
  // MARK: - Настройки
  private var settingsSection: some View {
    VStack(spacing: 0) {
      SectionHeader(title: "Настройки")
      
      VStack(spacing: 0) {
        // Уведомления
        SettingRow(
          icon: "bell.fill",
          title: "Уведомления",
          value: .toggle($isNotificationsEnabled),
          iconColor: .orange
        )
        
        Divider()
          .padding(.leading, 52)
        
        // Темная тема
        SettingRow(
          icon: "moon.fill",
          title: "Темная тема",
          value: .toggle($isDarkModeEnabled),
          iconColor: .indigo
        )
        
        Divider()
          .padding(.leading, 52)
        
        // Валюта
        SettingRow(
          icon: "dollarsign.circle.fill",
          title: "Валюта",
          value: .picker(selectedCurrency, currencies),
          iconColor: .green
        )
      }
    }
    .background(Color.white)
    .padding(.top, 16)
  }
  
  // MARK: - Дополнительные опции
  private var additionalOptionsSection: some View {
    VStack(spacing: 0) {
      SectionHeader(title: "Дополнительно")
      
      VStack(spacing: 0) {
        // Избранное
        NavigationLink(destination: Favorites()) {
          SettingRow(
            icon: "star.fill",
            title: "Избранное",
            value: .chevron,
            iconColor: .yellow
          )
        }
        .buttonStyle(PlainButtonStyle())
        
        Divider()
          .padding(.leading, 52)
        
        // Помощь
        Button(action: {
          // Открыть помощь
        }) {
          SettingRow(
            icon: "questionmark.circle.fill",
            title: "Помощь",
            value: .chevron,
            iconColor: .blue
          )
        }
        .buttonStyle(PlainButtonStyle())
        
        Divider()
          .padding(.leading, 52)
        
        // О приложении
        Button(action: {
          // О приложении
        }) {
          SettingRow(
            icon: "info.circle.fill",
            title: "О приложении",
            value: .chevron,
            iconColor: .gray
          )
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .background(Color.white)
    .padding(.top, 16)
  }
  
  // MARK: - Выйти
  private var logoutSection: some View {
    Button(action: {
      // Выход из аккаунта
    }) {
      HStack {
        Image(systemName: "rectangle.portrait.and.arrow.right")
          .foregroundColor(.red)
        
        Text("Выйти из аккаунта")
          .font(.headline)
          .foregroundColor(.red)
        
        Spacer()
      }
      .padding()
      .background(Color.white)
      .cornerRadius(12)
      .padding(.horizontal)
      .padding(.top, 24)
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  // MARK: - Кнопка настроек
  private var settingsButton: some View {
    Button(action: {
      showingSettings = true
    }) {
      Image(systemName: "gearshape.fill")
        .foregroundColor(.blue)
    }
  }
}

// MARK: - Компоненты
struct SectionHeader: View {
  let title: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.headline)
        .foregroundColor(.primary)
        .padding(.horizontal)
      
      Spacer()
    }
    .padding(.vertical, 12)
    .background(Color(.systemGroupedBackground))
  }
}

struct StatItem: View {
  let value: String
  let label: String
  let icon: String
  
  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(.blue)
      
      Text(value)
        .font(.title2)
        .fontWeight(.bold)
      
      Text(label)
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity)
  }
}

enum SettingValueType {
  case toggle(Binding<Bool>)
  case picker(String, [String])
  case chevron
  case text(String)
}

struct SettingRow: View {
  let icon: String
  let title: String
  let value: SettingValueType
  let iconColor: Color
  
  var body: some View {
    HStack(spacing: 16) {
      // Иконка
      Image(systemName: icon)
        .font(.body)
        .foregroundColor(.white)
        .frame(width: 30, height: 30)
        .background(
          Circle()
            .fill(iconColor)
        )
      
      // Заголовок
      Text(title)
        .font(.body)
        .foregroundColor(.primary)
      
      Spacer()
      
      // Значение
      Group {
        switch value {
        case .toggle(let binding):
          Toggle("", isOn: binding)
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .blue))
          
        case .picker(let selected, let options):
          Menu {
            ForEach(options, id: \.self) { option in
              Button(option) {
                // Обработка выбора
              }
            }
          } label: {
            HStack(spacing: 4) {
              Text(selected)
                .foregroundColor(.secondary)
              Image(systemName: "chevron.down")
                .font(.caption)
                .foregroundColor(.gray)
            }
          }
          
        case .chevron:
          Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundColor(.gray)
          
        case .text(let text):
          Text(text)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding(.horizontal)
    .padding(.vertical, 14)
    .contentShape(Rectangle())
  }
}

// MARK: - Экран редактирования профиля
struct EditProfileView: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var userName: String
  @Binding var userEmail: String
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Имя", text: $userName)
            .textContentType(.name)
          
          TextField("Email", text: $userEmail)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
        } header: {
          Text("Основная информация")
        }
        
        Section {
          Button("Сохранить изменения") {
            // Сохранение изменений
            dismiss()
          }
          .frame(maxWidth: .infinity)
          .foregroundColor(.white)
          .padding(.vertical, 8)
          .background(Color.blue)
          .cornerRadius(8)
        }
        .listRowBackground(Color.clear)
      }
      .navigationTitle("Редактировать профиль")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Отмена") {
            dismiss()
          }
        }
      }
    }
  }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}

