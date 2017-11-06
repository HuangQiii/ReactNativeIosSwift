'use strict';
import React, {
  Component,
} from 'react';
import {
  View,
  Platform,
  StyleSheet,
  Text,
} from 'react-native';

export default class Header extends Component {

  static propTypes = {
    selectedTab: React.PropTypes.string,
  };

  constructor(props) {
    super(props);
  }

  render() {
    var bgColor = this.props.selectedTab == 'second' ? '#039BE5' : '#F8F8F8';
    var txt = this.props.selectedTab == 'second' ? 'MobileCloud' : this.props.selectedTab == 'first' ? '个人信息' : '测试页';
    var Color = this.props.selectedTab == 'second' ? '#FFFFFF' : '#000000';
    return (
      <View style={[styles.container, { backgroundColor: bgColor }]}>
        <Text style={{ fontSize: 16, color: Color }}>{txt}</Text>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    paddingLeft: 10,
    paddingRight: 10,
    paddingTop: Platform.OS === 'ios' ? 20 : 0,
    height: Platform.OS === 'ios' ? 68 : 48,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
