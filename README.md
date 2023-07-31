# MyOpinionRocks

## Motivation

### Why cross-platform? 

In a nutshell, to reduce the development time and cost and to ensure consistency across platforms.

### Why Flutter?

Flutter is a cross-application framework to build apps for Android, iOS, Web, Windows, Linux and MacOS with a single codebase.
The main advantage over WebView-based frameworks is that the runtime is developed by Google for all platforms and this empowers behavioral consistency across platforms and you rarely get a problem on one platform that doesn't exist on other platforms. 
Also, the rendering of the UI is more consistent if compared to HTML/CSS where each platform has a different implementation of the WebView.
Performance-wise Flutter is superior when compared to JavaScript-based frameworks.
Another advantage of Flutter is the ecosystem of plugins to speed up development and improve code separation.
Also, development is blazing fast with hot-reload.
Finally, Flutter doesn't completely abstract the underlying platform, for example you can make changes directly to the AndroidManifest.xml or the Xcode project.

### Why Java for the backend?

I thought about two possible languages for the server: dart (one language to rule them all) or Java.
Java is a widely used language and it's easy to find developers with experience; I myself have a long experience with that.
Over time a big amount of libraries have been made available and the knowledge base is huge.

### Why MySQL for the data?

First choice is always: SQL or NoSQL? For a survey app a NoSQL approach would probably be better because performances are superior and the lack of schemas let you be flexible with different question types over time.
For this PoC I opted for MySQL because of time constraints (I am far more familiar with the MySQL/phpMyAdmin stack).

## App

Repository: https://github.com/mauriziopinotti/myopinionrocks_app

### Build and run locally

Install Flutter as described [in the docs](https://docs.flutter.dev/get-started/install).

```shell
# Run for local server on 127.0.0.1:8080
flutter run --flavor=local
# Run for hosted server
flutter run --flavor=prod
```

### Development

#### Architecture

The app is a Flutter application that uses Provider as state manager.

Being a small app, the code is organized in packages/folders as follows:
- `data`: data-related classes, such as REST client, models for REST requests and responses.
- `models`: non-REST models to be used by the app.
- `providers`: providers for state management, as of now just the User provider to handle login/logout.
- `screens`: UI widgets for whole screens/pages, such as Welcome Page, Survey Page and so on.
- `widgets`: reusable UI widgets such as form fields, buttons, and so on. App widgets are built on top of Flutter widgets to ensure consistency across the app and reduce the boilerplate code, so parameters should be kept to the bare minimum.

If the app size grows, it would be a better idea to add a per-feature segmentation.

Flavors are in the `flavors.dart` file, there you can change the endpoints for local and prod servers.

#### Regenerate l10n strings

If you need to add or remove l10n strings in `assets/translations`, after that run

```shell
flutter pub run easy_localization:generate -f keys -S assets/translations/ -o locale_keys.g.dart
```

### Hosted version

```shell
./mvnw -Pprod -DskipTests clean verify
```

then copy target/myopinionrocks-VERSION.jar to server and run it with Java 19.

Hosted version is `https://myopinionrocks.mauriziopinotti.it` (can be used as Postman environment to test).

## Backend

Repository: https://github.com/mauriziopinotti/myopinionrocks_backend

### Build and run locally

You need Java 19.

```shell
# Build, will generate ./target/myopinionrocks-0.0.1-SNAPSHOT.war
./mvnw clean package -Pprod -DskipTests
# Run, will open server on port 8080
./mvwn
```

### Development

**Note: due to time constraints unit tests are incomplete and broken.**

#### Architecture

The backend has been generated with jHipster 8.0.0-beta2 and uses standard Java components:
- Spring Boot for dependency injection
- Hibernate / JPA for data persistence
- Jackson for JSON serialization/deserialization
- DTO to convert entities
- Exposes REST/JSON APIs

The APIs are documented in the Postman collection `MyOpinionRocks.postman_collection.json`, as of now is really just:
- Register `POST /api/register`
- Login `POST /api/authenticate`
- Get user details `GET /api/account`
- Get a survey `GET /api/user-survey`
- Send a survey submission `POST /api/user-survey-result`

### Remote server

A remote backend is available at https://myopinionrocks.mauriziopinotti.it/api

## Possible improvements

For the sake of simplicity and time constraints I took a few shortcuts, including:

- Better error handling with error codes
- Most of the backend code is auto-generated and I didn't clean-up much of the unused code
- No unit tests
