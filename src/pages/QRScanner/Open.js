import React, { Component } from 'react';
import {
    WebView,
    Dimensions,
} from 'react-native';
const { width, height } = Dimensions.get('window');

export default class Open extends Component {
    static navigationOptions = {
        title: '二维码扫描结果',
    };
    render() {
        const { params } = this.props.navigation.state;
        return (
            <WebView
                style={{ width: width, height: height - 20, backgroundColor: 'gray' }}
                source={{ uri: params.url, method: 'GET' }}
                javaScriptEnabled={true}
                domStorageEnabled={true}
                scalesPageToFit={false}
            />
        )
    }
}