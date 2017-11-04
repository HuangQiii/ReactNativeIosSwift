import React from 'react';
import {NativeModules} from 'react-native';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
} from 'react-native';

class RNHighScores extends React.Component {

  callNativeMethod(){
    var nativeManager = NativeModules.NativeManager;
    nativeManager.testCall();
  }
  open(name){
    var nativeManager = NativeModules.NativeManager;
    nativeManager.openBundle(name);
  }
  download(name){
    var nativeManager = NativeModules.NativeManager;
    nativeManager.downloadBundle(name);
  }

  render() {
    return (
      <View style={styles.container}>
        <Text>
          Main Bundle
        </Text>
      <TouchableWithoutFeedback
        onPress={()=>this.download("test")}
      >
        <Text style={styles.highScoresTitle}>
          Download a test
        </Text>
      </TouchableWithoutFeedback>
      <TouchableWithoutFeedback
        onPress={()=>this.open("second")}
      >
        <Text style={styles.highScoresTitle}>
          Click Me to go to open second
        </Text>
      </TouchableWithoutFeedback>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'lightskyblue',
  },
  highScoresTitle: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  scores: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

// 整体js模块的名称
AppRegistry.registerComponent('Mutiple-View', () => RNHighScores);