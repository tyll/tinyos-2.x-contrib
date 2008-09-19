tTossim.jar: TestThrough.class AsmParser.class FileList.class SourceFile.class SourceLine.class Preprocessor.class PreMica2.class PreTossim.class Line.class
	jar cf tTossim.jar TestThrough.class AsmParser.class FileList.class SourceFile.class SourceLine.class Preprocessor.class PreMica2.class PreTossim.class Line.class

TestThrough.class: AsmParser.class TestThrough.java
	javac TestThrough.java


AsmParser.class: SourceLine.class FileList.class SourceFile.class AsmParser.java
	javac AsmParser.java 


FileList.class: SourceFile.class FileList.java 
	javac FileList.java

SourceFile.class: SourceLine.class SourceFile.java
	javac SourceFile.java

SourceLine.class: SourceLine.java
	javac SourceLine.java

Preprocessor.class: Line.class Preprocessor.java
	javac Preprocessor.java

PreMica2.class: PreMica2.java
	javac PreMica2.java

PreTossim.class: PreTossim.java
	javac PreTossim.java	

Line.class: Line.java
	javac Line.java	

