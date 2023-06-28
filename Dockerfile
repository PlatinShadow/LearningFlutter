FROM ubuntu:latest

# Install deps
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Setup user
RUN useradd -ms /bin/bash dev
WORKDIR /home/dev

# Prepare Android directories and system variables
#RUN mkdir -p Android/sdk
#ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
#RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
#RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
#RUN unzip sdk-tools.zip && rm sdk-tools.zip
#RUN mv tools Android/sdk/tools
#RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
#RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
#ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"


# Setup Flutter dev tools
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
RUN chown -R dev /opt/flutter
ENV PATH "$PATH:/opt/flutter/bin"

# Install firebase cli
RUN mkdir /opt/firebase
RUN wget https://firebase.tools/bin/linux/latest -O /opt/firebase/firebase
RUN chown dev /opt/firebase/firebase
RUN chmod +x /opt/firebase/firebase
ENV PATH "$PATH:/opt/firebase"

USER dev
RUN flutter doctor

ENV PATH "$PATH:/home/dev/.pub-cache/bin"
RUN dart pub global activate flutterfire_cli
