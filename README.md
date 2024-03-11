# spark_android

A new Flutter project.

Where are my logs stored? 
Your logs can be found in the path of your app's directory in storage:

Android:
--> Android/data/[YOUR_APP_PACKAGE]/files/[YOUR_LOGS_FOLDER_NAME]/Logs/

iOS:
--> [YOUR_APP_CONTAINER]/AppData/Library/Application Support/Logs/

/// 
flutter build apk  --split-per-abi --obfuscate --split-debug-info=debug-info --release