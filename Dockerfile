# Use OpenJDK for ARM
FROM eclipse-temurin:21-jdk

# Install dependencies for JavaFX
RUN apt-get update && \
    apt-get install -y maven wget unzip libgtk-3-0 libgbm1 libx11-6 libgl1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download JavaFX for ARM64 (Raspberry Pi)
RUN wget https://download2.gluonhq.com/openjfx/21/openjfx-21_linux-aarch64_bin-sdk.zip -O /tmp/openjfx.zip && \
    unzip /tmp/openjfx.zip -d /opt && \
    rm /tmp/openjfx.zip

WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build project
RUN mvn clean package -DskipTests

# Run the shaded JAR
CMD ["java", \
"--module-path", "/opt/javafx-sdk-21/lib", \
"--add-modules", "javafx.controls,javafx.fxml", \
"-jar", "target/sum-product_fx-1.0-SNAPSHOT.jar"]