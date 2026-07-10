# FitQuest

FitQuest is a gamified fitness tracking application built with Flutter. It utilizes a charming "Pencil & Paper RPG" aesthetic to turn your daily physical activities into epic missoes. Track your PASSOS, visit real-world gyms (Masmorras), complete daily missoes, and level up your hero!

## Features

- **RPG Theme:** Enjoy a unique hand-drawn pencil and paper UI with custom sketches.
- **Daily missoes:** Complete physical activities and PASSOS to earn XP and Recompensas.
- **Masmorra Mapping:** Uses geolocation to find nearby gyms and treats them as Masmorras you can Entrar and conquer.
- **Hero Progression:** Gain XP and level up your Herói as you accomplish your fitness goals.

## How to Run the App

1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
2. Open a terminal in the root directory of this project.
3. Run `flutter pub get` to fetch all necessary dependencies.
4. Connect a physical mobile device or start an emulator/simulator.
5. Run the app using the command:
   ```bash
   flutter run
   ```

   **Note on Map Data (Masmorras):** By default, if no API key is provided, the app will use mock data for nearby gyms/Masmorras. This allows you to run and test the app immediately without any setup. If you want to see real gyms near you, you must provide a Google Places API key when running the app:
   ```bash
   flutter run --dart-define=GOOGLE_API_KEY=your_api_key_here
   ```

   **Running on Web (Chrome):**
   If you encounter issues running the app on Chrome (such as CORS errors or blank screens), use the following command for a higher chance of success:
   ```bash
   flutter run -d chrome --web-browser-flag "--disable-web-security"
   ```
   *To run on Chrome with a real Google Places API key:*
   ```bash
   flutter run -d chrome --web-browser-flag "--disable-web-security" --dart-define=GOOGLE_API_KEY=your_api_key_here
   ```

## Demo Accounts

You can test the application by logging in with any of the following Contas de Teste:

- **Free User**
  - Email: `free@test.com`
  - Senha: `123`

- **Premium User**
  - Email: `premium@test.com`
  - Senha: `123`

- **Administrator**
  - Email: `admin@test.com`
  - Senha: `123`
