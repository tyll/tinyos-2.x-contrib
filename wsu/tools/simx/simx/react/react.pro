-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers

# Enabling reduces size to about half
-dontoptimize
-dontobfuscate

-dontusemixedcaseclassnames

-keepclasseswithmembers public class * {
  public static void main(java.lang.String[]);
}

-keepclassmembers class react.**.ConnectionFrame* {
  void puts(java.lang.String);
}
