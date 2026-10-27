import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

if (listOf("dev", "staging", "prod").any { file("src/$it/google-services.json").exists() }) {
    apply(plugin = "com.google.gms.google-services")
}

val signingPropertiesFile = rootProject.file("key.properties")
val signingProperties = Properties()
if (signingPropertiesFile.exists()) {
    signingPropertiesFile.inputStream().use(signingProperties::load)
}

android {
    namespace = "com.sgsaitechnology.mobile_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        resValues = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.sgsaitechnology.app"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            manifestPlaceholders["appLinksHost"] = "www.sgsaitechnology.com"
            manifestPlaceholders["deepLinkScheme"] = "sgsai-dev"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "SGS AI Dev")
        }
        create("staging") {
            dimension = "environment"
            manifestPlaceholders["appLinksHost"] = "www.sgsaitechnology.com"
            manifestPlaceholders["deepLinkScheme"] = "sgsai-stg"
            applicationIdSuffix = ".stg"
            resValue("string", "app_name", "SGS AI Staging")
        }
        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appLinksHost"] = "www.sgsaitechnology.com"
            manifestPlaceholders["deepLinkScheme"] = "sgsai"
            resValue("string", "app_name", "SGS AI")
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = signingProperties["keyAlias"] as String?
            keyPassword = signingProperties["keyPassword"] as String?
            storeFile = signingProperties["storeFile"]?.toString()?.let(::file)
            storePassword = signingProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"))
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
