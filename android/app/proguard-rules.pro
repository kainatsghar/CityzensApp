# Keep OkHttp
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Sometimes UCrop reflection needs this
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**
