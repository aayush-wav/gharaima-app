# HamroSewa - Home Services Marketplace Nepal

A Flutter mobile application for connecting customers with verified local service providers in Nepal.

## Tech Stack
- **Framework**: Flutter
- **Backend**: Supabase (Auth, DB, Storage)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Maps**: Google Maps Flutter
- **Styling**: Google Fonts (Nunito)

## File Structure Created
- **config/**: `app_config.dart`, `theme.dart`
- **models/**: `user_model.dart`, `category_model.dart`, `service_model.dart`, `provider_model.dart`, `booking_model.dart`, `review_model.dart`
- **providers/**: `auth_provider.dart`, `categories_provider.dart`, `services_provider.dart`, `booking_provider.dart`, `user_provider.dart`
- **screens/**: `onboarding/`, `auth/`, `home/`, `categories/`, `services/`, `booking/`, `bookings/`, `profile/`
- **services/**: `supabase_service.dart`, `auth_service.dart`, `booking_service.dart`
- **utils/**: `date_formatter.dart`, `price_formatter.dart`, `validators.dart`
- **widgets/**: `category_card.dart`, `service_card.dart`, `provider_card.dart`, `booking_status_chip.dart`, `star_rating.dart`, `custom_button.dart`, `custom_text_field.dart`, `bottom_nav_bar.dart`
- **Root**: `main.dart`, `app.dart`, `pubspec.yaml`, `supabase_schema.sql`, `analysis_options.yaml`

## Setup Instructions

### 1. Supabase Setup
1. Create a new project on [Supabase](https://supabase.com/).
2. Go to the **SQL Editor** in your Supabase dashboard and paste the content of `supabase_schema.sql` to create tables and set up RLS policies.
3. Go to **Authentication > Providers** and enable **Phone Auth**. You may need a Twilio or MessageBird account for real SMS, or use Supabase's test OTPs.
4. Go to **Project Settings > API** and copy your `Project URL` and `anon public key`.
5. Open `lib/config/app_config.dart` and paste these values into `supabaseUrl` and `supabaseAnonKey`.

### 2. Google Maps API Setup
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a project and enable the **Maps SDK for Android** and **Maps SDK for iOS**.
3. Create an **API Key** under **Credentials**.
4. For Android:
   - Modify `android/app/src/main/AndroidManifest.xml` (you may need to run `flutter create .` to generate this file first).
   - Add `<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY_HERE"/>` inside the `<application>` tag.
5. For iOS:
   - Modify `ios/Runner/AppDelegate.swift`.
   - Add `GMSServices.provideAPIKey("YOUR_API_KEY_HERE")` inside `application(...)`.

### 3. Running the App
1. Ensure Flutter is installed on your machine.
2. If you haven't generated the platform folders, run:
   ```bash
   flutter create .
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Key Features
- **Phone Auth**: Seamless login via +977 phone numbers and OTP.
- **Service Browsing**: Search for cleaning, plumbing, etc.
- **Real-time Booking**: Schedule services with price estimation.
- **Booking Management**: Track upcoming and past services.
- **Status Timeline**: See the progress of your booked service from "Pending" to "Completed".
- **Reviews**: Leave feedback for providers after completion.
