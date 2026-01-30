import SwiftUI

struct ImpressionsView: View {
  @State private var selectedFilter: ImpressionFilter = .all
  @State private var searchText = ""
  @State private var showingNewImpression = false
  
  let impressions = mockImpressions
  
  var filteredImpressions: [Impression] {
    let filtered = impressions.filter { impression in
      switch selectedFilter {
      case .all:
        return true
      case .recent:
        return Calendar.current.isDateInToday(impression.date) ||
        Calendar.current.isDateInYesterday(impression.date)
      case .popular:
        return impression.likes > 10
      case .my:
        return impression.author == "Вы"
      }
    }
    
    if !searchText.isEmpty {
      return filtered.filter { impression in
        impression.title.localizedCaseInsensitiveContains(searchText) ||
        impression.content.localizedCaseInsensitiveContains(searchText) ||
        impression.city.localizedCaseInsensitiveContains(searchText)
      }
    }
    
    return filtered
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // Поиск и фильтры
        searchAndFilterBar
        
        // Контент
        if filteredImpressions.isEmpty {
          emptyStateView
        } else {
          impressionsListView
        }
      }
      .navigationTitle("Впечатления")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          newImpressionButton
        }
      }
      .sheet(isPresented: $showingNewImpression) {
        NewImpressionView()
      }
    }
  }
  
  // MARK: - Поиск и фильтры
  private var searchAndFilterBar: some View {
    VStack(spacing: 12) {
      // Поле поиска
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.gray)
        
        TextField("Поиск впечатлений...", text: $searchText)
          .textFieldStyle(PlainTextFieldStyle())
        
        if !searchText.isEmpty {
          Button(action: {
            searchText = ""
          }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
      .background(Color(.systemGray6))
      .cornerRadius(10)
      .padding(.horizontal)
      
      // Фильтры
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(ImpressionFilter.allCases, id: \.self) { filter in
            FilterChip(
              title: filter.title,
              icon: filter.icon,
              isSelected: selectedFilter == filter
            ) {
              selectedFilter = filter
            }
          }
        }
        .padding(.horizontal)
      }
    }
    .padding(.vertical, 12)
    .background(Color.white)
    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
  }
  
  // MARK: - Список впечатлений
  private var impressionsListView: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(filteredImpressions) { impression in
          ImpressionCard(impression: impression)
            .padding(.horizontal)
        }
      }
      .padding(.vertical)
    }
    .background(Color(.systemGroupedBackground))
  }
  
  // MARK: - Пустое состояние
  private var emptyStateView: some View {
    VStack(spacing: 20) {
      Spacer()
      
      Image(systemName: "quote.bubble")
        .font(.system(size: 60))
        .foregroundColor(.gray.opacity(0.3))
      
      VStack(spacing: 8) {
        Text("Впечатлений пока нет")
          .font(.headline)
        
        Text(selectedFilter == .my ?
             "Поделитесь своими впечатлениями первыми!" :
              "Измените параметры поиска")
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
      }
      
      if selectedFilter == .my {
        Button("Написать впечатление") {
          showingNewImpression = true
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.top, 8)
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
  }
  
  // MARK: - Кнопка нового впечатления
  private var newImpressionButton: some View {
    Button(action: {
      showingNewImpression = true
    }) {
      Image(systemName: "plus.circle.fill")
        .font(.title3)
        .foregroundColor(.blue)
    }
  }
}

// MARK: - Карточка впечатления
struct ImpressionCard: View {
  let impression: Impression
  @State private var isExpanded = false
  @State private var isLiked = false
  @State private var likeCount: Int
  
  init(impression: Impression) {
    self.impression = impression
    self._likeCount = State(initialValue: impression.likes)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Шапка
      headerView
      
      // Контент
      contentView
      
      // Изображение (если есть)
      if let imageUrl = impression.imageUrl {
        AsyncImage(url: URL(string: imageUrl)) { phase in
          switch phase {
          case .empty:
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.gray.opacity(0.2))
              .aspectRatio(16/9, contentMode: .fill)
              .overlay(ProgressView())
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          case .failure:
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.gray.opacity(0.2))
              .aspectRatio(16/9, contentMode: .fill)
              .overlay(
                Image(systemName: "photo")
                  .foregroundColor(.gray)
              )
          @unknown default:
            EmptyView()
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      
      // Действия
      actionsView
      
      // Комментарии (если есть)
      if !impression.comments.isEmpty && isExpanded {
        commentsView
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
  }
  
  private var headerView: some View {
    HStack(spacing: 12) {
      // Аватар
      Circle()
        .fill(
          LinearGradient(
            colors: impression.author == "Вы" ? [.blue, .purple] : [.orange, .yellow],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .frame(width: 40, height: 40)
        .overlay(
          Text(impression.author.prefix(1))
            .font(.headline)
            .foregroundColor(.white)
        )
      
      VStack(alignment: .leading, spacing: 2) {
        Text(impression.author)
          .font(.headline)
        
        HStack(spacing: 4) {
          Image(systemName: "mappin.circle.fill")
            .font(.caption2)
            .foregroundColor(.gray)
          
          Text(impression.city)
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Spacer()
      
      Text(formatDate(impression.date))
        .font(.caption)
        .foregroundColor(.secondary)
    }
  }
  
  private var contentView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(impression.title)
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.primary)
      
      Text(impression.content)
        .font(.body)
        .foregroundColor(.primary)
        .lineLimit(isExpanded ? nil : 3)
      
      if !isExpanded && impression.content.count > 150 {
        Button("Читать далее") {
          withAnimation {
            isExpanded.toggle()
          }
        }
        .font(.subheadline)
        .foregroundColor(.blue)
        .padding(.top, 4)
      }
    }
  }
  
  private var actionsView: some View {
    HStack(spacing: 20) {
      // Лайки
      Button(action: {
        withAnimation {
          isLiked.toggle()
          likeCount += isLiked ? 1 : -1
        }
      }) {
        HStack(spacing: 6) {
          Image(systemName: isLiked ? "heart.fill" : "heart")
            .foregroundColor(isLiked ? .red : .gray)
          
          Text("\(likeCount)")
            .font(.subheadline)
            .foregroundColor(.primary)
        }
      }
      
      // Комментарии
      Button(action: {
        withAnimation {
          isExpanded.toggle()
        }
      }) {
        HStack(spacing: 6) {
          Image(systemName: "bubble.left")
            .foregroundColor(.gray)
          
          Text("\(impression.comments.count)")
            .font(.subheadline)
            .foregroundColor(.primary)
        }
      }
      
      Spacer()
      
      // Поделиться
      Button(action: {
        // Действие поделиться
      }) {
        Image(systemName: "square.and.arrow.up")
          .foregroundColor(.gray)
      }
      
      // Сохранить
      Button(action: {
        // Действие сохранить
      }) {
        Image(systemName: "bookmark")
          .foregroundColor(.gray)
      }
    }
    .padding(.top, 4)
  }
  
  private var commentsView: some View {
    VStack(alignment: .leading, spacing: 12) {
      Divider()
        .padding(.vertical, 8)
      
      Text("Комментарии")
        .font(.headline)
      
      ForEach(impression.comments.prefix(3)) { comment in
        CommentRow(comment: comment)
      }
      
      if impression.comments.count > 3 {
        Button("Показать все (\(impression.comments.count))") {
          // Показать все комментарии
        }
        .font(.subheadline)
        .foregroundColor(.blue)
        .padding(.top, 4)
      }
    }
  }
  
  private func formatDate(_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter.localizedString(for: date, relativeTo: Date())
  }
}

// MARK: - Компоненты
struct FilterChip: View {
  let title: String
  let icon: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 6) {
        Image(systemName: icon)
          .font(.caption)
        
        Text(title)
          .font(.subheadline)
      }
      .foregroundColor(isSelected ? .white : .primary)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(
        Capsule()
          .fill(isSelected ? Color.blue : Color(.systemGray6))
      )
      .overlay(
        Capsule()
          .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
      )
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct CommentRow: View {
  let comment: Comment
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Circle()
        .fill(Color.gray.opacity(0.2))
        .frame(width: 32, height: 32)
        .overlay(
          Text(comment.author.prefix(1))
            .font(.caption)
            .fontWeight(.medium)
        )
      
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(comment.author)
            .font(.subheadline)
            .fontWeight(.semibold)
          
          Spacer()
          
          Text(formatDate(comment.date))
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        
        Text(comment.text)
          .font(.subheadline)
          .foregroundColor(.primary)
      }
    }
    .padding(.vertical, 4)
  }
  
  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    return formatter.string(from: date)
  }
}

