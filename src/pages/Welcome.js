import React, {
    Component
} from 'react';
import { NativeModules } from 'react-native';
import {
    Text,
    View,
    Image,
    Dimensions,
    StyleSheet,
} from 'react-native';
import { StackNavigator } from 'react-navigation';

const { height, width } = Dimensions.get('window');
export default class Welcome extends Component {
    componentDidMount() {
        setTimeout(() => {
            this.checkToken();
        }, 3000)//这里设定欢迎页时间，3s
    }

    async checkToken() {
        var nativeManager = NativeModules.NativeManager;
        try {
            const back = await nativeManager.getConfigData();
            token = back[1];
            console.log("token from swift in welcome:"+token)
            if (token.length > 0 && token.startsWith('Bearer')) {
                this.props.navigation.dispatch({
                    key: 'MainScreen',
                    type: 'ReplaceCurrentScreen',
                    routeName: 'MainScreen',
                    params: this.props.navigation.state.params,
                });
            } else {
                this.props.navigation.dispatch({
                    key: 'Login',
                    type: 'ReplaceCurrentScreen',
                    routeName: 'Login',
                    params: this.props.navigation.state.params,
                });
            }
        } catch (e) {
            console.error(e);
        }

        // const token = NativeModules.NativeManager.getToken()
        // .then((back) => {
        //     token = back['token'];
        //     console.log(token);
        // })
        // .then(() => {
        // if (token.length > 0 && token.startsWith('Bearer')) {
        //     this.props.navigation.dispatch({
        //         key: 'MainScreen',
        //         type: 'ReplaceCurrentScreen',
        //         routeName: 'MainScreen',
        //         params: this.props.navigation.state.params,
        //     });
        // } else {
        //     this.props.navigation.dispatch({
        //         key: 'Login',
        //         type: 'ReplaceCurrentScreen',
        //         routeName: 'MainScreen',
        //         params: this.props.navigation.state.params,
        //     });
        // }
        //});
    }

    render() {
        return (
            <View style={{ height: height, }}>
                <Image
                    style={{ width: width, height: height * 0.8 }}
                    source={require('../images/welcome.jpg')}
                />
                <View style={styles.WelcomeBottom}>
                    <Text style={styles.Name}>Mobile Cloud</Text>
                    <Text style={styles.Copyright}>©DLQW</Text>
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    WelcomeBottom: {
        flex: 1,
        height: height * 0.2,
        justifyContent: 'center',
        alignItems: 'center',
    },
    Name: {
        fontSize: 16,
        textAlign: 'center',
        marginTop: -20,
    },
    Copyright: {
        fontSize: 10,
        textAlign: 'center',
        marginTop: 5,
    },
});