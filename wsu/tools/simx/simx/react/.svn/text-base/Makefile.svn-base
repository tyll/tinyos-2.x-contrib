SCALAC ?=scalac
JAR =jar
JAVA =java
JAVAC =javac

CP =.:lib/tinyos.jar:lib/piccolo.jar:lib/piccolox.jar:lib/json-lib-2.2.2-jdk15.jar:lib/protobuf-java-2.1.0.jar:

ACTDIR =../python/simx/act

PROTOMAP =../python/simx/protomap
PROTO_SOURCE=$(PROTOMAP)/proto/java/org/izra/protomap
PROTO_TARGET=src/main/java/org/izra/protomap

TINYOSLIB =$(TOSROOT)/support/sdk/java/tinyos.jar

# For building small distribution JAR using proguard.
# These are system-specific.
SCALALIB =$(HOME)/scala/lib/scala-library.jar
JAVALIB =/usr/lib/jvm/java-6-sun-1.6.0.07/jre/lib/rt.jar
PROGUARD =$(JAVA) -jar ~/proguard/lib/proguard.jar
PROGUARD_OPTS =@react.pro

all: build-setup compile

build-clean: FORCE
	rm -fR bin

build-setup: build-clean
	mkdir -p bin

compile: compile-mig compile-java compile-scala

compile-scala:
#	@echo `find src -name \*.scala -or -name \*.java`
	$(SCALAC) -cp "$(CP):bin" -d bin -sourcepath src/main/scala `find src/main/scala -name \*.scala`

compile-java: proto
	$(JAVAC) -cp "$(CP):bin" -d bin src/main/java/simx/react/guibase/*.java
	$(JAVAC) -cp "$(CP):bin"  -d bin src/main/java/org/json/*.java
	$(JAVAC) -cp "$(CP):bin" -d bin $(PROTO_TARGET)/*.java

react-big.jar: compile
	$(JAR) cfM react-big.jar \
		-C META-INF MANIFEST.MF \
		-C bin mig -C bin react \
		-C lib license-piccolo.txt

# note use of ignore warnings...
react.jar: react-big.jar
	$(PROGUARD) $(PROGUARD_OPTS) -injars react-big.jar \
		-injars $(SCALALIB) \
		-injars lib/piccolo.jar -injars lib/piccolox.jar \
		-outjars react.jar \
		-libraryjars $(JAVALIB) \
		-libraryjars $(TINYOSLIB) \
		-ignorewarnings
	@echo "(The above warnings can -likely- be safely ignored.)"
	$(JAR) i react.jar

mig: $(ACTDIR)/React.h FORCE
	make -C $(ACTDIR) mig
	mkdir -p src/main/java/simx/mig
	cp -R $(ACTDIR)/mig/java/mig/*.java src/main/java/simx/mig 

proto:
	#make -C $(PROTOMAP)
	#mkdir -p $(PROTO_TARGET)
	#cp $(PROTO_SOURCE)/* $(PROTO_TARGET)

compile-mig: mig
	mkdir -p bin
	$(JAVAC) -d bin src/main/java/simx/mig/*.java

clean:
	rm -fR bin mig
	rm -f react-big.jar
	mkdir -p bin # for others that use it

run:
	$(JAVA) -cp $(CLASSPATH):react.jar react.Boot

FORCE:
