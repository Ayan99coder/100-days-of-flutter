// Top-level build.gradle.kts

import org.gradle.api.file.Directory   // <-- IMPORT TOP PE

plugins {
    // AGP/Kotlin versions mat pin karo (Flutter already la raha hai)
    // id("com.android.application") apply false
    // id("com.android.library") apply false
    // id("org.jetbrains.kotlin.android") apply false

    // Firebase Google Services
    id("com.google.gms.google-services") version "4.4.3" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// --- custom build dir logic ---
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

// modern setter: .set(...)
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
