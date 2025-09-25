plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")       // <-- 'kotlin-android' ki jagah ye sahi hai
    id("dev.flutter.flutter-gradle-plugin")  // Flutter plugin MUST be after Android & Kotlin
    id("com.google.gms.google-services")     // <-- Firebase Google Services plugin (zaroori)
}

android {
    namespace = "com.example.firebase_authentication"
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
        applicationId = "com.example.firebase_authentication"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // (optional) agar methods zyada hon to:
        // multiDexEnabled = true
    }

    buildTypes {
        release {
            // apne release ke hisab se signConfig set karna — filhal debug rakha hua hai
            signingConfig = signingConfigs.getByName("debug")
            // isMinifyEnabled/Proguard waghera yahan add kar sakte ho agar chaho
        }
    }

    // (optional) agar kabhi duplicate META-INF issues aayein:
    // packaging {
    //     resources {
    //         excludes += "/META-INF/{AL2.0,LGPL2.1}"
    //     }
    // }
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