// MARK: - Новое впечатление
struct NewImpressionView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var title = ""
  @State private var content = ""
  @State private var selectedCity = "Москва"
  @State private var rating = 5
  
  let cities = ["Москва", "Санкт-Петербург", "Сочи", "Казань", "Екатеринбург", "Новосибирск"]
  
  var body: some View {
    NavigationView {
      Form {
        Section("Основная информация") {
          TextField("Заголовок впечатления", text: $title)
          
          Picker("Город", selection: $selectedCity) {
            ForEach(cities, id: \.self) { city in
              Text(city).tag(city)
            }
          }
          
          VStack(alignment: .leading, spacing: 8) {
            Text("Оценка: \(rating)/5")
              .font(.subheadline)
            
            HStack {
              ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                  .foregroundColor(.yellow)
                  .onTapGesture {
                    rating = star
                  }
              }
            }
          }
          .padding(.vertical, 8)
        }
        
        Section("Ваше впечатление") {
          TextEditor(text: $content)
            .frame(minHeight: 150)
        }
        
        Section {
          Button("Опубликовать") {
            // Публикация
            dismiss()
          }
          .frame(maxWidth: .infinity)
          .foregroundColor(.white)
          .padding(.vertical, 12)
          .background(title.isEmpty || content.isEmpty ? Color.gray : Color.blue)
          .cornerRadius(8)
          .disabled(title.isEmpty || content.isEmpty)
        }
        .listRowBackground(Color.clear)
      }
      .navigationTitle("Новое впечатление")
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

// MARK: - Модели данных
struct Impression: Identifiable {
  let id = UUID()
  let author: String
  let city: String
  let title: String
  let content: String
  let date: Date
  let likes: Int
  let imageUrl: String?
  let comments: [Comment]
}

struct Comment: Identifiable {
  let id = UUID()
  let author: String
  let text: String
  let date: Date
}

enum ImpressionFilter: String, CaseIterable {
  case all, recent, popular, my
  
  var title: String {
    switch self {
    case .all: return "Все"
    case .recent: return "Недавние"
    case .popular: return "Популярные"
    case .my: return "Мои"
    }
  }
  
  var icon: String {
    switch self {
    case .all: return "square.grid.2x2"
    case .recent: return "clock"
    case .popular: return "flame"
    case .my: return "person"
    }
  }
}

// MARK: - Моки данных
private let mockImpressions: [Impression] = [
  Impression(
    author: "Анна",
    city: "Санкт-Петербург",
    title: "Белые ночи — это магия!",
    content: "Только что вернулись из поездки в Петербург на время белых ночей. Это нечто невероятное! Город совершенно преображается, гулять по набережным в 2 часа ночи при полном свете — уникальный опыт. Советую всем, кто еще не был.",
    date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
    likes: 24,
    imageUrl: "https://images.unsplash.com/photo-1556481623190-b4d85bff7d2c",
    comments: [
      Comment(author: "Михаил", text: "Полностью согласен! Сам был в прошлом году.", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
      Comment(author: "Ольга", text: "А какая погода была?", date: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!)
    ]
  ),
  Impression(
    author: "Вы",
    city: "Москва",
    title: "Москва с высоты птичьего полета",
    content: "Вчера поднялся на Останкинскую башню. Вид просто захватывает дух! Весь город как на ладони. Особенно красиво на закате, когда зажигаются огни. Рекомендую взять экскурсию с гидом — много интересных фактов узнали.",
    date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
    likes: 15,
    imageUrl: "https://images.unsplash.com/photo-1513326738677-b964603b136d",
    comments: [
      Comment(author: "Дмитрий", text: "Сколько стоит билет?", date: Calendar.current.date(byAdding: .hour, value: -10, to: Date())!)
    ]
  ),
  Impression(
    author: "Игорь",
    city: "Сочи",
    title: "Идеальный отдых в Красной Поляне",
    content: "Провели неделю в Сочи, большую часть времени — в Красной Поляне. Даже летом там есть чем заняться: канатные дороги, походы в горы, парк развлечений. Для семейного отдыха — идеально!",
    date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
    likes: 42,
    imageUrl: nil,
    comments: []
  ),
  Impression(
    author: "Екатерина",
    city: "Казань",
    title: "Встреча культур в сердце Татарстана",
    content: "Казань поразила своим гармоничным сочетанием культур. Утром были в мечети Кул-Шариф, днем — в православном соборе, вечером гуляли по улице Баумана с ее национальным колоритом. Очень гостеприимный город!",
    date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
    likes: 31,
    imageUrl: "https://images.unsplash.com/photo-1596464716127-f2a82984de30",
    comments: [
      Comment(author: "Алина", text: "Обязательно попробуйте чак-чак!", date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!),
      Comment(author: "Сергей", text: "А в Кремль заходили?", date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)
    ]
  )
]

// MARK: - Preview
struct ImpressionsView_Previews: PreviewProvider {
  static var previews: some View {
    ImpressionsView()
  }
}
