# README for Hide And Seek Game

## Overview
This project is a simple "Hide and Seek" game built with Flutter. The player can hide in an open world while the machine attempts to find them. The game features two characters: the "hider" and the "seeker," represented by images stored in the assets folder.

## Project Structure
```
DS-hideandseek
├── lib
│   └── main.dart
├── assets
│   ├── hider.png
│   └── seeker.png
├── pubspec.yaml
└── README.md
```

## Files Description
- **lib/main.dart**: This is the entry point of the application. It contains the main game logic, including the open world mechanics and player movement.
- **assets/hider.png**: This image represents the character that hides in the game.
- **assets/seeker.png**: This image represents the character that seeks the player in the game.
- **pubspec.yaml**: This file contains the Flutter project configuration, including dependencies and asset declarations.
- **README.md**: This file provides documentation for the project.

## How to Run the Game
1. Ensure you have Flutter installed on your machine.
2. Clone the repository or download the project files.
3. Navigate to the project directory in your terminal.
4. Run `flutter pub get` to install the necessary dependencies.
5. Ensure that the images `hider.png` and `seeker.png` are located in the `assets` folder.
6. Run the application using `flutter run`.

## Gameplay Instructions
- Use the arrow buttons to move the hider around the open world.
- The objective is to hide from the seeker, who will attempt to find you.

## Assets
Make sure to include the following images in the `assets` folder:
- `hider.png`: Image for the hider character.
- `seeker.png`: Image for the seeker character.

## License
This project is open-source and available for modification and distribution. Enjoy playing and modifying the game!