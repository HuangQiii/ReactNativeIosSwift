import React, {
    Component
} from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
} from 'react-native';
import { StackNavigator } from 'react-navigation';

export default class ThirdPage extends Component {
    static propTypes = {
        nav: React.PropTypes.object,
    };

    render() {
        const { navigate } = this.props.nav;
        return (
            <View
                style={styles.container}>
                <TouchableOpacity
                    onPress={() => navigate('ScannerView')}
                    style={styles.button}>
                    <Text
                        style={styles.btText}>QRScanner</Text>
                </TouchableOpacity>

                <TouchableOpacity
                    onPress={() => navigate('StackNavigatorFour')}
                    style={styles.button}>
                    <Text
                        style={styles.btText}>Contact</Text>
                </TouchableOpacity>

                <TouchableOpacity
                    onPress={() => navigate('BaiduMap')}
                    style={styles.button}>
                    <Text
                        style={styles.btText}>BaiduMap</Text>
                </TouchableOpacity>
            </View>

        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F1F1F1',
        borderTopWidth: 0.5,
        borderTopColor: '#D1D1D1',
    },
    button: {
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 8,
        backgroundColor: 'grey',
        paddingVertical: 10,
        paddingHorizontal: 50,
    },
    btText: {
        color: '#fff',
    }
});