#/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#Set up Java to be used by the kafka-test

if [ -d /java/jre/bin ];then
	echo "Using mounted Java8"
	export JAVA_BIN=/java/jre/bin
	export JAVA_HOME=/java
	export PATH=$JAVA_BIN:$PATH
	java -version
elif [ -d /java/bin ]; then
	echo "Using mounted Java9"
	export JAVA_BIN=/java/bin
	export JAVA_HOME=/java
	export PATH=$JAVA_BIN:$PATH
	java -version
else
	echo "Using docker image default Java"
	java_path=$(type -p java)
	suffix="/java"
	java_root=${java_path%$suffix}
	export JAVA_BIN="$java_root"
	echo "JAVA_BIN is: $JAVA_BIN"
	$JAVA_BIN/java -version
fi

TEST_SUITE=$1

echo "PATH is : $PATH"
echo "JAVA_HOME is : $JAVA_HOME"
echo "type -p java is :"
type -p java
echo "java -version is: \n"
java -version

# Initial command to trigger the execution of kafka test
cd /kafka
ls .
pwd

echo "Building kafka  using gradle" && \
gradle -q
./gradlew jar

echo "Kafka Build - Completed"

echo "Running (ALL) Kafka tests :"

./gradlew testAll
