### Development Commands

#### Download and install all the dependencies

    flutter pub get

#### Install specific dependencies

    flutter pub add flutter_svg

### Deploy Commands

#### Android

    flutter build apk --release
    build/app/outputs/flutter-apk/app-release.apk

##### Build app bundle

```
keytool -genkey -v -keystore pwd/insider_oink_flutter/android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
flutter build appbundle
build/app/outputs/bundle/release/app-release.aab
```

#### Ios

    WIP

#### Web

    flutter build web --release
    cd build/web
    python3 -m http.server 8080


