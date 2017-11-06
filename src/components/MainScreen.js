'use strict';
import React, {
    Component,
} from 'react';
import {
    StyleSheet,
    Image,
    Text,
    View,
    Navigator
} from 'react-native';
import TabNavigator from 'react-native-tab-navigator';
import { StackNavigator } from 'react-navigation';

import Header from './Header';
//import FirstPage from '../pages/FirstPage';
import FirstPage from './Header';
import SecondPage from '../pages/SecondPage';
import ThirdPage from '../pages/ThirdPage';


const FIRST = 'first';
const FIRST_NORMAL = require('../images/tabs/user.png');
const SECOND = 'second';
const SECOND_NORMAL = require('../images/tabs/home.png');
const THIRD = 'third';
const THIRD_NORMAL = require('../images/tabs/chat.png');


export default class MainScreen extends Component {

    constructor(props) {
        super(props);
        this.state = { selectedTab: SECOND }
    }

    _renderTabItem(img, selectedImg, tag, childView, badgeText) {
        return (
            <TabNavigator.Item
                selected={this.state.selectedTab === tag}
                renderIcon={() => <Image style={styles.tabIcon} source={img} />}
                renderSelectedIcon={() => <Image style={styles.tabIconSelected} source={selectedImg} />}
                badgeText={badgeText}
                onPress={() => this.setState({ selectedTab: tag })}>
                {childView}
            </TabNavigator.Item>
        );
    }

    render() {
        return (
            <View style={{ flex: 1 }}>
                <Header selectedTab={this.state.selectedTab} />
                <TabNavigator hidesTabTouch={true} tabBarStyle={styles.tab}>
                    {this._renderTabItem(FIRST_NORMAL, FIRST_NORMAL, FIRST, <FirstPage nav={this.props.navigation} />)}
                    {this._renderTabItem(SECOND_NORMAL, SECOND_NORMAL, SECOND, <SecondPage nav={this.props.navigation} />)}
                    {this._renderTabItem(THIRD_NORMAL, THIRD_NORMAL, THIRD, <ThirdPage nav={this.props.navigation} />)}
                </TabNavigator>
            </View >
        );
    }
}

const styles = StyleSheet.create({
    tab: {
        height: 52,
        backgroundColor: '#F8F8F8',
        alignItems: 'center',
    },
    tabIcon: {
        width: 25,
        height: 25,
        resizeMode: 'stretch',
        marginTop: 12.5,
        tintColor: "#A5A5A5",
    },
    tabIconSelected: {
        width: 25,
        height: 25,
        resizeMode: 'stretch',
        marginTop: 12.5,
        tintColor: "#0092DA",
    }
});