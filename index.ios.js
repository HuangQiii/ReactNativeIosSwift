import React from 'react';
import {NativeModules} from 'react-native';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
} from 'react-native';

class RNHighScores extends React.Component {

  callNativeMethod(){
    var nativeManager = NativeModules.NativeManager;
    nativeManager.testCall();
  }

  render() {
    var contents = this.props["scores"].map(
      score => <Text key={score.name}>{score.name}{score.value}{"\n"}</Text>
    );
    return (
      <View style={styles.container}>
      <TouchableOpacity
        onPress={()=>this.callNativeMethod()}
      >
        <Text style={styles.highScoresTitle}>
          xie tian xie di aaa
        </Text>
      </TouchableOpacity>
        <Text style={styles.scores}>    
          {contents}
        </Text>
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