plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")       // <-- 'kotlin-android' ki jagah ye sahi hai
    id("dev.flutter.flutter-gradle-plugin")  // Flutter plugin MUST be after Android & Kotlin
    id("com.google.gms.google-services")     // <-- Firebase Google Services plugin (zaroori)
}

android {
    namespace = "com.example.repract"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.repract"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    // Firebase BoM (versions manage karta hai)
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))

    // Firebase libraries
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")

    // (optional) agar chahiye:
    // implementation("com.google.firebase:firebase-crashlytics")
    // implementation("com.google.firebase:firebase-messaging")
    // implementation("com.google.firebase:firebase-firestore")
}
