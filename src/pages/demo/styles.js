'use strict';

import { StyleSheet, Dimensions } from "react-native";
const { width, height } = Dimensions.get('window');

module.exports = StyleSheet.create({

    container: {
        flex: 1,
        height: height,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    map: {
        flex: 1,
        height: height,
    }

});