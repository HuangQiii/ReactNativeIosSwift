import React, { Component } from 'react';
import {
    Text,
    View,
    StyleSheet,
    TouchableOpacity,
    WebView,
    Dimensions,
} from 'react-native';
import { NativeModules } from 'react-native';
import { StackNavigator } from 'react-navigation';

import CookieManager from 'react-native-cookies';

var url = '';
getData();
const { width, height } = Dimensions.get('window');

async function getData() {
    var nativeManager = NativeModules.NativeManager;
    try {
        const back = await nativeManager.getConfigData();
        url = back[2];
        console.log("========url: "+url)
    } catch (e) {
        console.error(e);
    }
}
export default class Login extends Component {

    //脚本注入
    injectJS = () => {
        const script = `
                    function get(a){
                            var arr,reg=new RegExp("(^| )"+a+"=([^;]*)(;|$)"); 
                            if(arr=document.cookie.match(reg)) 
                                return unescape(arr[2]); 
                            else 
                                return null;
                        } 
                        var data = null;
                        var t = setInterval(function(){
                            data = get('access_token');
                            if(data != null){
                              clearInterval(t);
                              window.postMessage(data);
                            }
                          }, 100);`;

        if (this.webview) {
            this.webview.injectJavaScript(script);
        }
    }
    render() {
        return (
            <View style={styles.container}>
                <WebView
                    ref={(webview) => {
                    this.webview = webview
                        console.log("==================webview: "+url)
                    }}
                    onLoadEnd={this.injectJS}
                    style={{ width: width, height: height - 20, backgroundColor: 'gray' }}
                    source={{ uri: url, method: 'GET' }}
                    javaScriptEnabled={true}
                    domStorageEnabled={false}
                    scalesPageToFit={false}
                    onMessage={(e) => {
                        this.props.navigation.dispatch({
                            key: 'MainScreen',
                            type: 'ReplaceCurrentScreen',
                            routeName: 'MainScreen',
                            params: this.props.navigation.state.params,
                        });
                        console.log(e.nativeEvent.data);
                        NativeModules.NativeManager.setToken(e.nativeEvent.data);
                        CookieManager.clearAll();
                    }}
                />
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
})
