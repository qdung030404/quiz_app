#  QuizBlast (In Progress)

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
</p>

## 📖 Giới thiệu (About)
**Quiz App** là một ứng dụng di động hỗ trợ người dùng học tập và ôn luyện kiến thức thông qua Flashcard và các bài trắc nghiệm. Ứng dụng cung cấp các chế độ học tập đa dạng (Multiple Choice, Typing) để tối ưu hóa khả năng ghi nhớ của người dùng. 

*💡 Lưu ý: Dự án hiện đang trong giai đoạn phát triển tích cực (Active Development).*

---

## ✨ Tính năng nổi bật (Features)
- 🔐 **Xác thực người dùng:** Đăng nhập, đăng ký nhanh chóng.
- 🗂️ **Quản lý Flashcard:** Cho phép người dùng xem tập hợp các bộ Flashcard.
- 🎓 **Chế độ học tập (Learn Mode):**
  - **Trắc nghiệm (Multiple Choice):** Trộn câu hỏi và đưa ra bài kiểm tra nhanh.
  - **Viết (Typing/Writing):** Người dùng nhập đáp án thủ công để tăng cường trí nhớ.
- 📊 **Theo dõi kết quả:** Hiển thị màn hình kết quả ngay sau khi học.
- 💫 **Trải nghiệm mượt mà:** UI/UX trực quan với các Custom Transitions.

---

## 🛠️ Công nghệ sử dụng (Tech Stack)
- **Framework:** Flutter
- **Ngôn ngữ:** Dart
- **Quản lý trạng thái (State Management):** GetX
- **Backend / Cơ sở dữ liệu:** Supabase

---

## 📂 Kiến trúc thư mục (Folder Structure)
Dự án được cấu trúc theo tính năng (Feature-based folder structure) giúp code gọn gàng và dễ bảo trì:
```text
lib/
├── data/                # Data layer (Models, Repositories)
├── feature/
│   ├── auth/            # Luồng xác thực đăng nhập
│   ├── flashcard_set/   # Tính năng liên quan đến bộ flashcard & học tập
│   ├── home/            # Màn hình chính
│   ├── library/         # Thư viện lưu trữ học tập
│   └── match/           # (Tính năng game / nối từ...)
├── core/                # Các utilities dùng chung, theme, const,...
└── main.dart            # Entry point
```

